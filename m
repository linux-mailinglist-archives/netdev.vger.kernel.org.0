Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82E51334E7
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgAGVb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:31:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgAGVb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:31:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CBB7115A17087;
        Tue,  7 Jan 2020 13:31:55 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:31:55 -0800 (PST)
Message-Id: <20200107.133155.65415495361949231.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     jakub.kicinski@netronome.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-01-07
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107093438.10089-1-daniel@iogearbox.net>
References: <20200107093438.10089-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:31:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Tue,  7 Jan 2020 10:34:38 +0100

> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 2 non-merge commits during the last 1 day(s) which contain
> a total of 2 files changed, 16 insertions(+), 4 deletions(-).
> 
> The main changes are:
> 
> 1) Fix a use-after-free in cgroup BPF due to auto-detachment, from Roman Gushchin.
> 
> 2) Fix skb out-of-bounds access in ld_abs/ind instruction, from Daniel Borkmann.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
