Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5474ED56F9
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 19:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfJMRN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 13:13:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbfJMRN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 13:13:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A244E1433DB74;
        Sun, 13 Oct 2019 10:13:27 -0700 (PDT)
Date:   Sun, 13 Oct 2019 10:13:25 -0700 (PDT)
Message-Id: <20191013.101325.1549436648496002099.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net 0/9] tcp: address KCSAN reports in tcp_poll() (part
 I)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 10:13:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 10 Oct 2019 20:17:37 -0700

> This all started with a KCSAN report (included
> in "tcp: annotate tp->rcv_nxt lockless reads" changelog)
> 
> tcp_poll() runs in a lockless way. This means that about
> all accesses of tcp socket fields done in tcp_poll() context
> need annotations otherwise KCSAN will complain about data-races.
> 
> While doing this detective work, I found a more serious bug,
> addressed by the first patch ("tcp: add rcu protection around
> tp->fastopen_rsk").

Series applied, thanks Eric.
