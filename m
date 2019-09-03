Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB9AA6AD7
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfICOJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 10:09:12 -0400
Received: from mail1.hager.com ([194.99.49.58]:41017 "HELO mail1.hager.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1728122AbfICOJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 10:09:12 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2019 10:09:11 EDT
Received: from mail1.hager.com (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id B31AB6078A;
        Tue,  3 Sep 2019 15:59:38 +0200 (CEST)
Received: from SAASIMSVAP01.fra.hager.corp (unknown [194.99.49.62])
        by mail1.hager.com (Postfix) with ESMTP id A3750603EE;
        Tue,  3 Sep 2019 15:59:38 +0200 (CEST)
Received: from SAASIMSVAP01.fra.hager.corp (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 759D6A406B;
        Tue,  3 Sep 2019 15:59:18 +0200 (CEST)
Received: from SAASMSXP05.fra.hager.corp (unknown [10.109.2.45])
        by SAASIMSVAP01.fra.hager.corp (Postfix) with ESMTP id 6A6FCA4068;
        Tue,  3 Sep 2019 15:59:18 +0200 (CEST)
Received: from SAASMSXP05.fra.hager.corp (10.109.2.45) by
 SAASMSXP05.fra.hager.corp (10.109.2.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1531.3; Tue, 3 Sep 2019 15:59:18 +0200
Received: from SAASMSXP05.fra.hager.corp ([10.109.2.45]) by
 SAASMSXP05.fra.hager.corp ([10.109.2.45]) with mapi id 15.01.1531.003; Tue, 3
 Sep 2019 15:59:18 +0200
From:   HOLTZ Matthieu <matthieu.holtz@hagergroup.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "matthieu.holtz@gmail.com" <matthieu.holtz@gmail.com>
Subject: KSZ8863 ethernet PHY support question
Thread-Topic: KSZ8863 ethernet PHY support question
Thread-Index: AdViX6cCOr/iwtlnSTesTQkUz/6UZw==
Date:   Tue, 3 Sep 2019 13:59:18 +0000
Message-ID: <deba2802f6914ac3ba3245de0bfd2c1a@hagergroup.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.49.1.147]
x-exclaimer-md-config: 44955ae8-93b3-479a-ad4a-f722a0584362
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-TM-AS-GCONF: 11111111
X-TM-AS-SMTP: 1.0 U0FBU01TWFAwNS5mcmEuaGFnZXIuY29ycA== 
        bWF0dGhpZXUuaG9sdHpAaGFnZXJncm91cC5jb20=
X-TM-AS-ERS: 10.109.2.45-0.0.0.0
X-TM-AS-Product-Ver: IMSVA-9.1.0.1842-8.2.0.1013-23674.006
X-TMASE-Version: IMSVA-9.1.0.1842-8.2.1013-23674.006
X-TMASE-Result: 10--0.851800-10.000000
X-TMASE-MatchedRID: Z4bnI9qGcPydtLQ02m0B1riMC5wdwKqdMApqy5cfknXkMnUVL5d0E0Ue
        RhGY4VMdvgx58gWPp2LQFeKTnsl15EkjllSXrjtQ0gVVXNgaM0pyZ8zcONpAsdmzcdRxL+xwKra
        uXd3MZDUECaJkddKf9BmRJGsLym8J0casLRWAYzbmyqP/9SB8WK62XKzOiygPp5DFxO/tuzWUSS
        JPERKCCG1G0sdA2yd47FHW4PQA8ke6rLuaBPjT2g==
X-TMASE-SNAP-Result: 1.821001.0001-0-2-1:0,12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCknigJlkIGxpa2UgdG8gdXNlIGEgc3dpdGNoIHBoeSBLU1o4ODYzIHdpdGggYW4g
TlhQIGkubXg4bW0gTVBVIChuZXcgbW90aGVyYm9hcmQgZGV2KSBhbmQgYSBrZXJuZWwgNC4xNC54
IGJ1dCBJIGFtIGEgYml0IGxvc3QgcmVnYXJkaW5nIHRoZSBkcml2ZXIgc3VwcG9ydC4NCg0KSXMg
dGhlIFBoeSBzdXBwb3J0ZWQgYnkgdGhlIGRyaXZlciB1bmRlciBsaW51eC9kcml2ZXJzL25ldC9w
aHkvbWljcmVsLmMgYW5kIHdoYXQgYWJvdXQgdGhlIHN3aXRjaCBjb25maWd1cmF0aW9uLCBpcyBp
dCBpbXBsZW1lbnRlZCBpbiB0aGUgRFNBIHN1YnN5c3RlbSA/DQoNCktSLA0KTWF0dGhpZXUgSA0K
