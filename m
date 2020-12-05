Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6C2CF7FB
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgLEA1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:27:33 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:12014 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLEA1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:27:33 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcad3cb0000>; Sat, 05 Dec 2020 08:26:51 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 5 Dec
 2020 00:26:46 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 5 Dec 2020 00:26:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzaSRzpjEx1jzL0UKOq+JQU6HGkkvJlyXAlaBNGVSmslblm0ivvk0XRpLrl6n4X466IODsKoeCVJgyYXZxMXTpbge94mzUALPtYXwBNEDt5tyIJXpKdNqXf1O+DptNVypXhp1GvFI59WKrEHn7Jami9X7PnPpZyKAd4MuzPjqugH5htEjzQnx4FiphSKA4kbnQCpGIacQH366sa/G8zWEWA3JQ/oIS8gLgrJQfZ3Q0CULOcjL7xAZLv3T7X1UYKwTxtAKA+lABCmatoXnVVAZCLwT8Wg6RZhVRSXvkCQytrBXCLPE21QWh2MNo55ELLt+h242Z337NbfhavBpio/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNUkcNiFujdshch6o5HAbCpXbBS1Wb2d5VgDTKlkBfQ=;
 b=dcIfo+JFkrOwf3BQC9t3kMgbnGaeBiG18gNb9WGG7jja0tf9IjskFAuhqNnMDQ749vp/NZWwS6Fh/182gxD7QV8UDYEkyW3bbKB7JE2LFVFPz/6z4gJRFN2vmfJnlGT54fXgyQcrASfSKdH9Xv1QM9zfVuw7DlAcpeeFbR+q0IVG66xOgeeZ3J2tjR3fsot475yjgvym1iAA284DvcgdauS6OUdQZEB7UL9121xx+XTZep0N8sErT0YUuirYNXpuy5R6L2aiLW404yoZDAXZAZZVh59BtEBYgsKwaTa4WnRhX6X4ygtt8dXTHS6CftI8p4LbBWc/X6+Hg02XWx7gPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2811.namprd12.prod.outlook.com (2603:10b6:5:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 5 Dec
 2020 00:26:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 00:26:44 +0000
Date:   Fri, 4 Dec 2020 20:26:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [pull request][for-next] mlx5-next auxbus support
Message-ID: <20201205002642.GA1495499@nvidia.com>
References: <20201204182952.72263-1-saeedm@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201204182952.72263-1-saeedm@nvidia.com>
X-ClientProxiedBy: MN2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:208:23b::11) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0006.namprd11.prod.outlook.com (2603:10b6:208:23b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 00:26:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1klLPO-006HOk-IO; Fri, 04 Dec 2020 20:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607128011; bh=VNUkcNiFujdshch6o5HAbCpXbBS1Wb2d5VgDTKlkBfQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=hmXAuI+238Pf7mONQxFGdfjQHGg2PYqPwYmV/IUMYL9HXLebhlo0e09bt/Y0qRFfs
         EsJCXA7VkilDqWYYAqrO3b1GMgUERL7JLJwXxq983kesL3/Qx17jhBT4CCegPaaiXm
         OOTyY9vaEn4BLn2pVd5Mm3wbjcmSv2JcF5Sr8pj/ONOwEwaNEqaeg1l9TPZbDHohrK
         /sSAZ7TuJXUVEXLe/hzac4ZN7hh1aw0KsyVhzdXRm5K6RZkBNS0ZyXrgSV32PtQFwf
         Ccik3Cj9nahm/gtPjNbkVVoiaR1c2FyPRrS28sz2ivqL4RlFoPy+1RO5RN8l8yCPVx
         zbrwY+S6LcQ0g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 10:29:52AM -0800, Saeed Mahameed wrote:
> Hi Jakub, Jason
> 
> This pull request is targeting net-next and rdma-next branches.
> 
> This series provides mlx5 support for auxiliary bus devices.
> 
> It starts with a merge commit of tag 'auxbus-5.11-rc1' from
> gregkh/driver-core into mlx5-next, then the mlx5 patches that will convert
> mlx5 ulp devices (netdev, rdma, vdpa) to use the proper auxbus
> infrastructure instead of the internal mlx5 device and interface management
> implementation, which Leon is deleting at the end of this patchset.
> 
> Link: https://lore.kernel.org/alsa-devel/20201026111849.1035786-1-leon@kernel.org/
> 
> Thanks to everyone for the joint effort !
> 
> Please pull and let me know if there's any problem.

This all looks good, thanks.

Jakub a few notes on shared branch process here.. 

In general Linus's advice has been to avoid unnecessary merges so
Saeed/Leon have tended to send PRs to one tree or the other based on
need and that PR might have a "catch up" from the other tree. I guess
this one is special because it makes lots of changes in both trees.

Whoever pulls first means the other cannot refuse the PR, so I usually
prefer to let netdev go first. I have more BW to manage trouble on the
RDMA side..

I saw your other request related to the CI failures due to the wrong
branch basis in the build bot. This means you will need to pull every
update to the mlx5 shared branch, even if it is not immediately
relevant to netdev, or have Saeed include the 'base commit' trailer
and teach the build bots to respect it..

Also, I arrange the RDMA merge window PR to be after netdev (usually
on Thursday) so that Linus sees minor RDMA stuff in the netdev
diffstat, and almost no netdev stuff in the RDMA PR.

Cheers,
Jason
