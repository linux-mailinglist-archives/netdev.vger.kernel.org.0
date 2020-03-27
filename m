Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5773A195FA5
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgC0UZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:25:23 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:12414 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726959AbgC0UZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:25:22 -0400
X-UUID: fc4de451caf94de1905136eed59a291e-20200328
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Srf3BRn2UUVY4cXD1Kv+sL+AswQnzJsHnmQNVtOozvY=;
        b=IThb/2dXv2ASi0QKA6TjB9GbJT6/Uy/2tv1gbXF2mWgRPS36RGnKo3uEJn08mZdX08GcoXXyHpqnkY6eXFIvbMAMy937hn5gMM707G9YJ1Dvts3sQjY9ZkX+jNnY7eyHaq+6YzHwYTsOEsERv5aW5Jeftr2JO4C2bU3Qet3fGVM=;
X-UUID: fc4de451caf94de1905136eed59a291e-20200328
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 617636089; Sat, 28 Mar 2020 04:25:18 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 28 Mar 2020 04:25:16 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 28 Mar 2020 04:25:15 +0800
From:   <sean.wang@mediatek.com>
To:     <netdev@vger.kernel.org>
CC:     <sean.wang@mediatek.com>, <frank-w@public-files.de>,
        <landen.chao@mediatek.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <matthias.bgg@gmail.com>,
        <linux@armlinux.org.uk>, <linux-mediatek@lists.infradead.org>
Subject: =?UTF-8?q?Re=3A=20=5BPATCH=20net-next=5D=20net=3A=20dsa=3A=20mt7530=3A=20use=20resolved=20link=20config=20in=20mac=5Flink=5Fup=28=29?=
Date:   Sat, 28 Mar 2020 04:25:14 +0800
Message-ID: <1585340714-9932-1-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20200327144412.100913-1-opensource@vdorst.com>
References: <20200327144412.100913-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2VhbiBXYW5nIDxzZWFuLndhbmdAbWVkaWF0ZWsuY29tPg0KDQo+Q29udmVydCB0aGUg
bXQ3NTMwIHN3aXRjaCBkcml2ZXIgdG8gdXNlIHRoZSBmaW5hbGlzZWQgbGluayBwYXJhbWV0ZXJz
IGluIG1hY19saW5rX3VwKCkgcmF0aGVyIHRoYW4gdGhlIHBhcmFtZXRlcnMgaW4gbWFjX2NvbmZp
ZygpLg0KPg0KPlNpZ25lZC1vZmYtYnk6IFJlbsOpIHZhbiBEb3JzdCA8b3BlbnNvdXJjZUB2ZG9y
c3QuY29tPg0KDQpUaGF0IHBhdGNoIHdvcmtzIHdlbGwgd2l0aCBlaXRoZXIgVFJHTUkgb24gUkdN
SUkgbW9kZSBvbiBNVDc2MjMgcmVmZXJlbmNlIGJvYXJkLg0KDQpUZXN0ZWQtYnk6IFNlYW4gV2Fu
ZyA8c2Vhbi53YW5nQG1lZGlhdGVrLmNvbT4NCg0KPi0tLQ0KPiBkcml2ZXJzL25ldC9kc2EvbXQ3
NTMwLmMgfCA1NyArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IGRy
aXZlcnMvbmV0L2RzYS9tdDc1MzAuaCB8ICA0ICsrKw0KPiAyIGZpbGVzIGNoYW5nZWQsIDI4IGlu
c2VydGlvbnMoKyksIDMzIGRlbGV0aW9ucygtKQ0KPg0KPmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbXQ3NTMwLmMgYi9kcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmMgaW5kZXggNmU5MWZlMmY0
YjlhLi5lZjU3NTUyZGIyNjAgMTAwNjQ0DQo+LS0tIGEvZHJpdmVycy9uZXQvZHNhL210NzUzMC5j
DQo+KysrIGIvZHJpdmVycy9uZXQvZHNhL210NzUzMC5jDQo+QEAgLTU2MywxNyArNTYzLDYgQEAg
bXQ3NTMwX21pYl9yZXNldChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+IAltdDc1MzBfd3JpdGUo
cHJpdiwgTVQ3NTMwX01JQl9DQ1IsIENDUl9NSUJfQUNUSVZBVEUpOyAgfQ0KPiANCj4tc3RhdGlj
IHZvaWQNCj4tbXQ3NTMwX3BvcnRfc2V0X3N0YXR1cyhzdHJ1Y3QgbXQ3NTMwX3ByaXYgKnByaXYs
IGludCBwb3J0LCBpbnQgZW5hYmxlKSAtew0KPi0JdTMyIG1hc2sgPSBQTUNSX1RYX0VOIHwgUE1D
Ul9SWF9FTiB8IFBNQ1JfRk9SQ0VfTE5LOw0KPi0NCj4tCWlmIChlbmFibGUpDQo+LQkJbXQ3NTMw
X3NldChwcml2LCBNVDc1MzBfUE1DUl9QKHBvcnQpLCBtYXNrKTsNCj4tCWVsc2UNCj4tCQltdDc1
MzBfY2xlYXIocHJpdiwgTVQ3NTMwX1BNQ1JfUChwb3J0KSwgbWFzayk7DQo+LX0NCj4tDQo+

