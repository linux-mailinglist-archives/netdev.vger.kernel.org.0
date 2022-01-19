Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A14493330
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351122AbiASCz6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jan 2022 21:55:58 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:43026 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351100AbiASCz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:55:57 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 20J2tHjJ008465; Wed, 19 Jan 2022 11:55:17 +0900
X-Iguazu-Qid: 2wHHbCQQm4XLgqjaTS
X-Iguazu-QSIG: v=2; s=0; t=1642560916; q=2wHHbCQQm4XLgqjaTS; m=mvwZ255FdBpr94kJ17SAlPtzu99EIlmzUFJrqKDxMQc=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1110) id 20J2tFPa000767
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 11:55:15 +0900
X-SA-MID: 31810479
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeN6usZJdg2LOCITnijIuUcyPbjXDSKgX7MAPZRDJ3p7SI9plDbHuKGSKEOX9uI79pnUeX+uWhJKzE4yilLXH0IvFmJKlOP4fWgsIgyMGQD5E/ZDCyyW0g5udrYp0nZNOw4905XIXc3IMDvUBICQCCetxM+o39zzZatz0tw2r1750aQj1k+gl+e+SZOiEEVOdn8D5VrxmrBMXkClFN+RSm7+lbErDafjCj2u//R56bsMfZv5dPB0OACRqg6yjzfE2zffCLRQoEIi2kLllwwfLgKOMn6Lje4JRa0YCTo6vqW9MhovduWL01/LKK3Dwnma7p7GX7ZKryEFrkUJ7lNEHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Td0rmwwGG6V4uDy2EN8pKLXxNj8OJPQ1fp4XPuyiUE=;
 b=gpwQzIiBGZY+Q3ukDHIcxZwQFo5whzDDa8iYBUlnxLyhU84iBJdo2OE4S8q5r0EUxg8hNTcI3hp7aptp3wDFAL6sDG8wp87A8a20zFzaLn2xfAJ3gLLKUhoAvPWSW/TFUah1X47+YUm1oCni9KXkN5BfrfQxqhKkqQRP2b4jo9IBJ67ABdTQWyuhULIUAxGKeTZTiSQNx1QAuWW+cbED5B9oaJysc4dmPyz9J+zQkww/hTpdVNtCwpj2AWgQR4o7RUZ/yD1qRntPrWSHTSQh3KbEye8tYEjg7bT1cENLYnJf8T1dQNvLtYIrW+gm7hboPoLoHfyWpCyK5U5tU+DTSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <yuji2.ishikawa@toshiba.co.jp>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <joabreu@synopsys.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: RE: [PATCH 0/2] net: stmmac: dwmac-visconti: Fix bit definitions and
 clock configuration for RMII mode
Thread-Topic: [PATCH 0/2] net: stmmac: dwmac-visconti: Fix bit definitions and
 clock configuration for RMII mode
Thread-Index: AQHYDC3tqWOPOb2sn0yoj1zZ+1Ut4axphLiAgAAgxxA=
Date:   Wed, 19 Jan 2022 02:49:40 +0000
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-ID: <TYAPR01MB6201E26CD93F6BCE0F0E76B892599@TYAPR01MB6201.jpnprd01.prod.outlook.com>
References: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
 <20220118165023.559dfe3b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118165023.559dfe3b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toshiba.co.jp;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74119afe-ed17-44ab-6969-08d9daf65726
x-ms-traffictypediagnostic: OSBPR01MB2693:EE_
x-ld-processed: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <OSBPR01MB2693FE1A04F821C6EF00016E92599@OSBPR01MB2693.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CTLGT6AY0K4aFbliiuFL4MKgOPQXruDIRh4tZRjoGB3DjvZnWsgdskRvwqWulUOjclVFI46zCYmLKVWBOBzpFdyhQVK79T3HHIZkojfUiw+j5t/+lV94zHFoWNEkkldFnlzv/EdZJuGwRSKkJ3kKoKV3Z3SW9QaZ+9b6SMDed+o3QYd2kMEIbzGlMzNGyAGv4n97j8oYuHL17kCUoD7XRglUpOAwbzrXxU07+s9zjk2FU5vb5I7xewqWh3OCp7KRc2KAagVPbD+jz4Q3JHytUDey8+CChrU3O8C6MCwQljrfEbtWboPweJRuuhPk4Kfsn0sLbJBxZwt4dv/Hj3fy2O07kVXZ5fTy7jG7GgwdgyFhW/cJ5hO1kpLVVoCp9GDbcpqVSBKa0UJ2aNdl/R0C/fwITqMzN5Ci+MUmQskOutLmKPBdNDpPUZRec7VRoO3jll4lzNbRutiNOV/4F4ROww2m+BS/AJOgt5DL5ouYxEZxhYJ10A+As0YBJ/8dB+zqWEqpOd1Ni29uFb/ICEk00ZO1zdAwm12drYkQmjItpteWQX1zCKyEJTuqAxznaa5uTXr2Et8Z0qAKly1Kwd1F3HJdjY9EJ09GhEht9LaoxRtK4ZbLIiV3F4Ncera+Ojzxsc99jvtZfuBIQWlq6gjmkC1DslfJCpg5UTVb08xqqFu3lHMDcT/pq81lPV5Ucq2oOZgCLDyBh1w6bS+fpykGZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB6201.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(38070700005)(54906003)(33656002)(26005)(122000001)(5660300002)(86362001)(83380400001)(52536014)(186003)(6916009)(55016003)(2906002)(4326008)(53546011)(6506007)(508600001)(66446008)(66476007)(64756008)(7696005)(71200400001)(9686003)(76116006)(66556008)(8676002)(66946007)(316002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?RHR6UHpROUtuNnFiOS9rYXh5dnBSWXQ5a1MxWVFqbm55aC9Nb2JKZWZV?=
 =?iso-2022-jp?B?c3JvSHl2WFlLWmRJYndGMEc1NktuNWpXaFhLMHNTdCtuUlZ5T3NkSENq?=
 =?iso-2022-jp?B?TDhpTWFoSzY2ZjUwTHRYMUV0cGdjMi9pSmhtY0FENjhDVHROVE5RMldT?=
 =?iso-2022-jp?B?OEJLbUN0cnlVZ2NvM1Z5K3l5eTluZmFNUjBFSXlsK1pJVWhHelBtUmZF?=
 =?iso-2022-jp?B?WThBUUdBZXlUQkI0TENYTG5XNkxRRFFzU3NsRU1SOFgzTk4rZEdMNEV6?=
 =?iso-2022-jp?B?bktnRkljWW04TjVHaWpUNzh5RVY5SWt3VFdBV0w5VDVJMmwyQW5QdnNa?=
 =?iso-2022-jp?B?Ty9lZUNTZXdldEs3cmplUGltVzEwWm1FQ3VPN0RjdEpzTmFtYWlyQlV0?=
 =?iso-2022-jp?B?MTlJS0xYUHNPNmRzRDlDZjdvSkdYaGRaL0YvWnpxK0VGYVZpa2k0eWJ1?=
 =?iso-2022-jp?B?UzQrOTI5ZHpPY1I2ckNPcWNRSE5mZjF0aW5Ocm11aVNPdklvOVZXYWR6?=
 =?iso-2022-jp?B?NDJsNFBQOGRGQlhjZVdYMFR2NDZWSlJkOXFqWW1wOHRZYWRIK3Z0Nlow?=
 =?iso-2022-jp?B?eE5ZenQ5bzhhRUhMT09jWUI5WXV4WXlHVzNwWjByQysrMnZJZENrUGFo?=
 =?iso-2022-jp?B?QmNDZkQ5OHFEeURPYThlYWQveDNaT3JqZmV2NEFVRk54MHE3MDlMUzFS?=
 =?iso-2022-jp?B?NzJ4TkkvdmhoVTRaQng5TWtuQ3Z5NGk1Z21MQmFpR1F2MHEvQmJUUkph?=
 =?iso-2022-jp?B?bzhuWGExVmR2a0JLaWlqelRjSWNZTHJIVHA5ajlmV0R1WGlvUExNMnN4?=
 =?iso-2022-jp?B?TlhxQW41b25hUm1QRWxHTGtWRFRvWlNWcVNXV3d0WE9kbURYVGhlSVYr?=
 =?iso-2022-jp?B?eG1DWGo4K00zOXV0NWZmanFNZzB3dllFT2NFZ3A0ZlJGNjRQTG9HRWUy?=
 =?iso-2022-jp?B?Ymt0d3dYczljYktGUHgvT1FmNU9kaVFtOWZWSncrMnJGempocENxYTFF?=
 =?iso-2022-jp?B?VDE5eHRFVWE4cGRENEVPbzRWb3NWNU5mdGJlMmdUVzdWUVJkdmIvWlJ2?=
 =?iso-2022-jp?B?TGxTWWhrNFN3eVFpY3M2V1VnZmovUWw3UG5xVi9lQTRoZm1QNEFWYWUy?=
 =?iso-2022-jp?B?elovRzBrVXNRbXVET0FBNkZYMmxxa2ZkbE9BUURRdTlYdVJsYWxGd1Vq?=
 =?iso-2022-jp?B?Z0tqeXZOMHJ4L2laRWN2SHVyc1B6c29LTTFSRW5Hc3RFbHVMSWpuVTJx?=
 =?iso-2022-jp?B?dHNDRGRtRmVPUFlzUTV0TFhzWmI2eEFLTTU3SDJzUlh0WCtDSys4Ym9D?=
 =?iso-2022-jp?B?eXI5TjhXSDF6UnZpaEtVZDd1dUdtT3l6MmQ5RVl0OUhPSnNKc2xwUHU2?=
 =?iso-2022-jp?B?ZnExUGxlT2R0aGNNMHlOQUI1TnAvYXJlRzZEUjBqWkwzWWhHRTNXM01p?=
 =?iso-2022-jp?B?aWZRZVBqL042d3NMQTQyOG4rTXhubE95MGZjV015ZEoyWFFid2s3Nnl3?=
 =?iso-2022-jp?B?cE9MeE56MERGMUtQMm1QNGJwN2VoTFAzWkZYU0ZPQkNyVUhnaXJuYlRI?=
 =?iso-2022-jp?B?OHk4WUx1NWwyTkExSXhIWm1nUXBMaVdZSXpSZjczNjRhOGp2c1Y3MFVY?=
 =?iso-2022-jp?B?Si9KVjhkblVyQ05OKzFVa0tiM0k4RDNWNWFPZnBkRk0yTHEraGhxaGEx?=
 =?iso-2022-jp?B?d25oSmFDN2ZGT1NrWmdzVzFvLzEySGFUVE0xcmZLM1hMM0pES3d5NjRx?=
 =?iso-2022-jp?B?VHN0dUI3UG9YdWt6M0N1Qm1jaW5IbExERFlqZ1J0c2hUYUt3eGczQ3F6?=
 =?iso-2022-jp?B?ZzNYa0o3VGg1MUZxak5LNVIwSitZaHVwb1dXanBZV01OTGJLSlF4RHBI?=
 =?iso-2022-jp?B?K2NFcWltZVp0NUxMREtZTGpEUTU2bldXSHpxM2JEbFZQNFZoZVhEVGJF?=
 =?iso-2022-jp?B?SVpXa2pScWFQNC9DRHdLYlJlUmJxYzRUT3ZlWUw2Ym1jRlZRallGeFlK?=
 =?iso-2022-jp?B?RFhXZ2c1OS8zalBhdEsrVXhWZDhWWko2U0N1T1NmNG5XalM4cUpmbXlQ?=
 =?iso-2022-jp?B?eG9kQ0NsVWNVSStsWmJ2ckJ2RkNTYnEyZDJqNHpQZ25MQm1ONE1RejJO?=
 =?iso-2022-jp?B?MWRocmNpRTdUaGNXUTVzcFhDTUp6SWZRREU5YmJwdEk3cmREVll0bFJx?=
 =?iso-2022-jp?B?VFBpVUJuSkRoa0EvVEZLcXZ5RHBBWTZac3VkSUF5cXpxZVdIclpDbXRv?=
 =?iso-2022-jp?B?Q0hVOFlXYzlEZWZmQVkrN01GMTZSenY3OG1jVXZaTVlDZFY5emxZaEZt?=
 =?iso-2022-jp?B?R0RUZHhGUFc5WGk2WkcyTzFYeWRUbjlpeXo0Z3VpWjdBTXZ4aWhiTDFM?=
 =?iso-2022-jp?B?RFZXSk0rQVFNTWdQVkZaUFAxbTZqcWRxbWk3YnVrSnZMYWd6dEZCaVRz?=
 =?iso-2022-jp?B?YXY2Nmh3PT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYAPR01MB6201.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74119afe-ed17-44ab-6969-08d9daf65726
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 02:49:40.7956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pjcXqDUKSn7Ew6w8Luc0isSpWg380gUQaKbTyCVGOadwfQpBAz0D4llqDMo3SyCowhPBVt/ztMBehvttF99Vyg+28LxxM4OFKELpIS5NRzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2693
X-OriginatorOrg: toshiba.co.jp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for your comment. I will add Fixed tags to commit messages.

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org> 
Sent: Wednesday, January 19, 2022 9:50 AM
To: ishikawa yuji(石川 悠司 ○ＲＤＣ□ＡＩＴＣ○ＥＡ開) <yuji2.ishikawa@toshiba.co.jp>
Cc: David S . Miller <davem@davemloft.net>; Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>; netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; iwamatsu nobuhiro(岩松 信洋 □ＳＷＣ◯ＡＣＴ) <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: Re: [PATCH 0/2] net: stmmac: dwmac-visconti: Fix bit definitions and clock configuration for RMII mode

> On Tue, 18 Jan 2022 14:39:48 +0900 Yuji Ishikawa wrote:
> > This series is a fix for RMII/MII operation mode of the dwmac-visconti driver.
> > It is composed of two parts:
> > 
> > * 1/2: fix constant definitions for cleared bits in ETHER_CLK_SEL 
> > register
> > * 2/2: fix configuration of ETHER_CLK_SEL register for running in RMII operation mode.
>
> Please add appropriate Fixes tag pointing to the commits where the buggy code was introduced, even if it's the initial commit adding the driver.

Best regards,
Yuji Ishikawa

