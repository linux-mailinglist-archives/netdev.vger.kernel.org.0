Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34132F3D8F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438008AbhALVhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436903AbhALUWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D43A1230FC;
        Tue, 12 Jan 2021 20:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610482910;
        bh=cGlnNuYwNJK5i7e2oQpdg3JqqG6mxOLIzl+yA1kjids=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mxdKtxkHCQE/c6fx/EMPxBYhaVSLyd7w7qQkAKIy1uYyHmYucKIYxOyZVAOjMTlmK
         WmfWF2f4pLDHSPThRo57gbTQmRHMRgx7hAV/5/Y4WL9H6z1Qep9Iv1hxyBgA41zCQP
         sUpxrCVhOfyzdILSujwbJ8HL1BXWXBdk+M0UsUJ4meppa49SGYezKlIQeZsW5xKHyP
         IjiLGdK7QvXp+VRpYOY1Abuuz6zApdvVK3FbZCJvV7q0ZDX+RCHN1ulUANlBuqTA1e
         kpPqAZOcol+hsQKgBrUVvUYUJrMnWO1TZCrm6MBLi57hxMN6X75scdY/mQf+pqJGVV
         1EMKDdvY2uF3g==
Message-ID: <6435f64ee2d1da8261ea1aed4b244a674e6ecac3.camel@kernel.org>
Subject: Re: [PATCH net-next 0/3] r8169: further improvements
From:   Saeed Mahameed <saeed@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 12 Jan 2021 12:21:48 -0800
In-Reply-To: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
References: <1bc3b7ef-b54a-d517-df54-27d61ca7ba94@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 09:27 +0100, Heiner Kallweit wrote:
> Series includes further smaller improvements.
> 
> Heiner Kallweit (3):
>   r8169: align rtl_wol_suspend_quirk with vendor driver and rename it
>   r8169: improve rtl8169_rx_csum
>   r8169: improve DASH support
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 81 +++++++++----------
> ----
>  1 file changed, 31 insertions(+), 50 deletions(-)
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

