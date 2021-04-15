Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CEF361290
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhDOSy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:54:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38488 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbhDOSyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:54:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FIZWhS100648;
        Thu, 15 Apr 2021 18:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=8Gqf0/evVWDhoGVwD8p8GrYtW57UPXn+DQqxzcdkQ6Y=;
 b=zZG/b3oYRBj7NdXGSubwptjseTxFQ9n56JOKo36RIsWGLRs3Rm0qJBdW1z2WB1LUoLga
 iGd9icHrEcOio4CBq0NU+k6oxZV3YHNYA0dWmtsbgU58282kn4PxNuJ8bMR8RsJvp7oe
 oKk75Dghh17HTTLhm9LEehh+dNplc7FHEXZYdMMqiP5koYCBUunctdUZ9W9fSR4EJn8W
 BgUZk+W4YOG8NugJp0QkafEW02JTJO4lrvx/6mRrF0lnoiRiRkjRmjw4EZVIypMbLRmx
 3ukmf6uG3DFFkzm5n5G2tsyHnEwNqIdozPL5ePu1aGvOYMoDHFMaLyIVVwarB9CtBXRR zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hbq20b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 18:53:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FIac4F115252;
        Thu, 15 Apr 2021 18:53:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 37unkt22ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 18:53:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inWWlAKHUbgODtMwIZuYWV5xdeaexzFP8ZidZmrxR3OuTKw+FcWVWpnB/vikxOpBvWzd71FiHcSn5i6t7CC9Dy/AyO2l2P87gUD6gXK2v0df8rE+cyhkBr+EAqASE/AUBfcnc/kvcgbuhSq3gCiwOz0soZ9Gz6+0ko9+vpHc3NFig74JhJtuqJ8kZlByxlwhpYrcYo4H0GNhmoA1pjOtC/0y3YyVcLXcbG1/XH5iCHktZlqOfkvZGg5TpKWnUpQ6Bxkb4D3DFu1tDRU1N2moQ0U90xpeI6lBg1g1hByatAWuxmoRhVjf1Xt8s7xO5poPdjAAVyklLbQ41keKPXh6sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Gqf0/evVWDhoGVwD8p8GrYtW57UPXn+DQqxzcdkQ6Y=;
 b=nxuXqB6V9Q0xCdxTysAqNdpOD0VqNtoktFWyv3ItD0yAm93OloLv6KUo50EEBlwzw88Pyu0UCb4/iIK7OksN+G6u6kJOKCSUK6ILn3J4MIusm2NMzko3mIs5AVZ2rjFakfOubl2upsoJ2KBXRyuuz2F+kBOeWjHwcs4Put0Nk46pCjNxX2trbu2MABGvfJwNadVvTuz47H1AqIq8cjkF1nO/KByDvWUqnWT3eIWMfiItf1xBvv2vhECRz5V5LrQCRNXTEiVh3liWUfWT1xqCpd/VlTKvOG8DvbVl5VqXE1IAviDVIX7h/zbZB9mQioWh87q8C4fyETskCY1IzUHcYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Gqf0/evVWDhoGVwD8p8GrYtW57UPXn+DQqxzcdkQ6Y=;
 b=H517ixnZoLooQk1ky9WVsmyiH7Da+ppJ55aMeBKozjDLHKEXGaSMKhxF4dXmVQ+0ylWDH3YjBbGjDP8dwAdjfPYzsKdMFmlvzDSp+NHKjLPbsCT74dKQoQJ3ZxPT4s4CQuVQ+myv8hsc5FQDm8P0C2j9gO+4bK2XXvYVOWoGE/g=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BYAPR10MB2998.namprd10.prod.outlook.com (2603:10b6:a03:84::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 15 Apr
 2021 18:53:10 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::50f2:e203:1cc5:d4f7%7]) with mapi id 15.20.4020.022; Thu, 15 Apr 2021
 18:53:10 +0000
Date:   Thu, 15 Apr 2021 14:52:58 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 06/12] HV/Vmbus: Add SNP support for VMbus
 channel initiate message
Message-ID: <YHiLiqpTEYbWjbSb@dhcp-10-154-102-149.vpn.oracle.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-7-ltykernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-7-ltykernel@gmail.com>
X-Originating-IP: [138.3.200.21]
X-ClientProxiedBy: SN2PR01CA0039.prod.exchangelabs.com (2603:10b6:804:2::49)
 To BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-154-102-149.vpn.oracle.com (138.3.200.21) by SN2PR01CA0039.prod.exchangelabs.com (2603:10b6:804:2::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 18:53:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ac03ad5-5f2d-4718-e756-08d9003fb68e
X-MS-TrafficTypeDiagnostic: BYAPR10MB2998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB29983A9C3F2EAE8A6F757A35894D9@BYAPR10MB2998.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJhKT3Gv9SbIGXihhMAbUFUNbalx3YVYZBgNsvu1g7tUy9ohIFnbXzskxw7mZYdoX/G5BtgVFY7hMMo6Q04tO6uKOLJqnt3rO+4ht29lobJMr4Eo5174JmCScCbKWomnQUUd7qs1ND1zLhpSvScuR//0HQvrW3mL27C3oBxyRjHappjXFPYjkD0eqcx7puYLO7+ghTa/5jo649Yu4gEcpRM/a43q+f8vKKJugyUP1qGWvESivCM2Iy0OTrUKEcsvL7HNwHE4PJDq1eQH/esf1ewum1Ks+DZx4YM5TICbx61V/qgOneiQkEzDoGHGJ8nBAh+yACYJXWW3Di0UHwhsHa6vUq2+lhKCD2FkBqj8FLCZY4KG0NMR5i7dEcNpc6W5Xhb4whTtORiWnUIDYsXhhS8sZ8hZkA5QzIEaDR2Z1XhBdUo+xp2nKL4eyMu0XLNLf9Pg0nk4uO0I1B3RuiNHXrSfH/Z2CcUtVDOXRNdEN/CTBsvB2lUvRM5hi+nCu7usE1YlXLHHveZzAQJiL5xl5u3vIO040B7NubVOCjI7JTf+WmiLwX30fU3dpf56MHEgoAh0TE6UFuT9uSgz1MRlOtqo1AIV3ZnT4F903xRDb8YCL3aLscyy8GnscfubVW+Z583pEZq5Jkk+cavcUBGOSdm4yVcQxfj0WIciDfLdfy8vYBFNibSI9aTCBwcZLahr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(376002)(366004)(136003)(186003)(16526019)(26005)(5660300002)(86362001)(6666004)(55016002)(4326008)(45080400002)(38350700002)(38100700002)(478600001)(8676002)(83380400001)(956004)(8936002)(316002)(6916009)(66556008)(15650500001)(2906002)(66476007)(7406005)(7416002)(7696005)(52116002)(66946007)(102196002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bl6uEZEIHPgzXa1fFka4oJOCAjXHc1hBl/ic2GPosPol7D2mL4hDEmvTkJ1p?=
 =?us-ascii?Q?w7TJ2eJKJmdrlDGpYRseZ5sM7M98LRaNxzsum0KJnnbBMyPwQzJQKkS88YDB?=
 =?us-ascii?Q?ecZQFrsiegOYvEWEvpDS2ugViWk1MiQ+G8p1GOLoS9lOMSAsBPh1LWrnriNJ?=
 =?us-ascii?Q?vSs5Xslne90dty2fMEiYpXE6t45TxeaPL6pDnHPAp5G19gVUPI4QfJYlB1BG?=
 =?us-ascii?Q?R8I/LxTmg6dqF0RBoOWEA8+50MIF5txRfRgpdQ3vnpqTmfdO9a64JdUgBYfR?=
 =?us-ascii?Q?oiTLPtK6eoU41PIzNMyNESimhs5g314itYrjduONHK90NeaJUsm6LJDA9oL6?=
 =?us-ascii?Q?PFyBk//KOwdr6ZWWn3Fa4OHe2X9WBYmqTgQfmWThucIbv379efSf1pQL7i6e?=
 =?us-ascii?Q?o5km5NyujT9qlT+6FmDfFIjBJ0SuvikAdsZ0Nakl2WMownI4C1d+Dl+qSK1G?=
 =?us-ascii?Q?WZ3A0BIkJLQVUjK1d3oqXK4bAPT1lNOotYpTBNh7Keudd+prNaEOzsmQbyXe?=
 =?us-ascii?Q?gz/C5giG5JwRMa/6DxkO9f6eoB8uisD4mfgvtAKQQwi/x926dp8Mi8XLIzJF?=
 =?us-ascii?Q?IFz4OCY7pHg2/bPawj6xasjuj+crAE5fQLhjBe9WuiyHr/fgef2eEYzEVaGp?=
 =?us-ascii?Q?ZzqEpxptMjnYY6vYEElC3fQYb2cx2OHvb4QnePoWuOD5KXFYVThsT1Yx6tOC?=
 =?us-ascii?Q?X1iYNnlaZ5JeQEYIAjRiuamvrA7IsM18IeDEgItnzFrggFYXg0t4I7qxBDoL?=
 =?us-ascii?Q?oCGJDGluBavfSljA2iR//jEs4njcla0HBMuQ4wE48OqTcnKx3rvQFMDUCf38?=
 =?us-ascii?Q?p/Uhw7yyuuDPFzP9Pm+ZiahePj9Bw5f45Uv79p6rKUc+sjD/DWEB65gMoSOe?=
 =?us-ascii?Q?uB6OQSivi4qDFxpRiICYvlO1gd0Z7o13JvzIwj/9GA8HemBvdaAFzNLKNQwh?=
 =?us-ascii?Q?e01tLS1QzTmEMLC+a/yl6Q6FmhSw3VDJruXFKFO1x5N740A/bO1ZeooPyPbl?=
 =?us-ascii?Q?k24fU4fZNTDxGzEFRC2aZ/z2oyqPgtNMWFuOQh70oF6qeqXlzty2vs02SomR?=
 =?us-ascii?Q?MQ8++io2bgcc8Hwk8bNvaV94lYBZFTa27QPBWRNR9tMd7nWVbNChwpYn7K7L?=
 =?us-ascii?Q?Y4BhOgp4rK7WwpH/VQ2+GpbJJ+RGCc4nTS2Y0CPfxf6snX9raJ7fvhr6pokt?=
 =?us-ascii?Q?t6JEoiOAOiDbDT68RA5OjbMvf5dsIKXRlVkXEuCmwzJSkLxWoyDAbjos53ps?=
 =?us-ascii?Q?U7STvylsdzJ4YzS+PwVxcWjz2WyFkoRaBzTVt7+R0Xc1PpXdl9He8KBf5sfG?=
 =?us-ascii?Q?qNDqZwfABy2PWAqp5OQ29kmy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac03ad5-5f2d-4718-e756-08d9003fb68e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 18:53:09.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHr5/W5UnjOVXfAWin+Hry1ldmgQRWgYv1rJ+zaLL6v/ed4jX2XIz/EjtBHf/+zezXFKJ34OCelWkjPUVVaFzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2998
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150115
X-Proofpoint-GUID: OXRS-NEE6sUlbgy-yRHyCoVS_cUwPv-B
X-Proofpoint-ORIG-GUID: OXRS-NEE6sUlbgy-yRHyCoVS_cUwPv-B
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:49:39AM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> The physical address of monitor pages in the CHANNELMSG_INITIATE_CONTACT
> msg should be in the extra address space for SNP support and these

What is this 'extra address space'? Is that just normal virtual address
space of the Linux kernel?

> pages also should be accessed via the extra address space inside Linux
> guest and remap the extra address by ioremap function.

OK, why do you need to use ioremap on them? Why not use vmap for
example? What is it that makes ioremap the right candidate?





> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>  drivers/hv/connection.c   | 62 +++++++++++++++++++++++++++++++++++++++
>  drivers/hv/hyperv_vmbus.h |  1 +
>  2 files changed, 63 insertions(+)
> 
> diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
> index 79bca653dce9..a0be9c11d737 100644
> --- a/drivers/hv/connection.c
> +++ b/drivers/hv/connection.c
> @@ -101,6 +101,12 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
>  
>  	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
>  	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
> +
> +	if (hv_isolation_type_snp()) {
> +		msg->monitor_page1 += ms_hyperv.shared_gpa_boundary;
> +		msg->monitor_page2 += ms_hyperv.shared_gpa_boundary;
> +	}
> +
>  	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
>  
>  	/*
> @@ -145,6 +151,29 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
>  		return -ECONNREFUSED;
>  	}
>  
> +	if (hv_isolation_type_snp()) {
> +		vmbus_connection.monitor_pages_va[0]
> +			= vmbus_connection.monitor_pages[0];
> +		vmbus_connection.monitor_pages[0]
> +			= ioremap_cache(msg->monitor_page1, HV_HYP_PAGE_SIZE);
> +		if (!vmbus_connection.monitor_pages[0])
> +			return -ENOMEM;
> +
> +		vmbus_connection.monitor_pages_va[1]
> +			= vmbus_connection.monitor_pages[1];
> +		vmbus_connection.monitor_pages[1]
> +			= ioremap_cache(msg->monitor_page2, HV_HYP_PAGE_SIZE);
> +		if (!vmbus_connection.monitor_pages[1]) {
> +			vunmap(vmbus_connection.monitor_pages[0]);
> +			return -ENOMEM;
> +		}
> +
> +		memset(vmbus_connection.monitor_pages[0], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +		memset(vmbus_connection.monitor_pages[1], 0x00,
> +		       HV_HYP_PAGE_SIZE);
> +	}
> +
>  	return ret;
>  }
>  
> @@ -156,6 +185,7 @@ int vmbus_connect(void)
>  	struct vmbus_channel_msginfo *msginfo = NULL;
>  	int i, ret = 0;
>  	__u32 version;
> +	u64 pfn[2];
>  
>  	/* Initialize the vmbus connection */
>  	vmbus_connection.conn_state = CONNECTING;
> @@ -213,6 +243,16 @@ int vmbus_connect(void)
>  		goto cleanup;
>  	}
>  
> +	if (hv_isolation_type_snp()) {
> +		pfn[0] = virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
> +		pfn[1] = virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
> +		if (hv_mark_gpa_visibility(2, pfn,
> +				VMBUS_PAGE_VISIBLE_READ_WRITE)) {
> +			ret = -EFAULT;
> +			goto cleanup;
> +		}
> +	}
> +
>  	msginfo = kzalloc(sizeof(*msginfo) +
>  			  sizeof(struct vmbus_channel_initiate_contact),
>  			  GFP_KERNEL);
> @@ -279,6 +319,8 @@ int vmbus_connect(void)
>  
>  void vmbus_disconnect(void)
>  {
> +	u64 pfn[2];
> +
>  	/*
>  	 * First send the unload request to the host.
>  	 */
> @@ -298,6 +340,26 @@ void vmbus_disconnect(void)
>  		vmbus_connection.int_page = NULL;
>  	}
>  
> +	if (hv_isolation_type_snp()) {
> +		if (vmbus_connection.monitor_pages_va[0]) {
> +			vunmap(vmbus_connection.monitor_pages[0]);
> +			vmbus_connection.monitor_pages[0]
> +				= vmbus_connection.monitor_pages_va[0];
> +			vmbus_connection.monitor_pages_va[0] = NULL;
> +		}
> +
> +		if (vmbus_connection.monitor_pages_va[1]) {
> +			vunmap(vmbus_connection.monitor_pages[1]);
> +			vmbus_connection.monitor_pages[1]
> +				= vmbus_connection.monitor_pages_va[1];
> +			vmbus_connection.monitor_pages_va[1] = NULL;
> +		}
> +
> +		pfn[0] = virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
> +		pfn[1] = virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
> +		hv_mark_gpa_visibility(2, pfn, VMBUS_PAGE_NOT_VISIBLE);
> +	}
> +
>  	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
>  	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
>  	vmbus_connection.monitor_pages[0] = NULL;
> diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
> index 9416e09ebd58..0778add21a9c 100644
> --- a/drivers/hv/hyperv_vmbus.h
> +++ b/drivers/hv/hyperv_vmbus.h
> @@ -240,6 +240,7 @@ struct vmbus_connection {
>  	 * is child->parent notification
>  	 */
>  	struct hv_monitor_page *monitor_pages[2];
> +	void *monitor_pages_va[2];
>  	struct list_head chn_msg_list;
>  	spinlock_t channelmsg_lock;
>  
> -- 
> 2.25.1
> 
