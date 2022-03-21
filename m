Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637414E2695
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiCUMeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347415AbiCUMeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A18788B0B;
        Mon, 21 Mar 2022 05:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBE986101F;
        Mon, 21 Mar 2022 12:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E47C340E8;
        Mon, 21 Mar 2022 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647865953;
        bh=0hpskIm9pWLXzICrLn1EgKCUMeLCwl9GC0pWEao0jR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ek6GPB4XtMpHRObk48GuhMd3SeYfPYy7cEP06zfMyyJGWRivY5+JiDL/8r0rhpWz8
         GubFKuWm71hVPaM+IBfUCgg9KE/sdgt0sRuwTqzQ2X7mDB/qD758lg3fytx6PXO09k
         OkFnL1yBV3InIdLBFr3AR57Bqv4Sxn1pmo9Nps20=
Date:   Mon, 21 Mar 2022 13:32:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev <netdev@vger.kernel.org>, m.reichl@fivetechno.de,
        Martyn Welch <martyn.welch@collabora.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: smsc95xx: Commits for 5.10 stable inclusion
Message-ID: <YjhwWXCMmbUmTHSJ@kroah.com>
References: <CAOMZO5BqzQ1vMRHHem1pRydjYQiMJOzBzyHtmaPU07jiY_4JTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BqzQ1vMRHHem1pRydjYQiMJOzBzyHtmaPU07jiY_4JTg@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 08:10:09AM -0300, Fabio Estevam wrote:
> Hi,
> 
> I would like to request the following patches to be included
> into the stable 5.10 tree:
> 
> a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
> 0bf3885324a8 ("net: usb: Correct reset handling of smsc95xx")
> c70c453abcbf ("smsc95xx: Ignore -ENODEV errors when device is unplugged")
> 
> They are already present in 5.15 and 5.16 and they fix real issues
> on 5.10 too. I have been running 5.10 with these 3 patches applied locally
> and no reboot/disconnect errors are seen anymore. Alexander Stein also
> sees an smsc95xx suspend/resume issue fixed in 5.10 with the series applied.

Now queued up, thanks.

greg k-h
