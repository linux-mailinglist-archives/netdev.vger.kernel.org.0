Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4911858D0
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgCOCYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgCOCYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 22:24:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7187520767;
        Sat, 14 Mar 2020 09:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584179880;
        bh=WVVParOWzgYVO4dfjDohwouHvjf1IsqACAGzrU0YV4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m8WfkxcMqznt826Wz+VQ0hcKDHS2V+XHmw7zFPl6lYz//Kdbv1GIVekjqJmkNHMvR
         UnYQ7dLJP8CkmAsoBq/dTnSP6qkGK6eg8vc1o0wkDkbfGmQ8dBL7GfLzc7DbTSFnQq
         JRGyUO8zHetKBBcfTpo9ejnXPBtJ7xnSORpG/6ZI=
Date:   Sat, 14 Mar 2020 11:57:54 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [net-next 13/14] net/mlx5: DR, Add support for flow table id
 destination action
Message-ID: <20200314095754.GF67638@unreal>
References: <20200314011622.64939-1-saeedm@mellanox.com>
 <20200314011622.64939-14-saeedm@mellanox.com>
 <20200313193643.5186b300@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313193643.5186b300@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 07:36:43PM -0700, Jakub Kicinski wrote:
> On Fri, 13 Mar 2020 18:16:21 -0700 Saeed Mahameed wrote:
> > From: Alex Vesker <valex@mellanox.com>
> >
> > This action allows to go to a flow table based on the table id.
> > Goto flow table id is required for supporting user space SW.
>
> What's user space SW?

"User space software steering" is a way to add rules to the packet
processing. The rules can be written by user space applications and
they are executed by the HW.

The rdma-core (RDMA userspace counterpart) is exposing the proper API
for that functionality.
https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/man/mlx5dv_dr_flow.3.md

Thanks
