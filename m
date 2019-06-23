Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6E24FD71
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfFWSAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:00:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43078 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfFWSAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:00:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D6FC140CFF4E;
        Sun, 23 Jun 2019 11:00:43 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:00:42 -0700 (PDT)
Message-Id: <20190623.110042.1172184297315738761.davem@davemloft.net>
To:     bpoirier@suse.com
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/16] qlge: Factor out duplicated expression
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190623.105935.2293591576103857913.davem@davemloft.net>
References: <20190617074858.32467-1-bpoirier@suse.com>
        <20190617074858.32467-10-bpoirier@suse.com>
        <20190623.105935.2293591576103857913.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:00:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 23 Jun 2019 10:59:35 -0700 (PDT)

> "(u16) 65536" is zero and the range of these values is 0 -- 65536.
> 
> This whole expression is way overdone.

Also, when you post the next revision of this patch series, please
provide a proper "[PATCH net-next 00/16]" header posting explaining
what this patch series does logically at the high level, how it is
doing it, and why it is doing it that way.

Thank you.
