Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DA6F3EA9
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfKHEEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:04:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfKHEEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:04:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C7EA14F499F2;
        Thu,  7 Nov 2019 20:04:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 20:04:08 -0800 (PST)
Message-Id: <20191107.200408.114425105076404885.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/9] net: introduce u64_stats_t
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 20:04:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 16:27:13 -0800

> KCSAN found a data-race in per-cpu u64 stats accounting.
> 
> (The stack traces are included in the 8th patch :
>  tun: switch to u64_stats_t)
> 
> This patch series first consolidate code in five patches.
> Then the last three patches address the data-race resolution.

Series applied, thanks Eric.
