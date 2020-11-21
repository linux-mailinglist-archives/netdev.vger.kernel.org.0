Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E522BC2A7
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgKUXi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 18:38:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgKUXi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 18:38:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B932076B;
        Sat, 21 Nov 2020 23:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606001907;
        bh=V8ttHdEDBcnVMkZMy3JAAn2DM09krZDsfWproVxzb+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FrsGEMVMt5e/c65qCzRTTuMdIPBEYNG8bo9gChx/BuA+RDFOASuKTrtU9TMrRUztw
         csJfUPTJs985e/Cyr9F9iLZX4iMvlBdJWByUgM+XWHzOfL/ljbL5SQ3PMquUF/mzyI
         EdNEvmKLHqjJQ5rR+iaY/H1s5LlyTWtzET2wCK1Q=
Date:   Sat, 21 Nov 2020 15:38:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 02/15] ibmvnic: process HMC disable command
Message-ID: <20201121153826.51f548ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
        <20201120224049.46933-3-ljp@linux.ibm.com>
        <20201121153637.17a91ac4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 15:36:37 -0800 Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 16:40:36 -0600 Lijun Pan wrote:
> > From: Dany Madden <drt@linux.ibm.com>
> > 
> > Currently ibmvnic does not support the disable vnic command from the
> > Hardware Management Console. This patch enables ibmvnic to process
> > CRQ message 0x07, disable vnic adapter.  
> 
> What user-visible problem does this one solve?

Re-reading the commit message - is Hardware Management Console operated
by a human? So this is basically adding a missing feature, not fixes a
bug? Unless not being able to disable vnic is causing other things to
break.
