Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE883275E82
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 19:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWRV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 13:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIWRV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 13:21:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF6821BE5;
        Wed, 23 Sep 2020 17:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600881686;
        bh=EobRGic8X7iRZIMf6BZ8jeaG15o3dXM3tG39taqNJbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NTSo0B9jMlAJrBvAz0Hwhqot6E3AXML69w/QijhLct6JSqjPJJa5Sa1ppfMQF3+Kc
         /N+Z5NGSIkTBz90dbG6D4A95+F+FW9qJLTbqAT+u4qQdcDzibp+YFYmp/tJDdRlNGk
         ail5Tkgam4cPq/uuB4SkSVbEnKbB97QK8MjR8ER4=
Date:   Wed, 23 Sep 2020 10:21:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next 00/15] mlx5 Connection Tracking in NIC
 mode
Message-ID: <20200923102124.4f54aadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 23:24:23 -0700 saeed@kernel.org wrote:
> This series adds the support for connection tracking in NIC mode,
> and attached to this series some trivial cleanup patches.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

> This series includes mlx5 updates
> 
> 1) Add support for Connection Tracking offload in NIC mode.
>  1.1) Refactor current flow steering chains infrastructure and
>       updates TC nic mode implementation to use flow table chains.
>  1.2) Refactor current Connection Tracking (CT) infrastructure to not
>       assume E-switch backend, and make the CT layer agnostic to
>       underlying steering mode (E-Switch/NIC)
>  1.3) Plumbing to support CT offload in NIC mode.
> 
> 2) Trivial code cleanups.

I'm surprised you need so much surgery here.

Am I understanding correctly that you're talking "switchdev mode" vs
legacy mode?

Could you add a little bit more color about use cases and challenges?

What happens to the rules installed in "NIC mode" when you switch to
"switchdev mode"? IIUC you don't recreated netdevs on switch, right?
