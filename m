Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F6569FC2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbfGPAUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:20:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730623AbfGPAUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:20:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B1A214E0387A;
        Mon, 15 Jul 2019 17:20:14 -0700 (PDT)
Date:   Mon, 15 Jul 2019 17:20:11 -0700 (PDT)
Message-Id: <20190715.172011.35985411594256225.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/3] Mellanox, mlx5 fixes 2019-07-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190715200940.31799-1-saeedm@mellanox.com>
References: <20190715200940.31799-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jul 2019 17:20:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 15 Jul 2019 20:09:53 +0000

> This pull request provides mlx5 TC flower and tunnel fixes for
> kernel 5.2 from Eli and Vlad.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
