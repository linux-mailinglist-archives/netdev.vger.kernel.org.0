Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4152D57EF4F
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 15:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiGWNyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiGWNyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 09:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CE41A3B7;
        Sat, 23 Jul 2022 06:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5062961435;
        Sat, 23 Jul 2022 13:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562EBC341C0;
        Sat, 23 Jul 2022 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658584441;
        bh=wjoPQoKlN9DNZLfr1OEhyq+k03T3Ro/Z/zur46B0Ics=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E549j7nJ4fu6S+KhPvtr466WNZOCwb9btvWCkAV2smoyBfIjmwyB5BkO2h0mR7QG0
         u4pDODSMtiLtsCgsM6Mh5uRALwtaXqK6AMymrxxI1PDwgy1MxjoZXTEMqgwZku/3yq
         yGNv9Nh0inmO2/k22fI1e76OWyyXVJKDPN3nGoss=
Date:   Sat, 23 Jul 2022 15:53:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: request to stable branch [PATCH net] net: usb: ax88179_178a
 needs FLAG_SEND_ZLP
Message-ID: <Ytv9dhH3fmMgzQFE@kroah.com>
References: <8353466644205cf9bb2479ac8ced91dd111d9a01.camel@gmail.com>
 <Yswijtbd3nGjVF35@kroah.com>
 <e388870f72a6b13e801f4114bfb92537940efd6e.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e388870f72a6b13e801f4114bfb92537940efd6e.camel@gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:24:35AM -0300, Jose Alonso wrote:
> On Mon, 2022-07-11 at 15:15 +0200, Greg Kroah-Hartman wrote:
> > 
> > What stable kernels do you want this backported to?
> > 
> The same kernels as 'net-usb-ax88179_178a-fix-packet-receiving.patch'
> 
> releases/4.14.287/net-usb-ax88179_178a-fix-packet-receiving.patch
> releases/4.19.251/net-usb-ax88179_178a-fix-packet-receiving.patch
> releases/4.9.322/net-usb-ax88179_178a-fix-packet-receiving.patch
> releases/5.10.129/net-usb-ax88179_178a-fix-packet-receiving.patch
> releases/5.15.53/net-usb-ax88179_178a-fix-packet-receiving.patch
> releases/5.18.10/net-usb-ax88179_178a-fix-packet-receiving.patch
> releases/5.4.204/net-usb-ax88179_178a-fix-packet-receiving.patch

It would only apply to the 5.18.y tree.  Please provide a working
backport for all other branches if you wish to have it applied there.

thanks,

greg k-h
