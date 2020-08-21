Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A551424D77F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHUOmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 10:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgHUOmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 10:42:10 -0400
Received: from coco.lan (ip5f5ad5bf.dynamic.kabel-deutschland.de [95.90.213.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05D512078B;
        Fri, 21 Aug 2020 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598020928;
        bh=oZnskDyx49feGRU1KivrlcX9Ad2+BpqnA5lPTA64O8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TM5fK7GvQnAs4QuEft/iwxbpoY78lVyQ499aIFK9Sa67v+FeZFjpsiiZREgfmjpP7
         F3wg8pER3AL0vqDXvCJz2TcQ0e0v2xkCaUoU0CrC5EmmIP99YKxfqHltzvoTX1ZBz7
         /XGjEqvRbxj0QEnDxNw/MfGzBLR1d5g80zBFWmO8=
Date:   Fri, 21 Aug 2020 16:41:58 +0200
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
Message-ID: <20200821164158.22777f95@coco.lan>
In-Reply-To: <20200819173558.GA3733@ravnborg.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <20200819152120.GA106437@ravnborg.org>
        <20200819174027.70b39ee9@coco.lan>
        <20200819173558.GA3733@ravnborg.org>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another quick question:

Em Wed, 19 Aug 2020 19:35:58 +0200
Sam Ravnborg <sam@ravnborg.org> escreveu:

> > +#define DSS_REDUCE(x)	((x) > 0 ? ((x) - 1) : (x))  
> Use generic macros for this?

Do you know a generic macro similar to this? Or do you mean adding
it to include/kernel.h?

There are the atomic sub ones, but doesn't make sense here.

The closest one I found was min_not_zero(), but this would
take two args.

Btw, I agree that the name here is a bit odd... I would
have called such macro as 'dec_not_zero()'.

Thanks,
Mauro
