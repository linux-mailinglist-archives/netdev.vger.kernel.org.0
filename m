Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964F9153187
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgBENPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:15:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgBENPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:15:39 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECA69158E27F9;
        Wed,  5 Feb 2020 05:15:38 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:15:37 +0100 (CET)
Message-Id: <20200205.141537.74468083994693269.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] wireguard fixes for 5.6-rc1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204211729.365431-1-Jason@zx2c4.com>
References: <20200204211729.365431-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:15:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  4 Feb 2020 22:17:24 +0100

> Here are fixes for WireGuard before 5.6-rc1 is tagged. It includes:
> 
> 1) A fix for a UaF (caused by kmalloc failing during a very small
>    allocation) that syzkaller found, from Eric Dumazet.
> 
> 2) A fix for a deadlock that syzkaller found, along with an additional
>    selftest to ensure that the bug fix remains correct, from me.
> 
> 3) Two little fixes/cleanups to the selftests from Krzysztof Kozlowski
>    and me.

Series applied, thanks Jason.
