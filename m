Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFB945E94F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 09:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359462AbhKZI0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359588AbhKZIYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 03:24:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35EAC6108F;
        Fri, 26 Nov 2021 08:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637914865;
        bh=CRPfs2P9H8rtk4VfN1WhYSeMirERM1drV1FEZXGPGWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R84CpZcSmMKtG+/pXndyNzA7RlgMr8Svg9b2gll3Do3b9ci+ISt1Z2Ad6PzZkkhIM
         khCA7ekU7Z07Er/Sb0JaQ7iX4pvmo0OFdNYRRqyf848nZDqXRXZNPXTNdjAjtC1lEz
         Wo2qwGWAJ3/CO+vUUj3t+tyeGiGI38RvbzaZ0HuE=
Date:   Fri, 26 Nov 2021 09:21:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alsi@bang-olufsen.dk
Subject: Re: [PATCH v2] net: dsa: realtek-smi: fix indirect reg access for
 ports>3
Message-ID: <YaCY76T9ZWPKtKn1@kroah.com>
References: <20211126063645.19094-1-luizluca@gmail.com>
 <20211126081252.32254-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126081252.32254-1-luizluca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 05:12:52AM -0300, luizluca@gmail.com wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> 
> This switch family can have up to 8 ports {0..7}. However,
> INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK was using 2 bits instead of 3,
> dropping the most significant bit during indirect register reads and
> writes. Reading or writing ports 4, 5, 6, and 7 registers was actually
> manipulating, respectively, ports 0, 1, 2, and 3 registers.
> 
> rtl8365mb_phy_{read,write} will now returns -EINVAL if phy is greater
> than 7.
> 
> v2:
> - fix affected ports in commit message
> 
> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/rtl8365mb.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
