Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42091B3CBA
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfIPOj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:39:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfIPOj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:39:59 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 05F16153CB38A;
        Mon, 16 Sep 2019 07:39:56 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:39:55 +0200 (CEST)
Message-Id: <20190916.163955.2206355736506010205.davem@davemloft.net>
To:     tph@fb.com
Cc:     netdev@vger.kernel.org, jonathan.lemon@gmail.com, dsj@fb.com,
        edumazet@google.com, ncardwell@google.com, dave.taht@gmail.com,
        ycheng@google.com, soheil@google.com
Subject: Re: [PATCH v5 2/2] tcp: Add snd_wnd to TCP_INFO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913232332.44036-2-tph@fb.com>
References: <20190913232332.44036-1-tph@fb.com>
        <20190913232332.44036-2-tph@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 07:39:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Higdon <tph@fb.com>
Date: Fri, 13 Sep 2019 23:23:35 +0000

> Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
> performance problems --
>> (1) Usually when we're diagnosing TCP performance problems, we do so
>> from the sender, since the sender makes most of the
>> performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
>> From the sender-side the thing that would be most useful is to see
>> tp->snd_wnd, the receive window that the receiver has advertised to
>> the sender.
> 
> This serves the purpose of adding an additional __u32 to avoid the
> would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
> 
> Signed-off-by: Thomas Higdon <tph@fb.com>

Applied.
