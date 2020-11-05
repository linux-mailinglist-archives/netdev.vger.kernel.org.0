Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F06F2A8712
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgKET0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:26:18 -0500
Received: from mail-vi1eur05on2086.outbound.protection.outlook.com ([40.107.21.86]:48929
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726729AbgKET0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:26:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmtZBBBKtoB9brS8h3bJLwmfnLoSuTJBAHtAW+Tuhuvav7H47lvALEIAfau8qhxrYhBC+98PGpPex7JsptI9MZFs6tv0GWvi5vEm87KIBfoQJRvLkIa8QKDY3qIlRHmuASNV1X+N54L5CJ4CbRGUIfO8owwlRO74dL7KcODXpLIS/k+I/6dSekutHmbrYHAEz5t6OPGBjXzPeqVwz4tE5fXlEClG135K0KZZwt75mxtGCIPdVPsRIUWcOVMZUOd5Ev3WFiez9qzdMDnBpM8xLUiOcoZ+TN03xwKD/iQe96XQ1h43Fw2A+TdzY5eTBX9qxzfye7ylHr086uwJcxDRfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyRCiY5e3/7e12i+4Kc5sNUcdNdVjpzs6GbOeUd0qGM=;
 b=QeiTbthpwspBfUbOO2Ar2Oh/aY0ygUbCA4nde32Eu/lycevZ6JUuXQms0/y4K54tAGruB8humehantEDYeQstqc7gvkrOnkvxX3CI9XdZFMDdKoIMilt2YMcCkbGmNHMpfdKclPCfXQSmaTBQY0f5oXUbn01PMiVZ4EKD7QnYsH5p/TdGQgGNmKFexUar/hTubDG4qUmEv6jBpf/OUbo7zB9o3C8dt+maI0SQkRMUENtPvZdgs3CoaKtocYuMduHYLNuWfN+m12QjcdwQ+VRHz/UE3G3iLD2cfIpsE3Vx1s+ZlF2u6g7c0NT0Be0H9e3RikW1kpYuZ6iMazITarbPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyRCiY5e3/7e12i+4Kc5sNUcdNdVjpzs6GbOeUd0qGM=;
 b=ZMdGVlpVgU8ZXwc9UckMShw03OVmUf8JWKGrNy3ysHgid2sONBgdixL+uDxaLWVttIx3HlXCaOnGNJi45uM2Y39cKXTTEhdJXEu7wa0VQnQSyAgYSMZBCifFPuAzQbXGMnYKAtWxV9XswDMPfZM91BeERvRMHhPe7E3Qah6M5vk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB6142.eurprd04.prod.outlook.com (2603:10a6:803:fe::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 5 Nov
 2020 19:26:14 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3%2]) with mapi id 15.20.3541.021; Thu, 5 Nov 2020
 19:26:13 +0000
Subject: Re: [PATCH 2/2] dt-bindings: misc: convert fsl,qoriq-mc from txt to
 YAML
To:     Rob Herring <robh@kernel.org>
Cc:     leoyang.li@nxp.com, corbet@lwn.net,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, ioana.ciornei@nxp.com,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>
References: <20201105141114.18161-1-laurentiu.tudor@nxp.com>
 <20201105141114.18161-2-laurentiu.tudor@nxp.com>
 <20201105191745.GB1644330@bogus>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <07d9db34-d6bc-bce8-c1bd-cbf738af9547@nxp.com>
Date:   Thu, 5 Nov 2020 21:26:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201105191745.GB1644330@bogus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [82.78.235.173]
X-ClientProxiedBy: AM0PR06CA0125.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::30) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.105] (82.78.235.173) by AM0PR06CA0125.eurprd06.prod.outlook.com (2603:10a6:208:ab::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32 via Frontend Transport; Thu, 5 Nov 2020 19:26:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 836eb7cf-c28f-4b90-7f47-08d881c0a89a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB61424507609D5E31A9A17FE1ECEE0@VI1PR04MB6142.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C29dpjK2ZnlaPNAmPTTvVv2Agf9r4TD/2Irh2MbH/Ux72QFCd+Jcxa7W9Q3iY0w5K0bRasjHsOtraHVW8vwWd23synSunH8DuVNF3ycNLfN+1iK2NBu+jAPsBzyArx/jqYNgV5jbxNO26KLPIs+0U+/8rIDFjF0UM9Ma8dZ01+ZUWYFcNjYhXYUCow9BQ3mVpHiDGcGft3htPQrxJYFhsiu11JDjkEp1bDrzsVQkCc1BZ6//O0aXrvcFfxwGvrWrEdGkQI+bM5wbl6imILFS/6jehdp0Z2abCT2XEiUa4TUqdTzP/K1uB9PuXyX9kRkk0Ipv1xacPUuw0V+1Azctdv2GZCbiDAkI8nNPMEVb/kdCZUSW4Xd2NAndmjuSZY3AwpytNZ83xgJDY6a+3u2O20TXDGJpINY5d1NnRZj+duh/uZUDrwezku4Islk10bMj2z2iSpiV3c46bXlF4OlAnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(8676002)(31686004)(44832011)(7416002)(8936002)(36756003)(86362001)(6916009)(2906002)(956004)(26005)(52116002)(16576012)(6486002)(6666004)(4326008)(66556008)(66476007)(478600001)(45080400002)(31696002)(66946007)(966005)(16526019)(2616005)(53546011)(186003)(5660300002)(316002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: l6O90qDTCUTyH89OVVuLSvQ7ytyncwfGFFM2VHjVuMOq3+pvwVSyQhkdDso/iYMbc7DQDVflOHQVGx12wmBUl7lPwwtnQsv+oHLNQoYfJlMfl6M2dxgnSz8aOc5hY96sSy31BTG8KIvQWNzoqwTd2yUlzKH01+jwdmFjQUSD4FrcRLlMXNCphLYY+0aOEFrahzhUtqqjI/AD6p4jT9+YwEpJPsgPL9/inHo+MrQ0SxxAnk8/e/UgwPU28xNXbcXrFPQx9T1mOffbAWLwa3RMTATnqPDM+PfVqbwYsyHRCirya7Dh0rPkkPk3HVNdRMVIfxVytTePNxzGEjcxgP3QfvPuoFAa/GI1qCY4n0qI+JbIXO1vxStx+mjx51JtRgrnom/a1ceCPgg91nSbbFGhPjSIi+DcFkhN/ceVTIlJwqPZue6HV6cAzqX25S3atKQRzCVQmrBAIfTz8CaWTGyJfZzv7NSu4U1+GAKC2enHYIbFvI7IJeh5kaUaPSKSn7Hs631S0GcoP0p1fQ6e5YJSuWBaUM59Ud4maufXg2hqNhW8pf4WmVNebU+D2IVZ5tp/h/lcFXHgQnW3BoNeyjLV3Uyyd34YsQQw7r0uj5gRTB5mvaODb+1aeUVbUnL3cD5YudphdbtIQjxqx+sDauyw2w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836eb7cf-c28f-4b90-7f47-08d881c0a89a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 19:26:13.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oeFivD6B48wg/v9Wy1sN+aXp409i2qeSdixe7PhXrhtN3Y+ESvkrKAAwXTaf2x1FQiOiBVC9eeo/9xzKXmDhSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 11/5/2020 9:17 PM, Rob Herring wrote:
> On Thu, Nov 05, 2020 at 04:11:14PM +0200, Laurentiu Tudor wrote:
>> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
>>
>> Convert fsl,qoriq-mc to YAML in order to automate the verification
>> process of dts files. In addition, update MAINTAINERS accordingly
>> and, while at it, add some missing files.
>>
>> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
>> [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
>> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>> ---
>>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
>>  .../bindings/misc/fsl,qoriq-mc.yaml           | 218 ++++++++++++++++++
>>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>>  MAINTAINERS                                   |   4 +-
>>  4 files changed, 225 insertions(+), 198 deletions(-)
>>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
>>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> 
> [...]
> 
>> diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
>> new file mode 100644
>> index 000000000000..9e89fd8eb635
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
>> @@ -0,0 +1,218 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +# Copyright 2020 NXP
>> +%YAML 1.2
>> +---
>> +$id: https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fdevicetree.org%2Fschemas%2Fmisc%2Ffsl%2Cqoriq-mc.yaml%23&amp;data=04%7C01%7Claurentiu.tudor%40nxp.com%7C64a5aeb6fee5459041db08d881bf7bf2%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637402006701140599%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=fkXEIYUqXK1Dn6AqZtYLzro8nwJNCPJFI1Q9F9fRYxE%3D&amp;reserved=0
>> +$schema: https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23&amp;data=04%7C01%7Claurentiu.tudor%40nxp.com%7C64a5aeb6fee5459041db08d881bf7bf2%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637402006701140599%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=X7k0Sxh7uPo11GgkGCeaKKMzHdu0gtphKheyJeROZ9Q%3D&amp;reserved=0
>> +
>> +maintainers:
>> +  - Laurentiu Tudor <laurentiu.tudor@nxp.com>
>> +
>> +title: Freescale Management Complex
>> +
>> +description: |
>> +  The Freescale Management Complex (fsl-mc) is a hardware resource
>> +  manager that manages specialized hardware objects used in
>> +  network-oriented packet processing applications. After the fsl-mc
>> +  block is enabled, pools of hardware resources are available, such as
>> +  queues, buffer pools, I/O interfaces. These resources are building
>> +  blocks that can be used to create functional hardware objects/devices
>> +  such as network interfaces, crypto accelerator instances, L2 switches,
>> +  etc.
>> +
>> +  For an overview of the DPAA2 architecture and fsl-mc bus see:
>> +  Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
>> +
>> +  As described in the above overview, all DPAA2 objects in a DPRC share the
>> +  same hardware "isolation context" and a 10-bit value called an ICID
>> +  (isolation context id) is expressed by the hardware to identify
>> +  the requester.
>> +
>> +  The generic 'iommus' property is insufficient to describe the relationship
>> +  between ICIDs and IOMMUs, so an iommu-map property is used to define
>> +  the set of possible ICIDs under a root DPRC and how they map to
>> +  an IOMMU.
>> +
>> +  For generic IOMMU bindings, see:
>> +  Documentation/devicetree/bindings/iommu/iommu.txt.
>> +
>> +  For arm-smmu binding, see:
>> +  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
>> +
>> +  MC firmware binary images can be found here:
>> +  https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2FNXP%2Fqoriq-mc-binary&amp;data=04%7C01%7Claurentiu.tudor%40nxp.com%7C64a5aeb6fee5459041db08d881bf7bf2%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637402006701140599%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=QKyEydXdS2AzqS7BlXVXDXpdjHfGL1%2BEdx95F1j5OHM%3D&amp;reserved=0
>> +
>> +properties:
>> +  compatible:
>> +    const: "fsl,qoriq-mc"
> 
> Don't need quotes.
> 
>> +    description: "Must be 'fsl,qoriq-mc'. A Freescale Management Complex
> 
> Drop                ^^^^^^^^^^^^^^^^^^^^^^^^
> 
> The schema says that.
> 
>> +                compatible with this binding must have Block Revision
>> +                Registers BRR1 and BRR2 at offset 0x0BF8 and 0x0BFC in
>> +                the MC control register region."
>> +
>> +  reg:
>> +    description: "A standard property. Specifies one or two regions defining
> 
> Don't need quotes. You need '|' for a literal block to keep formatting.
> 
> But all this should be expressed as schema...
> 
>> +                the MC's registers:
>> +
>> +                - the first region is the command portal for the this machine
>> +                  and must always be present
>> +
>> +                - the second region is the MC control registers. This region
>> +                  may not be present in some scenarios, such as in the device
>> +                  tree presented to a virtual machine."
> 
> reg:
>   minItems: 1
>   items:
>     - description: the command portal for the this machine
>     - description: MC control registers. This region may not be present 
>         in some scenarios, such as in the device tree presented to a 
>         virtual machine.
> 
>> +
>> +  ranges:
>> +    description: "A standard property. Defines the mapping between the child
>> +                MC address space and the parent system address space.
>> +
>> +                The MC address space is defined by 3 components:
>> +                <region type> <offset hi> <offset lo>
>> +
>> +                Valid values for region type are:
>> +                  0x0 - MC portals
>> +                  0x1 - QBMAN portals"
>> +
>> +  '#address-cells':
>> +    const: 3
>> +
>> +  '#size-cells':
>> +    const: 1
>> +
>> +  dpmacs:
>> +    type: object
>> +    description: "The fsl-mc node may optionally have dpmac sub-nodes that
>> +                describe the relationship between the Ethernet MACs which belong
>> +                to the MC and the Ethernet PHYs on the system board.
>> +
>> +                The dpmac nodes must be under a node named 'dpmacs' which
>> +                contains the following properties:
>> +
>> +                - '#address-cells'
>> +                  const: 1
>> +                  description: Must be present if dpmac sub-nodes are defined
>> +                              and must have a value of 1.
>> +
>> +                - '#size-cells'
>> +                  const: 0
>> +                  description: Must be present if dpmac sub-nodes are defined
>> +                              and must have a value of 0."
> 
> Drop whatever description can be expressed in schemas.
> 
>> +
>> +    properties:
>> +      '#address-cells':
>> +        const: 1
>> +
>> +      '#size-cells':
>> +        const: 0
>> +
>> +    patternProperties:
>> +      "^dpmac@[0-9a-f]+$":
>> +        type: object
>> +
>> +        description: "dpmac sub-node that describes the relationship between the
>> +                    Ethernet MACs which belong to the MC and the Ethernet PHYs
>> +                    on the system board."
>> +
>> +        properties:
>> +          compatible:
>> +            const: "fsl,qoriq-mc-dpmac"
>> +
>> +          reg:
>> +            description: Specifies the id of the dpmac
> 
> Constraints on the value?
> 

Thanks a lot for taking a look. Will take care in the next spin.

PS. Nice work on the validation tools. My ~1 month old version didn't
catch those errors.

---
Best Regards, Laurentiu
