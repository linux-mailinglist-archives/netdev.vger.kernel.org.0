Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD4AC167CEA
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgBUL4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:54 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726909AbgBUL4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnD12e8ISaOhQTnnyekJI33dGX/QCAw9zJaHseFOdQrS8klFDbGeGbjYxuCL5WL3f0zrL4CxH7X+QtCY/A4vPNmINxBicU/z7823cARfLMRJUGl8ETkzVTXGwDDmmEii6Qbu4quBWJQFvJEWiZrTieQhS4AvFJxOgJeSnZFtiI6capduwND0aKigEf290lPL2MTUenGx+xmSXjRrTz1ayPqouQ/wWbHzdzkicfey/Ca7nAKNWMCnnS1giMreTo7YNH96Fn7hpeM1nawfJdlMJ8UNDLZLL04ln6WhYIgkZa6fAIuGGgZEkTnVvHpB4D/ODownSC/6L+++o/mg6KR3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKG8epXSt51lMrKEqMU06v2H4BrZcTShDrwPFIiLhRE=;
 b=W49CpVvX5Xl+DUY32Mab1fCfL5UKXtQQafX9U4AvQzDU+2sKW/kCEx3rWNlup6ugurnqIZYWCUbjM4xwfDr2WYzQDpU7kw71fOAOzxaWgOZKFNHr5rDSERBoBOr2r6MnKB28RhrXKiTx4PeeIoEuKYs6f7CSSP6qiqmroLtyyjRXJED1ApDOj7pzRfDGcXiXbxfhyR6SURDu2s7+y/EvfiU6sx1tCwlf46ByCrtgaE6beWZvKPx0TjlX1YaRLZN1z00aXnmnlNGsHCYbdMkgzyMqalvE522Ga8WLGuFcCnGIcs91Vg+kJRTSkW+8ldp/uTFJcYBHNMlQRu2g7bPFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKG8epXSt51lMrKEqMU06v2H4BrZcTShDrwPFIiLhRE=;
 b=EeQKbVdiZcEYbTOdyuqoKPv1QYPJSlFAHQF9lMEEnhm9/AMPPcOtZn9jbx+jVhob2EX4WhqVHn1sT/gCQwmpNSUALSuh8poEl/9Cw9BEW5hUS93WqcZjED6Fwao8o2DiS1eYRvVp+7q1CSH6cz4Kyr7MBtrJNWEBm/QPdVA6AFE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:30 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/10] cfg80211: fix indentation errors
Date:   Fri, 21 Feb 2020 12:56:04 +0100
Message-Id: <20200221115604.594035-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:29 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea209a89-34c9-4d01-c54b-08d7b6c516ea
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB46625FA91718E9D49CB32D1F93120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: don3P2CYGVgboiKFuBz/6dQggaaMyM7oe+F5RdxjhpLMnKH/KPLwCZqlD5FYEP4H9xbMWGgEzMu069SjzdEXX+wyNIWLSTIK6QJE+fboCX3skLob6llCbUFMKjcsmaNkOhWDhbWEuE9CDh8xf5Nsv+4r47ekmeLcPFci+N2xNIx0dCMUmdDW8r0lZDGoHIUw7U+6Ng4E3oieCbBEN8BBcUhun6pISA0iqqc3IbFhkonr/Ik1wJXd2aXMC832tHCgtvWfjo4fX43yc4l+zEjjZo41ZGfBbXSpetE/N5bh7KQr9c6CuSknhA/7Qh8acYBfkvIWg1enu/AVqb2AVUyAGa2ydFCg6bCssHgCXuW+BGxteVuL5/ArkqFhw88hmWPaACUW8ixA0j5LMfNqYkEvOI/Tf3ReQoxFHVtanDnj+BaKyxNDi/KATDbA060X64TH
X-MS-Exchange-AntiSpam-MessageData: YY9ekbYd9T4FFLXGBtuALABBvuXEuQeU5bk1S58OvqtMZTj+9M+jNoNK0fsAZ/JhPB0KpYRNEd3AlpKXLKItAS0tCbsC36OT80S8Fg7QPd6RWnMZiUZNiFhq69RQ62fPfnOlu+xO5Q+nQnAaHMIdaA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea209a89-34c9-4d01-c54b-08d7b6c516ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:30.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQSDujNE1tUf6bDO3uvtkDVRcOSFw3uA3aHKPtbJHndi6D8gJIO0pA4CHcn82erTfr3p+9RAvGTXdTc2JbMWjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGluY2x1ZGUvbmV0L2NmZzgwMjExLmggfCAyMiArKysrKysrKysrKy0tLS0tLS0tLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaCBiL2luY2x1ZGUvbmV0L2NmZzgwMjExLmgK
aW5kZXggMmY4YzQxOTkzZWQyLi42ZGM2NDJiYmRiZDEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0
L2NmZzgwMjExLmgKKysrIGIvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaApAQCAtNzIsMTIgKzcyLDEy
IEBAIHN0cnVjdCB3aXBoeTsKICAqCiAgKiBASUVFRTgwMjExX0NIQU5fRElTQUJMRUQ6IFRoaXMg
Y2hhbm5lbCBpcyBkaXNhYmxlZC4KICAqIEBJRUVFODAyMTFfQ0hBTl9OT19JUjogZG8gbm90IGlu
aXRpYXRlIHJhZGlhdGlvbiwgdGhpcyBpbmNsdWRlcwotICogCXNlbmRpbmcgcHJvYmUgcmVxdWVz
dHMgb3IgYmVhY29uaW5nLgorICoJc2VuZGluZyBwcm9iZSByZXF1ZXN0cyBvciBiZWFjb25pbmcu
CiAgKiBASUVFRTgwMjExX0NIQU5fUkFEQVI6IFJhZGFyIGRldGVjdGlvbiBpcyByZXF1aXJlZCBv
biB0aGlzIGNoYW5uZWwuCiAgKiBASUVFRTgwMjExX0NIQU5fTk9fSFQ0MFBMVVM6IGV4dGVuc2lv
biBjaGFubmVsIGFib3ZlIHRoaXMgY2hhbm5lbAotICogCWlzIG5vdCBwZXJtaXR0ZWQuCisgKglp
cyBub3QgcGVybWl0dGVkLgogICogQElFRUU4MDIxMV9DSEFOX05PX0hUNDBNSU5VUzogZXh0ZW5z
aW9uIGNoYW5uZWwgYmVsb3cgdGhpcyBjaGFubmVsCi0gKiAJaXMgbm90IHBlcm1pdHRlZC4KKyAq
CWlzIG5vdCBwZXJtaXR0ZWQuCiAgKiBASUVFRTgwMjExX0NIQU5fTk9fT0ZETTogT0ZETSBpcyBu
b3QgYWxsb3dlZCBvbiB0aGlzIGNoYW5uZWwuCiAgKiBASUVFRTgwMjExX0NIQU5fTk9fODBNSFo6
IElmIHRoZSBkcml2ZXIgc3VwcG9ydHMgODAgTUh6IG9uIHRoZSBiYW5kLAogICoJdGhpcyBmbGFn
IGluZGljYXRlcyB0aGF0IGFuIDgwIE1IeiBjaGFubmVsIGNhbm5vdCB1c2UgdGhpcwpAQCAtMTY1
Niw3ICsxNjU2LDcgQEAgc3RydWN0IG1wYXRoX2luZm8gewogICogQGJhc2ljX3JhdGVzX2xlbjog
bnVtYmVyIG9mIGJhc2ljIHJhdGVzCiAgKiBAYXBfaXNvbGF0ZTogZG8gbm90IGZvcndhcmQgcGFj
a2V0cyBiZXR3ZWVuIGNvbm5lY3RlZCBzdGF0aW9ucwogICogQGh0X29wbW9kZTogSFQgT3BlcmF0
aW9uIG1vZGUKLSAqIAkodTE2ID0gb3Btb2RlLCAtMSA9IGRvIG5vdCBjaGFuZ2UpCisgKgkodTE2
ID0gb3Btb2RlLCAtMSA9IGRvIG5vdCBjaGFuZ2UpCiAgKiBAcDJwX2N0d2luZG93OiBQMlAgQ1Qg
V2luZG93ICgtMSA9IG5vIGNoYW5nZSkKICAqIEBwMnBfb3BwX3BzOiBQMlAgb3Bwb3J0dW5pc3Rp
YyBQUyAoLTEgPSBubyBjaGFuZ2UpCiAgKi8KQEAgLTIwMzIsOCArMjAzMiw4IEBAIHN0cnVjdCBj
Zmc4MDIxMV9ic3Nfc2VsZWN0X2FkanVzdCB7CiAgKiBAaWVfbGVuOiBsZW5ndGggb2YgaWUgaW4g
b2N0ZXRzCiAgKiBAZmxhZ3M6IGJpdCBmaWVsZCBvZiBmbGFncyBjb250cm9sbGluZyBvcGVyYXRp
b24KICAqIEBtYXRjaF9zZXRzOiBzZXRzIG9mIHBhcmFtZXRlcnMgdG8gYmUgbWF0Y2hlZCBmb3Ig
YSBzY2FuIHJlc3VsdAotICogCWVudHJ5IHRvIGJlIGNvbnNpZGVyZWQgdmFsaWQgYW5kIHRvIGJl
IHBhc3NlZCB0byB0aGUgaG9zdAotICogCShvdGhlcnMgYXJlIGZpbHRlcmVkIG91dCkuCisgKgll
bnRyeSB0byBiZSBjb25zaWRlcmVkIHZhbGlkIGFuZCB0byBiZSBwYXNzZWQgdG8gdGhlIGhvc3QK
KyAqCShvdGhlcnMgYXJlIGZpbHRlcmVkIG91dCkuCiAgKglJZiBvbW1pdGVkLCBhbGwgcmVzdWx0
cyBhcmUgcGFzc2VkLgogICogQG5fbWF0Y2hfc2V0czogbnVtYmVyIG9mIG1hdGNoIHNldHMKICAq
IEByZXBvcnRfcmVzdWx0czogaW5kaWNhdGVzIHRoYXQgcmVzdWx0cyB3ZXJlIHJlcG9ydGVkIGZv
ciB0aGlzIHJlcXVlc3QKQEAgLTI0MjYsNyArMjQyNiw3IEBAIHN0cnVjdCBjZmc4MDIxMV9kaXNh
c3NvY19yZXF1ZXN0IHsKICAqCXdpbGwgYmUgdXNlZCBpbiBodF9jYXBhLiAgVW4tc3VwcG9ydGVk
IHZhbHVlcyB3aWxsIGJlIGlnbm9yZWQuCiAgKiBAaHRfY2FwYV9tYXNrOiAgVGhlIGJpdHMgb2Yg
aHRfY2FwYSB3aGljaCBhcmUgdG8gYmUgdXNlZC4KICAqIEB3ZXBfa2V5czogc3RhdGljIFdFUCBr
ZXlzLCBpZiBub3QgTlVMTCBwb2ludHMgdG8gYW4gYXJyYXkgb2YKLSAqIAlDRkc4MDIxMV9NQVhf
V0VQX0tFWVMgV0VQIGtleXMKKyAqCUNGRzgwMjExX01BWF9XRVBfS0VZUyBXRVAga2V5cwogICog
QHdlcF90eF9rZXk6IGtleSBpbmRleCAoMC4uMykgb2YgdGhlIGRlZmF1bHQgVFggc3RhdGljIFdF
UCBrZXkKICAqLwogc3RydWN0IGNmZzgwMjExX2lic3NfcGFyYW1zIHsKQEAgLTQzNTAsNyArNDM1
MCw3IEBAIHN0cnVjdCBjZmc4MDIxMV9wbXNyX2NhcGFiaWxpdGllcyB7CiAgKglub3RlIHRoYXQg
aWYgeW91ciBkcml2ZXIgdXNlcyB3aXBoeV9hcHBseV9jdXN0b21fcmVndWxhdG9yeSgpCiAgKgl0
aGUgcmVnX25vdGlmaWVyJ3MgcmVxdWVzdCBjYW4gYmUgcGFzc2VkIGFzIE5VTEwKICAqIEByZWdk
OiB0aGUgZHJpdmVyJ3MgcmVndWxhdG9yeSBkb21haW4sIGlmIG9uZSB3YXMgcmVxdWVzdGVkIHZp
YQotICogCXRoZSByZWd1bGF0b3J5X2hpbnQoKSBBUEkuIFRoaXMgY2FuIGJlIHVzZWQgYnkgdGhl
IGRyaXZlcgorICoJdGhlIHJlZ3VsYXRvcnlfaGludCgpIEFQSS4gVGhpcyBjYW4gYmUgdXNlZCBi
eSB0aGUgZHJpdmVyCiAgKglvbiB0aGUgcmVnX25vdGlmaWVyKCkgaWYgaXQgY2hvb3NlcyB0byBp
Z25vcmUgZnV0dXJlCiAgKglyZWd1bGF0b3J5IGRvbWFpbiBjaGFuZ2VzIGNhdXNlZCBieSBvdGhl
ciBkcml2ZXJzLgogICogQHNpZ25hbF90eXBlOiBzaWduYWwgdHlwZSByZXBvcnRlZCBpbiAmc3Ry
dWN0IGNmZzgwMjExX2Jzcy4KQEAgLTU0MjAsOSArNTQyMCw5IEBAIHZvaWQgY2ZnODAyMTFfc2Vu
ZF9sYXllcjJfdXBkYXRlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGNvbnN0IHU4ICphZGRyKTsK
ICAqIEB3aXBoeTogdGhlIHdpcmVsZXNzIGRldmljZSBnaXZpbmcgdGhlIGhpbnQgKHVzZWQgb25s
eSBmb3IgcmVwb3J0aW5nCiAgKgljb25mbGljdHMpCiAgKiBAYWxwaGEyOiB0aGUgSVNPL0lFQyAz
MTY2IGFscGhhMiB0aGUgZHJpdmVyIGNsYWltcyBpdHMgcmVndWxhdG9yeSBkb21haW4KLSAqIAlz
aG91bGQgYmUgaW4uIElmIEByZCBpcyBzZXQgdGhpcyBzaG91bGQgYmUgTlVMTC4gTm90ZSB0aGF0
IGlmIHlvdQotICogCXNldCB0aGlzIHRvIE5VTEwgeW91IHNob3VsZCBzdGlsbCBzZXQgcmQtPmFs
cGhhMiB0byBzb21lIGFjY2VwdGVkCi0gKiAJYWxwaGEyLgorICoJc2hvdWxkIGJlIGluLiBJZiBA
cmQgaXMgc2V0IHRoaXMgc2hvdWxkIGJlIE5VTEwuIE5vdGUgdGhhdCBpZiB5b3UKKyAqCXNldCB0
aGlzIHRvIE5VTEwgeW91IHNob3VsZCBzdGlsbCBzZXQgcmQtPmFscGhhMiB0byBzb21lIGFjY2Vw
dGVkCisgKglhbHBoYTIuCiAgKgogICogV2lyZWxlc3MgZHJpdmVycyBjYW4gdXNlIHRoaXMgZnVu
Y3Rpb24gdG8gaGludCB0byB0aGUgd2lyZWxlc3MgY29yZQogICogd2hhdCBpdCBiZWxpZXZlcyBz
aG91bGQgYmUgdGhlIGN1cnJlbnQgcmVndWxhdG9yeSBkb21haW4gYnkKLS0gCjIuMjUuMAoK
