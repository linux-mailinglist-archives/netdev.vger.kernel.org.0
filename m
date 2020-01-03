Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD0312FDEA
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgACU0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:26:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46680 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgACU0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:26:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5FB081597661D;
        Fri,  3 Jan 2020 12:26:46 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:26:46 -0800 (PST)
Message-Id: <20200103.122646.551144444195211447.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] l2tp: Remove redundant BUG_ON() check in l2tp_pernet
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1578043696-35911-1-git-send-email-vulab@iscas.ac.cn>
References: <1578043696-35911-1-git-send-email-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:26:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Date: Fri,  3 Jan 2020 09:28:16 +0000

> Passing NULL to l2tp_pernet causes a crash via BUG_ON.
> Dereferencing net in net_generic() also has the same effect.
> This patch removes the redundant BUG_ON check on the same parameter.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied.
