Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFD51AAD74
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415325AbgDOQNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:13:34 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:6138
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415293AbgDOQNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:13:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpXGtCFGELEqSPYIPzJfzget8T7ZEk1z1+RCOYaM+rd9kK8+aNfgN5rRHhuKjTVqOY+r9pykab2jwpPFMWBfGo4JLIlFO48EhM3kV78gh6CdrY3Ll6C3V7axBxUoJxjxy6kn466y7OBIbzDq7vJPMmiwtKiK4JAU6JPdJ2ft7RFOtSwTX0NTnlFYUw7+3XGoDs776TCkjMSdNbIC2OUCSvZCyJXlKxRocaWhXri+KvsSxWZosw5kZa4t6o6zY/mGySTMkHLs2Zedlcpm73HBUhxaqXK8VdxCAfqPNEZsejNF4Uj+KLCz17gisiuHO+/tJHnzFNv0Pm8JIBRRZ1NQMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMMpG8gnISmIROGGpUscDAlczvuyFeJmquYoEVpkyCc=;
 b=LzMRUz1SYcRd2U+L/akzoL7CzfaRb3XW2VbKaBloheFyRq7RQNvHIUmUWdj2LzZMy8JnDM2hk8gQDybqMPqBYhptHWWdIHZVgdcGTIk1DBw1rwv076QGV8NvVjo/gnI/d7LvB7sMzi9pw+9tGkFWOtDBqOZwWd3yPak2TuDXkGgz9cyJ/R1SRCM/dc2yWm8JODGkzi+Opqk79BICLUpl/ExgxqxHJSmxUczlHatmF5MXx+CTKT2JIwAy9Q63SuWd+y+zFlBZhXnkAWUJmK2BNP1TqZn7txEC7P9jJtH+qi0fnqpp6Tb/GJZZQI88xvLljHpWvsHU/PGprvjhQI82Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMMpG8gnISmIROGGpUscDAlczvuyFeJmquYoEVpkyCc=;
 b=fCxQBa+hQFwVK5FWAA73+Evh7H2VLdOy4+W6tyuUJARgu8LcJYdO1Y7xXTbzGLqKJ8+DS4PKtwq2/5iYvzX9PEN5B/3ppgxiE0C1BxmV204b4YadSvALQCtwMd8/JBQmF/+J3abhEcusuzbdFXIebRfcNaYsJ3Z0/yRATAS2t+k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1327.namprd11.prod.outlook.com (2603:10b6:300:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 15 Apr
 2020 16:13:03 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:13:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 20/20] staging: wfx: update TODO
Date:   Wed, 15 Apr 2020 18:11:47 +0200
Message-Id: <20200415161147.69738-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:13:01 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1a22fcc-e692-45d0-a3ad-08d7e157dfcf
X-MS-TrafficTypeDiagnostic: MWHPR11MB1327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1327C744ED648368B841C1AA93DB0@MWHPR11MB1327.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(136003)(346002)(366004)(376002)(396003)(4326008)(966005)(81156014)(107886003)(52116002)(54906003)(8676002)(478600001)(8936002)(6506007)(5660300002)(6512007)(36756003)(8886007)(86362001)(316002)(6486002)(1076003)(2616005)(186003)(2906002)(66574012)(6666004)(66556008)(16526019)(66946007)(66476007)(15650500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KiB6MGJ3LRxuqSR9ScBeyqxStb7RTb+RkengRBAsQ2e0oVag/7uoLTuK7Amle7WzDmniCXO47tFcuPUx02NcPAlvjgLv9PiNg0Bi3JfVLVOLybnzVBI1WUFMXGQFJLrpUoumWVXAjc2dmJJkShPUXlDgG56gAX51R2BxwBVFVCQ+Yljtq6HeKTvLzB4j3gezFbUpAQsFu16yDKlko6LBo6m+TEB5P1Lv9y/003X5eB34PAu3SxaqkzP141WvGjkQIQ1wDfOo16X35JyPDnD6yCwTVvIl8/AflzHmJAWz804/s+WK+zTziwvhn1V5VDp9NqcTc4/wHBr+vLWpDbQcd1/3Dvj6NEOMm4gGBD0UleDyjZaH17zX+eV7a8XUAjgEF6J2iOHvNnKghvlRSsTgHhhydm0oQeQ02vTgX8N0TMY0OvPGqqZiU09twAurTUFiw1tgMSm+WyQ5MREzDm3xucyzlfMAkiQUoif29bCy/hyB4epXdXev4vmEYWvHPLoNuy+qEw8C1BROXWh20YD+SQ==
X-MS-Exchange-AntiSpam-MessageData: 3ImYzr2IDHDpw+QGVHWrxWCEaO++cRZ0WTIPpjcWED8fv+atShJRumVSzxW9z6tP3Do7oFvG2sOU0aJiFr4eKi0WRegwbLwv5m26wwQ/oAR4O25qrqT6lIp1twjMwtJx//GpccBmpDtRsUH04Y/qY7QERWUsK76fEqIesbRm3AGJ/fL/+A6bueTJ8mhNEWXA9nZyOT4eEcIpvzn8JrwsNQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a22fcc-e692-45d0-a3ad-08d7e157dfcf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:13:03.0635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqMko9GGvsZMwM7qX9CPHvKCC9ctloagB2NdmXMYs5kr1CgS1IskcfnuozwEIjMD0C1TtYIT22z9SLXRAa/Siw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVXBk
YXRlIHRoZSBUT0RPIGxpc3QgYXNzb2NpYXRlZCB0byB0aGUgd2Z4IGRyaXZlciB3aXRoIHRoZSBs
YXN0CnByb2dyZXNzZXMgYW5kIGxhc3QgcmVtYXJrcyBtYWRlIGJ5IHJldmlld2Vycy4KClRoZSBp
dGVtcyBhYm91dCBzdXBwb3J0IGZvciBQMlAgYW5kIG1lc2ggaGF2ZSBhbHNvIGJlZW4gcmVtb3Zl
ZC4gSW5kZWVkLAppdCBzZWVtcyB0aGF0IHRoZSBkZXZpY2UgZG9lcyBub3QgZnVsbHkgc3VwcG9y
dCB0aGVtLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvVE9ETyB8IDQwICsrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNl
cnRpb25zKCspLCAyOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L1RPRE8gYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8KaW5kZXggZWZjYjdjNmE1YWE3Li5m
Y2EzMzMyZTQyY2UgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8KQEAgLTEsMjYgKzEsMTggQEAKIFRoaXMgaXMgYSBsaXN0
IG9mIHRoaW5ncyB0aGF0IG5lZWQgdG8gYmUgZG9uZSB0byBnZXQgdGhpcyBkcml2ZXIgb3V0IG9m
IHRoZQogc3RhZ2luZyBkaXJlY3RvcnkuCiAKLSAgLSBBbGwgc3RydWN0dXJlcyBkZWZpbmVkIGlu
IGhpZl9hcGlfKi5oIGFyZSBpbnRlbmRlZCB0byBzZW50L3JlY2VpdmVkIHRvL2Zyb20KLSAgICBo
YXJkd2FyZS4gQWxsIHRoZWlyIG1lbWJlcnMgd2hvdWxkIGJlIGRlY2xhcmVkIF9fbGUzMiBvciBf
X2xlMTYuCi0gICAgU2VlOgorICAtIFRoZSBISUYgQVBJIGlzIG5vdCB5ZXQgY2xlYW4gZW5vdWdo
LgorCisgIC0gRml4IHN1cHBvcnQgZm9yIGJpZyBlbmRpYW4gYXJjaGl0ZWN0dXJlcy4gU2VlOgog
ICAgICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAxOTExMTEyMDI4NTIuR1gyNjUz
MEBaZW5JVi5saW51eC5vcmcudWsKIAotICAtIE9uY2UgcHJldmlvdXMgaXRlbSBkb25lLCBpdCB3
aWxsIGJlIHBvc3NpYmxlIHRvIGF1ZGl0IHRoZSBkcml2ZXIgd2l0aAotICAgIGBzcGFyc2UnLiBJ
dCB3aWxsIHByb2JhYmx5IGZpbmQgdG9ucyBvZiBwcm9ibGVtcyB3aXRoIGJpZyBlbmRpYW4KLSAg
ICBhcmNoaXRlY3R1cmVzLgorICAtIFRoZSBwb2ludGVycyByZXR1cm5lZCBieSBhbGxvY2F0aW9u
IGZ1bmN0aW9ucyBhcmUgYWx3YXlzIGNoZWNrZWQuCiAKLSAgLSBoaWZfYXBpXyouaCB3aGF2ZSBi
ZWVuIGltcG9ydGVkIGZyb20gZmlybXdhcmUgY29kZS4gU29tZSBvZiB0aGUgc3RydWN0dXJlcwot
ICAgIGFyZSBuZXZlciB1c2VkIGluIGRyaXZlci4KKyAgLSBUaGUgY29kZSB0aGF0IGNoZWNrIHRo
ZSBjb3JlY3RuZXNzIG9mIHJlY2VpdmVkIG1lc3NhZ2UgKGluIHJ4X2hlbHBlcigpKSBjYW4KKyAg
ICBiZSBpbXByb3ZlZC4gU2VlOgorICAgICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaXZl
cmRldi1kZXZlbC8yMzAyNzg1LjZDN09EQzJMWW1AcGMtNDIvCiAKLSAgLSBEcml2ZXIgdHJ5IHRv
IG1haW50YWlucyBwb3dlciBzYXZlIHN0YXR1cyBvZiB0aGUgc3RhdGlvbnMuIEhvd2V2ZXIsIHRo
aXMKLSAgICB3b3JrIGlzIGFscmVhZHkgZG9uZSBieSBtYWM4MDIxMS4gc3RhX2FzbGVlcF9tYXNr
IGFuZCBwc3BvbGxfbWFzayBzaG91bGQgYmUKLSAgICBkcm9wcGVkLgotCi0gIC0gd2Z4X3R4X3F1
ZXVlc19nZXQoKSBzaG91bGQgYmUgcmV3b3JrZWQuIEl0IGN1cnJlbnRseSB0cnkgY29tcHV0ZSBp
dHNlbGYgdGhlCi0gICAgUW9TIHBvbGljeS4gSG93ZXZlciwgZmlybXdhcmUgYWxyZWFkeSBkbyB0
aGUgam9iLiBGaXJtd2FyZSB3b3VsZCBwcmVmZXIgdG8KLSAgICBoYXZlIGEgZmV3IHBhY2tldHMg
aW4gZWFjaCBxdWV1ZSBhbmQgYmUgYWJsZSB0byBjaG9vc2UgaXRzZWxmIHdoaWNoIHF1ZXVlIHRv
Ci0gICAgdXNlLgorICAtIFN1cHBvcnQgZm9yIFNESU8gd2l0aCBleHRlcm5hbCBJUlEgaXMgYnJv
a2VuLgogCiAgIC0gQXMgc3VnZ2VzdGVkIGJ5IEZlbGl4LCByYXRlIGNvbnRyb2wgY291bGQgYmUg
aW1wcm92ZWQgZm9sbG93aW5nIHRoaXMgaWRlYToKICAgICAgICAgaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGttbC8zMDk5NTU5Lmd2M1E3NUtuTjFAcGMtNDIvCkBAIC0yOCwxNyArMjAsOCBAQCBz
dGFnaW5nIGRpcmVjdG9yeS4KICAgLSBXaGVuIGRyaXZlciBpcyBhYm91dCB0byBsb29zZSBCU1Ms
IGl0IGZvcmdlIGl0cyBvd24gTnVsbCBGdW5jIHJlcXVlc3QgKHNlZQogICAgIHdmeF9jcW1fYnNz
bG9zc19zbSgpKS4gSXQgc2hvdWxkIHVzZSBtZWNoYW5pc20gcHJvdmlkZWQgYnkgbWFjODAyMTEu
CiAKLSAgLSBBUCBpcyBhY3R1YWxseSBpcyBzZXR1cCBhZnRlciBhIGNhbGwgdG8gd2Z4X2Jzc19p
bmZvX2NoYW5nZWQoKS4gWWV0LAotICAgIGllZWU4MDIxMV9vcHMgcHJvdmlkZSBjYWxsYmFjayBz
dGFydF9hcCgpLgotCi0gIC0gVGhlIGN1cnJlbnQgcHJvY2VzcyBmb3Igam9pbmluZyBhIG5ldHdv
cmsgaXMgaW5jcmVkaWJseSBjb21wbGV4LiBTaG91bGQgYmUKLSAgICByZXdvcmtlZC4KLQogICAt
IE1vbml0b3JpbmcgbW9kZSBpcyBub3QgaW1wbGVtZW50ZWQgZGVzcGl0ZSBiZWluZyBtYW5kYXRv
cnkgYnkgbWFjODAyMTEuCiAKLSAgLSAiY29tcGF0aWJsZSIgdmFsdWUgYXJlIG5vdCBjb3JyZWN0
LiBUaGV5IHNob3VsZCBiZSAidmVuZG9yLGNoaXAiLiBTZWU6Ci0gICAgICAgaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvZHJpdmVyZGV2LWRldmVsLzUyMjY1NzAuQ01INWhWbFpjSUBwYy00MgotCiAg
IC0gVGhlICJzdGF0ZSIgZmllbGQgZnJvbSB3ZnhfdmlmIHNob3VsZCBiZSByZXBsYWNlZCBieSAi
dmlmLT50eXBlIi4KIAogICAtIEl0IHNlZW1zIHRoYXQgd2Z4X3VwbG9hZF9rZXlzKCkgaXMgdXNl
bGVzcy4KQEAgLTQ5LDEyICszMiwxMyBAQCBzdGFnaW5nIGRpcmVjdG9yeS4KICAgLSBGZWF0dXJl
IGNhbGxlZCAic2VjdXJlIGxpbmsiIHNob3VsZCBiZSBlaXRoZXIgZGV2ZWxvcGVkICh1c2luZyBr
ZXJuZWwKICAgICBjcnlwdG8gQVBJKSBvciBkcm9wcGVkLgogCisgIC0gVGhlIGRldmljZSBhbGxv
d3MgdG8gZmlsdGVyIG11bHRpY2FzdCB0cmFmZmljLiBUaGUgY29kZSB0byBzdXBwb3J0IHRoZXNl
CisgICAgZmlsdGVycyBleGlzdHMgaW4gdGhlIGRyaXZlciBidXQgaXQgaXMgZGlzYWJsZWQgYmVj
YXVzZSBpdCBoYXMgbmV2ZXIgYmVlbgorICAgIHRlc3RlZC4KKwogICAtIEluIHdmeF9jbWRfc2Vu
ZCgpLCAiYXN5bmMiIGFsbG93IHRvIHNlbmQgY29tbWFuZCB3aXRob3V0IHdhaXRpbmcgdGhlIHJl
cGx5LgogICAgIEl0IG1heSBoZWxwIGluIHNvbWUgc2l0dWF0aW9uLCBidXQgaXQgaXMgbm90IHll
dCB1c2VkLiBJbiBhZGQsIGl0IG1heSBjYXVzZQogICAgIHNvbWUgdHJvdWJsZToKICAgICAgIGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaXZlcmRldi1kZXZlbC9hbHBpbmUuREVCLjIuMjEuMTkx
MDA0MTMxNzM4MS4yOTkyQGhhZHJpZW4vCiAgICAgU28sIGZpeCBpdCAoYnkgcmVwbGFjaW5nIHRo
ZSBtdXRleCB3aXRoIGEgc2VtYXBob3JlKSBvciBkcm9wIGl0LgogCi0gIC0gQ2hpcCBzdXBwb3J0
IFAyUCwgYnV0IGRyaXZlciBkb2VzIG5vdCBpbXBsZW1lbnQgaXQuCi0KLSAgLSBDaGlwIHN1cHBv
cnQga2luZCBvZiBNZXNoLCBidXQgZHJpdmVyIGRvZXMgbm90IGltcGxlbWVudCBpdC4KLS0gCjIu
MjUuMQoK
