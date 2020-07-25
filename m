Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636F022D3F3
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 04:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGYCyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 22:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYCyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 22:54:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B512C0619D3;
        Fri, 24 Jul 2020 19:54:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79A8F1277A0AA;
        Fri, 24 Jul 2020 19:37:57 -0700 (PDT)
Date:   Fri, 24 Jul 2020 19:54:41 -0700 (PDT)
Message-Id: <20200724.195441.1368606642401001205.davem@davemloft.net>
To:     trix@redhat.com
Cc:     kuba@kernel.org, masahiroy@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cdc_ncm: USB_NET_CDC_NCM selects USB_NET_CDCETHER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723142210.21274-1-trix@redhat.com>
References: <20200723142210.21274-1-trix@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 19:37:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: trix@redhat.com
Date: Thu, 23 Jul 2020 07:22:10 -0700

> From: Tom Rix <trix@redhat.com>
> 
> A link error
> 
> ld: drivers/net/usb/cdc_ncm.o:
>   undefined reference to `usbnet_cdc_update_filter'
> 
> usbnet_cdc_update_filter is defined in cdc_ether.c
> Building of cdc_ether.o is controlled by USB_NET_CDCETHER
> 
> Building of cdc_ncm.o is controlled by USB_NET_CDC_NCM
> 
> So add a select USB_NET_CDCETHER to USB_NET_CDC_NCM
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Please indicate the appropriate target tree ('net' or 'net-next') in
your Subject line f.e. "[PATCH net-next] ..."

Please provide an appropriate and properly formatted Fixes: tag.

Thank you.
