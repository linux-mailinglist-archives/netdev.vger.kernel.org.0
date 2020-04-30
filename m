Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59A31C0738
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgD3UAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgD3UAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C60AC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07111128A4273;
        Thu, 30 Apr 2020 13:00:31 -0700 (PDT)
Date:   Thu, 30 Apr 2020 13:00:31 -0700 (PDT)
Message-Id: <20200430.130031.615867525670616970.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [pull request][net V2 0/7] Mellanox, mlx5 fixes 2020-04-29
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 13:00:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 30 Apr 2020 09:25:44 -0700

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled.

 ...
> For -stable v4.12
>  ('net/mlx5: Fix forced completion access non initialized command entry')
>  ('net/mlx5: Fix command entry leak in Internal Error State')
> 
> For -stable v5.4
>  ('net/mlx5: DR, On creation set CQ's arm_db member to right value')
>  
> For -stable v5.6
>  ('net/mlx5e: Fix q counters on uplink representors')

Queued up, thanks.
