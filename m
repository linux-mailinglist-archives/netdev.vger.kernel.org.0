Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE40D304A60
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbhAZFFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:05:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15154 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbhAYNIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:08:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ec2790000>; Mon, 25 Jan 2021 05:07:05 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 13:06:57 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 13:06:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlES/XAK5kiQUzy5IFZt0F7Bz8pUIfg+5wm7tSm4FJFs3ZeiW2S3KOR4ozkz5CC5eTtoJhNiybPMjkmwMlDY87fsBz9RL0Of8h3k7SGmLEp745vfvAVzpXO++3AxsyhLiwDhf8N+2Wn4zcv5nhoyiI9pj9KamuijwlBURQ3weplySQMPmge1L1mczb6YJ/UNuy+OFYZiUkvqKbvOj6twsA61kZAJ5uMTFBe8JbcIpgJJj0VpZ/hgUghUt2OFMu+CXUZ1QvUcwy56oBoK+WNdxW3xFVaLvpqpZrSfqBT17TIfP/XKyzvqy1mNK/jcoEntGbXIq8fLHO4460KmbfA6mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2BtXjwSXfzJg2tpgFpOEQEtp3L1KjIvV6LvlaELgEg=;
 b=ZSxc8I3xrj0UvbQX5MKoj8lnKOCBGYKO4WtkqINvkEvY80y2btrLKjPfq8cSDbVxWPjGmKGDCLkXA+9/4AX5PJVxuaue08R1l6Z4fOASxLY/odzTVJsUqvz8ZJd/SC5ht0nCuZj3r7QRc+sTv2ooaOAz7sn47hbEG5eEIdidiEjJ9+PsJEZrTK7SM85K4R+88QMedqa0Bi+Es27RWNKLV5VQfo/W8XmFUhNpdMTXnsQ9GzM9FS0C8is/1r8Xa2FnptDluf2wzd/br2BlzZSdH/OkfSMMNVHcr6W3dXNfM1b//WFfq6rX9FAkHAR9nmu3JrV0+letJc40l8vEqqBmJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2582.namprd12.prod.outlook.com (2603:10b6:4:b5::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 13:06:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:06:56 +0000
Date:   Mon, 25 Jan 2021 09:06:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <alexander.duyck@gmail.com>,
        <edwin.peer@broadcom.com>, <dsahern@kernel.org>,
        <kiran.patil@intel.com>, <jacob.e.keller@intel.com>,
        <david.m.ertman@intel.com>, <dan.j.williams@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V9 14/14] net/mlx5: Add devlink subfunction port
 documentation
Message-ID: <20210125130654.GI4147@nvidia.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-15-saeed@kernel.org>
 <d5ef3359-ff3c-0e71-8312-0f24c3af4bce@intel.com>
 <20210122001157.GE4147@nvidia.com>
 <89d0c6de-18e3-5728-a220-3440ca263616@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <89d0c6de-18e3-5728-a220-3440ca263616@intel.com>
X-ClientProxiedBy: BLAPR03CA0057.namprd03.prod.outlook.com
 (2603:10b6:208:32d::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0057.namprd03.prod.outlook.com (2603:10b6:208:32d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 13:06:56 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l41a2-006UR5-HS; Mon, 25 Jan 2021 09:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611580025; bh=GOxnf/1FDRpkmxX0Rfc95kJhR6v5dbRL9ZP6sX1B9XI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=No/XmjyJwcyJ16fHZy0vx3rFK7qdfjw37B853q5YkvIN2RCEuF0JxlbkC+jPxKRCv
         v56dqq/RxiYmOSltseP6CZYigFtruotot5HWKwY2ss4mNddKV8E85LJbkQmSgszSbb
         DmnbjqoOiEKohk/3o/I5MsVmAGK3K/KvB8mq1vs4pYZ7E9umUps3XoR0ZZkY8sM/xn
         /ABZUOXfUWSVbj/3i6Pt8XZUxLgKKoBLlBHmfhIq2tsK5QyL9psW+8/NpubRxMfYC8
         sScOGkcF3fPLgJGAqcxlsl+P/64lym/TREKp8olDHxufdbNx/+7kUtOnMMB/b9Lcfd
         zOqNCmQif7c2A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 12:09:15PM -0800, Samudrala, Sridhar wrote:

> > The other aux devices represent the subsystem split of the mlx5 driver
> > - mlx5_core creates them and each subsystem in turn binds to the
> > mlx5_core driver. This already exists, and Intel will be doing this as
> > well whenever the RDMA driver is posted again..
>=20
> Yes. I see that the intel RDMA patches are now submitted. We are
> creating an aux device to expose RDMA functionality, but=C2=A0 not
> planning to create an aux device for ethernet subsystem on a PF/SF
> as the function-level pci/aux device can represent the default
> ethernet.

That is because the ethernet and shared code are all in the same
module

You may find this becomes inconvenient when you want to add something
like SF, where there is alot of merit to having uniformity in the
ethernet driver.

Jason
