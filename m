Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D57289FAE
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 11:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgJJJzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 05:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgJJJuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 05:50:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05622184D;
        Sat, 10 Oct 2020 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602323408;
        bh=RXC5xfWPGap97Kf/8w9E8um1wI1s4p6TDrC8nncf/W8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gE+R6o0WgK+hfLUR6OQqXr8LKb9PIamD5KL6oqMOvRkPZaNzPy8vGdhdPh6t/UhVi
         h7bVtfOrwctRlEiv5bGHWvS8Qe702zkL3CrGxTrzmdIX3D6X4hILxg29c+qOo1F8wV
         syyPaWy543VBm7D2tBfb4b0ba+xMexpCi+PCROFQ=
Date:   Sat, 10 Oct 2020 11:50:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 4/4] dt-bindings: usb: use preferred license tag
Message-ID: <20201010095052.GA989257@kroah.com>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
 <d76ca8b2d64c7c017e3ddaca8497eb38ee514204.1602318869.git.chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d76ca8b2d64c7c017e3ddaca8497eb38ee514204.1602318869.git.chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 04:43:14PM +0800, Chunfeng Yun wrote:
> This is used to fix the checkpach.pl WARNING:SPDX_LICENSE_TAG
> 
> See bindings/submitting-patches.rst:
> "DT binding files should be dual licensed. The preferred license tag is
>  (GPL-2.0-only OR BSD-2-Clause)."
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v2: new patch
> ---
>  Documentation/devicetree/bindings/usb/usb-hcd.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-hcd.yaml b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
> index 42b295afdf32..11b9b9ee2b54 100644
> --- a/Documentation/devicetree/bindings/usb/usb-hcd.yaml
> +++ b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)

Are you sure you are allowed to change the license of this file?  Last I
checked, you did not write this file, and so, you can't change the
license of it.  You need to get the owners of the file to do so.

thanks,

greg k-h
