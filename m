Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C042F430F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbhAMEWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:22:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbhAMEWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C5E23122;
        Wed, 13 Jan 2021 04:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610511683;
        bh=RkAKArIj2Lz2+aFdr3x7SAnsAaDH3Tsu/LDdKQXMFWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lwmDU+z+XFa64Yg0WiB2ThGekGx7fWp2Oxa0wsTN37n2QP5qkrF5vT/aDyGqMI4JZ
         HxvS6qfYiFfZNyECVlm6vSfklsVWbrTMWPxPcGYLVV4V6OXRyp3u/oAU8knKTmdR2o
         gJmygWN/KXY89FImbn5wWNp2yHj2/xlzcqlNlG/76gwNlqjxSvH0hphZGoZVNjLYBv
         L0ZustdtkECXeq+qZzMPQmp+U6kZJU54D9Ls7TFItVzGrgQ8WUEj6SRffpA4BfCzEn
         i0RaM55tlxiVquSt+VV7c/GAU/mP7GVcsVIW+WUAvqihXtuxXH3vK7I8TnG9lIylLv
         GQYAA4tFL5jCQ==
Date:   Tue, 12 Jan 2021 20:21:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: Register physical ports as a
 devlink resource
Message-ID: <20210112202122.5751bc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112083931.1662874-2-idosch@idosch.org>
References: <20210112083931.1662874-1-idosch@idosch.org>
        <20210112083931.1662874-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 10:39:30 +0200 Ido Schimmel wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> The switch ASIC has a limited capacity of physical ('flavour physical'
> in devlink terminology) ports that it can support. While each system is
> brought up with a different number of ports, this number can be
> increased via splitting up to the ASIC's limit.
> 
> Expose physical ports as a devlink resource so that user space will have
> visibility to the maximum number of ports that can be supported and the
> current occupancy.

Any thoughts on making this a "generic" resource?

The limitation on number of logical ports is pretty common for switches.
