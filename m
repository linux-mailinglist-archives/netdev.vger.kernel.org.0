Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808DE2B7A36
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKRJSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 04:18:33 -0500
Received: from Mailgw01.mediatek.com ([1.203.163.78]:11152 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726837AbgKRJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:18:32 -0500
X-UUID: e40d2a85f990416ea17f906529bcf277-20201118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=qfpE3TD0SXn2IdwIG4zbudRW/4wZoYJlExaUY6FckbM=;
        b=jGaw3LpG+D2ZJSq0ti/x1pZ2cREV4x5dTfwNc14vDBS3Nhkpzwf3BEqV2E8Oir6FmH79EoovD+NgdDIhs52XCnjxlE4jDmYhp1RsVITJjuTG1M8aOgP0QwjZssHw8dRuWwozmn0X+zk1gJcgprqenaskRAssgFfCN4lMyVKdts0=;
X-UUID: e40d2a85f990416ea17f906529bcf277-20201118
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 813261830; Wed, 18 Nov 2020 17:18:27 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS31DR.mediatek.inc (172.27.6.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 18 Nov 2020 17:18:24 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 17:18:24 +0800
Message-ID: <1605691104.18082.3.camel@mtkswgap22>
Subject: Re: [PATCH v3 05/11] dt-bindings: phy: convert phy-mtk-ufs.txt to
 YAML schema
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "David Airlie" <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Kishon Vijay Abraham I" <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Min Guo <min.guo@mediatek.com>,
        <dri-devel@lists.freedesktop.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>
Date:   Wed, 18 Nov 2020 17:18:24 +0800
In-Reply-To: <20201118082126.42701-5-chunfeng.yun@mediatek.com>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
         <20201118082126.42701-5-chunfeng.yun@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 3661B6D048093FC12761A842A0EF53BC43F4169167C5DF3D9BA71DE7D2A9FEBD2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTExLTE4IGF0IDE2OjIxICswODAwLCBDaHVuZmVuZyBZdW4gd3JvdGU6DQo+
IENvbnZlcnQgcGh5LW10ay11ZnMudHh0IHRvIFlBTUwgc2NoZW1hIG1lZGlhdGVrLHVmcy1waHku
eWFtbA0KPiANCj4gQ2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IENodW5mZW5nIFl1biA8Y2h1bmZlbmcueXVuQG1lZGlhdGVrLmNvbT4N
Cj4gUmV2aWV3ZWQtYnk6IFJvYiBIZXJyaW5nIDxyb2JoQGtlcm5lbC5vcmc+DQoNClJldmlld2Vk
LWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo=

