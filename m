Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26E322B16
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhBWNDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:03:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12929 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbhBWNAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:00:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6034fc4b0001>; Tue, 23 Feb 2021 04:59:55 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 23 Feb 2021 12:59:53 +0000
Date:   Tue, 23 Feb 2021 14:59:49 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2] vdpa/mlx5: Enable user to add/delete vdpa device
Message-ID: <20210223125949.GA171769@mtl-vdi-166.wap.labs.mlnx>
References: <20210218074157.43220-1-elic@nvidia.com>
 <20210223072847-mutt-send-email-mst@kernel.org>
 <20210223123304.GA170700@mtl-vdi-166.wap.labs.mlnx>
 <20210223075211-mutt-send-email-mst@kernel.org>
 <20210223125442.GA171540@mtl-vdi-166.wap.labs.mlnx>
 <20210223075508-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223075508-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614085195; bh=f5CMDGFhor+9RsiYFJVJVRhN5XtruNBihrZTrnz+WeU=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=Mf4Pqfcz54xq3Go3EcteQHesyRfK3lL6ra6Q2mCMmfEE5OIYKYulaTdyVYsi3zNW9
         co6UBVjbF5UU0/FyVxqe/nxkPccSjtMog/R1MM44PqD6eqwfqPWMXrNqDxdeFbwkPS
         qdskj+jW7Qp9d4MJZO9OtIINtSJ+OQXFBGQZpRmcrdbzzcFgJ3oeCnSBdOQHsAIhMd
         Y+Malx8pWzmBhYvssN/+G9fQNHzrDjs377o7nsc+W9WK2UBGMvLDkFtNvMipVcdWR5
         4ycMRZWYAOvVArF3QDANFJ0nO0Kxq0Fx11pvKMfW2nazD8mnb5LOJ/mjUcoHOI7G6/
         5UKC0iAE23W7A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:56:16AM -0500, Michael S. Tsirkin wrote:
> On Tue, Feb 23, 2021 at 02:54:42PM +0200, Eli Cohen wrote:
> > On Tue, Feb 23, 2021 at 07:52:34AM -0500, Michael S. Tsirkin wrote:
> > > 
> > > I think I have them in the linux next branch, no?
> > > 
> > 
> > You do.
> 
> I guest there's a conflict with some other patch in that tree then.
> Can you rebase please?
> 

Parav, will send later today.

> -- 
> MST
> 
