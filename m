Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E6966174
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfGKWFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 18:05:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfGKWFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 18:05:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4476F14DB4EAC;
        Thu, 11 Jul 2019 15:05:01 -0700 (PDT)
Date:   Thu, 11 Jul 2019 15:05:00 -0700 (PDT)
Message-Id: <20190711.150500.434111377573647531.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Mellanox, mlx5 build fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190711193937.29802-1-saeedm@mellanox.com>
References: <20190711193937.29802-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 15:05:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 11 Jul 2019 19:39:53 +0000

> I know net-next is closed but these patches are fixing some compiler
> build and warnings issues people have been complaining about.
> 
> I hope it is not too late, but in case it is a lot of trouble for
> you, I guess they can wait.

Never too late to submit build fixes :-)

Series applied, thanks.
