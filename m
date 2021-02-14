Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B231B37D
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 00:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhBNXvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 18:51:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhBNXvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 18:51:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D5D364DD6;
        Sun, 14 Feb 2021 23:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613346664;
        bh=GWmbwqVJ6melv6EG0HVsZA49QrkGXO2pXS6pzRN2LvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=b+YYOqdFweqox3TwN7hPDZ/ds8EaNq4Dzg5tEGpcKfcv6CjlYiDPZ5FwWc8JUTX8Y
         r3PR/9SK+DoFctv1kvVATm1wUBghLumbMp67z9jUm7gSkxMbDclXsTMVzbBBUOYePn
         a+GN+5I8RGcxpyzo33c/dhERqPeAi7vLw23oaEWJSya6Kp3LOkzmYJCjKV/oYnwimh
         8FkvqNj8Smc2BwMXh1DkKcAxu3FDDTVhyLMVqZ0dLp+W+bpyih08V4s9i8BCBmekTG
         VV6itFN7IfVgSXP3m2Ie7+Lr1hYtRWK1/ALvoyb+URoTC8sPh2z/sTu60D7OgjXHjY
         E9FouOZlW9yug==
Received: by pali.im (Postfix)
        id 2807C896; Mon, 15 Feb 2021 00:51:01 +0100 (CET)
Date:   Mon, 15 Feb 2021 00:50:58 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, gregory.clement@bootlin.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next 1/2] net: mvneta: Remove per-cpu queue mapping
 for Armada 3700
Message-ID: <20210214235058.aicn6aqsm66chrxi@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212151220.84106-2-maxime.chevallier@bootlin.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> According to Errata #23 "The per-CPU GbE interrupt is limited to Core
> 0", we can't use the per-cpu interrupt mechanism on the Armada 3700
> familly.
> 
> This is correctly checked for RSS configuration, but the initial queue
> mapping is still done by having the queues spread across all the CPUs in
> the system, both in the init path and in the cpu_hotplug path.

Hello Maxime!

This patch looks like a bug fix for Armada 3700 SoC. What about marking
this commit with Fixes line? E.g.:

    Fixes: 2636ac3cc2b4 ("net: mvneta: Add network support for Armada 3700 SoC")
