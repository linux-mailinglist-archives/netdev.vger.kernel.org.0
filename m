Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB05C22B
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfGARmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:42:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46086 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfGARmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:42:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26AFE14BFCB36;
        Mon,  1 Jul 2019 10:42:17 -0700 (PDT)
Date:   Mon, 01 Jul 2019 10:42:14 -0700 (PDT)
Message-Id: <20190701.104214.353713894841168473.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] Documentation/networking: fix default_ttl typo in
 mpls-sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701084528.25872-1-liuhangbin@gmail.com>
References: <20190701084528.25872-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 10:42:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon,  1 Jul 2019 16:45:28 +0800

> default_ttl should be integer instead of bool
> 
> Reported-by: Ying Xu <yinxu@redhat.com>
> Fixes: a59166e47086 ("mpls: allow TTL propagation from IP packets to be configured")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thank you.
