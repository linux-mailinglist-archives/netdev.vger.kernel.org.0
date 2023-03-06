Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA876AB6DE
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCFHTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 02:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFHTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:19:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA7C7DAE;
        Sun,  5 Mar 2023 23:19:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF9F860B89;
        Mon,  6 Mar 2023 07:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA3CC433EF;
        Mon,  6 Mar 2023 07:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087188;
        bh=Bh627lCb0vYrxIQsSKKlJ2BBFDDQqZgeGMhftBIAswo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2LFvS5AEJI1O/6Mv4e4l1AUpGRihOwvkHOBqYRgarV6HQDUa3LuQYyNDiRfq6wsf
         MUw/En1kS0lvVaoXc6tnHpF/9YAEXLvlvxOx6Z2JfqJMQ29bSJp2Soulm4AmDGqPgW
         i8U11ALrcVp+7KTW3UM0HSvgAdzsgpujLm070ChE=
Date:   Mon, 6 Mar 2023 08:19:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Juhyung Park <qkrwngud825@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 0/2] r8152: allow firmwares with NCM support
Message-ID: <ZAWUETCf2zUJgoTl@kroah.com>
References: <20230106160739.100708-1-bjorn@mork.no>
 <144f843a-a5d5-4d2b-6d8e-6dfb064cbeba@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144f843a-a5d5-4d2b-6d8e-6dfb064cbeba@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 04, 2023 at 07:00:05PM +0900, Juhyung Park wrote:
> Hi everyone,
> 
> Can we have this series backported to all applicable stable kernels?
> +and future fixes:
> commit 0d4cda805a18 ("r8152: avoid to change cfg for all devices")
> commit 95a4c1d617b9 ("r8152: remove rtl_vendor_mode function")

These do not apply to 6.2.y at all, please submit a tested and working
series for us to apply if you wish to see them in any stable kernel
tree.

thanks,

greg k-h
