Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28502408BC6
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbhIMNGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:06:01 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:38187
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240160AbhIMNEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzjlHkhDiDAw+nYGKWJpwrY+ip4fjh/N8GWXLlrhUeK8F46oTFlrnugCc4bVZIve7+oTeqPRGafHSr0N810cjktHWZzmdP9qIUahm+tVSF3bXoC9P4S47U/H3XzJ3dj+joAMTpB7lphfoq6Rz5hURklzhtcOLK4QC3lbx/lNViBAwh6rKDpsdDgxGjC0kxHHoiXB2Rtgt7lvPZWRVX0lno6c5tRd1AUDLQ25GwKMaGkP+pn2vkLQZBFh05qHPCaM3nwXU0gIdpax/QG7WdIRBJGfKnBJa6sAlJcZ2cjpJvqrX+EaA81FETZ2cToYYfdHjv6k4nvWxMmd3i471r579g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Dpb4kGMGvfj35Vbk2VtBmz6gj03sg9/7HG89Z6uGabo=;
 b=GIt30LGUUCIa62Gs9VVRy1l2a1HJaVcK6cOWP0F11jUWPdB46b7UwYp9DhD4pvuxB1EhUvfWcJHq4skuJ0TkmjZpsNK3FVWNWbZaiQieh7mtRdCAdIX+xE8BVJbMvh5Ur/KG2AZAfjPoPj4dtDuTXhUnqYNronAMk24Rw+0ABbOCLR1U2mz6EPcEpy9xgUAK2k7OCrNDXtsjUOaLn/qQo5yLQsr+ACVNnDr+fhn17Mn4BMmyYGTVBoAJjqchInByJbSOxE2jA5iv2P1cmpJ/Bon3Fr6iYd3Rcc4buMIHi8Km0vxZIHqUJ0wqoW15wtc1hJDPQe1SSVwfcGUG2dWkTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dpb4kGMGvfj35Vbk2VtBmz6gj03sg9/7HG89Z6uGabo=;
 b=P+W3bBjxqjwF4foRT0/l6rBTSTY0TL3hyl0Cpw2GSBGfwoENwmqwVyo0mUbOl/OmQ4HXtzYksi2lac7V9jSGCPwmNTicqp3aNKkis1+33LZlUY+eBU6HBTeS5OPv5AAsOjVXlX7xgUafCuZkGsEi+lbyv+G/KAt8B4BjH2Blnk0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:06 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:06 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 26/32] staging: wfx: reformat comment
Date:   Mon, 13 Sep 2021 15:01:57 +0200
Message-Id: <20210913130203.1903622-27-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:03:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99e7a8ab-7417-4282-fa9b-08d976b6d415
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502E442FB97897E161075AB93D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FF6Z6kBTdmXge1jQItEFp5d2PKmGuNkybjZND8Mmxse/3Zf1GU4RYQdI6kd8sDviIaN29dHkGckD1Xc4zRMzY1jZqUMuYuY+8bpDwuwmZaIQTsh4fg/1jauhMq17/wUcRFiXFHoXpJoYdSPS9XViZRk4b9/aGHr+jbYMm4RHOu60TosbA3GyeSszekh1b1iIcK3rnzuIPRYA8cu5xElx/0K+FYm71kQwZ7S8f09UI9UoztNJboWQu1C+e8efUs9EA15OGGTMHMmiNDqXK6hLdar0S4dK2LbOJK1QB+GqUCnO5IZthXwdGM9nJAXvAkok3o52TTTnkkVFBfDvE4KicTWw1UqfTzFsQ0M6X+EJpmorRCGWk8lrJJe2t/LyQldY7Ip8TJ7uNAbBGHHQUOyi5T9IKdCNGYHxrKxnQFJqEODgXdhc+5wsPmw38AqtZH8dxt4MT3mORLBsq/n7cVWZL7hq9SP+F14jMO+3x5h1f80EdFobFiE9usocfj4YhUcasB8XL7XI7eS5WoZG00+V17g6889C77LEdGud5fYTIzQuwm/qQagLJ/dUFtizX3/GKeCpD25a1OaA6E1fajId+AkHNJ5x//vp5ab+vm/snQdYLfYg6ibUAfIq+2DSSYz4nZD3B5HZl+HGm2bSpolxJG6zlEh71vfyHjBU502+uDNMXUPnkZAuPJXojRBeJx4bsv0I78xMSuFc4JeLY7gGIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(4744005)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(66574015)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmUreVhaUnBDeXdaTlcvVVRxMlBseEtuc2dtc1ZMZ0cyN1huVjRaaDQ1aE1w?=
 =?utf-8?B?VG5RM1pHcHZFVXJKaEoxZXlybVZtY24wa1lxSVhITzNaL040bVkybmFRUTZX?=
 =?utf-8?B?dGo2RDRFUkxEK21VK3IybytiWVNIZ3BpK0xIbkt2TTd5eElRUXJIcENnVkZP?=
 =?utf-8?B?RFVyM2FhV3dIaDVMUHBPZm84MWN3L0FLcWI3NFpqVzM2MlhyT2d0elB1OVpm?=
 =?utf-8?B?Z1A1QlJmeU83QmsyYld2aVhJbTFjQnY1ejRNMnNtMzdtMm53c3FtaCtiTTJR?=
 =?utf-8?B?YzhRT1RBSUZHSWpRSjlJU0IzbTJVVzMrZG4yNnQ5a0lPWlZBWGoycEFRVGx1?=
 =?utf-8?B?RFd6WVNrdkxrd0M5RUh3SEVRcWRNZFJSME5vaU1sUzRxSElEemdtb0Y1TXlW?=
 =?utf-8?B?RXZyOFQ2UXFhNnYyLzdKRWsyTXVISm5lV1NTZTAzSHJiZWJOVFNvNHhGUitn?=
 =?utf-8?B?WFNxTTkyNmRSY0RtMjd5VDRCYXpwKzJkandaVktnSDlJaVM2ZC9yZVNlMDdo?=
 =?utf-8?B?UEdZMXRDNnNYRHhiZ1JXRiswTUpFNkZZTmxMWHNlaW9wa0djWExpczNVTWhz?=
 =?utf-8?B?cXl5L25iT3JZaUh0UUhUVnV0eUc1UDVhcjBwdzZMaTlBZ2p1aTNVbXBnMUtM?=
 =?utf-8?B?S1p3ZzlDSWF4aUkxSVhnNmZqbHBFYkVVYWswSTNLSnRRNWlMME9ZTExrTVVX?=
 =?utf-8?B?RkMwY2dFQ3BMTHZDRVYxTVlUb29TZm9OdHZHaFVvdU9USUU4alQ4MHhpOEth?=
 =?utf-8?B?OE1TaUVBRFNQUHFQMnpsb1FHbjlZT2pXdDJId1EzUzZOOFdDbFNkYXl6YThK?=
 =?utf-8?B?YzdWUVAxeEVLK0tobGFCZzA0eHQvZlBwNW1HNGh1TTNDNzRLZEk4R00yMjRJ?=
 =?utf-8?B?NlNBYUUrbzVDZHlVd21MNENObG1VTFR0dXRpUHkrazNaL1JFSHY5eDJJSVF6?=
 =?utf-8?B?V05ZSDhhWXhoNkhqTU9pMVpFL1lOem5ZYzNmMFU5bkxZYjRYK3Z1Z0xJWTdy?=
 =?utf-8?B?blppSzErYlFGcVdNdnFFdFVCMHIxdDZ1SCtLczlocnhYSk9GYi80T2RCcE9j?=
 =?utf-8?B?K1dMbU5WYXNsZ1JvVXVyL0FiQUxabkVCd29pL0dxR1h4ZU1od1VuYjN1dkxH?=
 =?utf-8?B?ZW5nSlJRZ2UvcTFDY3hOUDhoMlZLRVVnYW1icDBnOTJ0eldGZlZUSmdjV2U1?=
 =?utf-8?B?b3AwS3pjWVE3UkJOSWpFZzdVSWFxNzYrSHFVU2g5YVRxQURXaUFWdUxMd0ha?=
 =?utf-8?B?UlZpemQ4aE03Q0xraThnc0dvOGR0aEFCZHZwT3A3UFljOFR6dzhBSFZWNGpu?=
 =?utf-8?B?OSsrSmxBS21hQWgwQTZXbFZFYzB5eWljNy9jeER6TE1zNnNIUGRHMjBWeXNh?=
 =?utf-8?B?SXh0cnJTTUp4Q21PREV4a2dvYXlEeEVKVDFndE9DNDBYZnF6ckNqOHNjODVO?=
 =?utf-8?B?dmVRaUlmSjV6UGROSWVMdDdZVk0rdm5KUEF1YXdUTFN0YzJTeFI1K1VrRVdM?=
 =?utf-8?B?VFBLMTRDOVlUSjl4enVoTXFRMGhzRmkvaUdHYWk2QnJ0MzNlREo5cnZqZ2d1?=
 =?utf-8?B?NmtTMkpBcnE3UDBqSXk2S1hyYml0d0tiRkw3VkVVVjZINHZ5K2JkOTNQODE5?=
 =?utf-8?B?eUdreldTVzBpYmloY3NpazFOcUw2QnNoNmpkM1JnTUs0WmtZS2VJbnNLM0dp?=
 =?utf-8?B?Zmd3a3FlRlFtUUVONVBPUWpqQkhPNU05REt6bzYybHdRRnBzTXNXWjBMNmJz?=
 =?utf-8?Q?kpoEigjc6Uc6suWb/akpCeuT1+TsT6Fw7SwG315?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e7a8ab-7417-4282-fa9b-08d976b6d415
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:06.7279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHXNzFNVgKTSw8A3PzU5PWZBZBXKLW5EMiR/UdeaMmbbpV3RGPSMH9ccn6T3u0+U45RUoydEZ5PdnFRmtcTmpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
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
