Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0960A5AA0CA
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiIAUSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiIAUSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:18:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C87CA98
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 13:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 895E2B828FC
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 20:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E432EC433D6;
        Thu,  1 Sep 2022 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662063516;
        bh=dLKFmAPBmJwRRq6yMvJoGRhZjJQtlcTEqlLxmo+Q9jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRt+zdswlv9zzX3qcS7J2o1TnUoyX1H1Aa0jfmy+Kku20buC1aw7BIw+oqEyxurSZ
         m/lpx6hCv6tlFZW4VJJjhfT7kFO4X8KiW0US4hd/i4FPCAoXpgNEe/HGymHB8sYr7B
         V5W92EFINx1yS9Xyh2zk105A266j5DHmgPJwn4mSNMgK8KUwWm3fXEjn2O67sk0hHk
         2sVfBniiw3AlzdbjQMSVWuvb2g/u+S+QoOzp2vWPdmVZrQRUf5k+2Q8MfDOqc8twf+
         LH4QqwGkN8ouY0ZFvAce/WugNsL3jjnNm4CvMvTRWverK18d1o774/DT02iu0FN/a9
         OBVoO+8hfWybw==
Date:   Thu, 1 Sep 2022 13:18:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Message-ID: <20220901131835.0fe7b02e@kernel.org>
In-Reply-To: <YxBHL6YzF2dAWf3q@kroah.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
        <20220829220049.333434-4-anthony.l.nguyen@intel.com>
        <20220831145439.2f268c34@kernel.org>
        <YxBHL6YzF2dAWf3q@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Sep 2022 07:46:23 +0200 Greg Kroah-Hartman wrote:
> > Please CC GNSS and TTY maintainers on the patches relating to 
> > the TTY/GNSS channel going forward.
> > 
> > CC: Greg, Jiri, Johan
> > 
> > We'll pull in a day or two if there are no objections.  
> 
> Please see above, I'd like to know what is really failing here and why
> as forcing drivers to have "empty" functions like this is not good and
> never the goal.

Thanks for a prompt look!

Tony, I presume you may want to sidetrack this patch for now and ship
the rest so lemme toss this version of the series.
