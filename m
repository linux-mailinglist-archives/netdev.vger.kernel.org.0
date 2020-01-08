Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E52134D2C
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgAHU0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:26:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHU0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:26:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1E601584B07C;
        Wed,  8 Jan 2020 12:26:16 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:26:13 -0800 (PST)
Message-Id: <20200108.122613.1537035816902170131.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/13] Mellanox, mlx5 updates
 2020-01-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:26:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 7 Jan 2020 19:14:05 +0000

> This series adds some misc updates and multi-destination support in SW
> steering for mlx5 driver.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
