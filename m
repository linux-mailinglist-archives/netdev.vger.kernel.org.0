Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF1143995
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAUJfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:35:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgAUJfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:35:51 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B322815BC0BD6;
        Tue, 21 Jan 2020 01:35:48 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:35:46 +0100 (CET)
Message-Id: <20200121.103546.795107006412728523.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, dledford@redhat.com, jgg@mellanox.com,
        leonro@mellanox.com, santosh.shilimkar@oracle.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next, rdma-next] [pull request] Use ODP MRs for kernel
 ULPs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120073046.75590-1-leon@kernel.org>
References: <20200120073046.75590-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:35:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 20 Jan 2020 09:30:46 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi David, Jakub, Doug and Jason
> 
> This is pull request to previously posted and reviewed series [1] which touches
> RDMA and netdev subsystems. RDMA part was approved for inclusion by Jason [2]
> and RDS patches were acked by Santosh [3].
> 
> For your convenience, the series is based on clean v5.5-rc6 tag and applies
> cleanly to both subsystems.
> 
> Please pull and let me know if there's any problem. I'm very rare doing PRs
> and sorry in advance if something is not as expected.

Pulled into net-next, thanks.
