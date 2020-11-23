Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E820B2C14A6
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730169AbgKWTna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgKWTn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 14:43:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 353EE20719;
        Mon, 23 Nov 2020 19:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606160609;
        bh=yKBik2d+XdjIH2t3lAbd95QFf69C1XkKVbLCdzhjqrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sUEcfj5xKNodInegaihq/wAnOzeqdE8EGm1UueN37LO/TBfH4FvmShptQg4eAJEip
         Az0CQj4RVGYI0POfE32uFnqAWtYnaHxAO6MSMClxJ1aalON92HmUL8UTCYARicVyC2
         WRT2gRdBuokeRqeItL0tSEDiq5Nr4OmavPrFE/xU=
Date:   Mon, 23 Nov 2020 11:43:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     drt <drt@linux.vnet.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org,
        sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 02/15] ibmvnic: process HMC disable command
Message-ID: <20201123114328.00c0b933@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <aa10c3fad62841df56a6185b3b267ca9@linux.vnet.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-3-ljp@linux.ibm.com>
        <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <aa10c3fad62841df56a6185b3b267ca9@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 07:12:38 -0800 drt wrote:
> On 2020-11-21 15:36, Jakub Kicinski wrote:
> > On Fri, 20 Nov 2020 16:40:36 -0600 Lijun Pan wrote:  
> >> From: Dany Madden <drt@linux.ibm.com>
> >> 
> >> Currently ibmvnic does not support the disable vnic command from the
> >> Hardware Management Console. This patch enables ibmvnic to process
> >> CRQ message 0x07, disable vnic adapter.  
> > 
> > What user-visible problem does this one solve?  
> This allows HMC to disconnect a Linux client from the network if the 
> vNIC adapter is misbehaving and/or sending malicious traffic. The effect 
> is the same as when a sysadmin sets a link down (ibmvnic_close()) on the 
> Linux client. This patch extends this ability to the HMC.

Okay, sounds to me like net-next material, then.

IIUC we don't need to fix this ASAP and backport to stable.
