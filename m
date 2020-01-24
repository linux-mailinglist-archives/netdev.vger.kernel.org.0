Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92521147EEB
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 11:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731458AbgAXKnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 05:43:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAXKnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 05:43:09 -0500
Received: from localhost (unknown [147.229.117.36])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0826E15884B18;
        Fri, 24 Jan 2020 02:43:06 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:42:39 +0100 (CET)
Message-Id: <20200124.114239.135148237471100782.davem@davemloft.net>
To:     vvs@virtuozzo.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] netdev: seq_file .next functions should increase
 position index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4d27bcf7-cebf-0f7d-9d5b-5bf1f681eff7@virtuozzo.com>
References: <4d27bcf7-cebf-0f7d-9d5b-5bf1f681eff7@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jan 2020 02:43:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Date: Thu, 23 Jan 2020 10:11:01 +0300

> In Aug 2018 NeilBrown noticed 
> commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
> "Some ->next functions do not increment *pos when they return NULL...
> Note that such ->next functions are buggy and should be fixed. 
> A simple demonstration is
 ...
> There are lot of other affected files, I've found 30+ including
> /proc/net/ip_tables_matches and /proc/sysvipc/*
> 
> This patch-set fixes files related to netdev@ 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206283

Series applied, thank you.
