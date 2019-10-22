Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCDE0CB9
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388473AbfJVTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:42:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:46196 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731806AbfJVTmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:42:33 -0400
Received: from 13.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.13] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iN030-0005QE-Ii; Tue, 22 Oct 2019 21:42:26 +0200
Date:   Tue, 22 Oct 2019 21:42:26 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xdp: fix type of string pointer in __XDP_ACT_SYM_TAB
Message-ID: <20191022194226.GD31343@pc-66.home>
References: <20191022125925.10508-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022125925.10508-1-ben.dooks@codethink.co.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25610/Tue Oct 22 10:54:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 01:59:25PM +0100, Ben Dooks (Codethink) wrote:
> The table entry in __XDP_ACT_SYM_TAB for the last item is set
> to { -1, 0 } where it should be { -1, NULL } as the second item
> is a pointer to a string.
> 
> Fixes the following sparse warnings:
> 
> ./include/trace/events/xdp.h:28:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:53:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:82:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:140:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:155:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:190:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:225:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:260:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:318:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:356:1: warning: Using plain integer as NULL pointer
> ./include/trace/events/xdp.h:390:1: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

Applied, thanks!
