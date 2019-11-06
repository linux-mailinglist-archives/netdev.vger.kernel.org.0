Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5573AF0BFD
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbfKFCVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:21:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730576AbfKFCVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:21:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B52E015104578;
        Tue,  5 Nov 2019 18:21:09 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:21:09 -0800 (PST)
Message-Id: <20191105.182109.1997652161189833250.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 0/3] net_sched: convert packet counters to
 64bit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105031315.90137-1-edumazet@google.com>
References: <20191105031315.90137-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:21:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  4 Nov 2019 19:13:12 -0800

> This small patch series add 64bit support for packet counts.
> 
> Fact that the counters were still 32bit has been quite painful.
> 
> tc -s -d qd sh dev eth0 | head -3
> qdisc mq 1: root 
>  Sent 665706335338 bytes 6526520373 pkt (dropped 2441, overlimits 0 requeues 91) 
>  backlog 0b 0p requeues 91

Series applied.
