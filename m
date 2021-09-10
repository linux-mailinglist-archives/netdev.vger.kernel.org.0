Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C5406EE1
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhIJQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:00 -0400
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:20975
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229976AbhIJQIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSW9K4ZFO2+1n2Q/uQ09HkyMFR5qtGP098HD5eQhjhwFe1FnEr/Mrg9pjbtPdou7Ba5bh9eKDPxomTIwAEXKOvg/r+IQ5rpVIMYsEc8m05Wl44qcpaNytk6tWMPl53eQTsTVqdQv3O2QYX0S4h+vxQR5c+KqLS2JiZkoRjiBZxAcwaNDQxlYwxgaQ0z7bZmzTlAqbR2j/OHc1P7yaAP8etxVCrPgA7y2SUFmgwJ8DmQ5CycjZg1D9M8AXxzD5xvF5oTmG5cMlLY2Fu2bj2Y6nMO5m58HFXOECnMirY/h8OQpGLAkCWG1AolpNxsj4GbQYgXAW9jTb6JOW10vYFlRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HcjC0x4GRAxwfKkA5UMWXqZtFAOXbrjpXeRYZIftO60=;
 b=LDgSks/eQaLgc9PH2W5WZX9K4HTkhgE7PYNxIaQTAemgas5dhrcGesshQekvZ1Fa9XRn3WaeuzNIPwiJb2k/IOhKN4yg0tuDt+IM6/mS07Mgf1EkBxPikMcJy44tat1nj4bXqWUP2VvhkGHTWr41fD2lt7iAMagaYoxaFR65Iehy5pW8KpgEbn1qB4amq5H7a7Y2On+4hb36ySOHB2I+xQu5WPyMHnepJaiPPItNsYv1T8PEgcSOLPKhEoZQMZd+RR+bX+U3MySgm1wJUK1M7QVGHsk24vODwvOeBLoVJ46BXaxaIjoH/pKYDNFpVeNX9ee97S6Z4/1lGeGIvcpYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcjC0x4GRAxwfKkA5UMWXqZtFAOXbrjpXeRYZIftO60=;
 b=WjZ/5DFoEt9XSoXJnpV8huwcgqtK/ITV7UhdMZb6jXnsf+uUgPnp5EoQDPddDnkAhY5LxThhjuIwWmNp/w15KF1iMUKsBGiePPrSZH4+3jKMZCijYpC8Tz1Jv2KrZe+FHTHTCGnFswA8Q4CwrjQimEtjNr5Yj6TZlmZL0H6ANcI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Fri, 10 Sep
 2021 16:06:12 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:12 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 21/31] staging: wfx: remove unused definition
Date:   Fri, 10 Sep 2021 18:04:54 +0200
Message-Id: <20210910160504.1794332-22-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c51a0f47-e0a8-4b26-70e4-08d97474e91a
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB50021E3920EDEA958DB974AC93D69@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /pcpGlRDFgP5HE63fEUfYE3cjExHAvisG2f6DVJJdt4uhT9ef2N2r2+JPoX46KR3E0oyqC7jYdlqGQ8qiualZ42hyhTclx/PIz+MGRragju80hHThFTeZ6kzJRfcpTee4UeaUFy4nls2IsAwpdoR7k3UFrOxkSjwW3hvfGKcEGYGJkFMzA8sWiVCuEzGR2o8lNs1eF0HqJwnt+N3GzzbMbbH3z2ClgB5jPXsd5k2V/KE51vKt19qXeoQSHQ79EskYgPb7CSY7e3v+7avbYzTdU4zZkcje8d3l47RC3dpgit8Qs+VzTCUw2UeEIMgNzQIj7vqu/RsZN01yhofZ30Z6yO2kFiooQbslj0s7HfxceGDBTmNYyews3y7nvvkPGQUO5qPiQvzCPXdYf2EBx9a6TEOMP7tB630ZNNYvS5jkcKOkjMig1JUDm7NR63oc5uyoQOVsF6fsT+Y/sggD+Ad+8zjkXfgdgfknuBn5h7NQpELixecly+HItMmrWshAHXqUFPkjwzUEKdx8lLd0mwjnk6LprwvDguh+SBT4P9Kjxbg7huu6tk1GBXJmJtSKJqeBw8ybEprhnJEVUdLc3s+ZdSxnfdVlPqyOoGTfauDu/Xj0mshfsRPKw3gNHMLaJ6qmEmfIdX6N3WVnOec0qgGuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(52116002)(86362001)(38100700002)(8936002)(186003)(7696005)(4326008)(508600001)(8676002)(4744005)(36756003)(2616005)(6666004)(66556008)(316002)(66476007)(83380400001)(54906003)(66946007)(2906002)(1076003)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWNiVHNFbmVic3NyMjNrR0JuMU1NRDR3R2VuMDYvelVXMHRWcFhab21BVlVz?=
 =?utf-8?B?NC9ZRDFxUDVrVjRiVDRGQUNGQXYxMHZHQlorRUxSUzhhZFVNYU9JamxUYXpH?=
 =?utf-8?B?OVREOWk5NDVoSnRGRkFQZTZ6NkYycVIxOW01YVQremdNWXNZa29zeThtR21G?=
 =?utf-8?B?RDg4ZXh2NG9nQkZmWjBzRDlwbWdBTE1uSlZYZnZFd0FSN1EveGtNbGhYcTVZ?=
 =?utf-8?B?Qk5wdDdyTVpoZmI4cFBWa1pUaVdFWitsY3FXRDdvZW9lUVRVd1R2VmdxZERO?=
 =?utf-8?B?WVZuMzRmZitxSXloVjQvVnR4cjZFS3N6YXVaUWt3Y1dJdjlqamtCRXBXN0s1?=
 =?utf-8?B?ZmhOM2lrS2ZqbThHRHVMZ2g4cWNhU3VIZWNWY3JNV3R0emJyNGEvL2Q3ZitQ?=
 =?utf-8?B?azJLOVFhRGNMU2pvdDBoWWdYRGI0NjRGMXNrM0NXaWFSeXVham5vNk1mK1B3?=
 =?utf-8?B?bW14WDhIOEtzWjdnV0dhS2FvMUorUm1CUEVMUHVhOEtqOHhmNVVSYWFVSlZz?=
 =?utf-8?B?UlVjQjRxVzhQdUhoM0ZadGhLcFRMcmtva2dMT3c3cHBNRGtVWldCZy85ekk2?=
 =?utf-8?B?MyszUEFPRnlzN3ZqVFRPUjJiNXlXZEY1ZDJwRmRYNTZ1S2xaQmxydlFBRktu?=
 =?utf-8?B?czFEbDBGVm1Xb1FvYVkxTUJSVEhpeDZsVDBONk9RTVdFeTdtRzB5K21tbTNz?=
 =?utf-8?B?ZlI4SExFcWZoWW1wNWVIWjFQeWNSZXZpeUYyL1E0OTlEajhWNVdIc1krc1li?=
 =?utf-8?B?OS8yd2tDOXQvUVJRUGtNc3pPT1NnNGxkYjVnT1FmUVNOMFhsdjlTUThvSVl5?=
 =?utf-8?B?cmF5U0NOQWFmQXNUUUJaZ1lMT1JJUlZnODVSbkVXOXIxMW1mWDBrbVNiNHli?=
 =?utf-8?B?NEZINHFmbUt1WkxqYVhPZTlHNVh3aVBTa3hORGFzSEc5TG5YQktTUHMvTDhL?=
 =?utf-8?B?eWp4aVA0V0JyVWdxZGYwMjIvbmZVOEM0MFpnZE05MlhNbFBHT1l1Qkpud3d1?=
 =?utf-8?B?U3lXUjdodTZsQ3BSaFRiN0JiUW5HZ25XZUY5bWZJemxtVVdLNmxTTUhKeERP?=
 =?utf-8?B?QjJvRXJycnd3Zk1jcGRTQlhoa1pEa3VGSDFRNjhjeDE3eGpIWjRSd3M3azlY?=
 =?utf-8?B?MHQraTFzdThUazdFK201WjlINUsvbnJzSnhDWHJadTMveUNobVZFYnpUNHRI?=
 =?utf-8?B?a2ZKRHdWaUdUblBiZHpCSytXTjFManhEck5iR09Sc0ZtTEhZYUYxZERhWGpV?=
 =?utf-8?B?YUJvRjFmQlVOaFlMWVF1QVdOR0dBZFVOY3U5dWlpNE96ZkVsdnVKa2NZUFo4?=
 =?utf-8?B?YkZXUG5MMFQzWFN6b3U0N2l5S2dZQUxoTVppTkZ0OW1zcHJ6enBoQXh3K2kv?=
 =?utf-8?B?bHFoUHdRWnYvYzJaUFkwd1RNeGlwK1ZzUW40TG1OYWk0SDlvbmdod0tYMlF1?=
 =?utf-8?B?NHhJSnRQQ1o5OWpCQzA0L3NLUElkNCtDc0dNNTRCbTlOV1hIUDRaNDFnK2Zz?=
 =?utf-8?B?Ukt6bnBONDVDTUZlbSs2YkhWemhtbGN3MG5XNm1jUG5lVnhIYitXSlhoZzRa?=
 =?utf-8?B?VWlRc09aeGdCMS93Ty9VOXpqTC9XUE9YSGxIVmNTa1ZzNHUvNElhRllqcWU4?=
 =?utf-8?B?eXp6Q2htWXdqT25ZeVRaTzJWV2FSalRXNGdSTHJ2dGNOakdwdTliTHJiOVo3?=
 =?utf-8?B?SFV4WnhSb05wbXJsLzhtQzFQbTRQK25CYlNHY3o1ZmhoeGxqQTh2MndRQW5q?=
 =?utf-8?B?MnhTTHVScjBiemYwYzhva1Y2L21Bb2Nsa01OVE1hWGJMMkhaYkwxa21lQnFw?=
 =?utf-8?B?THV1NmZacy9KM0xTOXVqQVM3NjY4UVlBL3dlRWJKY3FRNzFsOFYyRS9idVFp?=
 =?utf-8?Q?g0HykdLSoLcst?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51a0f47-e0a8-4b26-70e4-08d97474e91a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:12.7866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1gzUtAqmR9xkUTgQWerU5Bcfb2Wu0FXDsIh75mcZG0plTRbHAGOx6CL6SRZl8yU/LmzYfnprKt1W5Z6ylhhxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGVudW0gaGlmX2Z3X3R5cGUgaXMgbmV2ZXIgdXNlZCBpbiB0aGUgZHJpdmVyLiBEcm9wIGl0LgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggfCA2IC0tLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9nZW5lcmFsLmgKaW5kZXggMjQxODg5NDU3MThkLi43NzAzMGNlY2YxMzQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaApAQCAtMTEzLDEyICsxMTMsNiBAQCBlbnVtIGhpZl9h
cGlfcmF0ZV9pbmRleCB7CiAJQVBJX1JBVEVfTlVNX0VOVFJJRVMgICAgICAgPSAyMgogfTsKIAot
ZW51bSBoaWZfZndfdHlwZSB7Ci0JSElGX0ZXX1RZUEVfRVRGICA9IDB4MCwKLQlISUZfRldfVFlQ
RV9XRk0gID0gMHgxLAotCUhJRl9GV19UWVBFX1dTTSAgPSAweDIKLX07Ci0KIHN0cnVjdCBoaWZf
aW5kX3N0YXJ0dXAgewogCS8vIEFzIHRoZSBvdGhlcnMsIHRoaXMgc3RydWN0IGlzIGludGVycHJl
dGVkIGFzIGxpdHRsZSBlbmRpYW4gYnkgdGhlCiAJLy8gZGV2aWNlLiBIb3dldmVyLCB0aGlzIHN0
cnVjdCBpcyBhbHNvIHVzZWQgYnkgdGhlIGRyaXZlci4gV2UgcHJlZmVyIHRvCi0tIAoyLjMzLjAK
Cg==
