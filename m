Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3FD29464D
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 03:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411124AbgJUBZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 21:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411120AbgJUBZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 21:25:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE1712098B;
        Wed, 21 Oct 2020 01:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603243551;
        bh=MzVmb6tuEN5moAKXUsfpUr/GGHXE3sSYWHFu4Z3FzOs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vqvAObUxwFdGQDD2e8rhnyiRC8CWjsISmTn99nY3lI0pPkgdTzcEP+/HhF3UOOQIt
         l4VGyOio6CByHPP8qMnbALvp11b7+pY4p+rlMeJgN0CUKfiYQQU13imqq7oumeoDtZ
         3MCRwVINqlFdPUqYB4k0VEgsAGrWBNyT3vIaRXkA=
Date:   Tue, 20 Oct 2020 18:25:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.vnet.ibm.com>,
        Lijun Pan <ljp@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] powerpc/vnic: Extend "failover pending" window
Message-ID: <20201020182549.667c29fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019195233.GA1282438@us.ibm.com>
References: <20201019195233.GA1282438@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 12:52:33 -0700 Sukadev Bhattiprolu wrote:
> From 67f8977f636e462a1cd1eadb28edd98ef4f2b756 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Thu, 10 Sep 2020 11:18:41 -0700
> Subject: [PATCH 1/1] powerpc/vnic: Extend "failover pending" window

I think you copy/pasted the patch into the email client. I can't seem
to apply this patch with git pw:

Patch is empty.
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".


Can you try re-sending with get-send-email? Or please remove these 4
header lines from the email body.
