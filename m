Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C6F31BBE4
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhBOPIB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Feb 2021 10:08:01 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35303 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhBOPHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:07:42 -0500
X-Originating-IP: 90.55.97.122
Received: from bootlin.com (apoitiers-259-1-26-122.w90-55.abo.wanadoo.fr [90.55.97.122])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 2AE03E0013;
        Mon, 15 Feb 2021 15:06:55 +0000 (UTC)
Date:   Mon, 15 Feb 2021 16:06:54 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     davem@davemloft.net, gregory.clement@bootlin.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next 1/2] net: mvneta: Remove per-cpu queue mapping
 for Armada 3700
Message-ID: <20210215160654.7ff1a145@bootlin.com>
In-Reply-To: <20210214235058.aicn6aqsm66chrxi@pali>
References: <20210212151220.84106-2-maxime.chevallier@bootlin.com>
        <20210214235058.aicn6aqsm66chrxi@pali>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

On Mon, 15 Feb 2021 00:50:58 +0100
Pali Rohár <pali@kernel.org> wrote:

>> According to Errata #23 "The per-CPU GbE interrupt is limited to Core
>> 0", we can't use the per-cpu interrupt mechanism on the Armada 3700
>> familly.
>> 
>> This is correctly checked for RSS configuration, but the initial queue
>> mapping is still done by having the queues spread across all the CPUs in
>> the system, both in the init path and in the cpu_hotplug path.  
>
>Hello Maxime!
>
>This patch looks like a bug fix for Armada 3700 SoC. What about marking
>this commit with Fixes line? E.g.:
>
>    Fixes: 2636ac3cc2b4 ("net: mvneta: Add network support for Armada 3700 SoC")

Yes you're correct, I'll add that to the V2 !

Thanks for the review,

Maxime


-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
