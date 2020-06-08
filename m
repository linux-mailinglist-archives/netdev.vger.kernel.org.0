Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF11F1C8B
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgFHP7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 11:59:45 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:6228
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730231AbgFHP7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 11:59:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgiVubfLuwyePKy8lbkcchHrrCnMOAmKuF6ZVUvxk+BH13iU05bNeux7i1wDtTTZDp0bpg4xeC1Udx9oJSRbV3U0bXRhKrjf8LItieRaA5YkRVdBM1iBIumvhjVumpoyA+TtGTYcjRJafHqTzy243Vw5nDI99jfiJrWQ1oG3P8tHDvSBk5ttCuAhrqgAf3gJ4YKWjVpEdi9AVCenPgjqIPWCLncLyToOpggKQMQnKbsBixYcZOjGMjvGnWQiy0Qnt9Qtj3B9vc/JWDFJZ5v/xUkjnIYjyloMldJYx15U4ytgEw73EcXwL23bQPiQhbYgPmpZK2ow3+n0gYZzPstc9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQeVuWMrxJv9rWbmIQYRQOMNIbLCkE1hW8H3vyg8e+c=;
 b=N67HaBbecM30DXkImqr+lhZIROr4Oor5pbxZkUjp/JDQECOMH9mN9OjicX/E6AO4QTuXd86/RazdRuna3wTfp67Ec7l4hBuux+9SAEMVcp87jprYphyx5PyaqscbuYsxHHHGSrCvcCV+JwEVna4PFpNtjp6MYUH+YwtkzewRJrzTcEhQEADx8HmMAd1NYjp7S8zOkuYkk8ktMTmX8lgyfomnHotZdg820ng0y+aF7zA6Ike/X7zjrC0NaC4kMpbjst3weV2YQ0aBHZxUTHytErvBK9cValSMdLusdJlDHeEJ47ujjTF684q2O02/YQoJ3VTdvJXYCkxuq/DDt9YUPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQeVuWMrxJv9rWbmIQYRQOMNIbLCkE1hW8H3vyg8e+c=;
 b=k1kRHG1C15kC/gsA5zmWsdv6JVQ7gI6g+TcbIXPLzLu5x055G97kntDbmy0jmOsnx6kTKlT87R0rbmNwzFteksBgkDXPqNRSqP5nb0db7thFNUlX5aRd9PrG102EpA9YfXcDlH7ONP2d83qcDuLM8yFx1mIOzj3zPFSmGqonHcA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB3971.eurprd05.prod.outlook.com
 (2603:10a6:208:11::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Mon, 8 Jun
 2020 15:59:37 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 15:59:37 +0000
Subject: Re: [RFC PATCH net-next 05/10] Documentation: networking:
 ethtool-netlink: Add link extended state
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-6-amitc@mellanox.com>
 <de5a37cd-df07-4912-6928-f1c3effba01b@gmail.com>
From:   Amit Cohen <amitc@mellanox.com>
Message-ID: <8096f9ba-4fa9-bbad-7501-6c8e3d4dd1ac@mellanox.com>
Date:   Mon, 8 Jun 2020 18:59:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <de5a37cd-df07-4912-6928-f1c3effba01b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0041.eurprd04.prod.outlook.com
 (2603:10a6:208:1::18) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.7] (87.68.150.248) by AM0PR04CA0041.eurprd04.prod.outlook.com (2603:10a6:208:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Mon, 8 Jun 2020 15:59:35 +0000
X-Originating-IP: [87.68.150.248]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a538ecbd-fa05-45d9-9b64-08d80bc4f1f8
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB397159DDBE7D4F3F325AAC93D7850@AM0PR0502MB3971.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 042857DBB5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /HaknT/j6xMnTkjAbES4WVmkXP9ZaOWKdNph4ofH0oH5R7y0yVkCy5Je3XSOivkbXY2WAuahSuvkTeKwb8BpY9BR+YPrWkREQVY2eohXi3oQjFx2oRKv+NJPRfP7Jd3KBIKDB/ykjXHi5dsbi2G0oGLPwDP01GMVUzUAn1esl0rCgpQKoeoMCMwnSmE1WiIc7HiyJwRW8eofESHHvrffE5xBuiPsuzoMdcsNrlAjPfaF6pHTQ4Ypiint8SJGshg8Wh9cYubxwFBPus+jopVoXzTkwMHxGXt//9VA1Y8mxTkK1Vsba/Avl9mEAikLpjfl3dw2Gz2NmnlNCDdghSLVNlREaDQh1Rg+EIDTty4iZe+NiWdjvo5ZCOIyAhRBoLrp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(16576012)(316002)(5660300002)(66556008)(6666004)(31696002)(66946007)(2616005)(956004)(53546011)(2906002)(36756003)(6486002)(66476007)(52116002)(8936002)(7416002)(8676002)(4326008)(186003)(26005)(16526019)(478600001)(83380400001)(86362001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Mv7r3ut4qEn+WMnlppE57VWNZxXlo/baRItxIkZnZrzPhpjgxt2X5JcfeDpfYO0aRCPSzISZ1Mw3q0vgXvcLH7jjQqNNwMimk5LXYJPIQbBO58pPyw/9G7saoWwg1KN3ncN0VfRcGN14wEkzjvg/i9gUXdRK+QrsMAiunVvMpQMycto+5UIFTZWDB0IDeoZMYUVWflc3upGBZsgW3kG1BAOKCilGuOMYIwKS/4y+YS0L4hSumLpIVbr6NSR59xvGZuUofwHSGGz4TKoKYOfipAY2D12abZ1ENjLsNbfrx+eM41gmRQi1SHp0EP3QCphq/AHyVyZEsrkyuG9HSheK3Arxzz7jx94jRgomxSk+SoA8S/Laq6yCQQHjRSJ21tIXn7PbEe1i4hRhUnM7oXACvK01vilRh9+fFSeROrBZrx4NTUzWfS17m5DnTIhcFmjb+uQDuFp2yON+fbAe9r6laYRixlMc4+FL+7C0eyHp06I=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a538ecbd-fa05-45d9-9b64-08d80bc4f1f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2020 15:59:37.7680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YcSiqs4GwZ9CJUNr8eTPxrm95RUxd4s91+m+h/ERtZzPxhdktEz2jzLDBbE0hpU6nqtn721mWuxSQ5HcMEOFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3971
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-Jun-20 22:11, Florian Fainelli wrote:
> 
> 
> On 6/7/2020 7:59 AM, Amit Cohen wrote:
>> Add link extended state attributes.
>>
>> Signed-off-by: Amit Cohen <amitc@mellanox.com>
>> Reviewed-by: Petr Machata <petrm@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 
> If you need to resubmit, I would swap the order of patches #4 and #5
> such that the documentation comes first.
> 
> [snip]

ok

> 
>>  
>> +Link extended states:
>> +
>> +  ============================    =============================================
>> +  ``Autoneg failure``             Failure during auto negotiation mechanism
>> +
>> +  ``Link training failure``       Failure during link training
>> +
>> +  ``Link logical mismatch``       Logical mismatch in physical coding sublayer
>> +                                  or forward error correction sublayer
>> +
>> +  ``Bad signal integrity``        Signal integrity issues
>> +
>> +  ``No cable``                    No cable connected
>> +
>> +  ``Cable issue``                 Failure is related to cable,
>> +                                  e.g., unsupported cable
>> +
>> +  ``EEPROM issue``                Failure is related to EEPROM, e.g., failure
>> +                                  during reading or parsing the data
>> +
>> +  ``Calibration failure``         Failure during calibration algorithm
>> +
>> +  ``Power budget exceeded``       The hardware is not able to provide the
>> +                                  power required from cable or module
>> +
>> +  ``Overheat``                    The module is overheated
>> +  ============================    =============================================
>> +
>> +Many of the substates are obvious, or terms that someone working in the
>> +particular area will be familiar with. The following table summarizes some
>> +that are not:
> 
> Not sure this comment is helping that much, how about documenting each
> of the sub-states currently defined, even if this is just paraphrasing
> their own name? Being able to quickly go to the documentation rather
> than looking at the header is appreciable.
> 
> Thank you!

np, I'll add.
> 
>> +
>> +Link extended substates:
>> +
>> +  ============================    =============================================
>> +  ``Unsupported rate``            The system attempted to operate the cable at
>> +                                  a rate that is not formally supported, which
>> +                                  led to signal integrity issues
> 
> Do you have examples? Would you consider a 4-pair copper cable for
> Gigabit that has a damaged pair and would downshift somehow fall in that
> category?
> 

For example, this statement might appear when an 100G OPTICs (not copper) which is used in 40G rate and sees high BER (when using Parallel Detect).
In this situation we recommend to  see the other end configuration and understand why it is configured to lower speed.

Regarding your example, if it stays on the same speed and have high BER you should expect a different BAD SI statement.

