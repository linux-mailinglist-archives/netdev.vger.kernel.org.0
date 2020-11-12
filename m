Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86C22B06D8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgKLNlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:41:04 -0500
Received: from mail-db8eur05on2110.outbound.protection.outlook.com ([40.107.20.110]:17376
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728330AbgKLNir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 08:38:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7iqI0ni8NxeMOcJxeiwhiGDikqRxBT0P8hVChYEkaqtICPmHF4RlMp0VDDDVP7Uhzpagv8sGc5952d5zZdcP5BTH2lQhiTf+VGYGk9UlFOXK/B5HUkMw4uvGEzJe7rqf+UYtLVrBVRsKQTQUSj1h4G0FnCTydwvTUCoZ4yKiEHxU/EUyDEewI7RuLnkUxmIImXYwzy8+MQ1SGTjwQFGUre14qufLJXHKLEWE7+xHXjeqZP6Gj7oT8iNSZZMcF+czYOygJJMuW3KovNgRpxqEd+GdrgoPF0U1akamXebYzS52QQHn57UewpzWYaDDPH/PkNrPp+j6zRQibARTNj60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGeWbEO1SoYVFTHIr3BVwvqKJBTkzuSsksTHzNbKfe0=;
 b=m+M08RYlmSNjqoliT6yk1UpRiVNKXi6HolhsaeFinBa7b7KuAfarYG6u7Zi1yRMnYnLaJIJWxuGzHd0QlpBGY4XIR4FYRk1DhNClIBAsbgKqlrzZOrT4WCiZ+7qQPxqqvdg8BcbPlOfHQLqGKOXJ7HxFxQVL8QxQXANlB0lez/A1e4YSUjsTsIzd5qwKhNLFBOEVBC/tSIM/IfM6RmZJdXSI4UXJ9ubKbGwVZ8Qeq6YJdAbjiuVv0fE7aqgUtuj5kxfil2Bs960RNKTDNu/BxLc8Y6hE1DSrjw+djG9sH+65uVDXZqUgRcBXsZrCnzcwQRhDnxeflzv+CZc6tr2srA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGeWbEO1SoYVFTHIr3BVwvqKJBTkzuSsksTHzNbKfe0=;
 b=WENk5xIiCVWOkMEHtCbQi7nwz2r/o1jVXEBwu0fAEB7v8F/NF6fz9yQG3srSKOwsPbSzVplaHCtDmB71wNiVE0wKt6Z6ChEWOFug5PJx6PD80TMZUD+5OYy1RYYeR5SMpjiUErBArh48QqzGhnC6jVHMzGtbWsPKvmU3pEW4lSM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0364.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.22; Thu, 12 Nov 2020 13:38:42 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::619d:c0a4:67d7:3a16]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::619d:c0a4:67d7:3a16%6]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 13:38:42 +0000
References: <e83a263f-26e3-7d96-5808-2bbf3e89ead9@alliedtelesis.co.nz>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "vadym.kochan\@plvision.eu" <vadym.kochan@plvision.eu>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Marvell Prestera Switchdev driver
In-reply-to: <e83a263f-26e3-7d96-5808-2bbf3e89ead9@alliedtelesis.co.nz>
Date:   Thu, 12 Nov 2020 15:38:41 +0200
Message-ID: <vrcxh2zh3moftq.fsf@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0301CA0015.eurprd03.prod.outlook.com
 (2603:10a6:206:14::28) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan (217.20.186.93) by AM5PR0301CA0015.eurprd03.prod.outlook.com (2603:10a6:206:14::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 13:38:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90e09736-4a38-4366-9d9d-08d88710455c
X-MS-TrafficTypeDiagnostic: HE1P190MB0364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0364925B6DE856628E82314195E70@HE1P190MB0364.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VeAAep57f6WT+WxuY4YKN/1difBS+Jd+CT3gOHEpmQ1M1HFolKIX++8e9Lm3wMPNYWCJ89Nc6cwyVxCCpFV4XMgcpWpcIA2A7xs8onG/xeHIcHPKz5CfCTlbkuQpbmWh9VlGKPpMWYcQuvSndLRuKdN7ZpY1vn//vAgMU97D0B/J5+n+FuryoK5hcfF3HAsbVtkA3jIgbwDfClTwKzwoEmIFapuPae4PeL/jN+a0TuZkN5l4sLeUQvqXf0OANnBfgAywUgTg1lefGKy62T2VdYYmsZDh072ZRhyhRsBKZprc+nAwMT6Alj91jwasWUAno0dhmAm/ASJeIGQtEOwaGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39830400003)(136003)(54906003)(5660300002)(83380400001)(8676002)(6486002)(8936002)(66946007)(66476007)(66556008)(4744005)(86362001)(26005)(52116002)(6496006)(16526019)(478600001)(4326008)(316002)(2906002)(186003)(36756003)(6916009)(44832011)(3480700007)(2616005)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LlGDgllgdvMzucJtjqkPCd2phURxah2CNm34+g4nhfxX+bCqTV0hg1UXdBBZRuictX2DUUyHjYfxtjMQt81Pztc3wmtmzeXeS9796UZi36y39gSNFAXIUaiGa3QxV3yWLPQprWH4FYLcrbDYpq83RHnH1u3o8tr55B/I8KA0kUlThyVUWlj5zjoqp1YFuBJUCXDMiVM9hyr3/Aibs5/e9aEoMNNzpAdK26Zfgv3CxoOI+D1Q40yr540dWsfVsuQtbPMKR1vcOny1ZQ+hrJZqY/t9QXlt+QxM+S6pYxGlWh2wyjYWv2LUyndmLeNTLFa6Ux1Lz62T6NB6Gh6VrjWW3s0maPG9VU4caH1NB7DJbit83SDBgxW6+qSLiGPRotW/a1wmVnEYy8o5gdrhLzJkPQb73YFRu29SMZ8YNIJXQxSfmIuTC6VTQXZu6d5FccXQ8vnErURkk/CZRyctUtVv2udCpxtPMIpPvFQ/NJNH+zauTmuCV+2/LWYfKgHB7xE4viqw6msl1e7eg3piNh7MwoNNTMJFekfj86KKEFtWmsziu9BIAoidBLpumQ7Z367ugrOyMwQDu4wh0w4Buq//Vc8wk3MOYMoDng2UxQYvpnyrfX911loV0dkBkohLdwlwzN49gGt+ipPKoh9zrLtmAKLcWKbtYsUExrxuYveNOJbo3BZ1vWTDmrjNtnkOyXzDp2KNJg8+vuJPuq5EW3S5xBmlUDJFZ2FIEwp98IimBRWIrxY7JTnIN9MY0/HWAo+HCvUPFPrHVT6RK+3vy2Xnq+7z4oAESq8Mh5DDZ//0urc7N3jh3mRY51BXPCdtukom6OlUuHeDJ7rTSrz8Sy7G+pew1z7Jzz83vOBO6ZqgyQ+Oyg6RGjDUTZMhlqXkOl4dKg7Kh9nTAAdk5HjlTNYTGQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e09736-4a38-4366-9d9d-08d88710455c
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 13:38:42.7878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0SI8dPrbUKMncQHdWEwgx9a719OPM4+T+zLB7XgJoC8FUM0njeFtoEP3WTSyc0UvVTjMImG2sQC4i+dyVg6is463I4rqg+bTabtsLvzqhJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

Chris Packham <Chris.Packham@alliedtelesis.co.nz> writes:

> Hi Vadym,
>
> We (Allied Telesis) have got some funding for a university student (i.e. 
> an intern) over the southern hemisphere summer (~ Nov-Feb). I was going 
> to have them do a little research into switchdev, specifically the 
> Prestera AC3x support you recently landed upstream.
>
> We've got a Marvell RD board and our own custom boards with AC3x 
> silicon. Part of the summer project will be attempting to get support 
> for the boards upstream (probably just a couple of dts files). Is there 
> anything on the switchdev/prestera side that you think would be good to 
> work on?
>
> Thanks,
> Chris

There is an activity to push the Prestera build SDK in form of 'Buildroot
external tree' to the Github to build the image for some of the the Prestera
Switchdev-designed board (if you refer to this kind of board).

Regards,
Vadym Kochan
