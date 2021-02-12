Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EE531A051
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBLOHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:07:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14490 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhBLOHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:07:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60268b7b0001>; Fri, 12 Feb 2021 06:06:51 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 14:06:45 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 14:06:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHEmR4IMSMXRZa45BtXaLW0x6itrG/MtHgXDg+lCr8rKWVqcGYHMTp586PQ9RSjI6jxU2/uTbtprHwBWRW/CtZ/yytPWtvDCB1mGl2kkwDnhJHPNU+3AV5DzHNaijouTGnD7/1zIKQIigX6nzB+WdNHb6KsIMH3E90IjfsghjPmZkltw67uRZwr5oNs8XdT7RiRkNoiPjoPopqRDEy3jMpduUGx9i44WuIBxDVB9kIRgdT9hjxxJpdc6Y0LRQEmGoj2uyYmsFmABfESHJjdYeErscEkB6nvSo2vWpeNtfDuoMoPm2cic872mumy7a4TZkVnyjjWCT0nxa6PNOX8rWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iuIbeQKc6ubOGNkSHhm77VsT8/QbxDHT61adHE0lDro=;
 b=DfKUUWKF4kV9D9p0vD/f5uL5qoW7/5rytuLVOvLKCs3IjMqA/QLeCoMdmu+Ubxi+Gl7jm64vNIG8g0c7onCV6qHUHwmeKI7rnmC27mMckqYNWCdn+JfseXf/aWeFmOO6jB6iW3TrPNvlV25WgjDM7N/aFYC3g2PY5ttIHTWkAId+W9s2fj7pEF8pyFx+qAAhIPMTghGyeMONVcJczbrYEWl6Fm7GFYIEJNIdvOqAIW9Q7H7PXAMXRHDgzUlpo8YIJztizWxv20ZnsgaD+yTYbRQ4DGaiRT4wylxqMaQ9A1O7RN0jjhFj7QxX2kzVlQeknevm6DvJmgTjk4qQ8pnM1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1849.namprd12.prod.outlook.com (2603:10b6:3:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 14:06:43 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 14:06:43 +0000
Subject: Re: [PATCH v4 net-next 21/21] Documentation: add TCP DDP offload
 documentation
To:     Boris Pismenny <borisp@mellanox.com>, <dsahern@gmail.com>,
        <kuba@kernel.org>, <davem@davemloft.net>, <saeedm@nvidia.com>,
        <hch@lst.de>, <sagi@grimberg.me>, <axboe@fb.com>,
        <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210212052031.18123-1-borisp@mellanox.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a18aaeec-049e-72c1-f981-3e18381b0f49@nvidia.com>
Date:   Fri, 12 Feb 2021 16:06:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210212052031.18123-1-borisp@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::13) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.151] (213.179.129.39) by ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26 via Frontend Transport; Fri, 12 Feb 2021 14:06:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d6bd300-e865-494e-38f9-08d8cf5f6cf3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1849:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1849AAC9A842BDA013ABD901DF8B9@DM5PR12MB1849.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4RRxEH30Cq9sutWwm2847NJGKYKQegE47xioQEnqVvn8K0w+hWVCJVnJVM+xNYKAO1CEx9lPG+FjT3BRhesNUNKZzblRjcPlWs1ahC+tPJJHIdS+MlTYxHgn62ZGDv4VCqVJT1ERIW8gkgUp48bhhEvFQXZ5ZWMvEe57kbX74odIJnElUzM5x2qsvg3H0n427uCEG53U2zJilQKFWElIfp5hYCOz70bHSVeFEW1/Kf+Xo6hNMu5+qpnC4GWv9cHBRU1gfH/EvXtH6kvciEt0LfO/GcrKAffIKnkNxYvGKANEA31xfmYtYPHCi0CZmrxalB+605q27INSOJJkelkh5/mcXHrpF++dA/oZrxzYaIzP1VbdgYD2MBKrbeEc7tv8XXyx2xSh+w8UAqmII1C4H50ZHbf5eGpteAP7PSqs5VgblkIlNQycQkJaaiTaK41g5hyMNKVFC0hHm9mlLdqcXqdnwJun3FxJIt90QmmuRGTWWEr9vxIn9Bpsx0D5fItEC1F/C3heBC3wKdEG0DAaYw3wH2SluGAvdW4LJGImdwXncAst8kdKBt6uvCpKewgZ+MfoGxiMYYjfwPv66/HFrPqAsFivDkyzC2ZAEd0mJz+AEO0rwVAd6eqGzGxHTgp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(186003)(107886003)(31686004)(26005)(921005)(53546011)(16526019)(6486002)(83380400001)(6666004)(956004)(2906002)(2616005)(7416002)(8676002)(478600001)(8936002)(66556008)(36756003)(66476007)(66946007)(54906003)(86362001)(16576012)(316002)(4326008)(31696002)(5660300002)(30864003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c0VlaVlFT0pZMTRIZFIxMXNzVHpPSlRrRlBLdEcrbTNvVzNWaC9iTndhWXVt?=
 =?utf-8?B?UVlVSmlYUGNuUitMUGxZRXdKanhIYmxYK2RCZklNazRiMHJ3SW1WaUwzUTFz?=
 =?utf-8?B?bDkrdmtiYWRZTEYwSThUMldjdGJUbGpibE9zMUNtcmFYWkdmdUpsTkR5bHFD?=
 =?utf-8?B?L2ZBQzBpNFIzVk9tRFpnQTQ1b1EyaFR5amZRVWZaQWhOYWxNTjVLUDh4TkJJ?=
 =?utf-8?B?OGFGVGNRd2J4UmhqdHhMOVhrZUxpamFPSy9ROGZHSHBVWnQxYmNNZDNkaGk1?=
 =?utf-8?B?SVdKcXRLNzE3bkgyOHJ5RlFiV243V0NBWUkwdFFYRWQ2dHlRNjhZNzBiMXBk?=
 =?utf-8?B?WjFEY0FkSGVMTnRSVUQ3NXRKOXVIYkk2dWRLdXpJM2lOOU9LTGZ5U2MrYkJU?=
 =?utf-8?B?dkVObmttM0tMSGQ3M25xNElBZjJlcEFncjR4eTNHVUN1dWJsZGFrdy92d1FD?=
 =?utf-8?B?TmZJQ0ZZY3gyZVVWclN6VFE5cTdzM2NXdFhVTzZ0djJoSHZ5bEJFVFk2WlBq?=
 =?utf-8?B?VnRxQXNKVWVuZ3lDTXlHOXh1U2d6V20xa1BjS2N5d1ZoSk9xMkhTajlLQWh6?=
 =?utf-8?B?VEdjTTRNcGtsYXN5cEJTWGgwV2lWQnZVMTRXMkV4bGlYWVVJQ3JEOUk2Nm5t?=
 =?utf-8?B?Z0RQcXNFR3luTkExTFFZcmdKN2FHUmw5NEJ0ZCtuMjZKZFNzb0o3WFpyLzBr?=
 =?utf-8?B?Q0s0SHdJSjB5YitEajRseEZBL05LdncvTnBBbXp6eEVGcGxtbWJnOEk3RnE4?=
 =?utf-8?B?VnlLeEhyNVNCRTRaWkxuWUM2Q1lxSytEYUY4ZkJNcFlieEQ0eCtwOWd4NGF0?=
 =?utf-8?B?TGg0WDVvSFg2UDNJdThUQ3d5V2g5QkJaNkd1cmxmenRxd3F5endOZ0dlWm1W?=
 =?utf-8?B?aGZ6TVNuOWpSR2xoMGVTRTRmbjAzN3ZDVXFnb2hnNzdieFh1QysxT2xkK2VI?=
 =?utf-8?B?VEJ6UnlpbENxdmxYU0dPeEJSUDFVc2wwcEdQTjR3ZU1YWGtBOW9pSzFLdHpD?=
 =?utf-8?B?WWUxY2hTWFlnR3JZa0xlL1QwbVYyOEtKcjVBMGQ3ankxV21IbGp0emI0RDBY?=
 =?utf-8?B?MDdnanJsRnJIQnJRVUpuN2t3clg5WHFLZGVUS1BpL2NpK0pBVUdIaGREbGZQ?=
 =?utf-8?B?SWlBeVAzYVNVaDFNYU9NVzRucjRzRzBxOVZvcXVidVFwUUtmam00K2JtNjFE?=
 =?utf-8?B?cTFadFhLWUV3bXdDTlpNSXEwTXRSTmt0ODhVV1pYUDRLY2h6OGZQeUNMNkts?=
 =?utf-8?B?U2dEZHh0MTVLbkJmQmROMnVuQ1VqdUFYL2VHdHBMc3JNV016OWpQS3lLVUV6?=
 =?utf-8?B?TmUvMHdXMm1RcDQ3enJINTB1S3I0ZmtZV3VmWVIxN0VXZkFyOUFrb1BVVWla?=
 =?utf-8?B?VWZobmxDbkFKaUxyME9aTUF0M01kR00yQlBkMlFucWJOdGNjK05SbEpzKzFv?=
 =?utf-8?B?dkJtR2g5b0tFVlB1K0JwTHhpMW5SaDc5OW5yQURocCsxRnpJb2NhWGFaQ2cy?=
 =?utf-8?B?YmNZRkRwSjVrT1pPamJuRXVsZW1HWUVKSVl6MFpZTmwvUWtGcFVmREdGWGdB?=
 =?utf-8?B?eno5ZG1nYkhzamNIUUQ5cnlOb09jWXg3eUN0NmF2Q05MYXFudHlLdVFmV3RE?=
 =?utf-8?B?TXFKWGhlcTR5YVJaQlJUUXRlNmRLd3dHZGxJNkNWdGJvb1g0M2tyRElmNnpB?=
 =?utf-8?B?a2ZET2pMV29uUFZUSm1HbjBMTnRySGc0MkZ1MFBrRkFaL2xSZG40ZGlXQjZv?=
 =?utf-8?Q?1oKbYVFe5+XNjLt2KtF7q6yiC0387LYYXGn0hGc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6bd300-e865-494e-38f9-08d8cf5f6cf3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 14:06:43.1976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rcapf/jrhAwiHB5cSfEfMpjcVLBN7pJ3vW0lPmnxlyNHAK7A5LPjzYdVcZoQ0UP7ZcHWg6j2iWvbO+S9NRdMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1849
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613138811; bh=iuIbeQKc6ubOGNkSHhm77VsT8/QbxDHT61adHE0lDro=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=NRov8eZJBarj7cUVKJZ71YpBm5lnM12qutoQgF7ArtmveToSsRUvTWjEsEveSPPzm
         XfR5qnmxznkPyLewxvWjrVzNhIRgeoZPfDLFtOOoKZf5LdXfoWvLBfgF0P2qq64+wh
         y1BPJCKhJ6yXDR1uvTyR6XGt6MYIjpEyBfRGdvZRpwV03iNhpkGSahNEWUVNQyUNAy
         qRzJto6Uoq7EZMssuO05VSIcuVyD0Qw5jdKXOs22JykX9pjcfATAnrczbeWTv4zKzN
         lp0lhqB9tQ9tk4CmIXc6ZA334nFYuhCRfjX4t2XoHr+t33PRrfI1z81hQEFXQSlbOo
         1jGF3m6S+BRqg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2021 07:20, Boris Pismenny wrote:
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> ---
>  Documentation/networking/index.rst           |   1 +
>  Documentation/networking/tcp-ddp-offload.rst | 296 +++++++++++++++++++
>  2 files changed, 297 insertions(+)
>  create mode 100644 Documentation/networking/tcp-ddp-offload.rst
> 

Hi Boris,
I got interested and read through the doc, there are a few typos below.

> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index b8a29997d433..99644159a0cc 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -99,6 +99,7 @@ Contents:
>     sysfs-tagging
>     tc-actions-env-rules
>     tcp-thin
> +   tcp-ddp-offload
>     team
>     timestamping
>     tipc
> diff --git a/Documentation/networking/tcp-ddp-offload.rst b/Documentation/networking/tcp-ddp-offload.rst
> new file mode 100644
> index 000000000000..109810e447bf
> --- /dev/null
> +++ b/Documentation/networking/tcp-ddp-offload.rst
> @@ -0,0 +1,296 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +=================================
> +TCP direct data placement offload
> +=================================
> +
> +Overview
> +========
> +
> +The Linux kernel TCP direct data placement (DDP) offload infrastructure
> +provides tagged request-response protocols, such as NVMe-TCP, the ability to
> +place response data directly in pre-registered buffers according to header
> +tags. DDP is particularly useful for data-intensive pipelined protocols whose
> +responses may be reordered.
> +
> +For example, in NVMe-TCP numerous read requests are sent together and each
> +request is tagged using the PDU header CID field. Receiving servers process
> +requests as fast as possible and sometimes responses for smaller requests
> +bypasses responses to larger requests, i.e., read 4KB bypasses read 1GB.
> +Thereafter, clients corrleate responses to requests using PDU header CID tags.

s/corrleate/correlate/

> +The processing of each response requires copying data from SKBs to read
> +request destination buffers; The offload avoids this copy. The offload is
> +oblivious to destination buffers which can reside either in userspace
> +(O_DIRECT) or in kernel pagecache.
> +
> +Request TCP byte-stream:
> +
> +.. parsed-literal::
> +
> + +---------------+-------+---------------+-------+---------------+-------+
> + | PDU hdr CID=1 | Req 1 | PDU hdr CID=2 | Req 2 | PDU hdr CID=3 | Req 3 |
> + +---------------+-------+---------------+-------+---------------+-------+
> +
> +Response TCP byte-stream:
> +
> +.. parsed-literal::
> +
> + +---------------+--------+---------------+--------+---------------+--------+
> + | PDU hdr CID=2 | Resp 2 | PDU hdr CID=3 | Resp 3 | PDU hdr CID=1 | Resp 1 |
> + +---------------+--------+---------------+--------+---------------+--------+
> +
> +Offloading requires no new SKB bits. Instead, the driver builds SKB page
> +fragments that point destination buffers. Consequently, SKBs represent the
> +original data on the wire, which enables *transparent* inter-operation with the
> +network stack.  To avoid copies between SKBs and destination buffers, the
> +layer-5 protocol (L5P) will check ``if (src == dst)`` for SKB page fragments,
> +success indicates that data is already placed there by NIC hardware and copy
> +should be skipped.
> +
> +Offloading does require NIC hardware to track L5P procotol framing, similarly

s/procotol/protocol/

> +to RX TLS offload (see documentation at
> +:ref:`Documentation/networking/tls-offload.rst <tls_offload>`).  NIC hardware
> +will parse PDU headers extract fields such as operation type, length, ,tag
> +identifier, etc. and offload only segments that correspond to tags registered
> +with the NIC, see the :ref:`buf_reg` section.
> +
> +Device configuration
> +====================
> +
> +During driver initialization the device sets the ``NETIF_F_HW_TCP_DDP`` and
> +feature and installs its
> +:c:type:`struct tcp_ddp_ops <tcp_ddp_ops>`
> +pointer in the :c:member:`tcp_ddp_ops` member of the
> +:c:type:`struct net_device <net_device>`.
> +
> +Later, after the L5P completes its handshake offload is installed on the socket.
> +If offload installation fails, then the connection is handled by software as if
> +offload was not attempted. Offload installation should configure
> +
> +To request offload for a socket `sk`, the L5P calls :c:member:`tcp_ddp_sk_add`:
> +
> +.. code-block:: c
> +
> + int (*tcp_ddp_sk_add)(struct net_device *netdev,
> +		      struct sock *sk,
> +		      struct tcp_ddp_config *config);
> +
> +The function return 0 for success. In case of failure, L5P software should
> +fallback to normal non-offloaded operation.  The `config` parameter indicates
> +the L5P type and any metadata relevant for that protocol. For example, in
> +NVMe-TCP the following config is used:
> +
> +.. code-block:: c
> +
> + /**
> +  * struct nvme_tcp_ddp_config - nvme tcp ddp configuration for an IO queue
> +  *
> +  * @pfv:        pdu version (e.g., NVME_TCP_PFV_1_0)
> +  * @cpda:       controller pdu data alignmend (dwords, 0's based)

s/alignmend/alignment/

> +  * @dgst:       digest types enabled.
> +  *              The netdev will offload crc if ddp_crc is supported.
> +  * @queue_size: number of nvme-tcp IO queue elements
> +  * @queue_id:   queue identifier
> +  * @cpu_io:     cpu core running the IO thread for this queue
> +  */
> + struct nvme_tcp_ddp_config {
> +	struct tcp_ddp_config   cfg;
> +
> +	u16			pfv;
> +	u8			cpda;
> +	u8			dgst;
> +	int			queue_size;
> +	int			queue_id;
> +	int			io_cpu;
> + };
> +
> +When offload is not needed anymore, e.g., the socket is being released, the L5P
> +calls :c:member:`tcp_ddp_sk_del` to release device contexts:
> +
> +.. code-block:: c
> +
> + void (*tcp_ddp_sk_del)(struct net_device *netdev,
> +		        struct sock *sk);
> +
> +Normal operation
> +================
> +
> +At the very least, the device maintains the following state for each connection:
> +
> + * 5-tuple
> + * expected TCP sequence number
> + * mapping between tags and corresponding buffers
> + * current offset within PDU, PDU length, current PDU tag
> +
> +NICs should not assume any correleation between PDUs and TCP packets.  Assuming

s/correleation/correlation/

> +that TCP packets arrive in-order, offload will place PDU payload directly
> +inside corresponding registered buffers. No packets are to be delayed by NIC
> +offload. If offload is not possible, than the packet is to be passed as-is to
> +software. To perform offload on incoming packets without buffering packets in
> +the NIC, the NIC stores some inter-packet state, such as partial PDU headers.
> +
> +RX data-path
> +------------
> +
> +After the device validates TCP checksums, it can perform DDP offload.  The
> +packet is steered to the DDP offload context according to the 5-tuple.
> +Thereafter, the expected TCP sequence number is checked against the packet's
> +TCP sequence number. If there's a match, then offload is performed: PDU payload
> +is DMA written to corresponding destination buffer according to the PDU header
> +tag.  The data should be DMAed only once, and the NIC receive ring will only
> +store the remaining TCP and PDU headers.
> +
> +We remark that a single TCP packet may have numerous PDUs embedded inside. NICs
> +can choose to offload one or more of these PDUs according to various
> +trade-offs. Possibly, offloading such small PDUs is of little value, and it is
> +better to leave it to software.
> +
> +Upon receiving a DDP offloaded packet, the driver reconstructs the original SKB
> +using page frags, while pointing to the destination buffers whenever possible.
> +This method enables seemless integration with the network stack, which can

s/seemless/seamless/

> +inspect and modify packet fields transperently to the offload.

s/transperently/transparently/

> +
> +.. _buf_reg:
> +
> +Destination buffer registration
> +-------------------------------
> +
> +To register the mapping betwteen tags and destination buffers for a socket

s/betwteen/between/

> +`sk`, the L5P calls :c:member:`tcp_ddp_setup` of :c:type:`struct tcp_ddp_ops
> +<tcp_ddp_ops>`:
> +
> +.. code-block:: c
> +
> + int (*tcp_ddp_setup)(struct net_device *netdev,
> +		     struct sock *sk,
> +		     struct tcp_ddp_io *io);
> +
> +
> +The `io` provides the buffer via scatter-gather list (`sg_table`) and
> +corresponding tag (`command_id`):
> +
> +.. code-block:: c
> + /**
> +  * struct tcp_ddp_io - tcp ddp configuration for an IO request.
> +  *
> +  * @command_id:  identifier on the wire associated with these buffers
> +  * @nents:       number of entries in the sg_table
> +  * @sg_table:    describing the buffers for this IO request
> +  * @first_sgl:   first SGL in sg_table
> +  */
> + struct tcp_ddp_io {
> +	u32			command_id;
> +	int			nents;
> +	struct sg_table		sg_table;
> +	struct scatterlist	first_sgl[SG_CHUNK_SIZE];
> + };
> +
> +After the buffers have been consumed by the L5P, to release the NIC mapping of
> +buffers the L5P calls :c:member:`tcp_ddp_teardown` of :c:type:`struct
> +tcp_ddp_ops <tcp_ddp_ops>`:
> +
> +.. code-block:: c
> +
> + int (*tcp_ddp_teardown)(struct net_device *netdev,
> +			struct sock *sk,
> +			struct tcp_ddp_io *io,
> +			void *ddp_ctx);
> +
> +`tcp_ddp_teardown` receives the same `io` context and an additional opaque
> +`ddp_ctx` that is used for asynchronous teardown, see the :ref:`async_release`
> +section.
> +
> +.. _async_release:
> +
> +Asynchronous teardown
> +---------------------
> +
> +To teardown the association between tags and buffers and allow tag reuse NIC HW
> +is called by the NIC driver during `tcp_ddp_teardown`. This operation may be
> +performed either synchronously or asynchronously. In asynchronous teardown,
> +`tcp_ddp_teardown` returns immediately without unmapping NIC HW buffers. Later,
> +when the unmapping completes by NIC HW, the NIC driver will call up to L5P
> +using :c:member:`ddp_teardown_done` of :c:type:`struct tcp_ddp_ulp_ops`:
> +
> +.. code-block:: c
> +
> + void (*ddp_teardown_done)(void *ddp_ctx);
> +
> +The `ddp_ctx` parameter passed in `ddp_teardown_done` is the same on provided
> +in `tcp_ddp_teardown` and it is used to carry some context about the buffers
> +and tags that are released.
> +
> +Resync handling
> +===============
> +
> +In presence of packet drops or network packet reordering, the device may lose
> +synchronization between the TCP stream and the L5P framing, and require a
> +resync with the kernel's TCP stack. When the device is out of sync, no offload
> +takes place, and packets are passed as-is to software. (resync is very similar
> +to TLS offload (see documentation at
> +:ref:`Documentation/networking/tls-offload.rst <tls_offload>`)
> +
> +If only packets with L5P data are lost or reordered, then resynchronization may
> +be avoided by NIC HW that keeps tracking PDU headers. If, however, PDU headers
> +are reordered, then resynchronization is necessary.
> +
> +To resynchronize hardware during traffic, we use a handshake between hardware
> +and software. The NIC HW searches for a sequence of bytes that identifies L5P
> +headers (i.e., magic pattern).  For example, in NVMe-TCP, the PDU operation
> +type can be used for this purpose.  Using the PDU header length field, the NIC
> +HW will continue to find and match magic patterns in subsequent PDU headers. If
> +the pattern is missing in an expected position, then searching for the pattern
> +starts anew.
> +
> +The NIC will not resume offload when the magic pattern is first identified.
> +Instead, it will request L5P software to confirm that indeed this is a PDU
> +header. To request confirmation the NIC driver calls up to L5P using
> +:c:member:`*resync_request` of :c:type:`struct tcp_ddp_ulp_ops`:
> +
> +.. code-block:: c
> +
> +  bool (*resync_request)(struct sock *sk, u32 seq, u32 flags);
> +
> +The `seq` field contains the TCP sequence of the last byte in the PDU header.
> +L5P software will respond to this request after observing the packet containing
> +TCP sequence `seq` in-order. If the PDU header is indeed there, then L5P
> +software calls the NIC driver using the :c:member:`tcp_ddp_resync` function of
> +the :c:type:`struct tcp_ddp_ops <tcp_ddp_ops>` inside the :c:type:`struct
> +net_device <net_device>` while passing the same `seq` to confirm it is a PDU
> +header.
> +
> +.. code-block:: c
> +
> + void (*tcp_ddp_resync)(struct net_device *netdev,
> +		       struct sock *sk, u32 seq);
> +
> +Statistics
> +==========
> +
> +Per L5P protocol, the following NIC driver must report statistics for the above
> +netdevice operations and packets processed by offload. For example, NVMe-TCP
> +offload reports:
> +
> + * ``rx_nvmeotcp_queue_init`` - number of NVMe-TCP offload contexts created.
> + * ``rx_nvmeotcp_queue_teardown`` - number of NVMe-TCP offload contexts
> +   destroyed.
> + * ``rx_nvmeotcp_ddp_setup`` - number of DDP buffers mapped.
> + * ``rx_nvmeotcp_ddp_setup_fail`` - number of DDP buffers mapping that failed.
> + * ``rx_nvmeotcp_ddp_teardown`` - number of DDP buffers unmapped.
> + * ``rx_nvmeotcp_drop`` - number of packets dropped in the driver due to fatal
> +   errors.
> + * ``rx_nvmeotcp_resync`` - number of packets with resync requests.
> + * ``rx_nvmeotcp_offload_packets`` - number of packets that used offload.
> + * ``rx_nvmeotcp_offload_bytes`` - number of bytes placed in DDP buffers.
> +
> +NIC requirements
> +================
> +
> +NIC hardware should meet the following requirements to provide this offload:
> +
> + * Offload must never buffer TCP packets.
> + * Offload must never modify TCP packet headers.
> + * Offload must never reorder TCP packets within a flow.
> + * Offload must never drop TCP packets.
> + * Offload must not depend on any TCP fields beyond the
> +   5-tuple and TCP sequence number.
> 

Cheers,
 Nik

