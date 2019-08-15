Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E873C8F42B
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732672AbfHOTKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732639AbfHOTKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:10:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F64A13FC384B;
        Thu, 15 Aug 2019 12:10:15 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:10:14 -0700 (PDT)
Message-Id: <20190815.121014.1797190329154381943.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/2] Mellanox, mlx5 fixes 2019-08-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190815184639.8206-1-saeedm@mellanox.com>
References: <20190815184639.8206-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:10:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 15 Aug 2019 18:47:04 +0000

> This series introduces two fixes to mlx5 driver.
> 
> 1) Eran fixes a compatibility issue with ethtool flash.
> 2) Maxim fixes a race in XSK wakeup flow.
> 
> Please pull and let me know if there is any problem.

Pulled, thank you.
