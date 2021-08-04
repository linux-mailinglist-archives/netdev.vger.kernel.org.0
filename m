Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ACA3DFB5F
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 08:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbhHDGTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 02:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235530AbhHDGTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 02:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D116F61050;
        Wed,  4 Aug 2021 06:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628057978;
        bh=HA9klDKAhB7u3xKjbiam5DW++hiAgHCppM/HwIeAtUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yafcmiN1BdLf9LGsrtbn80lbU87dSotnVIWLws+xFBjyFaVHvzT/hY9CWSQH84QzX
         70BLYRB1Kvs6pN+XFUfp+nBc7bu98PonztZ6BCqavDe8Wgp+gka0goCgb+EzhTK6x2
         3O9SaBa0vak+Xt7Bia61MYf5jK0kwf1CklQ5gcsk=
Date:   Wed, 4 Aug 2021 08:19:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com, davem@davemloft.net,
        stable@vger.kernel.org, Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net v3 2/2] net: usb: pegasus: Remove the changelog and
 DRIVER_VERSION.
Message-ID: <YQoxd4gU+J7874Ts@kroah.com>
References: <20210803172524.6088-1-petko.manolov@konsulko.com>
 <20210803172524.6088-3-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803172524.6088-3-petko.manolov@konsulko.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:25:24PM +0300, Petko Manolov wrote:
> From: Petko Manolov <petkan@nucleusys.com>
> 
> These are now deemed redundant.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> ---
>  drivers/net/usb/pegasus.c | 30 ++----------------------------
>  1 file changed, 2 insertions(+), 28 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
