Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AC7167C4
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfEGQ0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 12:26:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfEGQ0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 12:26:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42E101478A014;
        Tue,  7 May 2019 09:26:05 -0700 (PDT)
Date:   Tue, 07 May 2019 09:26:02 -0700 (PDT)
Message-Id: <20190507.092602.655978914303051867.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-05-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190506102341.12361-1-daniel@iogearbox.net>
References: <20190506102341.12361-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 09:26:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Mon,  6 May 2019 12:23:41 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) Two x32 JIT fixes: one which has buggy signed comparisons in 64
>    bit conditional jumps and another one for 64 bit negation, both
>    from Wang.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks Daniel.
