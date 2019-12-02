Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3320A10F322
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 00:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfLBXIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 18:08:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42286 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfLBXIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 18:08:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1837414DAF624;
        Mon,  2 Dec 2019 15:08:22 -0800 (PST)
Date:   Mon, 02 Dec 2019 15:08:19 -0800 (PST)
Message-Id: <20191202.150819.1676106400310976788.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     tglx@linutronix.de, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: bpf and local lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191202215237.jz7zkriantxyclj5@ast-mbp.dhcp.thefacebook.com>
References: <20191125.111433.742571582032938766.davem@davemloft.net>
        <20191202215237.jz7zkriantxyclj5@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 15:08:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 2 Dec 2019 13:52:38 -0800

> On Mon, Nov 25, 2019 at 11:14:33AM -0800, David Miller wrote:
>> 
>> Thomas,
>> 
>> I am working on eliminating the explicit softirq disables around BPF
>> program invocation and replacing it with local lock usage instead.
>> 
>> We would really need to at least have the non-RT stubs upstream to
>> propagate this cleanly, do you think this is possible?
> 
> Hi Thomas,
> 
> seconding the same question: any chance local lock api can be sent upstream
> soon? If api skeleton can get in during this merge window we will have the next
> bpf-next/net-next cycle to sort out details. If not the bpf+rt would need to
> wait one more release. Not a big deal. Just trying to figure out a time line
> when can we start working on concrete bpf+rt patches.

FWIW, I have some simple patches I'm working on that start to annotate
the bpf function invocation call sites.

And as part of that I add the non-RT stubs plus some new interfaces I
think might be necessary.

I've been told Thomas is going to be offline for another week so I'll
just keep working on this and post when I have something concrete.
