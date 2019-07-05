Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37DC60E23
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 01:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfGEX3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 19:29:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfGEX3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 19:29:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5581C15044B95;
        Fri,  5 Jul 2019 16:29:48 -0700 (PDT)
Date:   Fri, 05 Jul 2019 16:29:47 -0700 (PDT)
Message-Id: <20190705.162947.1737460613201841097.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, eranbe@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, moshe@mellanox.com
Subject: Re: [PATCH net-next 00/12] mlx5 TLS TX HW offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 16:29:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Fri,  5 Jul 2019 18:30:10 +0300

> This series from Eran and me, adds TLS TX HW offload support to
> the mlx5 driver.

Series applied, please deal with any further feedback you get from
Jakub et al.

Thanks.
