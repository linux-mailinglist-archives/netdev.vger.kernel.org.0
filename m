Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B622F1465E2
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgAWKjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:39:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgAWKjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:39:14 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 390DC153DCDAE;
        Thu, 23 Jan 2020 02:39:07 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:39:03 +0100 (CET)
Message-Id: <20200123.113903.125339377712611659.davem@davemloft.net>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, dave.taht@gmail.com,
        toke@redhat.com, kuba@kernel.org, stephen@networkplumber.org,
        lesliemonis@gmail.com, tahiliani@nitk.edu.in
Subject: Re: [PATCH net-next v7 00/10] net: sched: add Flow Queue PIE
 packet scheduler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:39:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gautamramk@gmail.com
Date: Wed, 22 Jan 2020 23:52:23 +0530

> From: Gautam Ramakrishnan <gautamramk@gmail.com>
> 
> Flow Queue PIE packet scheduler
> 
> This patch series implements the Flow Queue Proportional
> Integral controller Enhanced (FQ-PIE) active queue
> Management algorithm. It is an enhancement over the PIE
> algorithm. It integrates the PIE aqm with a deficit round robin
> scheme.
> 
> FQ-PIE is implemented over the latest version of PIE which
> uses timestamps to calculate queue delay with an additional
> option of using average dequeue rate to calculate the queue
> delay. This patch also adds a memory limit of all the packets
> across all queues to a default value of 32Mb.
> 
>  - Patch #1
>    - Creates pie.h and moves all small functions and structures
>      common to PIE and FQ-PIE here. The functions are all made
>      inline.
>  - Patch #2 - #8
>    - Addresses code formatting, indentation, comment changes
>      and rearrangement of structure members.
>  - Patch #9
>    - Refactors sch_pie.c by changing arguments to
>      calculate_probability(), [pie_]drop_early() and
>      pie_process_dequeue() to make it generic enough to
>      be used by sch_fq_pie.c. These functions are exported
>      to be used by sch_fq_pie.c.
>  - Patch #10
>    - Adds the FQ-PIE Qdisc.
> 
> For more information:
> https://tools.ietf.org/html/rfc8033

Series applied, thank you.
