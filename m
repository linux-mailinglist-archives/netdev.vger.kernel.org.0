Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C38F2731
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfKGFko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:40:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfKGFko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:40:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E245E1511FD57;
        Wed,  6 Nov 2019 21:40:43 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:40:43 -0800 (PST)
Message-Id: <20191106.214043.106838143617295899.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/4] Mellanox, mlx5 fixes 2019-11-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106220523.18855-1-saeedm@mellanox.com>
References: <20191106220523.18855-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:40:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 6 Nov 2019 22:05:38 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks.

> No -stable this time.

Phew :)
