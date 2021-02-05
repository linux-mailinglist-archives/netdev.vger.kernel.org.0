Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB93111A3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhBESQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 13:16:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhBESJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 13:09:29 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41AF064FB7;
        Fri,  5 Feb 2021 19:51:11 +0000 (UTC)
Date:   Fri, 5 Feb 2021 14:51:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     pmladek@suse.com, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] lib:  Replace obscene word with a better one :)
Message-ID: <20210205145109.24498541@gandalf.local.home>
In-Reply-To: <20210205121543.1315285-1-unixbhaskar@gmail.com>
References: <20210205121543.1315285-1-unixbhaskar@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 17:45:43 +0530
Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:

> s/fucked/messed/

Rules about obscene language is about new code coming into the kernel. We
don't want to encourage people to do sweeping changes of existing code. It
just causes unwanted churn, and adds noise to the git logs.

Sorry, NAK.

-- Steve
