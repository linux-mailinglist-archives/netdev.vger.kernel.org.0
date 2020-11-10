Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA5C2ADD04
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbgKJRgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:36:03 -0500
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:39204
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726467AbgKJRgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 12:36:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpqHvsBopzVtDOUsn6h6JTGFoFbKlUBdMXVXRI+7HviQqvgNqfvJi4xbE9w/UDN85p+tZa9BYTOvuU2c5q9FQZFcggWfGO/EBF5/+/Me7efsXguaWVBNcYm9JMxUaMDRvdh6YTgRpPHLDuMZd8DOWGQSNw75fU/vYkPxE7ah9vQ1xSh3l+vfHJFNquiDGG484d6oiYs7HLpcQd8ibMCfAGL5wcASO5Yw4NVgAUXUjRi2ZqncBJqfwRRqjQ+i5CV3VZVDB7QTWbp1Ma59RpdgLpd1qXCHHssPr6ikEyGkh60H8z2QlGsre9QF43m5+zTX6EKJ6v1iTGks7gCPVkgnyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+Sm9CkDhCo+hRn/H0UmlvgzcLb2YxeZM7EY3c21Ms8=;
 b=iFS0h9Gp2g/rfbhM5c3iu3ycgNDg9eE9WY4VcfHzCuaX72tERC4a1PYvOJQqtnl3DeJLti4ow0X+bnGMlXZ2WxHsZhDADtt/AqZCUm4EIYTarq8605gzUWUj8Uw05HoOZgGEWmim9gxynK5zjPOEm3EYmfHyLZceRgWpjxRQMY76nxSWLH1DdJoKVS1fGNXN1Xoo5nxL8Cw/Bp+V3aeJ/5iMJAHX612MrEFg0U6JKjcmCu523ZXMFeAwKk6vwhAk6GMQyZVjBP+XF76FeGjskq+QrLORMddXbH4idTNF0LOtg4VWikYPNZM7nohwqOqcdnnc4f5wTgD/Etko/BNoPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+Sm9CkDhCo+hRn/H0UmlvgzcLb2YxeZM7EY3c21Ms8=;
 b=ODDwNj4CbV89y/aiIsDgDpI4AOMxrs2Vbbgk7hx0nlL6RP/dc1yZXb0iNiN0pJ1V9QcuNPaOF0AOXD3ATtRLQikrphI3w1NKkgsKRhUfCWhF89Ew6U7ROyCOrej91iRPNGVZeTLmGNpxu2c2mc6Nrp3WrM8NEuHtWhyvyEY/Mls=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB4237.eurprd04.prod.outlook.com (2603:10a6:803:3e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Tue, 10 Nov
 2020 17:35:58 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3%2]) with mapi id 15.20.3541.021; Tue, 10 Nov 2020
 17:35:58 +0000
Subject: Re: [PATCH v2 2/2] dt-bindings: misc: convert fsl, qoriq-mc from txt
 to YAML
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Yang-Leo Li <leoyang.li@nxp.com>,
        David Miller <davem@davemloft.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>
References: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
 <20201109104635.21116-2-laurentiu.tudor@nxp.com>
 <20201109221123.GA1846668@bogus>
 <CAL_JsqJ2Ew6GdQmE0gcTgFX9cMZKtkL_rO1F+0EMNy88wF+gXw@mail.gmail.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <d089fa69-2a64-d182-16dd-5807f7834164@nxp.com>
Date:   Tue, 10 Nov 2020 19:35:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
In-Reply-To: <CAL_JsqJ2Ew6GdQmE0gcTgFX9cMZKtkL_rO1F+0EMNy88wF+gXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.123.58.209]
X-ClientProxiedBy: AM9P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::7) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.108] (86.123.58.209) by AM9P195CA0002.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 17:35:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 843a7d26-e6f6-4aab-dc29-08d8859f1575
X-MS-TrafficTypeDiagnostic: VI1PR04MB4237:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4237C89C509A33E22E8F7438ECE90@VI1PR04MB4237.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gKKl4DnFluGH1ZbYLiFAxLtuqHoPFU0UjN9arcG662p6KhDZu+cf3N11J9VI2kSacXWcEuwzIYlCY7IMsbax/W+kk1ESbjTA/F83bio9EhEmVPgS8Z+BWWG9CzYtl0Ru4hONoDymdeyJMuqYmlgVdRm+vt0C+5RzRqo9p4C+aP3uQE1v03rEhS3mZIcUfoag9nszurR8/dRAkephVmKjL36xJIRtO6F6AFiLKjX9vg0FC6cRmzD3d+5wKOrJ1hOC1cp+voMcD3Oq+GOYKlcTlriBC9/229pmBJ8yxwPe7ole8LI9nc6jsk8sXqSI4J6i2Q3Ybxz1P8mVKsA1Gpuij8APmj6CusllEJkTUCa2Mv7TWgA5LAGgg17VpHLfp0T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(66556008)(2616005)(6486002)(66476007)(956004)(8936002)(44832011)(83380400001)(2906002)(52116002)(26005)(86362001)(316002)(54906003)(16576012)(66946007)(8676002)(31686004)(53546011)(4326008)(186003)(5660300002)(31696002)(7416002)(478600001)(16526019)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bkpEUWc57qJ4O2Us+4XygfqOROhmSnq1ZXeJDjygeVPoh5hSHJNq98KHxxiraobT1MDAoXPqx7an0ezFz6SqRx73ys3IfRWeQSuphiN0PtBiBjzC0OFEpHHDfoguCJ6391p+N6+/TDxzUo7MHVqKi4TEGevzIIWTIROj0AE+sP3FLxb3osGk7dQH5P0vbsTELW6WizemWjtZU23udeDg/WaqiMdFEBeYFmKacGR22T8y/MEClHxjGXk8QZoOPqF8HYAfxvtQ1+oT5vT0PXJcfkyJUoG6EUHDDiNq2Av1WMUd9wnRkNIeFo+EwB/dtVYDUGjpR0Jnd6gQ0aTPyMHkrkOy4imd3PKqc5PQd9Hy2Y/ld2Bxwq891FFXGfjrlZJyDuHCaPWtdNioRwbWgTIKtkInSVObQOmDZWwnoL4evYhP7bTRkPvxMH16b/GU/hudSnaqkIt0mPumR0H0EmiCwEDw5Bpyb/mYshbEss+FzLFSt9uixTI8S7k4jWWWM8C379MMXtA7789UFozZX0n16X0b1dZJy6M02m5wr3ORrKwfFn9etFEes/ydWsGB4h+Vj1DCRcwkgsiENLErjR6a+DlwY7UlDfN/R7gRV0380ktpDYEBtjVwV2oGN3jV6XS0+Uk25cGqN2DIgcq6H1x1Tg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843a7d26-e6f6-4aab-dc29-08d8859f1575
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 17:35:58.0564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgLpO5xxfCojdQrCfMPNBuT8jpxfKd0TqMP8wAkrvuv7jmPQE1vnDk8dpnzyMHBIiqEl5euEnSrschCkBkrKXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4237
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2020 7:20 PM, Rob Herring wrote:
> On Mon, Nov 9, 2020 at 4:11 PM Rob Herring <robh@kernel.org> wrote:
>>
>> On Mon, 09 Nov 2020 12:46:35 +0200, Laurentiu Tudor wrote:
>>> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
>>>
>>> Convert fsl,qoriq-mc to YAML in order to automate the verification
>>> process of dts files. In addition, update MAINTAINERS accordingly
>>> and, while at it, add some missing files.
>>>
>>> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
>>> [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
>>> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>>> ---
>>> Changes in v2:
>>>  - fixed errors reported by yamllint
>>>  - dropped multiple unnecessary quotes
>>>  - used schema instead of text in description
>>>  - added constraints on dpmac reg property
>>>
>>>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
>>>  .../bindings/misc/fsl,qoriq-mc.yaml           | 210 ++++++++++++++++++
>>>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>>>  MAINTAINERS                                   |   4 +-
>>>  4 files changed, 217 insertions(+), 198 deletions(-)
>>>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
>>>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
>>>
>>
>> Applied, thanks!
> 
> And now dropped. This duplicates what's in commit 0dbcd4991719
> ("dt-bindings: net: add the DPAA2 MAC DTS definition") and has
> warnings from it:
> 
> /builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.example.dt.yaml:
> dpmac@1: $nodename:0: 'dpmac@1' does not match '^ethernet(@.*)?$'
>  From schema: /builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
> 

My patch converts the .txt devicetree/bindings/misc/fsl,qoriq-mc.yaml
while the commit you mention creates
devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml, but at a first sight
there seems to be some duplication. Will sync internally with my
colleagues and return with a resolution. Thanks and sorry for the trouble.

---
Best Regards, Laurentiu
