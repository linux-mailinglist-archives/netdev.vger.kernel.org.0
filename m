Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6272D8884
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439596AbgLLRDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgLLRDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 12:03:15 -0500
Date:   Sat, 12 Dec 2020 09:02:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607792555;
        bh=WkIReCFLC1vY0LLkvIQiiFkKuPGCsqQUhk409zbMtK0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=QWYsOKXmHsXOURggudyLKVztfMFW/IlXYz8U2WwL2piFFL8WwPRJ/Nh6K5cSu53GH
         oLEMOmxPjUch4s1jZJug40awfZ+OkEOd+66ZMJOzZt+w+sWAvlA1ZZoPVQZi1xFTPk
         fTUSUdW+1Lb0UpdY6Y24Tl7PZYc/Kaz46sTZW2qWNsRDXKTpmOEtoRQKnIU+V94rYr
         j6npyDwrKSJwjtvhtcX83XeWFx+IEC2rMZKaCWDEUIXJwx+8i7dF07k7DAqY6HELWA
         2sRX6ZDkPsmrm1FGJN4lIQCyAAztngwq1DAgRBxYGiMYLcNOSHWB5mfKk4++jKnlfp
         WvFtE2H9HIF+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasyl Gomonovych <gomonovych@gmail.com>
Cc:     tariqt@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4: Use true,false for bool variable
Message-ID: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211100518.29804-1-gomonovych@gmail.com>
References: <20201211100518.29804-1-gomonovych@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 11:05:18 +0100 Vasyl Gomonovych wrote:
> Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable

Apart from addressing Joe's comment please name the tool which produced
those.
