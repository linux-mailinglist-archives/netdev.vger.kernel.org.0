Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B333E14D
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhCPWVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhCPWVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D7A64EFC;
        Tue, 16 Mar 2021 22:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615933280;
        bh=9xv/j+oRsnhEOipTk+kZ388TZib6yHtOp2QFDfeaNw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qCK5NocAU0xthtfqJAfK6bGPKb5YDCSarF84KnqO9zwFpEskSQQgTbNqHOZGRbz/q
         boS6vOwCq81c06gjJmNYE7UD1abBm3alg+yI6wHn2bAsFRZb0j3akyoI71F1fjfbDJ
         kcFzPScovDM4A1/rCscA6kzqqJg3BQr+eY5EW08gG2HXW2dKplcrs7oP6XLLW2Osc6
         xu8QTHg2EuIUlxFMWxctG5sMDHOLLXbIC28sMBqxeUfNa5fXqaEcr6hvKFuqHOAWqx
         +8/S+O5xIsYr9CHtrt0OSIBmY+IrTvqeWYaqeWnJlOLp/NJX8/GNucnKqtO9mmRahy
         zPeu4x5NVd5TA==
Date:   Tue, 16 Mar 2021 15:21:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 00/10] mlxsw: Add support for egress and
 policy-based sampling
Message-ID: <20210316152119.051d7d46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 17:02:53 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> So far mlxsw only supported ingress sampling using matchall classifier.
> This series adds support for egress sampling and policy-based sampling
> using flower classifier on Spectrum-2 and newer ASICs. As such, it is
> now possible to issue these commands:
> 
>  # tc filter add dev swp1 egress pref 1 proto all matchall action sample rate 100 group 1
> 
>  # tc filter add dev swp2 ingress pref 1 proto ip flower dst_ip 198.51.100.1 action sample rate 100 group 2
> 
> When performing egress sampling (using either matchall or flower) the
> ASIC is able to report the end-to-end latency which is passed to the
> psample module.

Acked-by: Jakub Kicinski <kuba@kernel.org>
