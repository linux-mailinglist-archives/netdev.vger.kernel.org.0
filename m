Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6038AA39
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfHLWNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:13:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52246 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfHLWNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 18:13:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D331A1264D004;
        Mon, 12 Aug 2019 15:13:47 -0700 (PDT)
Date:   Mon, 12 Aug 2019 15:13:44 -0700 (PDT)
Message-Id: <20190812.151344.808737276838117231.davem@davemloft.net>
To:     ndesaulniers@google.com
Cc:     akpm@linux-foundation.org, sedat.dilek@gmail.com,
        jpoimboe@redhat.com, yhs@fb.com, miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 09/16] sparc: prefer __section from
 compiler_attributes.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190812215052.71840-9-ndesaulniers@google.com>
References: <20190812215052.71840-1-ndesaulniers@google.com>
        <20190812215052.71840-9-ndesaulniers@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Aug 2019 15:13:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 12 Aug 2019 14:50:42 -0700

> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
