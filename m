Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82EF5BBD63
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 12:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIRKNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 06:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIRKNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 06:13:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C39A13D4D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 03:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E827AB80EBD
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 10:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B860C433D6;
        Sun, 18 Sep 2022 10:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663495996;
        bh=MZpBZ4+Xo4BJCyxj6OXwh1pXmqhjRVeOhaBaXyfntKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wtD4X0K1o3VbfO0p0/n5jefpG8jW/79P/5m371pB2+ybai6e3vlMajS50RctqWAf8
         RTKAXt4asnstYZa6ojXbutPkigox9SmuiNTUHOQU38bujZm7YY1gicK3YRcnj2LcvG
         i6mkrHeCczowrG36z4H/vWF31bsXVvwTX6Q0IcnI=
Date:   Sun, 18 Sep 2022 12:13:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>, pablo@netfilter.org
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
Message-ID: <YybvTYO2pCwlDr2f@kroah.com>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 17, 2022 at 11:03:55AM +0300, Martin Zaharinov wrote:
> HI team
> 
> This is NAT server with 2gb/s traffic have 2x 10Gb 82599 in Bonding 
> 
> one report if find any solution write me :

Is this new?  If so, can you use 'git bisect' to find the problem?  Or
has this always been there?

thanks,

greg k-h
