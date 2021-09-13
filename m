Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCD7408717
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhIMIgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:36:54 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:62366
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238409AbhIMIeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuWCdR9kJqE3YUHd1wypuW2d9VxoCUctHy/lPtDIBzkF+QhK49Xil33hR/+5s8hbPh29ZJZjE+K70TqUjmfpxgg393mFK8I5ocRJsKHP8MTgbHQmvE3oxoLNJL9fk7R5r2YrjMdOhDWqWtBQ12GgFevKesvsViE8UDadGWUQC069ja5AHvK5I8Hi0NBD5mLCAjIDF6XeGy0kOhFzOQctYJvzny0ZNU7wvEYbXYnT5oHnGu+s7jaEHHYEiuuUmEstu7njHhU4LdEau6pEzmkd+CJ1TqbAvtOip6zsdiXSOxYocx/rYmaVhdyr2C1hw2TRWV+ye3va/1SsuWAg1ftJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Dpb4kGMGvfj35Vbk2VtBmz6gj03sg9/7HG89Z6uGabo=;
 b=KhZB73NzNiv3lPJ5b6F1Wd/g0QvTZWCTHGMPMcyUACGzOmTdUv/Q5YoAl7xWE+0Rdey+p2Lyqb4y1PfpMcNUVcES4yvqidiIGsSJBXpFjCENVGaNNRWgADgKikpzOc+6+vvCfqovvqx2GYfRohW2bXYoSZF6awx9efXG0qFcVFv11bv9PbeyjHFExshhBSIzva0a50s8SxmccjH/bhHdEgLTLX2O9t5w8toGhAXhE5ji7k9DMLVl23WhrOTo0KgT/Is0H1Ap/gIV9nqh/AmdvtOrGVTvULm2xGd3AeR0VjmjzB20fM/B86wUVLzAhbCOmnVnCStZaA2oEmEbC+rqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dpb4kGMGvfj35Vbk2VtBmz6gj03sg9/7HG89Z6uGabo=;
 b=m8MSwioNsgbwLBexWzJQzxPSrHfTgR+KwNXMiA31jeBZM59j9hjFBEfwVKIhjouDyDts8sFQ4JYyrH/JiKMldV9CQotqtC+6nRV0SYgPxBUJkAvn4vHoUYLrA4IHom8nJZD8iNGyjRRmQEJQxXFv40H+3Kp1YBTO7yYEliDK0Bw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:32:00 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:32:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 26/33] staging: wfx: reformat comment
Date:   Mon, 13 Sep 2021 10:30:38 +0200
Message-Id: <20210913083045.1881321-27-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df7c2017-6dd6-485f-ed1d-08d97690ef2c
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2717DC9C6A9F8FB4E608299693D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RBlCRmxZD7gouTyB/9BsbUInRlZ7sz30bU1yxo9WUVvWvf4InTMZR9Z7HGF4QAiGc/mYfE4x8mhUHiq59Lp405oNJS8tqmHucuWzQFqQSaWWauqbduBi+YB7DEVxKUN5XS/K36BQuKjkYz5rlTpyH1/1wXYyyLWmqTiwI2Q6b3E1aQ8rLMqWSqAIvkgdwI10y5egjNWpiE8H5ztrUWLx1k+Y/XDRGxAVlB1J6md+tHBPNW73KGppRoaqvLhwNFGO94smRbUArOXWNQmt19chhn18oiVVb+1zCPcvv4Ug0l66N8f7geEm2eBhQkrZfkxUZ248aqclaXP0DecPJRnSpP9JlcSVHW7bbnmFGi9mJCe/ZOp9DM28RMPzUE1kJ/x4QkXZyMr8Ga42h7FGhC2wEN4DijlOXZDAUsGtjrJXhBNPcWsMyT5v1hwgdqswOtQIxaErmIwScVk6bUtJ2EfGnz9JR+aRYTaXfJTHrhaDddE/Uxfl0egnf9yYKMOzq4RnwG+wtyBfg1aZ4iMgUfpABkM6YvD4Ux+vTWQmPhPbsXqnLzCHM51v4mJUdvQeUWQqBEgk2WdF1Mt/KwhRZw82IHIEXkKhvCgNO0SVqoP9mcak5ZyIvW02Sv0q0OemNwyeJAKxaDgwuCQ3K+9LbmT4thHmhsp9OAcHwEGsrqWmedSUGCqpTpsQN1F8WVewFB+RDXVLBwoy7ENIOu6cXpHlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(4744005)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aC9pcUlUSm83VEtoNkx0MDVTbDdSNUtnYWVWbzJndUZvbnd2ai8xUmdIYWhO?=
 =?utf-8?B?VlliQ0FCNmZqR2s4cGRWeDRmRlZVM0dnOWVuQWgxQ3NuNVRoOFlFR0RUVnd2?=
 =?utf-8?B?VUZKUld1aFM3UDh6c2VOMzRmRXR5eFcrdkJrcUlWTTBlblIwcTBoM3JTbXFX?=
 =?utf-8?B?QjFKbEUrZUtVWFRkQVFEZmJzbENwOGgweG91WFhvTnBxRzlqN1Z5d2l5Z3Vz?=
 =?utf-8?B?VGZVaGROdkpqVHNyWGxDVExtRHE0NW9wb3c3ZWp4Y0VYcVdqbFVnMlljdXZH?=
 =?utf-8?B?UE9mM05qd015ZmlORERTVTlXbms0WXZXUU1kM05PS0JpWGFBWjFvNFExSGlv?=
 =?utf-8?B?c20xM1FiTXdJTGludVZwdGkwbERDSHFrdXFSMGNPMU9NeUFob3RpazhONDFL?=
 =?utf-8?B?Z29IREM0MjJvWEd4WWJuVnRuUzB5WHJhSGhZaDczL0lZL01tL1RZNzQvTmJU?=
 =?utf-8?B?cjg2R0ZBRHk5UXg5ZG5oRVk2ZUFwNXlNSDV0VnZVelBNNDBTYlhtYmF6eXA1?=
 =?utf-8?B?aU9aRzFaNzU1bTk0alBqK0t1VlhHRVdDWTlWSHI0VGtkUGxiV3Rja2VMWWlq?=
 =?utf-8?B?by95RDh0aWZyOHNOZlBvTm4rUTh0OTNMMGR5TmpiNEF6MFJ0bjFoUWxVRTVy?=
 =?utf-8?B?K0QzcTdCU1EwRXJtbFdHTTQ1dDVndUMvL3RZVGhWWnJrRXVFNGV6UWVmNFpy?=
 =?utf-8?B?M3VoelNET3IzTmJtbTBOb29YUXlwQk9MSzBvMlZQMTdkVDNMQUdQdXlnTEZi?=
 =?utf-8?B?aVFOM05xaVZEQ1B3Y2xVZGRPL1lkb2M5OC91aWk1Q3pITVdlS2szbytpSzIw?=
 =?utf-8?B?OG56amxpcUIrTzRPMXQ3UXZSZGsyRVBNTC9RczRYdzZWaHJyZXVsM2pteWEx?=
 =?utf-8?B?VmxxQkVHMkVYRDhnS1c4WlFRTVMyRlRlNWtoSHU2ZVQrTzBqMUJxT1RSa0hm?=
 =?utf-8?B?STBrbTNkKzk1ZDF1Ky81Y1J2cm9EMVZCU3hhK0lUbXE1TjJVWXZFSEdVcTM0?=
 =?utf-8?B?b3hVR0VDZEJEQ2lyaWtyNnlvSUdQY0xlYS9wUEdaV3ZsNlZDSDdWdHZMeklD?=
 =?utf-8?B?anVmUUdlMTc0ellyYXlKdFJraG11YWZFYXl0bVNGbWRsNmhvQ1JISWNXNUZZ?=
 =?utf-8?B?UFlHWUxlRVhlZFFBd29pOU9ONko4YjNNY3VwV3hDSVpHRDBrMXRIbkVYejVt?=
 =?utf-8?B?M2Z6eXdDdUo3UFZRRC81U29aTjJsMXBJRjZ4Y2dQM2tmVWlhS1FiREFuK3dQ?=
 =?utf-8?B?enVQTHNraWVEd2UveVNIN1ZqTUZvYU9MalVpN0RTSGNXZk1SVEtCU2hIU2RD?=
 =?utf-8?B?OGVjbk9ZczlOQVlEYmtzN285NTZWdEFzSVFtUkpUSlN5RExwNUx4WFFwSUhm?=
 =?utf-8?B?Rkh0NlRxak1JK0xRR01IT2NTT1NOdjd4SFZWaE4rSGhmTDB0MUEyTTNuYlRC?=
 =?utf-8?B?L1R0dWozT1BPa2oyaFlUUzJndThrNUhGWUd4YlQ4TkRqSCthN0NkWmxNVlpw?=
 =?utf-8?B?YkpEdjRNdWkzYWphZFZET1l0T1RIZVl1MlhXVkxUS25kNUNndHJNWTJDVGZU?=
 =?utf-8?B?ZTdWNzlUdWhnbEU2eVpTeHBLR3BJK1g0MkxmTlhJR2N6QzQvU2NoNCtsUzIv?=
 =?utf-8?B?cEZkb3I1enJacTdXM3BDcnF5aW1RamNrcml5NEZDZXBNL1EzRlQvMlpsUUx5?=
 =?utf-8?B?Mm1DMS9kTUxhKy9XYWRDckNSTlNTUXdFZjhLNktERnBObVd2N0ttaWJiVlMy?=
 =?utf-8?Q?gT5A1cdneYEtNKFX9rG+hWOg1ALV3kO/+3HdpYF?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df7c2017-6dd6-485f-ed1d-08d97690ef2c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:51.2651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocuokpQ9HYgGyWAn8pxTUUXv1J98oAxODU/b5mIlAhEoh8R17Id2ky7UcZaVsw0QfoJzklCgCQ+Bjyew/+l0eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG5ldyBjb21tZW50IHRha2VzIG9ubHkgb25lIGxpbmUgaW5zdGVhZCBvZiB0aHJlZS4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4K
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNCArLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggMWUyMWJlZWVk
NDM4Li43MGUxYzRkOGFlMmUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNTk5LDkgKzU5OSw3IEBAIHN0YXRp
YyBpbnQgd2Z4X3VwZGF0ZV90aW0oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJdGltX3B0ciA9IHNr
Yi0+ZGF0YSArIHRpbV9vZmZzZXQ7CiAKIAlpZiAodGltX29mZnNldCAmJiB0aW1fbGVuZ3RoID49
IDYpIHsKLQkJLyogSWdub3JlIERUSU0gY291bnQgZnJvbSBtYWM4MDIxMToKLQkJICogZmlybXdh
cmUgaGFuZGxlcyBEVElNIGludGVybmFsbHkuCi0JCSAqLworCQkvKiBGaXJtd2FyZSBoYW5kbGVz
IERUSU0gY291bnRlciBpbnRlcm5hbGx5ICovCiAJCXRpbV9wdHJbMl0gPSAwOwogCiAJCS8qIFNl
dC9yZXNldCBhaWQwIGJpdCAqLwotLSAKMi4zMy4wCgo=
