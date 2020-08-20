Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EFF24B025
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHTH3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:29:07 -0400
Received: from mail.netline.ch ([148.251.143.178]:42737 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgHTH3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 03:29:07 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 03:29:05 EDT
Received: from localhost (localhost [127.0.0.1])
        by netline-mail3.netline.ch (Postfix) with ESMTP id 9BE3A2A6042;
        Thu, 20 Aug 2020 09:21:11 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at netline-mail3.netline.ch
Received: from netline-mail3.netline.ch ([127.0.0.1])
        by localhost (netline-mail3.netline.ch [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id mT6Tvc2NwglX; Thu, 20 Aug 2020 09:21:11 +0200 (CEST)
Received: from thor (212.174.63.188.dynamic.wline.res.cust.swisscom.ch [188.63.174.212])
        by netline-mail3.netline.ch (Postfix) with ESMTPSA id 0ADF22A6016;
        Thu, 20 Aug 2020 09:21:09 +0200 (CEST)
Received: from localhost ([::1])
        by thor with esmtp (Exim 4.94)
        (envelope-from <michel@daenzer.net>)
        id 1k8esn-002Aez-Ao; Thu, 20 Aug 2020 09:21:09 +0200
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
To:     Sam Ravnborg <sam@ravnborg.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linaro-mm-sig@lists.linaro.org, Rob Herring <robh+dt@kernel.org>,
        mauro.chehab@huawei.com, Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Liuyao An <anliuyao@huawei.com>,
        netdev@vger.kernel.org, Rongrong Zou <zourongrong@gmail.com>,
        bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org> <20200819174027.70b39ee9@coco.lan>
 <20200819204800.GA110118@ravnborg.org>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <0ddfd309-46d8-b69b-d1c6-e22384b78070@daenzer.net>
Date:   Thu, 20 Aug 2020 09:21:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200819204800.GA110118@ravnborg.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-19 10:48 p.m., Sam Ravnborg wrote:
> Hi Mauro.
> 
> It seems my review comments failed to reach dri-devel - likely due to
> the size of the mail.

Right, some e-mails in this thread went through the dri-devel moderation
queue due to their sizes. This mail of yours did as well, because you
didn't trim the quoted text (hint, hint).


-- 
Earthling Michel Dänzer               |               https://redhat.com
Libre software enthusiast             |             Mesa and X developer
