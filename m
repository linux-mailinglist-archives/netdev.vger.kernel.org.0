Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726885931CC
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiHOPbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHOPbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:31:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876036565;
        Mon, 15 Aug 2022 08:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43705B80F10;
        Mon, 15 Aug 2022 15:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF6CC433D6;
        Mon, 15 Aug 2022 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660577465;
        bh=pUF1opB3eIvBsU4zc1SZQXJOzE06itAJEjiaEFRsk3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dBNAEuIykYKTLXPdyM1pb89bX/KhMVQam9m8xRj+5QFyZmralD7IxFwDFjb519OTI
         M9SP8vBMM5nqnQfVVa5V1L+seKcIEvETOqqFAFZF0KU4RzHC8JNqp5dseBG1fGPwLp
         BmFBQP3PPwhCWLp48dASkkz5z0iognD1M4DEk5f8=
Date:   Mon, 15 Aug 2022 17:31:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jose Alonso <joalonsof@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH stable 4.9.x] Revert "net: usb: ax88179_178a needs
 FLAG_SEND_ZLP"
Message-ID: <YvpmtsW1tEt1lEVX@kroah.com>
References: <20220815151912.319147-1-joalonsof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815151912.319147-1-joalonsof@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 12:19:12PM -0300, Jose Alonso wrote:
> commit 6fd2c17fb6e02a8c0ab51df1cfec82ce96b8e83d upstream.
> 
> This reverts commit 36a15e1cb134c0395261ba1940762703f778438c.
> 
> The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
> versions that have no issues.
> 
> The FLAG_SEND_ZLP is not safe to use in this context.
> See:
> https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
> The original problem needs another way to solve.
> 
> Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
> Cc: stable@vger.kernel.org
> Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
> Link: https://bugs.archlinux.org/task/75491
> Signed-off-by: Jose Alonso <joalonsof@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/usb/ax88179_178a.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

All now queued up, thanks.

greg k-h
