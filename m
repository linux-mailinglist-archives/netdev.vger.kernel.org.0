Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A9BDF2D3
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfJUQTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:19:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37148 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbfJUQTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:19:53 -0400
Received: from localhost (unknown [12.156.66.3])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 569F61401B78E;
        Mon, 21 Oct 2019 09:19:53 -0700 (PDT)
Date:   Mon, 21 Oct 2019 09:19:50 -0700 (PDT)
Message-Id: <20191021.091950.653616939959954741.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 00/15] Mellanox, mlx5 kTLS fixes 18-10-2019
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Oct 2019 09:19:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 18 Oct 2019 19:37:59 +0000

> This series introduces kTLS related fixes to mlx5 driver from Tariq,
> and two misc memory leak fixes form Navid Emamdoost.
> 
> Please pull and let me know if there is any problem.

Puleld.

> I would appreciate it if you queue up kTLS fixes from the list below to
> stable kernel v5.3 !
> 
> For -stable v4.13:
>   nett/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq 
> 
> For -stable v5.3:
>   net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
>   net/mlx5e: Tx, Fix assumption of single WQEBB of NOP in cleanup flow
>   net/mlx5e: Tx, Zero-memset WQE info struct upon update
>   net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown flow
>   net/mlx5e: kTLS, Size of a Dump WQE is fixed
>   net/mlx5e: kTLS, Save only the frag page to release at completion
>   net/mlx5e: kTLS, Save by-value copy of the record frags
>   net/mlx5e: kTLS, Fix page refcnt leak in TX resync error flow
>   net/mlx5e: kTLS, Fix missing SQ edge fill
>   net/mlx5e: kTLS, Limit DUMP wqe size
>   net/mlx5e: kTLS, Remove unneeded cipher type checks
>   net/mlx5e: kTLS, Save a copy of the crypto info
>   net/mlx5e: kTLS, Enhance TX resync flow
>   net/mlx5e: TX, Fix consumer index of error cqe dump

Queued up.
