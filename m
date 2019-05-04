Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C148113772
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfEDEZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:25:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbfEDEZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:25:42 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8DD6614D8ADBC;
        Fri,  3 May 2019 21:25:38 -0700 (PDT)
Date:   Sat, 04 May 2019 00:25:34 -0400 (EDT)
Message-Id: <20190504.002534.469600514479665272.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next V2 00/15] Mellanox, mlx5 updates
 2019-04-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:25:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 1 May 2019 21:54:46 +0000

> This series provides misc updates to mlx5 driver.
> There is one patch of this series that is touching outside mlx5 driver:
> 
> ethtool.h: Add SFF-8436 and SFF-8636 max EEPROM length definitions
> Added max EEPROM length defines for ethtool usage:
>      #define ETH_MODULE_SFF_8636_MAX_LEN     640
>      #define ETH_MODULE_SFF_8436_MAX_LEN     640
> 
> These definitions used to determine the EEPROM data
> length when reading high eeprom pages.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> 
> V2: 
>   - Update the mlx5-next merge commit to include latest fix.

Pulled, thanks Saeed.
