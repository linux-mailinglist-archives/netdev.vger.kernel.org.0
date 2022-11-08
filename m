Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C194621A93
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiKHR2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiKHR1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:27:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7D359FC5;
        Tue,  8 Nov 2022 09:27:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17815B81BAC;
        Tue,  8 Nov 2022 17:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B943C433D7;
        Tue,  8 Nov 2022 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667928466;
        bh=eAJ7+1c8JgFvZUES5WDyaa0oVtQKBU+O468vTw8EW/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCLjIMPxHOhixXI3yY2HXSN698ahgXc07Mius3Mtr5eCNjPVj0NCrRZlbgIN5v/c2
         ax7RIq5rMJ2jSm5rjzaz3waOPDaQa87vOXGkyArk2BcTKFcFb5bPhTlNIiRI3D03We
         fymwJJj9mxhTm2H9nQ0nTw6iSBM0xZrttziH5ziM=
Date:   Tue, 8 Nov 2022 18:27:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next RFC 1/5] net: move back netif_set_gso_max helpers
Message-ID: <Y2qRjp9TS9Ek4t81@kroah.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108153342.18979-2-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108153342.18979-2-albert.zhou.50@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 02:33:38AM +1100, Albert Zhou wrote:
> Reverse commit 744d49daf8bd ("net: move netif_set_gso_max helpers") by
> moving the functions netif_set_gso_max* back to netdevice.h so that the
> updated R8152 v2 driver can use them.
> 
> Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
> ---
>  include/linux/netdevice.h | 21 +++++++++++++++++++++
>  net/core/dev.h            | 21 ---------------------
>  2 files changed, 21 insertions(+), 21 deletions(-)

No, use the helpers that are there to be used instead.  This should not
be needed to be done, fix up the driver you are adding instead.

thanks,

greg k-h
