Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF3220F0D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfEPTIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:08:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfEPTIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:08:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0A9C133E977F;
        Thu, 16 May 2019 12:08:51 -0700 (PDT)
Date:   Thu, 16 May 2019 12:08:51 -0700 (PDT)
Message-Id: <20190516.120851.1713772355356356074.davem@davemloft.net>
To:     huangfq.daxian@gmail.com
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] atm: iphase: Avoid copying pointers to user space.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190515004248.9440-1-huangfq.daxian@gmail.com>
References: <20190515004248.9440-1-huangfq.daxian@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 12:08:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>
Date: Wed, 15 May 2019 08:42:48 +0800

> Remove the MEMDUMP_DEV case in ia_ioctl to avoid copy
> pointers to user space.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Applied.
