Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502FD2501B3
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgHXQGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHXQGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:06:12 -0400
Received: from coco.lan (unknown [95.90.213.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10B92072D;
        Mon, 24 Aug 2020 16:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598285171;
        bh=03hAu4nRPFwVwIO4v5NWL3jE+EDhR0ft7Y0oPd1gP0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y7swRGyvuvKiCu9/nrs1SXr8C+kHHYOQrQUSAJjGAjyfAkO2vlAob2lP+2GvOiVv3
         Pt1iO8jmNElYCkalrWgU0wwBm1cz8FdwsHljARxYM9slVfU3ws0JegC3Brl+1hW/zf
         NjcQkkkNKRa79YYaPTJPVie4PrwlTYTaf84FyRb4=
Date:   Mon, 24 Aug 2020 18:06:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, David Airlie <airlied@linux.ie>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mauro.chehab@huawei.com,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        Rongrong Zou <zourongrong@gmail.com>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200824180601.192adc3b@coco.lan>
In-Reply-To: <20200821155650.GB300361@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <20200819152120.GA106437@ravnborg.org>
        <20200819174027.70b39ee9@coco.lan>
        <20200819173558.GA3733@ravnborg.org>
        <20200821164158.22777f95@coco.lan>
        <20200821155650.GB300361@ravnborg.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 21 Aug 2020 17:56:50 +0200
Sam Ravnborg <sam@ravnborg.org> escreveu:

> Hi Mauro.
> 
> On Fri, Aug 21, 2020 at 04:41:58PM +0200, Mauro Carvalho Chehab wrote:
> > Another quick question:
> > 
> > Em Wed, 19 Aug 2020 19:35:58 +0200
> > Sam Ravnborg <sam@ravnborg.org> escreveu:
> >   
> > > > +#define DSS_REDUCE(x)	((x) > 0 ? ((x) - 1) : (x))    
> > > Use generic macros for this?  
> > 
> > Do you know a generic macro similar to this? Or do you mean adding
> > it to include/kernel.h?  
> 
> It looked like something there should be a macro for.
> But I do not know one.
> 
> And no, do not try to go the kernel.h route on this.
> At least not until you see more than one user.

Yeah, adding this to kernel.h just for a single usage is overkill. I would
be expecting that a non-underflow decrement logic is something that 
would be used on other places at the Kernel, but identifying this
pattern would require some time. Maybe Kernel janitors could write some
coccinelle script to replace similar patterns like that into some
macro in the future.

Thanks,
Mauro
