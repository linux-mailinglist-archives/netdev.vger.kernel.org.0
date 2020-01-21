Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A32143B9E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgAULF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728682AbgAULF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 06:05:28 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE66524125;
        Tue, 21 Jan 2020 11:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579604728;
        bh=GzUVdNWRgt1Z8QTOKwebG8cbJEdO1vDe92L2r77ndzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCVPdPBku3TUVPCyf4jcUx0oG6fnWP1ME4d85yT9LBqGKmlF8r4LOJNkGf3AcsNfj
         hOwkuW+ZdByfK6EUB/BhCSzJ7fw5SDjOzKKgyqkeyWljM8NP+bl8lqusWeM0dhveuJ
         ZK1GpoZkABdFOXycI6ZPOKSCNOS2vlTtz7M3T6ms=
Date:   Tue, 21 Jan 2020 13:05:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, dledford@redhat.com, jgg@mellanox.com,
        santosh.shilimkar@oracle.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next, rdma-next] [pull request] Use ODP MRs for kernel ULPs
Message-ID: <20200121110525.GK51881@unreal>
References: <20200120073046.75590-1-leon@kernel.org>
 <20200121.103546.795107006412728523.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121.103546.795107006412728523.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 10:35:46AM +0100, David Miller wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Mon, 20 Jan 2020 09:30:46 +0200
>
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi David, Jakub, Doug and Jason
> >
> > This is pull request to previously posted and reviewed series [1] which touches
> > RDMA and netdev subsystems. RDMA part was approved for inclusion by Jason [2]
> > and RDS patches were acked by Santosh [3].
> >
> > For your convenience, the series is based on clean v5.5-rc6 tag and applies
> > cleanly to both subsystems.
> >
> > Please pull and let me know if there's any problem. I'm very rare doing PRs
> > and sorry in advance if something is not as expected.
>
> Pulled into net-next, thanks.

Thanks a lot.
