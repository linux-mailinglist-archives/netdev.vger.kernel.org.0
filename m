Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6F01828E6
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387859AbgCLGUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:20:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387848AbgCLGUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:20:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF7EA14DA84A4;
        Wed, 11 Mar 2020 23:20:13 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:20:13 -0700 (PDT)
Message-Id: <20200311.232013.489547255392767135.davem@davemloft.net>
To:     jbi.octave@gmail.com
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: Re: [PATCH 3/8] tcp: Add missing annotation for tcp_child_process()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311010908.42366-4-jbi.octave@gmail.com>
References: <0/8>
        <20200311010908.42366-1-jbi.octave@gmail.com>
        <20200311010908.42366-4-jbi.octave@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:20:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jules Irenge <jbi.octave@gmail.com>
Date: Wed, 11 Mar 2020 01:09:03 +0000

> Sparse reports warning at tcp_child_process()
> warning: context imbalance in tcp_child_process() - unexpected unlock
> The root cause is the missing annotation at tcp_child_process()
> 
> Add the missing __releases(&((child)->sk_lock.slock)) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied.
