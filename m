Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0FC1E567
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfENXB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 19:01:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfENXB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 19:01:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BB9914C11EEF;
        Tue, 14 May 2019 16:01:56 -0700 (PDT)
Date:   Tue, 14 May 2019 16:01:55 -0700 (PDT)
Message-Id: <20190514.160155.2039400951466133948.davem@davemloft.net>
To:     huangfq.daxian@gmail.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: iphase: Avoid copying pointers to user space.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190514151205.5143-1-huangfq.daxian@gmail.com>
References: <20190514151205.5143-1-huangfq.daxian@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 16:01:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>
Date: Tue, 14 May 2019 23:11:59 +0800

> When ia_cmds.sub_cmd is MEMDUMP_DEV in ia_ioctl,
> nullify the pointer fields of iadev before copying
> the whole structure to user space.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Honestly I'd rather you just remove the MEMDUMP_DEV ioctl altogether,
there is now ay that information is useful in any way whatsoever.

Thank you.
