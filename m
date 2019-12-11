Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4635411A07A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfLKB2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:28:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfLKB2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:28:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5780415037A02;
        Tue, 10 Dec 2019 17:28:22 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:28:21 -0800 (PST)
Message-Id: <20191210.172821.1406974012095303846.davem@davemloft.net>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, tglx@linutronix.de
Subject: Re: [RFC v1 PATCH 0/7] bpf: Make RT friendly.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191207.160357.828344895192682546.davem@davemloft.net>
References: <20191207.160357.828344895192682546.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:28:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 07 Dec 2019 16:03:57 -0800 (PST)

> 
> The goal of this patch set is to make the BPF code friendly in RT
> configurations.
> 
> The first step is eliminating preemption disable/enable and replacing
> it with local lock usage when full RT is enabled.
> 
> Likewise we also need to elide usage of up_read_non_owner() in the
> stackmap code when full RT is turned on.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thomas can you please take a look at this patch series?

It eliminates all of the RT problems we were made aware of, and these
patches have been through the bpf test suite as well as gotten 0-day
testing.

The only major thing we needs ACK'd is the locallock stubs.

Thank you.
