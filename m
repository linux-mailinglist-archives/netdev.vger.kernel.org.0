Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2554FA4163
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 02:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfHaAj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 20:39:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbfHaAj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 20:39:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 57C611550659F;
        Fri, 30 Aug 2019 17:39:56 -0700 (PDT)
Date:   Fri, 30 Aug 2019 17:39:56 -0700 (PDT)
Message-Id: <20190830.173956.571718622747999169.davem@davemloft.net>
To:     daniel@iogearbox.net
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2019-08-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830234006.31988-1-daniel@iogearbox.net>
References: <20190830234006.31988-1-daniel@iogearbox.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 17:39:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>
Date: Sat, 31 Aug 2019 01:40:06 +0200

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) Fix 32-bit zero-extension during constant blinding which
>    has been causing a regression on ppc64, from Naveen.
> 
> 2) Fix a latency bug in nfp driver when updating stack index
>    register, from Jiong.

Pulled, thanks.
