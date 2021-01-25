Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C980A304963
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732911AbhAZF2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:28:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17528 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbhAYSuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:50:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f12e60000>; Mon, 25 Jan 2021 10:50:14 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 18:50:09 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 18:50:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksX3jsVLnn/b7aPQIFBnr9ecG6NjtL8dDUA669bBee4PvhXj2U9wKQH2Ix6Pg59dkkcVSZdXIIT4X0g/6cLheIPlemqdvQojoE+Hx67qaKLk3IyBYtfVd7rr3/by89qCKglM2nkd66LL+ogkYpr4jV7p1WZ/HLjEW5RlWbghxUdv3GHVd1k6K9gD8n/NFTxqY8RIVCH4TG1OrkXT/5+sCtSIpKERBEg8VxTWZpDczgVKyt8XBV0qJjZexxfwExWW4nxTxkUrYnXgUhrmKof4DwvbyfRKKf+SfvG18hqNgBgzheYaVKoNiChKss8Fr3cRAneTljU04QrWJftMDlRenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpDoVR+N6+uNWW5oBGskQj2cK00K9NLiBGETUVgH0AA=;
 b=Qs3znFPh1PoX0m2lXYM30SjjeS1kpJny1j7iPwgrbe4axUWifCQcmbuOOQwphC/Rzxu2BQ+ECz01RtDnnD/aTvTnvzFNoBnO8JD+go+k4SsErbUn3i5NQ671pDI08ao7lanhFMhfBS8JWMk/kH9aKFex8lorDuHXc1KKOc1aiZwoHmGVSp/0TyA3u/teQlGwROi2BOUOMQ3Hj2Hx7QaNZgz+Sf4TLGMulGCzDl41c2BpSjqJEfrFrDih9hLoZnvavlnvEHK/NGEG290yisqzNWXN4uXRjl0YBgCCq+LRiSomy8AzLuf20vnzlaWi4MZu/DxISHuGI3B+JqKFEiedlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 18:50:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 18:50:08 +0000
Date:   Mon, 25 Jan 2021 14:50:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 21/22] RDMA/irdma: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20210125185007.GU4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-22-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-22-shiraz.saleem@intel.com>
X-ClientProxiedBy: MN2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0012.namprd15.prod.outlook.com (2603:10b6:208:1b4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 18:50:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l46wB-006hQI-AD; Mon, 25 Jan 2021 14:50:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611600614; bh=IpDoVR+N6+uNWW5oBGskQj2cK00K9NLiBGETUVgH0AA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=TBHY06XmG+0pCo9fvQes7yqHvQ4L9tzV4Zxgvu8XMPEez3VEXGEkS6lQpNBBsiAK/
         lYIZ7wfFHj7aKtdEQHKGvs1SwjgLe7oeoqHpVs8spwc4BYDLUfIaeglhyAHmsZA9l3
         uLj/+lL/lczUHh/0JOSn571ZArFjGli9q1Tu12vKioti0/Xzt7fBNABGDUnKKcTq7X
         F2f0gxbjGeAf7tuNBcpARowwOznlz+LxLY18vgzxo8cZhNjVVnz8qS3xFqWiQeXwKi
         /KoqqHQWRzgB6IrH22e+20zMufqAfjOZVj0KHaEXoQsUozGOGnLfuR8Jhwq6vZrQUC
         3cRHC8f5TpBkw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:26PM -0600, Shiraz Saleem wrote:
> Add Kconfig and Makefile to build irdma driver.
> 
> Remove i40iw driver and add an alias in irdma.
> irdma is the replacement driver that supports X722.
> 
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---

This didn't make it to patchworks or the mailing list

You will need to send it with the git format-patch flag --irreversible-delete

Jason
