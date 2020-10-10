Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B876A289F9D
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 11:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgJJJkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 05:40:07 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:14722 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726058AbgJJIw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 04:52:56 -0400
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2020 04:52:55 EDT
X-UUID: 68272fba54b846748cbffc4879a12b8e-20201010
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=6sHUyhe2bp+cJmLh9RM83LrzEjRu1vXNQUSVqfN6Cao=;
        b=nswxptfJcpsq2XP86I3RMRabeq0sbFlDp4Bu/Kmj1Oj6VVx+h3tCUQvKGZyF4rswnBQPEKKGVwXfzIT5qKzPN9PkvE7QXWQhtE6sL9Ve6TBBSEU/d+PXdAEzlN+l2rRu1oARAonjtcx6I0b8T1mpePrkDjn7Sk51l3tPvshIfb8=;
X-UUID: 68272fba54b846748cbffc4879a12b8e-20201010
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1869498794; Sat, 10 Oct 2020 16:43:18 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS31N1.mediatek.inc (172.27.4.69) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 10 Oct 2020 16:43:15 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 10 Oct 2020 16:43:16 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH v2 4/4] dt-bindings: usb: use preferred license tag
Date:   Sat, 10 Oct 2020 16:43:14 +0800
Message-ID: <d76ca8b2d64c7c017e3ddaca8497eb38ee514204.1602318869.git.chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 81C7BFD56C3FF5DF0971974FD98E8AF19CD3EED26B38F255A7C641B7BC3D0FC82000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyB1c2VkIHRvIGZpeCB0aGUgY2hlY2twYWNoLnBsIFdBUk5JTkc6U1BEWF9MSUNFTlNF
X1RBRw0KDQpTZWUgYmluZGluZ3Mvc3VibWl0dGluZy1wYXRjaGVzLnJzdDoNCiJEVCBiaW5kaW5n
IGZpbGVzIHNob3VsZCBiZSBkdWFsIGxpY2Vuc2VkLiBUaGUgcHJlZmVycmVkIGxpY2Vuc2UgdGFn
IGlzDQogKEdQTC0yLjAtb25seSBPUiBCU0QtMi1DbGF1c2UpLiINCg0KU2lnbmVkLW9mZi1ieTog
Q2h1bmZlbmcgWXVuIDxjaHVuZmVuZy55dW5AbWVkaWF0ZWsuY29tPg0KLS0tDQp2MjogbmV3IHBh
dGNoDQotLS0NCiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdXNiL3VzYi1oY2Qu
eWFtbCB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91c2Iv
dXNiLWhjZC55YW1sIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3VzYi91c2It
aGNkLnlhbWwNCmluZGV4IDQyYjI5NWFmZGYzMi4uMTFiOWI5ZWUyYjU0IDEwMDY0NA0KLS0tIGEv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3VzYi91c2ItaGNkLnlhbWwNCisrKyBi
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sDQpAQCAt
MSw0ICsxLDQgQEANCi0jIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQorIyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogKEdQTC0yLjAtb25seSBPUiBCU0QtMi1DbGF1c2UpDQogJVlB
TUwgMS4yDQogLS0tDQogJGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy91c2IvdXNi
LWhjZC55YW1sIw0KLS0gDQoyLjE4LjANCg==

