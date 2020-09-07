Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAC425F887
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgIGKPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:15:46 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:35456
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728524AbgIGKPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:15:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBeO0sZHKNoVzq29xn4Bhgzp9yXEfC1l+UEyiHf/qsc8P/FblfNoVV8aT+gwfhgpKp5EJ/HVfx4EiJVvyxXwBqlpN59/d0HTPJ3uNZLDXNawh3M82wFyx1SUncvVaGo0foQsb3xJcKtuRULVZtniEOUUTdprHGnIqbnx0RhQMngVQVWg/+AjQzopM7Rzbs8J5dYn85K8hJiOAOWxoh3tS730I7xWDHBBYIJ8OFB+c0tMepO5FDcVFedLp6Q/xcjtpjL6QE6QO9310G9aogr/yUSv4Y4IWDd0tjyuW4qNVhXuiDZKTCFDynCFrRPckuzZTbWYsNlT43oMDZCItaCnqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scuCA7KFfCLOkLlGi6SkfHMG+rrexR9taSYwPDYhb38=;
 b=POaIJOjRzzLO0REhksTT70dnBeCD47LgoV7TEDjBcMHB8sXbUBj4aVWnTUE4ZSw2+ti01/gHw2f0gprvnx9UAOwxiePiQDDTBthnVmX+k54cyMqR3qpJtALJ1zHIhYsETacM5xa8xcftdHpoK9aXo/PRelT6NoHyzLaTgwNVhcht4mDsrTl6AdChSNYuxSAizKQ14RCBtnzViKkX1KiDqRksSpFhTpiDBj1DvpUVg6881FPRox4fhYFu3fMq0UCkW8awLcQEc3y+CLkZc8iZfCv65kJGKAa9+U5++33fIMydPNIM3QZgpxatul1b6ag9quBkXT7Gqk6t0L3QrMhXPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scuCA7KFfCLOkLlGi6SkfHMG+rrexR9taSYwPDYhb38=;
 b=ca/24v9RcHUJCdJrWyJavJkmrSVnDB0ys7C9R9VypQzZAAk29ssBvxJOcoHSO+RmI5YbJyBF3KzYSSpc1svWl+DziMD1URA2xOfzyuORSxVuRdjGanO9zgYvb8HGq6BkykIVtyE0J95AjbwPySBJYPsRDafLIFq+NW8wZSSN8ac=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:39 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:39 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/31] staging: wfx: fix last items of the TODO list
Date:   Mon,  7 Sep 2020 12:14:50 +0200
Message-Id: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:37 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8a4d3a3-f51c-4395-6db3-08d85316f820
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB26064953EF86D8A14D55369193280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jsVrigSibZsyzgntpe58Y9onb/MjTL88EUEBQAxbLlKDOwiRKicHkiRjEsaKOuSgXlvsMrwy/TJVUl4wHRT9eD4HRvs+sWSfVY6wNNgS5ybGwC6FmNRYmwmh8/jSfFAB6velzera3fOiFS/P7VYJgzX6vZmpqXQFmhJ6QIAusiOSkPoeKdG96ctN+rPitSJDgYfCU0pPtL43ImB74JQa6hbPWjtcShSNoxQpqt6fIzdfU+uG48ys+7Sx2Gy1TZzxmuHD5VMq8dUOHShoe6xlwcSa7ZT00fkRnKGjbktpU1BPX8BBYhnpXotc51do5H3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GZk2FmOEjXdi5d5qRPjuuCTrOd69f3ytJxR+0Y9S/W7cpPN92kSZ6kQxuVlMIl60BHnNdxaX/wzezUt/94r6ktquwUPbq156fkbpS9IVwmaVy3l/Vv6cc+JJp37iJAlHkH9EcTWLnSeJzZfKeBZya/RCoVXyCyOR8MoPOb2W/VwIyFudmo59ld2a82OeLzE60D1V3uSh5GIkkehkGtRtd1Tf2GSM0E39lp5JyvSjBR7G1Fi245F3sX0ZUQI+kWs58dlgWvquo1Jq8X83tOi4PeCJE6vgimWLcdlzDffcLEpeRumdnf+LqWI7EMeDJ/FiprNOMCZSnYm5n43RN1z9imyC1JUat5QHn0FTCtUPDcIXiATwk0J0Gr/oeJb9kL7+1rbm3GuiDcJovIc4+PGBVdjwcS3uvfvQRf/JGR4RDPNqB3t+kNcU/SCBgaAaaR0PTtPfkotkdGiwieqguCwdLwlCtEQIjMYp/5Q4pRwF1Qail2vKlo2+hMKJ6k/WsBGJzj1ocX0Vd2p2OMCGqyPFvkt15cZsTFNpHdKyLwYPvftV8EMOdMREjYKe7LsncMfkj85zQTU3KvINFaLrwCMFQi5RI1gOiZGIdpgryMAJT4en2H3/RBX9bmSwmpyp/sqzV8U4CmjLlIM1rLuY5AU5iA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a4d3a3-f51c-4395-6db3-08d85316f820
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:39.2414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBOeXiRju5ljNS6i/Z6rz4YAjelYBLM8aaLNAsOPQ6eq5ixoe78WOc9LEjXb1EhfMexcnhNdorsIDR5l5Xnv4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8gZm9sa3MsCgpUaGlzIFBSIGZpeGVzIG1vc3Qgb2YgdGhlIGl0ZW1zIG9mIHRoZSBUT0RPIGxp
c3QgYXNzb2NpYXRlZCB0byB0aGUgd2Z4IGRyaXZlci4KTm9ybWFsbHksIG15IG5leHQgUFIgd2ls
bCBhc2sgdG8gbW92ZSB0aGUgd2Z4IGRyaXZlciBvdXQgb2YgdGhlIHN0YWdpbmcKYXJlYS4KCkrD
qXLDtG1lIFBvdWlsbGVyICgzMSk6CiAgc3RhZ2luZzogd2Z4OiBpbXByb3ZlIHJlYWRhYmlsaXR5
IG9mIGFzc29jaWF0aW9uIHByb2Nlc3NpbmcKICBzdGFnaW5nOiB3Zng6IHJlbG9jYXRlIHdmeF9q
b2luKCkgYmVzaWRlIHdmeF9qb2luX2ZpbmFsaXplKCkKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5
IGhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZSgpCiAgc3RhZ2luZzogd2Z4OiBrZWVwIEFQSSBlcnJv
ciBsaXN0IHVwLXRvLWRhdGUKICBzdGFnaW5nOiB3Zng6IGRyb3AgJ3NlY3VyZSBsaW5rJyBmZWF0
dXJlCiAgc3RhZ2luZzogd2Z4OiBkcm9wIG11bHRpY2FzdCBmaWx0ZXJpbmcKICBzdGFnaW5nOiB3
Zng6IGRyb3AgdXNlbGVzcyBmdW5jdGlvbgogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIGVu
dW0gaGlmX2JlYWNvbgogIHN0YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIHVuaW9uIGhpZl9jb21t
YW5kc19pZHMKICBzdGFnaW5nOiB3Zng6IGRyb3AgdXNlbGVzcyBzdHJ1Y3QgaGlmX3Jlc2V0X2Zs
YWdzCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVzZWxlc3Mgc3RydWN0IGhpZl9pZV9mbGFncwogIHN0
YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIHN0cnVjdCBoaWZfam9pbl9mbGFncwogIHN0YWdpbmc6
IHdmeDogZHJvcCB1c2VsZXNzIHN0cnVjdCBoaWZfYnNzX2ZsYWdzCiAgc3RhZ2luZzogd2Z4OiBk
cm9wIHVzZWxlc3Mgc3RydWN0IGhpZl9tYXBfbGlua19mbGFncwogIHN0YWdpbmc6IHdmeDogZHJv
cCB1c2VsZXNzIHN0cnVjdCBoaWZfc3VzcGVuZF9yZXN1bWVfZmxhZ3MKICBzdGFnaW5nOiB3Zng6
IGRyb3AgdXNlbGVzcyBzdHJ1Y3QgaGlmX3BtX21vZGUKICBzdGFnaW5nOiB3Zng6IGRyb3AgdXNl
bGVzcyBzdHJ1Y3QgaGlmX3J4X2ZsYWdzCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVzZWxlc3Mgc3Ry
dWN0IGhpZl90eF9yZXN1bHRfZmxhZ3MKICBzdGFnaW5nOiB3Zng6IGRyb3AgdXNlbGVzcyBzdHJ1
Y3RzIG9ubHkgdXNlZCBpbiBoaWZfcmVxX3R4CiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVzZWxlc3Mg
c3RyaWN0cyBvbmx5IHVzZWQgaW4gaGlmX3JlcV9zdGFydF9zY2FuX2FsdAogIHN0YWdpbmc6IHdm
eDogZHJvcCB1c2VsZXNzIHN0cnVjdHMgb25seSB1c2VkIGluIGhpZl9pbmRfc3RhcnR1cAogIHN0
YWdpbmc6IHdmeDogZHJvcCB1c2VsZXNzIHVuaW9uIGhpZl9wcml2YWN5X2tleV9kYXRhCiAgc3Rh
Z2luZzogd2Z4OiBkcm9wIHVzZWxlc3MgdW5pb24gaGlmX2V2ZW50X2RhdGEKICBzdGFnaW5nOiB3
Zng6IGRyb3AgdXNlbGVzcyB1bmlvbiBoaWZfaW5kaWNhdGlvbl9kYXRhCiAgc3RhZ2luZzogd2Z4
OiBkcm9wIHN0cnVjdCBoaWZfaWVfdGx2CiAgc3RhZ2luZzogd2Z4OiBkcm9wIG1hY3JvIEFQSV9T
U0lEX1NJWkUKICBzdGFnaW5nOiB3Zng6IGZpeCBuYW1pbmcgb2YgaGlmX3R4X3JhdGVfcmV0cnlf
cG9saWN5CiAgc3RhZ2luZzogd2Z4OiBmaXggc3BhY2VzCiAgc3RhZ2luZzogd2Z4OiB1bmlmb3Jt
aXplIG5hbWluZyBydWxlcyBpbiBoaWZfdHhfbWliLmMKICBzdGFnaW5nOiB3Zng6IGRyb3AgYXN5
bmMgZmllbGQgZnJvbSBzdHJ1Y3QgaGlmX2NtZAogIHN0YWdpbmc6IHdmeDogdXBkYXRlIFRPRE8g
bGlzdAoKIGRyaXZlcnMvc3RhZ2luZy93ZngvVE9ETyAgICAgICAgICAgICAgfCAgMTkgLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgICAgICAgICAgfCAgNDggKy0tLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV9yeC5jICAgICAgICAgfCAgIDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5jICAgICAgICAgfCAgNDIgKystLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9jbWQuaCAgICAgfCAyNTQgKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggfCAxMjkgKystLS0tLS0tLS0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oICAgICB8ICA0OCArLS0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfcnguYyAgICAgICAgICB8ICA0NSArKy0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguYyAgICAgICAgICB8IDEwOSArKy0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguaCAgICAgICAgICB8ICAgNyAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9t
aWIuYyAgICAgIHwgMTIyICsrKy0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
X21pYi5oICAgICAgfCAgMTEgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jICAgICAgICAg
ICAgfCAgMTcgKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2VjdXJlX2xpbmsuaCAgICAgfCAgNTkg
LS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAgICAgIHwgMjI5ICsrKysr
KysrKystLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgICAgICAgICAg
IHwgICAyIC0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggICAgICAgICAgICAgfCAgIDUgLQog
MTcgZmlsZXMgY2hhbmdlZCwgMjgwIGluc2VydGlvbnMoKyksIDg2OCBkZWxldGlvbnMoLSkKIGRl
bGV0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NlY3VyZV9saW5rLmgKCi0tIAoy
LjI4LjAKCg==
