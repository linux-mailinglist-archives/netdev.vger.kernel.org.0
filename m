Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD601C6C6A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgEFJHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:07:30 -0400
Received: from a3.inai.de ([88.198.85.195]:44678 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbgEFJHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 05:07:30 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id E9DD35872FA74; Wed,  6 May 2020 11:07:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id E894D60C40095;
        Wed,  6 May 2020 11:07:23 +0200 (CEST)
Date:   Wed, 6 May 2020 11:07:23 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Huang Qijun <dknightjun@gmail.com>
cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] netfilter: fix make target xt_TCPMSS.o error.
In-Reply-To: <20200506065021.2881-1-dknightjun@gmail.com>
Message-ID: <nycvar.YFH.7.76.2005061106420.3951@n3.vanv.qr>
References: <20200506065021.2881-1-dknightjun@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 2020-05-06 08:50, Huang Qijun wrote:

>When compiling netfilter, there will be an error
>"No rule to make target 'net/netfilter/xt_TCPMSS.o'",
>because the xt_TCPMSS.c in the makefile is uppercase,
>and the file name of the source file (xt_tcpmss.c) is lowercase.

>-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
>+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_tcpmss.o

Uhm, no:

11:07 a4:../net/netfilter » ls -l xt_*[Mm][Ss]*.c
-rw-r--r-- 1 jengelh users 8948 Feb 27 09:30 xt_TCPMSS.c
-rw-r--r-- 1 jengelh users 2459 Feb 27 09:30 xt_tcpmss.c
