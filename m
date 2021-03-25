Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074BB349D00
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhCYXoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:44:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54806 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhCYXoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 19:44:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1B0214D248DA2;
        Thu, 25 Mar 2021 16:44:38 -0700 (PDT)
Date:   Thu, 25 Mar 2021 16:44:37 -0700 (PDT)
Message-Id: <20210325.164437.691606485986679140.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, tariqt@nvidia.com,
        maximmi@mellanox.com, ayal@nvidia.com, saeedm@nvidia.com
Subject: Re: [net-next 05/15] net/mlx5e: Move params logic into its
 dedicated file
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210325050438.261511-6-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
        <20210325050438.261511-6-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 25 Mar 2021 16:44:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Wed, 24 Mar 2021 22:04:28 -0700

> +static inline u8 mlx5e_get_rqwq_log_stride(u8 wq_type, int ndsegs)

Please no inline in foo.c files.

Thasnk you.
