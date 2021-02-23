Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE33F322ADC
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhBWMza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:55:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12070 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhBWMz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:55:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6034fb180000>; Tue, 23 Feb 2021 04:54:48 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 23 Feb 2021 12:54:46 +0000
Date:   Tue, 23 Feb 2021 14:54:42 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH v2] vdpa/mlx5: Enable user to add/delete vdpa device
Message-ID: <20210223125442.GA171540@mtl-vdi-166.wap.labs.mlnx>
References: <20210218074157.43220-1-elic@nvidia.com>
 <20210223072847-mutt-send-email-mst@kernel.org>
 <20210223123304.GA170700@mtl-vdi-166.wap.labs.mlnx>
 <20210223075211-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223075211-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614084888; bh=d/mmEeDh+bRGUiSQfAh5Z2+I4Rz/blRtVtxbboMGPmU=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=Bhch7HFzCb3tQ6B3nK9ztsKBKtDSCwKqad3u5v1JYDwKHDHBsgy8yNyvXzCGxnfip
         vHvjvZ9th9FdrZJJLdvitaxGNung1vc7wnoKMIt1hSNxNcHcoRFA5ZAmrLAVLcQj70
         PrNZWhhvxBc6KC9dc/G7xjiD3biog4LdeG72JjfaQRgp2InuNBRMgBLiFuQW+5Z3Hp
         agoVLRoLFRSv+aQ/w3pgvxztwVaJxbAlPChhK+brqGVP5Zg5C7Jf812KxeCUpHUB1f
         krz//f/fwDQnDEtcm0bK0tLTq7Vwd4nVSruTktHn13f0zlVob3sDAm3Iur5lDg3oP4
         6wUdSkWHwWPRw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:52:34AM -0500, Michael S. Tsirkin wrote:
> 
> I think I have them in the linux next branch, no?
> 

You do.
