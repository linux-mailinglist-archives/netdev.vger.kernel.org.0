Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDA11D5CDA
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEOXhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOXhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:37:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632E0C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 16:37:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2289E157365BD;
        Fri, 15 May 2020 16:37:16 -0700 (PDT)
Date:   Fri, 15 May 2020 16:37:15 -0700 (PDT)
Message-Id: <20200515.163715.1230921414800550320.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/11] Mellanox, mlx5 misc updates
 2020-05-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 16:37:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 15 May 2020 15:48:43 -0700

> This series provides misc updates to mlx5.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

This all looks relatively straightforward, pulled.
