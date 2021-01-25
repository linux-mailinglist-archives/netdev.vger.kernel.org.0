Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10862304A3A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbhAZFK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:10:28 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6168 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbhAYN3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:29:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ec7a60000>; Mon, 25 Jan 2021 05:29:10 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 13:29:06 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 13:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFAAsp6/KgNcqGvIJOtxPpgShhxV1iZIIQxGIGV+zyMFyWjnycWRxRBVHvD2+gqdLoHtu9zVHY19UU2D0ztJOGQPOi0rD/8g+xI5F1HCUGs3IS0yMOpEdXsCPqCtRamRwT2y7bQNyrdHWVmaRZt+8MQZZK1cxPq48h5mW+Oiq8a7+jnfkAX+ucUSWCQkZGnI1vIqpH4Ey8aqtH/B4A1D/rbOzzVoaP+Hqu5RKR4zSk5NnIXMs0bCi/Tsm9A10Zf2y8sjAvymfK57P5rsyEXYKW74NRRRiQ7BAyZJhggSfrvF/e3o9aqNc4j09m1xn3bLWNtlrRTJ9ymljNM1oTYGuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKIDghmN9sC2/5PLFz8D2fKZcZwG9pP6TiLX9KKiASc=;
 b=Nqpp1CLPRy3icxBiKjA13HDsHg4cL/raMK7aQwTGOIQ0yka/ooNyU6siYv/KAXlDkCREUcbx+hKU7V/c+1dwY4M3yi8RUUIkBSf4U66Q7FV73QV1NdFHrFBMoNmyad/sdGsyViHMWvw89H4ZjXiYoNmonjCdl+fXlwdJ/PFUsY+PGtPYG6s2Ee7GjNYS0zi6R5RwBzJjQsYDnSSMoX/c/dKLC2ye1BybWIxSnQg7ntrwXDuzyWgA70CmwibR8I6kKDNQPDw9OMY5pTl3CTbR1/kO7ZJz/Vskz/cO2uHfjDHd8cR8CQPT0jV7sXvMjklcfLO++AhBHdPlSMgVHahP0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 13:29:05 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:29:05 +0000
Date:   Mon, 25 Jan 2021 09:29:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 00/22] Add Intel Ethernet Protocol Driver for RDMA (irdma)
Message-ID: <20210125132904.GL4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
X-ClientProxiedBy: MN2PR15CA0060.namprd15.prod.outlook.com
 (2603:10b6:208:237::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0060.namprd15.prod.outlook.com (2603:10b6:208:237::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 13:29:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l41vU-006UyC-54; Mon, 25 Jan 2021 09:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611581350; bh=GKIDghmN9sC2/5PLFz8D2fKZcZwG9pP6TiLX9KKiASc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=WNQkbLPhTKReRjJMPJ3jkd0pevQJj9cZeJ3cAvjIR/DS3zy6+/uCG/kku+JqWs/vW
         JJ1BUXDcp+UHSGlHbRNqW51dCGSHOt8Q9hTonlFxX0Y/qGMKE9AE8BhKgnn8165eoo
         AbnbwMJY06smsrP1HECzXyHeSdYt5+LvMIR0AOTk3ksmAYNn8r8lZZWGl3nsU5xAGu
         +2x9j0sLrt79eczomKkl6s4G1UrVLtMI4bjb3AHxSHDtOVwrm9/4If92FoFV3AMnpX
         gTKW7eStw2VOKsSDM5kNTyzw7Pma26TfltMhIh8HvvCPCLVKj0YOHhA4MTtU0QfX0n
         MZmSTBYnXllNw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:05PM -0600, Shiraz Saleem wrote:

> Once the patches are closer to merging, this series will be split into a
> netdev-next and rdma-next patch series targeted at their respective subsystems
> with Patch #1 and Patch #5 included in both. This is the shared header file that
> will allow each series to independently compile.

Nope, send a proper shared pull request.

Jason
