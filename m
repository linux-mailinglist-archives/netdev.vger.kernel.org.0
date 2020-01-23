Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6C147289
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 21:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgAWUY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 15:24:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgAWUY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 15:24:58 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3403F14EACBEA;
        Thu, 23 Jan 2020 12:24:56 -0800 (PST)
Date:   Thu, 23 Jan 2020 21:24:54 +0100 (CET)
Message-Id: <20200123.212454.218301597333582741.davem@davemloft.net>
To:     fthain@telegraphics.com.au
Cc:     tsbogend@alpha.franken.de, chris@zankel.net, laurent@vivier.eu,
        geert@linux-m68k.org, eric.dumazet@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 00/12] Fixes for SONIC ethernet driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1579730846.git.fthain@telegraphics.com.au>
References: <cover.1579730846.git.fthain@telegraphics.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 12:24:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Thu, 23 Jan 2020 09:07:26 +1100

> Various SONIC driver problems have become apparent over the years,
> including tx watchdog timeouts, lost packets and duplicated packets.
> 
> The problems are mostly caused by bugs in buffer handling, locking and
> (re-)initialization code.
> 
> This patch series resolves these problems.
> 
> This series has been tested on National Semiconductor hardware (macsonic),
> qemu-system-m68k (macsonic) and qemu-system-mips64el (jazzsonic).
> 
> The emulated dp8393x device used in QEMU also has bugs.
> I have fixed the bugs that I know of in a series of patches at,
> https://github.com/fthain/qemu/commits/sonic

Series applied, thank you.
