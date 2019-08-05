Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2158243D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbfHERui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:50:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbfHERui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:50:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1947153FFB4B;
        Mon,  5 Aug 2019 10:50:37 -0700 (PDT)
Date:   Mon, 05 Aug 2019 10:50:37 -0700 (PDT)
Message-Id: <20190805.105037.111009971120453478.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/12] Mellanox, mlx5 updates
 2019-08-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 10:50:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 1 Aug 2019 19:56:50 +0000

> This series provides misc updates to mlx5 driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.

Pulled, thank you.
