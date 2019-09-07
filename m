Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB702AC540
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394487AbfIGHxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 03:53:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbfIGHxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 03:53:36 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7185414C612BA;
        Sat,  7 Sep 2019 00:53:34 -0700 (PDT)
Date:   Sat, 07 Sep 2019 09:53:30 +0200 (CEST)
Message-Id: <20190907.095330.932239750115412383.davem@davemloft.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: pull-request: bpf 2019-09-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906222032.1007163-1-ast@kernel.org>
References: <20190906222032.1007163-1-ast@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 00:53:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>
Date: Fri, 6 Sep 2019 15:20:32 -0700

> The following pull-request contains BPF updates for your *net* tree.
> 
> The main changes are:
> 
> 1) verifier precision tracking fix, from Alexei.
> 
> Please consider pulling these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Pulled, thanks!
