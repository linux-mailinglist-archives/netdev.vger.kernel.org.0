Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B12B0EEC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 21:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgKLUQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 15:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgKLUQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 15:16:45 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD3520A8B;
        Thu, 12 Nov 2020 20:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605212204;
        bh=EHyeO0MPE0SxSjAa03kCUgKzknAdmQkHHmJPJH295oM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GUvWOnJ0bMa4wuvbDzTC9q1lyH4T+mXV5NiTRFM1FdWoIRvf9LymzSgt53eJK2KyZ
         /v/eXj3nSPOPXo4uw22YqnKCGOjkzvNlB/2iktBBH1g3BXNPg0+c7W/Xq0ILz7vctH
         oruCZYjSkCgV24KVTFMSpW13+80GZL83MOO3J4lw=
Message-ID: <0b91885ea6395a139f5d8a317f6a897af9d76cc6.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 00/13] Add ethtool ntuple filters support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Date:   Thu, 12 Nov 2020 12:16:40 -0800
In-Reply-To: <20201111071404.29620-1-naveenm@marvell.com>
References: <20201111071404.29620-1-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-11 at 12:43 +0530, Naveen Mamindlapalli wrote:
> This patch series adds support for ethtool ntuple filters, unicast
> address filtering, VLAN offload and SR-IOV ndo handlers. All of the
> above features are based on the Admin Function(AF) driver support to
> install and delete the low level MCAM entries. Each MCAM entry is
> programmed with the packet fields to match and what actions to take
> if the match succeeds. The PF driver requests AF driver to allocate
> set of MCAM entries to be used to install the flows by that PF. The
> entries will be freed when the PF driver is unloaded.
> 
> * The patches 1 to 4 adds AF driver infrastructure to install and
>   delete the low level MCAM flow entries.
> * Patch 5 adds ethtool ntuple filter support.
> * Patch 6 adds unicast MAC address filtering.
> * Patch 7 adds support for dumping the MCAM entries via debugfs.
> * Patches 8 to 10 adds support for VLAN offload.
> * Patch 10 to 11 adds support for SR-IOV ndo handlers.
> * Patch 12 adds support to read the MCAM entries.
> 
> Misc:
> * Removed redundant mailbox NIX_RXVLAN_ALLOC.
> 
> Change-log:
> v3:
> - Fixed Saeed's review comments on v2.
> 	- Fixed modifying the netdev->flags from driver.
> 	- Fixed modifying the netdev features and hw_features after
> register_netdev.
> 	- Removed unwanted ndo_features_check callback.
> v2:
> - Fixed the sparse issues reported by Jakub.
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

