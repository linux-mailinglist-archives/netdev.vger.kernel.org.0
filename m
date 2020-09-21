Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6BF273639
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgIUXJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:09:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:39138 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726457AbgIUXJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:09:27 -0400
X-UUID: 26c3d40a638743dc9777bb44bb154c1a-20200922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=ehfb91CZzudcGd//YT5PVZW9V0LBguKR5pLVDx0OdJs=;
        b=J6gt3PJox3P+JZ90sw6ZLwMiFYvPtU/3RDit4DItghK/7ej9mjVJGDx5FbT+eByNOHvX8pwwqDbR5HfqcELEdLmvvUZ6eddidEe838lv+PWPE/Z8RuaDRZWC3w7jpXgAtJIRXuat5HkoZz45omCv0Xqrxd6rlUsLCxMAJIvRLkI=;
X-UUID: 26c3d40a638743dc9777bb44bb154c1a-20200922
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1814755100; Tue, 22 Sep 2020 07:09:25 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n2.mediatek.inc (172.21.101.140) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 22 Sep 2020 07:09:24 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Sep 2020 07:09:23 +0800
From:   <sean.wang@mediatek.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, Sean Wang <objelf@gmail.com>,
        Steven Liu <steven.liu@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: [PATCH net-next] net: Update MAINTAINERS for MediaTek switch driver
Date:   Tue, 22 Sep 2020 07:09:23 +0800
Message-ID: <5d601ae7347d49268822356121d5388739311459.1600729601.git.objelf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2VhbiBXYW5nIDxvYmplbGZAZ21haWwuY29tPg0KDQpVcGRhdGUgbWFpbnRhaW5lcnMg
Zm9yIE1lZGlhVGVrIHN3aXRjaCBkcml2ZXIgd2l0aCBMYW5kZW4gQ2hhbyB3aG8gaXMNCmZhbWls
aWFyIHdpdGggTWVkaWFUZWsgTVQ3NTN4IHN3aXRjaCBkZXZpY2VzIGFuZCB3aWxsIGhlbHAgbWFp
bnRlbmFuY2UNCmZyb20gdGhlIHZlbmRvciBzaWRlLg0KDQpDYzogU3RldmVuIExpdSA8c3RldmVu
LmxpdUBtZWRpYXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTZWFuIFdhbmcgPHNlYW4ud2FuZ0Bt
ZWRpYXRlay5jb20+DQpTaWduZWQtb2ZmLWJ5OiBMYW5kZW4gQ2hhbyA8TGFuZGVuLkNoYW9AbWVk
aWF0ZWsuY29tPg0KLS0tDQogTUFJTlRBSU5FUlMgfCAxICsNCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKykNCg0KZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMNCmlu
ZGV4IGUzYzFjNzAwNTdlNC4uMGVlMDhmMTMxYTQyIDEwMDY0NA0KLS0tIGEvTUFJTlRBSU5FUlMN
CisrKyBiL01BSU5UQUlORVJTDQpAQCAtMTEwNjIsNiArMTEwNjIsNyBAQCBGOglkcml2ZXJzL2No
YXIvaHdfcmFuZG9tL210ay1ybmcuYw0KIA0KIE1FRElBVEVLIFNXSVRDSCBEUklWRVINCiBNOglT
ZWFuIFdhbmcgPHNlYW4ud2FuZ0BtZWRpYXRlay5jb20+DQorTToJTGFuZGVuIENoYW8gPExhbmRl
bi5DaGFvQG1lZGlhdGVrLmNvbT4NCiBMOgluZXRkZXZAdmdlci5rZXJuZWwub3JnDQogUzoJTWFp
bnRhaW5lZA0KIEY6CWRyaXZlcnMvbmV0L2RzYS9tdDc1MzAuKg0KLS0gDQoyLjI1LjENCg==

