Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFBC18AA90
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgCSCOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:14:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSCOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 22:14:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 384171572E848;
        Wed, 18 Mar 2020 19:14:08 -0700 (PDT)
Date:   Wed, 18 Mar 2020 19:14:07 -0700 (PDT)
Message-Id: <20200318.191407.70211491532900013.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [pull request][net-next 00/14] Mellanox, mlx5 updates
 2020-03-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 19:14:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 17 Mar 2020 19:47:08 -0700

> This series provides some fixes and cleanups for issues introduced lately
> in mlx5 Connection tracking offloads series. In the last 5 patches, Eli 
> adds the support for forwarding traffic between uplink representors
> (Hairpin for Switchdev mode).
> 
> For more information please see the tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
