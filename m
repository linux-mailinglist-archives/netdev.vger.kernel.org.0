Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD491327745
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 06:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbhCAFzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 00:55:32 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5451 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbhCAFza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 00:55:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603c81a90001>; Sun, 28 Feb 2021 21:54:49 -0800
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 1 Mar 2021 05:54:47 +0000
Date:   Mon, 1 Mar 2021 07:54:24 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: Not yet merged patches
Message-ID: <20210301055424.GA181420@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614578089; bh=P9W0wZU06Y3P7pUXtp9yfEs9E78I9hbbReY7kAmW9so=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
         Content-Disposition:User-Agent:X-Originating-IP:X-ClientProxiedBy;
        b=HD019nOsjhEfHRMh293rLru9TVPjKzUcytUCFpMkN2AOKN08MLHXITJdgJbpzD2cV
         cltPZCsfMqOE8G4PWBdjYhyqmtKt2ulyGGtpuNIddi3g3CimHvMFDMDkPMPdCnPiH3
         fKPPuCj2kY11j21Yn6RcU+wnlEMdGVE6kHc6jeKqfBF89o+nUzbOQLl2LahiSsyBEC
         Xy+5LZ2rQ2yUGNJmkwTutwEpkhjMvjK3m+m7ZwsUVso+/XNTYtVWdMiIrVy6uYS+NH
         R4xeaUl0zhDRwGX1gih86sb2G3zf9nUP71UQU/nJGQ8sREC+XymOwSDWo4BNzAcHx7
         awv/IMwzjTohw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

I see that you did not include these in your latest pull request.

https://lkml.org/lkml/2021/2/10/1386
https://lkml.org/lkml/2021/2/10/1383
https://lkml.org/lkml/2021/2/18/124

Are you going to merge them?

