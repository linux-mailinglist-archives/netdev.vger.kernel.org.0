Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31248682B9D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjAaLh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjAaLhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:37:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B4859DC;
        Tue, 31 Jan 2023 03:37:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B68DB81BDC;
        Tue, 31 Jan 2023 11:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF84DC4339B;
        Tue, 31 Jan 2023 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675165071;
        bh=hxBkXEDyAItgtiWJbPCNaS5sbNZupVbr3qrkapP9KuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2QmpPLfG1/31mdQEOZzXATDqSeVPAIblDiDCgKKDxEAXoNbI0q1wdaJ4pqd9T8lge
         7UE+J9nPZAC5C8QdYwcoBRqTM8Agn2I8pSiSsvYJ8n6bsGfkUZQ8QBnBEh9Tx4m6nL
         5twKeZpdlDRZX63T2KneDIm10fb8RvE3JOdGrQcE=
Date:   Tue, 31 Jan 2023 12:37:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miko Larsson <mikoxyzzz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [UNTESTED PATCH] net/usb: kalmia: Fix uninit-value in
 kalmia_send_init_packet
Message-ID: <Y9j9jAHLDBsTxZB7@kroah.com>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 12:14:54PM +0100, Miko Larsson wrote:
> >From ef617d8df22945b871ab989e25c07d7c60ae21f6 Mon Sep 17 00:00:00 2001
> From: Miko Larsson <mikoxyzzz@gmail.com>
> Date: Tue, 31 Jan 2023 11:01:20 +0100

Why is this in the changelog text?

> Subject: [UNTESTED PATCH] net/usb: kalmia: Fix uninit-value in kalmia_send_init_packet
> 
> syzbot reports that act_len in kalmia_send_init_packet() is
> uninitialized. Attempt to fix this by initializing it to 0.

You can send patches to syzbot to have it test things, have you tried
that?

thanks,

greg k-h
