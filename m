Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597A6137AC6
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgAKAut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:50:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbgAKAut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:50:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1036F15858B8D;
        Fri, 10 Jan 2020 16:50:49 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:50:48 -0800 (PST)
Message-Id: <20200110.165048.1993854113044478081.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, tariqt@mellanox.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 16:50:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Thu, 9 Jan 2020 11:23:17 -0800

> On modern hardware with a large number of cpus and using XDP,
> the current MSIX limit is insufficient.  Bump the limit in
> order to allow more queues.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tariq et al., please review.
