Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4FC408BA8
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbhIMNEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:04:55 -0400
Received: from mail-dm6nam10on2082.outbound.protection.outlook.com ([40.107.93.82]:64256
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240083AbhIMNEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEDi9iAsTAg6iiuT7HF6ZTdplmemLKiab/7FftOv1D5poURlbXEypGeRJh1p+Pc/K+jLQoo8JPzXpBi0HSuCcrmTJ0u/BsCrJzbuDcCBq/xrL6XvcunoExq+Z7K9WzdamRoI3lsTc2rsjU8RimSJUiRoXYa4cRFFQ7fDWUheOz9MaiTTgppj8rh6ImM11sZBFRv6jpU0Ikvb8XiozgN4W32ZlsaKd+epKVIxS6zt0Skj4E7vHZgsmX2R+ICuIRQK3z3qOGRh7fwiFsE47uFJwxtH5ON7GU7+eSc1HqVlMx0r9N8J1xElgiugqXu6dBmmW5e7aAIjN1hh72R8jP5Qag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HcjC0x4GRAxwfKkA5UMWXqZtFAOXbrjpXeRYZIftO60=;
 b=nojD7O46q7EoeKVjENFzJMGAuilxsrQrAhLk/G6VLVJu5IxpGEQ2sHyi3H+bbqMiye+rOQl+UbQZ0nY4TqagvpwJMS1vukmzxzHMF82W+pQyy/jWC3XcSFMII4ztcfOQqHgfwP3ujg43SsIOt1EgDuYuMrrRLXJ3hYWok3Mn5j5bhCUaU+Lu7pKl+L7vwstV9QkJquOb2LkZ2QJS4trs8U9Daac9jX2Srb+djjsCOBi6mUb2WH0IjVNGOS4wqWfvWTxD2fDQCb8aHbzQQvlZjHPqo4OAI88ht/byWHHDPyXLo1vKcpMQSjSNvUiL5NA5P1PoxUSgEzc+KQeO3AhoHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcjC0x4GRAxwfKkA5UMWXqZtFAOXbrjpXeRYZIftO60=;
 b=Y3y5GfdkBBjS10yJCW2NsIUDAeTijUNgNy9XkZZY8C10J3kP/HhrKfDqVzWpc+DCN5zA4f25sfDtdRUHzDxLsMYxZzzNTIU77Wm7EXIU+OvN1EjKxpXMVoP687CJ+wVqPker4Dl78ZlK4it4p9I2LO3GzSaAAcy03555mSqkXjY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:56 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:56 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 21/32] staging: wfx: remove unused definition
Date:   Mon, 13 Sep 2021 15:01:52 +0200
Message-Id: <20210913130203.1903622-22-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd254e6a-f94a-43c5-e31a-08d976b6cdff
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB350219312C26B8BDB18844DF93D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ugDxRRQS7rKFL4X5wNZo391l93rQB+QynM30gdIG9RmQRezMjWBzZMomzHxcIECFyDt6daL5B+ZqoEi1cM4CHhUtL0Ox+VxWA+HbaH1bSK1zKtGoiAhyA69PUgjclJvSgPtjWNNB9877Bsqg3Vb0/va17wSb3UMGAKxi5dIOqCfqOwUIdOTh0Ct0O9L2UtROleggrPIpSdqOxlDZCskd+W2Y2GS6VMRLJFKea2qvUyHCDE1fmSz+I/gU17HM3x2++49Y9u6xY0ehECv1Crbfz8DGer/eZm2OuivKvgfkoHYM147YR+9zM8cBTfxWTuUnGTLFZ9o2f5T8pGI8/RJuDNVV74PjnSycRU4ck+YqxmlpHhOy6YATTo45yRDBfvjTSGEVJUwgSwtp+hW1tfDDfhN/RPcaeFWMYpvDUGqmgu77z6GtRMLn/8hOxHR/BBsHmvvFBz0c3J6fjxK2jwMPiSiVMfmXh2RQT05c2MO7kP+Ztx3bRm+lrapksim70np2gGkmxEHbwRAJxDbobxIzc6KIq+Trhl4nD5i7Un74IubXNroG6fJhMlHlSFz9cAGcab4c9Sbb06DryIOjYvZW3HMoUVU4QdEmuXHfdDb8bl+NK4mbLtuR2JgbBxbEbLSfDwDMwjKSJmR+oBnON6d/MHEhM0RopeJlGEux1mo87AJwrWhWmHKRfefT0lyxJep6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(316002)(66476007)(8676002)(186003)(4744005)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDNTL2JNVDU4SUFnbGRXYWpSTU9lNXNXRnV4TXE4UnZDZTRHMUlBOS94V3Qy?=
 =?utf-8?B?OUo5Wll2bWtORXBQZHdHM3F1elpMSWRrMWVXWTRPWktQbi84SytqSkhJQ05V?=
 =?utf-8?B?M0dXN0JnMUVwYUo3ZnprS0FkbzBXZmxhYnNyNUx2cCtCMlNyTXREbXBRZUEr?=
 =?utf-8?B?MGFHeVowQU5NNmJwSHVyallmZVZzeURRNWxFM2gybjVzbVlGL1lsZGJUckVy?=
 =?utf-8?B?VFRIQ3hQVkZJb3VCMi9IOVppK0dKUHdwSDFmY0l1dEcvRk4rNzJFeGtiNkNC?=
 =?utf-8?B?Uk96U3dsVWZ6bWlhSkFNMktnRlhFZU1GUllGYXEvTXY5bUxVZ3VHdmgrbHpM?=
 =?utf-8?B?Rm1ZZndVRGpKWnlLVVlaLzNhYklMbm9xTEp2VkZsM0tlVU9BMWNIZmduc2lG?=
 =?utf-8?B?ci9pV3lRSmFtbkpXVlRPdDZHUkpkUTEyc1BmMTc4QTErbWFUUStHS0dqbG53?=
 =?utf-8?B?aGhMd0duZ25la2FlOS9YamhYR1JJMnlNd3k1NkE0dkVjSERHSXZPTmk0Lzdi?=
 =?utf-8?B?KzVScVdGcVhRMTJwUy9GQjBBVWlUaHYyYy9mZnIvQzhsTTJPRjQ5cmVOaC9j?=
 =?utf-8?B?aHlOb0NNZC92NVVCWUFuWnFEYjBJZ2JlMGVEejhOTDBrOFJjVFdyWFkvZlVx?=
 =?utf-8?B?Ui9xeHVMZHI4aHQ5ZFpUZEYxWmJvd1c5RkZuT09JUVZUZ1VUU2FaRUFLSDFN?=
 =?utf-8?B?QTZHUzJIR1phVXhmdHVtU0laTFpnZHI0aDAyWDVzSXRzN2ZITVVGV1Q3Yjl1?=
 =?utf-8?B?UWlNS0RrTjNtZTF5ckpGUDlteE5xd1ptcVhsL2dRNG5ZQ3Q5dHdGZVNWWVRJ?=
 =?utf-8?B?dFp1SmtnYWFPTXkyU2FudjNqZVQ3YVg4aWZhT09kK21xenpFbmJsS0s1Z09t?=
 =?utf-8?B?a3EzWXJ6eXI2YmtpdHBMWWdoWWlCc1Q1aXd6RGxMaEZ0bWM5NDZqU1luV1d6?=
 =?utf-8?B?QVBjdDQ3c1RYSTFvR3ptZVVBc29FMmxCOGgrK2hORVFjalpQcm04MzdhZkpl?=
 =?utf-8?B?Q1FRT3R1ekRSTzQrVGpoVktQTGpJVHNmMFBUZUljUW15TWtnaUZVekUxOEhC?=
 =?utf-8?B?emJneStqZURnR1VWeklVbm8zSTB2MytXOEpwajJSb3VtaGJGQ1J2L2dRRW8z?=
 =?utf-8?B?WkR0c2FlMGpOUDNnMERKUnRFeDhibTl0U0dVUlJwWDNNN0hkeU5GVmJ3cENz?=
 =?utf-8?B?Z0ZVUWJlNkQrUEVkdmhaV2lORE53b1BTNXNwaTJOdkx5TmRKZ1RUUFlGbm9l?=
 =?utf-8?B?bXRSRkN5WmhIU0g2M25xMS9zc29XVTg5eTduUExLWUxUc2c5aUx2RTlrRVZx?=
 =?utf-8?B?ZW81RkpkMHlWQ1ROZHNtR2gweVVmcWRRa0U3TVJiS2lHTkdoN2JJMW9lU0NS?=
 =?utf-8?B?TGRVbEJ0cDY3L2Fud0d5Vyt2VzBrNmJreG5OcGpwZWlGVGkvVWlTZy9MT0Uv?=
 =?utf-8?B?cTRTSk9mWEt0WmdMdVNYU3RjTjBLNU5UM0dSd1RCMXZuV3lpMHl4aUQ0VFYx?=
 =?utf-8?B?RTFPb3JGcnhEQkwvc2lkOTZMRk52Mks5WURBNUpYOEFYeG8xeG04aUJrdHpl?=
 =?utf-8?B?N1Ztb1B0V2hhQW9GeExOd0ZOS1FZRDZxa2tJbEtmVHQ1Wm9pOTVXUmxkY3da?=
 =?utf-8?B?QWM3MWxsR2FQb3dockRiSE1CVVlzWEJsTTI5MUFLR1JMVGgrdU1oVU51QlNS?=
 =?utf-8?B?cVA1NFV0bXFvY2RieHJIWUxHNDFXVEJaaVBMSHlxZTJQQmRlRVJoU2FPV2ZE?=
 =?utf-8?Q?uI4Lwy1kZ4ZQXVwS16h2vbxF/3uDRPTnUeo8Hhl?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd254e6a-f94a-43c5-e31a-08d976b6cdff
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:56.5278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOgjbnvutghzH9BQTAKn85Ph1iadGkSO2bsPxBrp7nRhCyZlbOli4Ya9gVTIt1a8w4QHjh2cOszpVKotzhQhYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
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
