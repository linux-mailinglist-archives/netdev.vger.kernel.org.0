Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE12D75A4
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405947AbgLKM3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:29:30 -0500
Received: from mailgw01.mediatek.com ([216.200.240.184]:57234 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389290AbgLKM1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:27:31 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2020 07:27:31 EST
X-UUID: a0002f06022b405e8735729346210bda-20201211
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jz0BU0zD8nJZqu8nclwQbGirKMqo34maEeKezynR3Kg=;
        b=TVsuF1eLs9Dt85MqEQPE49V4zRUAQdTVoyH6eG9HJUwVqYrOy1WHlITspiCvGe0LCDkb4PW0RrELE89R9mQCbtOJVE2SWnUoz4g94pZNtrHkZ9J129ql9FsJlLxfPf9Ft2RMBf5RGzUpxIGE/HQPzdn/QsTmntrr63n36L5PuNQ=;
X-UUID: a0002f06022b405e8735729346210bda-20201211
Received: from mtkcas66.mediatek.inc [(172.29.193.44)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1818083420; Fri, 11 Dec 2020 04:21:36 -0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 MTKMBS62N2.mediatek.inc (172.29.193.42) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Dec 2020 04:11:33 -0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Dec 2020 20:11:31 +0800
Message-ID: <1607688692.8846.2.camel@mtksdccf07>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable MTU normalization
From:   Landen Chao <landen.chao@mediatek.com>
To:     DENG Qingfang <dqfext@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Date:   Fri, 11 Dec 2020 20:11:32 +0800
In-Reply-To: <20201210170322.3433-1-dqfext@gmail.com>
References: <20201210170322.3433-1-dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEyLTExIGF0IDAxOjAzICswODAwLCBERU5HIFFpbmdmYW5nIHdyb3RlOg0K
PiBNVDc1MzAgaGFzIGEgZ2xvYmFsIFJYIGxlbmd0aCByZWdpc3Rlciwgc28gd2UgYXJlIGFjdHVh
bGx5IGNoYW5naW5nIGl0cw0KPiBNUlUuDQo+IEVuYWJsZSBNVFUgbm9ybWFsaXphdGlvbiBmb3Ig
dGhpcyByZWFzb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBERU5HIFFpbmdmYW5nIDxkcWZleHRA
Z21haWwuY29tPg0KPiAtLS0NCkFja2VkLWJ5OiBMYW5kZW4gQ2hhbyA8bGFuZGVuLmNoYW9AbWVk
aWF0ZWsuY29tPg0KDQpCZXN0IHJlZ2FyZHMsDQpsYW5kZW4NCg0KDQo=

