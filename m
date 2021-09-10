Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9CB406EA1
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhIJQGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:06:46 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:25696
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229448AbhIJQGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:06:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTouRQBowvHyCcGB/aCSURxURMakFhDct06BzVWznO7+eZkgbLz+BArJuf9lIYjshLbJTEKHY8GbiPmNKAX/Y7TJvc3xya+HyGNKNRLHWO5UAD0aXpcMM8PUCQrs978esn/VXVOFst9AtxOforqeWnyS1FMcEOJGBs8qzIMfpwy2MzibYpbxeg/G5doxUacqw/bMNfkgWuL+6Wh4BZrUQ2tDHj6lJSZoB3KGdQv2iLTy5RqBeo/reBwHdCYXjrCb+0RbKAMM4o9ogd2Nc9Ajx54NhCzmR9gl/DRuPIl5NSnxrhGnljtw2NqPjp0sI/8CGsshZHjRftBkt2wTyr0djQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XMICdxmOe3jb3Xembz/d5ptOSsq4dCHTuO6APpZ/tOI=;
 b=aqXVYzMDuSJPJKyWyeRj6kvutfl+hV1J4B3G/wBQixwFweo0tJjf9w9ZvRr6H/wsOU0Xdo4IpOKZuPcBhbq3bHxXq/3maSLqavfYC33wAQ0cibQxXKD3dxNOyRzp+6oNYiZZc/r6fGnnWxWP2JSmwMm33Sqivxz4CucFIXtqYbCKgt050GVOB9jPtsmRpEgCQF0eZku1ScZPJd4NQ3OkzPFRtwvWsqfck33DHFhBhwbzHIwFrj794hpj+I1Xz26QeeLp1O9QTIxjddfMdOShD0RrNkKCsvtvz03R7ZlR4l74GybBy6D3R6RQ5WekUxbHKpD6S4hWa2b8IA/an2EN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMICdxmOe3jb3Xembz/d5ptOSsq4dCHTuO6APpZ/tOI=;
 b=VWQTC4DykXCFT85ENLflX42CAJZWaW5BTJ/OpQG7fo8lg9UhcVdD4t3XKSS3QRxXxljpbo11CfLBYylpZk1Whmokk/QXQ6SlNdiqyMYG5yxTE6IH+T6ypFEEYZoZlzDuTqED95382/W9ZrZJWaEikj8lxE5Dk+hNMiy5AcndyEE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4592.namprd11.prod.outlook.com (2603:10b6:806:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:05:31 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:31 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/31]  [PATCH 00/31] staging/wfx: usual maintenance
Date:   Fri, 10 Sep 2021 18:04:33 +0200
Message-Id: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94851b2f-6880-4078-b9d1-08d97474d066
X-MS-TrafficTypeDiagnostic: SA0PR11MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4592540C31B1B3DD40A5C21F93D69@SA0PR11MB4592.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BoOrSYSQ58vn7Hm6dZH68xXuJNZYP/sWvnXeAtftGiWL3QAC0ZL2UPlHLGHAswUefD1xoDB5UtqXsrJx1k9kWxFq9uM4aOQGqPjlXiuI4UDAAjl5EGCGdZmevSqWyZqrcGnK/FNNUTcCz0TkjfpxhLsuKOq1jFIQ8EPBGRVz6s4n231lBdniXUIGQKy4oG+lB63bQwq9/WRZBLd/8CS/we5YQbrZsB5hZVAv27PcaShUA5RYhwiCtEOuDqPYdN5iNMg2+lE4QIYmfhc4gxbnt512IazPPgM0UQ/lpy14EG89nQR5mD67oQqwrNJG6KRdOAOKszw2eKcA238Ss8JqOxfpi6FC1ZW1AAYs8hv+5xIYPr81+Y5SRtZrkJjBHoqQecIzrIEDH1fPeRGGKE1M9MlB57MQf3KqeFld/KtbwpajqrV46pKBnhaStmx7qTbsy5qPzysfo6g6bfvtm1WphpdJb+siAar4p2PUy7+4PctFGJKs62rAm335QjTUAfnFeMYwbX3uHtyGlrCjMcmvK9/4oRq+qID3Irw6rYtFlKOzY6yad7lJbOLI24G0cUxUryPy6RbqYmj6Z9MXasXMR7QrFyLNvnO4CsXp5m+yrD5uu4fovOGNUDIcf3pPDFuOxr3528+Drj6XCQO03UIuYfGsNBOElasRaUU9b7D2r1v+FYhzItUqD0hFHgscZk9N7FDxmf9xE+fRoJpB0GYgxMQfv/0fPL1pf2rCKK5lhc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(2906002)(66556008)(6666004)(66476007)(316002)(66946007)(83380400001)(966005)(66574015)(8676002)(8936002)(36756003)(86362001)(6486002)(107886003)(7696005)(52116002)(54906003)(2616005)(5660300002)(4326008)(38100700002)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmZtRnJoc3pEcEJNOVhrV1pUUTV1ejNhN0VJSDNoejJ3K0gyTWFQZnRlL01R?=
 =?utf-8?B?eCsrRDNuN1ZORXM1Sjlrb0QwU3VIeFE4d2tpcEZEbkllb01pckd1aytxaTlo?=
 =?utf-8?B?cVlBUUhVVXVhNW5pVlNYb3ROQXozQmtvUklGeUtIM0FyQVNlYzVKWmNIYTRm?=
 =?utf-8?B?TXZtUXl3WEYvbE9SckVMMGNtZmV4S052dzB1MFJxeTFwSkJZQWJmQUVFZXpV?=
 =?utf-8?B?MTc1QkNSek5hLzZkek9FdFhXSktkbU9taDJwYlhBWjA2Zzh5ejhieUtMZTNz?=
 =?utf-8?B?NThMdlhWbTRSaUJOOGFUQTVQbDJQbUlZcm52NXN3ZGh3QjZjbC9jL1FWbHg1?=
 =?utf-8?B?OEpDMFZGQm9JSWNzK3pTbUo3cnRCdkRTRWtBTWhmSkdyTWxLQ0U2UTF2QkFu?=
 =?utf-8?B?cC9leFp4TDJlTW4veUFFbllNWDd4aGdtNmhxRDNRaTRLVFl3Yy8ya3hKeWFq?=
 =?utf-8?B?UUZ3RHdOUTVHZnlkR3BaR1FvalZvcHUwTGYxT0wwdG5iRWU3NVhoYTJnUjNM?=
 =?utf-8?B?aUtCYWRadFZLa0pkSW1LNnFDdDJ1QldZa0J3WnpkaG43aHFlOXo2a3EzQnhR?=
 =?utf-8?B?MUora2RGUHhuOC9ZTzNQQjhzZ3NaODN6NTMyM01mNUlvVXhmM1ltYktXa0hB?=
 =?utf-8?B?M1pGK3A4OVZtWUFyTmUwZmZBZklLTERPb1RvZEYxVUVPaUp0SWNMUUNRSktw?=
 =?utf-8?B?TWF6RUljV2c2Vnd2VWFDT2thUkF6U0RKUyt4bHpta0o0Zlh5L1hmQjFRRUcr?=
 =?utf-8?B?eWNUem1zVzIwcHZEMzdOdzkxbyt0UHdlOFc2aEtOMUlkeU9wd0IyZElSdkE3?=
 =?utf-8?B?OXd1dEV5clZTNVhMenNDK0laU3lQZHIySEZTT09QZUQrV3VJVGpCUFZpZFVR?=
 =?utf-8?B?aVRXdzJ6ODBzempYMDVMTHBjeGErUklZVlV0dUNIczZYODJ4SDl2eDN1WmE5?=
 =?utf-8?B?REl3ejhybENWaUZiL0dRU2JMdTAxbEpmS2dqeGVoWUNtcDI2RWRVYnZaOVRD?=
 =?utf-8?B?QVlzSU1VZXY0TEp4THhSMTE3OXRGV3BCalhHTmN6VFhva2dTYm4zRFhxdmdh?=
 =?utf-8?B?RkFTTC8rWk5aWmVaNWJFbHR0eWhVODFPQ014aHdmQjJ3bnNhQjdHM1VFeHky?=
 =?utf-8?B?bXAxaE54VmpFUysvRTc5UXl1dHB0UGtmU1FMRE5pNnV6TEJzdFl3cGNHbUJT?=
 =?utf-8?B?UnI2SWlNcnp2bmtXUVhEVHhZMmdZR1lQTGlqU0szcGhkR2QvUWxLR1ZzMTV6?=
 =?utf-8?B?MzhvaDBZb280Q0d2ZkZ1NU9HL240RE5CK0NjUUtzLzJzNzF3ckd0TFI3VGFt?=
 =?utf-8?B?WDdkandkQm5CTWJJR3cvODh5cm9LQWN3VHRnZTBJem92UWNESXNRODRkdjJr?=
 =?utf-8?B?clpRbnExVDFOUEZqa0JUbzZZRVRLclQrbVZDcVh4bnZqaXEveHBNc0lyWlk3?=
 =?utf-8?B?Ny91cTdBQlNBYXJEQnNQanBEelcxdjdWVW1IdFpaL3lqczBLZHF4ZThDSEdl?=
 =?utf-8?B?OG9pY1I1YzRFbkNROU9wUTB6Rks0NGpSV2FyUUNiZkFGNXozSnB3V2ovTTlE?=
 =?utf-8?B?TVhVS3Z4ZXZEUjlMUlcvUDJvUGt1dEhXbjZaaUVFZjd1VzYrRDZvbWNMUFlj?=
 =?utf-8?B?TnJkcDlFNjA1Znp2ZWJEYU9UWERPQmsxbmxBVXlMZDBvVG82M2tjS3JSTE43?=
 =?utf-8?B?RW9zMGM0Mjl4YUsvVDlwaXlvNzA1SktpZ2tERkZPbUJ6LzU2NHFldm4rdEJu?=
 =?utf-8?B?RGxHU0NTajlDNExvYSt0TDk1UEU2S2xDUGVQZGV5NjgySFcrbURReE8wVTNU?=
 =?utf-8?B?M0Y5dm5nVzZYQ0l4dVFaUDBXbTkzVE5ZWVJaYmhFUUh3U3FUYVhKUGVJR24x?=
 =?utf-8?Q?PjBMQoGa/VHOo?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94851b2f-6880-4078-b9d1-08d97474d066
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:31.4635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBPKJBREarbcsuadfL8T5FAqLCo7Vl6/vHqLo1rDd4aXK7cOpvuGptKuu5LwO/Cuyi90gvW6egC87H86vHgwtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4592
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGks
CgpUaGUgZm9sbG93aW5nIFBSIGNvbnRhaW5zIG5vdyB1c3VhbCBtYWludGVuYW5jZSBmb3IgdGhl
IHdmeCBkcml2ZXIuIEkgaGF2ZQptb3JlLW9yLWxlc3Mgc29ydGVkIHRoZSBwYXRjaGVzIGJ5IGlt
cG9ydGFuY2U6CiAgICAtIHRoZSBmaXJzdCBvbmVzIGFyZSBmaXhlcyBmb3IgYSBmZXcgY29ybmVy
LWNhc2VzIHJlcG9ydGVkIGJ5IHVzZXJzCiAgICAtIHRoZSBwYXRjaGVzIDkgYW5kIDEwIGFkZCBz
dXBwb3J0IGZvciBDU0EgYW5kIFRETFMKICAgIC0gdGhlbiB0aGUgZW5kIG9mIHRoZSBzZXJpZXMg
aXMgbW9zdGx5IGNvc21ldGljcyBhbmQgbml0cGlja2luZwoKSSBoYXZlIHdhaXQgbG9uZ2VyIHRo
YW4gSSBpbml0aWFsbHkgd2FudGVkIGJlZm9yZSB0byBzZW5kIHRoaXMgUFIuIEl0IGlzCmJlY2F1
c2UgZGlkbid0IHdhbnQgdG8gY29uZmxpY3Qgd2l0aCB0aGUgUFIgY3VycmVudGx5IGluIHJldmll
d1sxXSB0bwpyZWxvY2F0ZSB0aGlzIGRyaXZlciBpbnRvIHRoZSBtYWluIHRyZWUuIEhvd2V2ZXIs
IHRoaXMgUFIgc3RhcnRlZCB0byBiZQp2ZXJ5IGxhcmdlIGFuZCBub3RoaW5nIHNlZW1zIHRvIG1v
dmUgb24gbWFpbi10cmVlIHNpZGUgc28gSSBkZWNpZGVkIHRvIG5vdAp3YWl0IGxvbmdlci4KCkth
bGxlLCBJIGFtIGdvaW5nIHRvIHNlbmQgYSBuZXcgdmVyc2lvbiBvZiBbMV0gYXMgc29vbiBhcyB0
aGlzIFBSIHdpbGwgYmUKYWNjZXB0ZWQuIEkgaG9wZSB5b3Ugd2lsbCBoYXZlIHRpbWUgdG8gcmV2
aWV3IGl0IG9uZSBkYXkgOi0pLgoKWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIx
MDMxNTEzMjUwMS40NDE2ODEtMS1KZXJvbWUuUG91aWxsZXJAc2lsYWJzLmNvbS8KCkrDqXLDtG1l
IFBvdWlsbGVyICgzMSk6CiAgc3RhZ2luZzogd2Z4OiB1c2UgYWJicmV2aWF0ZWQgbWVzc2FnZSBm
b3IgImluY29ycmVjdCBzZXF1ZW5jZSIKICBzdGFnaW5nOiB3Zng6IGRvIG5vdCBzZW5kIENBQiB3
aGlsZSBzY2FubmluZwogIHN0YWdpbmc6IHdmeDogaWdub3JlIFBTIHdoZW4gU1RBL0FQIHNoYXJl
IHNhbWUgY2hhbm5lbAogIHN0YWdpbmc6IHdmeDogd2FpdCBmb3IgU0NBTl9DTVBMIGFmdGVyIGEg
U0NBTl9TVE9QCiAgc3RhZ2luZzogd2Z4OiBhdm9pZCBwb3NzaWJsZSBsb2NrLXVwIGR1cmluZyBz
Y2FuCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVudXNlZCBhcmd1bWVudCBmcm9tIGhpZl9zY2FuKCkK
ICBzdGFnaW5nOiB3Zng6IGZpeCBhdG9taWMgYWNjZXNzZXMgaW4gd2Z4X3R4X3F1ZXVlX2VtcHR5
KCkKICBzdGFnaW5nOiB3Zng6IHRha2UgYWR2YW50YWdlIG9mIHdmeF90eF9xdWV1ZV9lbXB0eSgp
CiAgc3RhZ2luZzogd2Z4OiBkZWNsYXJlIHN1cHBvcnQgZm9yIFRETFMKICBzdGFnaW5nOiB3Zng6
IGZpeCBzdXBwb3J0IGZvciBDU0EKICBzdGFnaW5nOiB3Zng6IHJlbGF4IHRoZSBQRFMgZXhpc3Rl
bmNlIGNvbnN0cmFpbnQKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IEFQSSBjb2hlcmVuY3kgY2hl
Y2sKICBzdGFnaW5nOiB3Zng6IHVwZGF0ZSB3aXRoIEFQSSAzLjgKICBzdGFnaW5nOiB3Zng6IHVu
aWZvcm1pemUgY291bnRlciBuYW1lcwogIHN0YWdpbmc6IHdmeDogZml4IG1pc2xlYWRpbmcgJ3Jh
dGVfaWQnIHVzYWdlCiAgc3RhZ2luZzogd2Z4OiBkZWNsYXJlIHZhcmlhYmxlcyBhdCBiZWdpbm5p
bmcgb2YgZnVuY3Rpb25zCiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBoaWZfam9pbigpCiAgc3Rh
Z2luZzogd2Z4OiByZW9yZGVyIGZ1bmN0aW9uIGZvciBzbGlnaHRseSBiZXR0ZXIgZXllIGNhbmR5
CiAgc3RhZ2luZzogd2Z4OiBmaXggZXJyb3IgbmFtZXMKICBzdGFnaW5nOiB3Zng6IGFwcGx5IG5h
bWluZyBydWxlcyBpbiBoaWZfdHhfbWliLmMKICBzdGFnaW5nOiB3Zng6IHJlbW92ZSB1bnVzZWQg
ZGVmaW5pdGlvbgogIHN0YWdpbmc6IHdmeDogcmVtb3ZlIHVzZWxlc3MgZGVidWcgc3RhdGVtZW50
CiAgc3RhZ2luZzogd2Z4OiBmaXggc3BhY2UgYWZ0ZXIgY2FzdCBvcGVyYXRvcgogIHN0YWdpbmc6
IHdmeDogcmVtb3ZlIHJlZmVyZW5jZXMgdG8gV0Z4eHggaW4gY29tbWVudHMKICBzdGFnaW5nOiB3
Zng6IHVwZGF0ZSBmaWxlcyBkZXNjcmlwdGlvbnMKICBzdGFnaW5nOiB3Zng6IHJlZm9ybWF0IGNv
bW1lbnQKICBzdGFnaW5nOiB3Zng6IGF2b2lkIGM5OSBjb21tZW50cwogIHN0YWdpbmc6IHdmeDog
Zml4IGNvbW1lbnRzIHN0eWxlcwogIHN0YWdpbmc6IHdmeDogcmVtb3ZlIHVzZWxlc3MgY29tbWVu
dHMgYWZ0ZXIgI2VuZGlmCiAgc3RhZ2luZzogd2Z4OiBleHBsYWluIHRoZSBwdXJwb3NlIG9mIHdm
eF9zZW5kX3BkcygpCiAgc3RhZ2luZzogd2Z4OiBpbmRlbnQgZnVuY3Rpb25zIGFyZ3VtZW50cwoK
IGRyaXZlcnMvc3RhZ2luZy93ZngvYmguYyAgICAgICAgICAgICAgfCAgMzMgKysrLS0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9iaC5oICAgICAgICAgICAgICB8ICAgNCArLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9idXNfc2Rpby5jICAgICAgICB8ICAgOCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9i
dXNfc3BpLmMgICAgICAgICB8ICAyMiArKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4
LmMgICAgICAgICB8ICAgNyArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmggICAgICAg
ICB8ICAgNCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgICAgICAgICB8ICA4NyAr
KysrKysrKystLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmggICAgICAgICB8
ICAgNiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jICAgICAgICAgICB8ICA1NCArKysr
KystLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5oICAgICAgICAgICB8ICAgMiArLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmMgICAgICAgICAgICB8ICAyNiArKy0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9md2lvLmggICAgICAgICAgICB8ICAgMiArLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX2NtZC5oICAgICB8ICAxNCArLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X2FwaV9nZW5lcmFsLmggfCAgMjUgKystLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9t
aWIuaCAgICAgfCAgODUgKysrKysrKystLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYyAgICAgICAgICB8ICAyMyArKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguaCAg
ICAgICAgICB8ICAgMyArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyAgICAgICAgICB8
ICA2MSArKysrKy0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggICAgICAgICAg
fCAgIDYgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jICAgICAgfCAgMTQgKy0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCAgICAgIHwgICAyICstCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2h3aW8uYyAgICAgICAgICAgIHwgICA2ICstCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2h3aW8uaCAgICAgICAgICAgIHwgIDIwICsrLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngva2V5
LmMgICAgICAgICAgICAgfCAgMzAgKysrLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5oICAg
ICAgICAgICAgIHwgICA0ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgICAgICAgICAg
IHwgIDM5ICsrKysrLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uaCAgICAgICAgICAgIHwg
ICAzICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgICAgICAgICAgIHwgIDQzICsrKyst
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmggICAgICAgICAgIHwgICA2ICstCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgICAgICAgICAgIHwgIDU1ICsrKysrKystLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaCAgICAgICAgICAgIHwgICA0ICstCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jICAgICAgICAgICAgIHwgMTM1ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgICAgICAgICAgIHwgICA4ICstCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3RyYWNlcy5oICAgICAgICAgIHwgICAyICstCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3dmeC5oICAgICAgICAgICAgIHwgIDE0ICsrLQogMzUgZmlsZXMgY2hhbmdlZCwgNDU3IGlu
c2VydGlvbnMoKyksIDQwMCBkZWxldGlvbnMoLSkKCi0tIAoyLjMzLjAKCg==
