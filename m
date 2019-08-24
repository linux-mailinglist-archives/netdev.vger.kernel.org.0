Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0549C0F9
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfHXX15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:27:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48532 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfHXX15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:27:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 922EE1525F9EE;
        Sat, 24 Aug 2019 16:27:56 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:27:56 -0700 (PDT)
Message-Id: <20190824.162756.2285262819354000040.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/4] Mellanox, mlx5 fixes 2019-08-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822204121.16954-1-saeedm@mellanox.com>
References: <20190822204121.16954-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:27:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 22 Aug 2019 20:41:34 +0000

> This series introduces some fixes to mlx5 driver.
> 
> 1) Form Moshe, two fixes for firmware health reporter
> 2) From Eran, two ktls fixes.
> 
> Please pull and let me know if there is any problem.
> 
> No -stable this time :) ..

:)  Pulled, thanks!
