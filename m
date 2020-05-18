Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5819C1D7DB5
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgERQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:03:09 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:37767
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727007AbgERQDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:03:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vopq1Sggv2mPT00sfIbwnpvhli9yNG9ew3z66kOADaEcLgw4aNoK83IEGd8rA403w1BQNYM6SCTvX2UT3dPzFYf0EJdrp/Kt9+pLYVdiBfKRteM+o+Le5gdfuFAoL+Sb/IVL1sHLN5rpcJKV7mc3rFMJUV3wvpB6RyP0qkFy8/aLGj7DkNCzzsmhKt1/zJxddDdDIN99BjitG4j9op/WtnrTFXxUuVyisE6+79q+3GQuLryuYHoy15Ud1R5mGI7BfWSLm3CJymqmXGYVCF0UH2MUy9EmtFVXCa9YeXpG1vuWEr9p5G/2IVhXk2BCm3UPTOXKTWY6ey6y7lOctyMJ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/dth0ntCFArUf8PXfmJ6OSvJ3SC401QyMreKiHxvp8=;
 b=ctaM+mUIfqk1F7lW8AQyWNyUx+psHGSnesUvFBwMRNE2Hd3ujT+FDnHLlm+KDNxeAM0zqmxFpUGD5AqqCAMj4T4p/Ir48fyh1K5QEwEecMbJGGnRcl+GdkqJLd+1mrESqhIqCRo7b3Tkzxw+/6QhYFFirUzhf7Rwj01vXS5Q3HH0sHg57hmMJ8G7+CApMKSogLhdDmVyBNBjt8ImXtZFMASm7/YgXNVl6JXHrRb5wpZexztr8a6B0TQZ5w2Pye/G3d1XGmr3sLt6DDJ8/DCHU93p/q6QCnKK+Rkn8IjnRc/C5plUfQ5cCu5K3ruHTbmI4h6+n4Wk0njybPBkn7r1JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/dth0ntCFArUf8PXfmJ6OSvJ3SC401QyMreKiHxvp8=;
 b=tr1PoD0cTo8xpZIFTa5Tyq9TsXa31/CULDCQ2mfOcfNxq69p3XHqpqYDay6ERtUEcsqXoWW32NNq/7grHD5EOrymSZkdGk9Ycg5n6CumiIkwE9sQPFFOviU/ovDzQwrdbrIx7kjce9ACW90E9gXu88Fp2iPBplnYxQPhZRwgHFI=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
 by AM6PR05MB6358.eurprd05.prod.outlook.com (2603:10a6:20b:bd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Mon, 18 May
 2020 16:03:04 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718%7]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 16:03:04 +0000
Subject: Re: [PATCH iproute2/net-next] man: tc-ct.8: Add manual page for ct tc
 action
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, Jiri Pirko <jiri@mellanox.com>
Cc:     ozsh@mellanox.com, roid@mellanox.com
References: <1589465420-12119-1-git-send-email-paulb@mellanox.com>
 <0c5f8a4b-2d09-6cda-9228-dd83c4d97ff1@gmail.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <942b3402-f5c8-2d32-8a5e-4f1ae0ad6ab4@mellanox.com>
Date:   Mon, 18 May 2020 19:02:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <0c5f8a4b-2d09-6cda-9228-dd83c4d97ff1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: PR0P264CA0219.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::15) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR0P264CA0219.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Mon, 18 May 2020 16:03:02 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c69728d-5149-46d3-4e5e-08d7fb44f256
X-MS-TrafficTypeDiagnostic: AM6PR05MB6358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6358EE7C0AB0F28946E574EECFB80@AM6PR05MB6358.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:53;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YxhxaD/5V8IVJgV23ArUS/fbekAiHgIagy1v1bFtmBL1BYI9Irut8VIjd17DtlrAmSbY7R9pjRKmksvNCU8qdgYWjD6btibp8epk5TGKLM/TCeH8eE001bEmOgmGtaIIHCDWI+k3XoHq8DWZ0StkM5pVsEG1VztUqc+TohEw+PHPV781f/WNEeyInqidkNiKFhAFKadhWOmBdyRr9/XoEaVETA22TTC5BhRWtbxm3plEM+6AdG2kElPuQlMoQpsY73MTOFETF6BRcdqmDyNJCjEk4RGmn3dxmzsC/b1MAdkwOYZAIoPgnFj177UIn2TjiVqqox8ljv2qQXEOka8In1+glbkRqk965mdhpgtP/au+6xwEgr+2di/BCo4n1JRFneWkzi76tWlaSM6WJXTtfxtz3ButW0gYbs/CNVXvYXlSzxr8nZzfXlQyIh9zQ2MgJlCNhK7BJ6j3BiZJp6XrOQNNH13X5RpUocqkY272AoGglpzsZZ/rhoYSBTwTC9P+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5096.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(8936002)(5660300002)(4326008)(8676002)(478600001)(186003)(107886003)(6486002)(2906002)(6636002)(36756003)(6666004)(956004)(2616005)(316002)(110136005)(86362001)(16526019)(31696002)(31686004)(16576012)(26005)(52116002)(66556008)(66946007)(66476007)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8ApfnYPSasBK+nQfvfekw6Ifdng8P/OwscRXknGO6mMiGQ9Mgs2Ux9fCqBvs5e2NiQcGXa0NXPJYl1MABF8U8okg8wtoNbG5WXq30s1sd4PJV4ivzsJibthUpny/GxAs683lAe/lPNXG74CdqyCC5/Uj+E5YZ0HfzDn/ptvIRJkLJrhwoetenGhUxMDKEVhymP/bHstn/RbN5HxWG9zvn7PcSL/5x4CgOqIu1BPuT6zRn1E/gdKGBfwjhn/KHE2iTLN4iKPH+q3Xm3pSbAAEfOMxyFGkzFgGFFsg19Im7x3jaFknsRpNWMGw4gq8X0yvlcP0n3ILZd9IhyV8raj44eUDSBwabK9UhWD/eh92k0ySD7vOMeao1COypXIZIK+p3kYrwoVT6tJdGdl9VZFkAxLyNGkm4hLGXT8+WOZX882Q7BwVFAv62FasULI1l/oGamJY2RPnuA59e4zVZwvvwnbrAZkkXymGsr/xGPDJDHQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c69728d-5149-46d3-4e5e-08d7fb44f256
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 16:03:04.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxayy+Uvk8l69jaOEuqeW3hVjVYFtpFVbiZagFdQPeUdPPrDsF5+WsYyl65JKIxG/re4TQqVvGuGvYHt/1/72A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/05/2020 17:56, David Ahern wrote:
> On 5/14/20 8:10 AM, Paul Blakey wrote:
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> ---
>>  man/man8/tc-ct.8     | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  man/man8/tc-flower.8 |   6 +++
>>  2 files changed, 113 insertions(+)
>>  create mode 100644 man/man8/tc-ct.8
>>
>> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
>> new file mode 100644
>> index 0000000..45d2932
>> --- /dev/null
>> +++ b/man/man8/tc-ct.8
>> @@ -0,0 +1,107 @@
>> +.TH "ct action in tc" 8 "14 May 2020" "iproute2" "Linux"
>> +.SH NAME
>> +ct \- tc connection tracking action
>> +.SH SYNOPSIS
>> +.in +8
>> +.ti -8
>> +.BR "tc ... action ct commit [ force ] [ zone "
>> +.IR ZONE
>> +.BR "] [ mark "
>> +.IR MASKED_MARK
>> +.BR "] [ label "
>> +.IR MASKED_LABEL
>> +.BR "] [ nat "
>> +.IR NAT_SPEC
>> +.BR "]"
>> +
>> +.ti -8
>> +.BR "tc ... action ct [ nat ] [ zone "
>> +.IR ZONE
>> +.BR "]"
>> +
>> +.ti -8
>> +.BR "tc ... action ct clear"
> seems like you are documenting existing capabilities vs something new to
> 5.8. correct?
Yes
