Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C414718E636
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgCVDNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:13:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:13:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 897F115AC1045;
        Sat, 21 Mar 2020 20:13:30 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:13:29 -0700 (PDT)
Message-Id: <20200321.201329.1050250622878099133.davem@davemloft.net>
To:     jianyang.kernel@gmail.com
Cc:     netdev@vger.kernel.org, soheil@google.com, willemb@google.com,
        jianyang@google.com
Subject: Re: [PATCH net-next 0/5] selftests: expand txtimestamp with new
 features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317192509.150725-1-jianyang.kernel@gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:13:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang.kernel@gmail.com>
Date: Tue, 17 Mar 2020 12:25:04 -0700

> From: Jian Yang <jianyang@google.com>
> 
> Current txtimestamp selftest issues requests with no delay, or fixed 50
> usec delay. Nsec granularity is useful to measure fine-grained latency.
> A configurable delay is useful to simulate the case with cold
> cachelines.
> 
> This patchset adds new flags and features to the txtimestamp selftest,
> including:
> - Printing in nsec (-N)
> - Polling interval (-b, -S)
> - Using epoll (-E, -e)
> - Printing statistics
> - Running individual tests in txtimestamp.sh

I'll apply this, thank you.
