Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96856340B4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiKVQAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiKVQAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:00:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E1D6B3BA;
        Tue, 22 Nov 2022 08:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D297CE1DBF;
        Tue, 22 Nov 2022 16:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B97C433C1;
        Tue, 22 Nov 2022 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669132814;
        bh=b3ctwkr+scX4h4ne4voevtoU6pRJllWeYEjkPJuW2XA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtvrlmzYQHXbpmQCdLIsZJ1RVguzzELPYAFWA68Q/XZVYrJYZlqJ8pzutVzkqSl6L
         EmeFaxG3HoAeu+BRpZAkoIKf8SWNZESj4yW8RdpP6+UEKVcWjVPX1qgVJjbElaDvyB
         QTdfRHBGlkc+iei6bep6d+DJy4rF0qHpb0YoOLNk=
Date:   Tue, 22 Nov 2022 17:00:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/3] USB: core: export usb_cache_string()
Message-ID: <Y3zyCz5HbGdsxmRT@kroah.com>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-2-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113040108.68249-2-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 01:01:06PM +0900, Vincent Mailhol wrote:
> usb_cache_string() can also be useful for the drivers so export it.
> 
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>  drivers/usb/core/message.c | 1 +
>  drivers/usb/core/usb.h     | 1 -
>  include/linux/usb.h        | 1 +
>  3 files changed, 2 insertions(+), 1 deletion(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
