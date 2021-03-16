Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0E033DA35
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbhCPRFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239071AbhCPREf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 13:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 612A36507D;
        Tue, 16 Mar 2021 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615914273;
        bh=gta9gdbu5EI2d+VUk3ax/ykdJFBtQRukMiis0SapmV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AEejnfsL27HvPyEfbfuOl68ZmRGSLCfiT6ELOdW6f/Ritjf92635rd8fwHLUxTEo2
         +V8M4S73sYFOrsdwAYyMJUB8bXvUaychY+aGYF6rT5jqlqGiX7fStL+azXplg7rYJ1
         qtOwVgw4qdRx8JFWANMSihlddhOctia3ViqHHIfMpQdNA4LK4ZYXbAgnEjivSQ8MHz
         WXNkJyeHoakQdriGUZ3ckk96HBvcVXmy0fMo8AMm44UmcmO0kMGlWdYMrIgXYofZpp
         WA/gBG7tnJhXm2T8rPh7shOFHnqZqZicHLkmBJeZXbtmoWj3d/kmIHjkIW2VXYwPTD
         gy9vKWOzTZ+pw==
Date:   Tue, 16 Mar 2021 10:04:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: Re: [net PATCH 3/9] octeontx2-af: Do not allocate memory for
 devlink private
Message-ID: <20210316100432.666d9bd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615886833-71688-4-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
        <1615886833-71688-4-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 14:57:07 +0530 Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Memory for driver private structure rvu_devlink is
> also allocated during devlink_alloc. Hence use
> the allocated memory by devlink_alloc and access it
> by devlink_priv call.
> 
> Fixes: fae06da4("octeontx2-af: Add devlink suppoort to af driver")
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Does it fix any bug? Looks like a coding improvement.
