Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9620D265A1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfEVO0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 10:26:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49842 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728491AbfEVO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 10:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xliR4pkBceBKXMuL8K0IPcfr0Tkls5aOoLDNqUn7FUY=; b=Xpp5LGLmUUHiAJhv+RwH6UdTc
        wZUWMAZ1qKGJnttQNjwxaLHKysTlpqH6oucE68TvdATECPIVgLYyh0rrEWaQaCUeubCFgEuJ71HX1
        0CLkYHzBURtgiuI4GTFsnLTsTfLGsy5d2VLFuj3cckoOxUcQxpuwmDb/CjnouNiygMZsfq/BJDWWz
        +74fMlkOCGZZ1132gUKkYXs98A3WzsT4hsBe1nisvGSwgk/0e3romo7NW3NKZbhWT5Qkr8Q3sK0Xp
        6KqHnPIx5Dw6x+K1VnR/Gqel6HgqWVB1G4HzjcLGHiNwH4QFM3PQ6M+LF27it/L9lGdW8nOWc95Li
        2epZmQ7mA==;
Received: from [31.161.185.207] (helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTSBS-0003j5-P8; Wed, 22 May 2019 14:25:35 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 14474984E0B; Wed, 22 May 2019 16:25:32 +0200 (CEST)
Date:   Wed, 22 May 2019 16:25:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522142531.GE16275@worktop.programming.kicks-ass.net>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:

> and no changes are necessary in kernel/events/ring_buffer.c either.

Let me just NAK them on the principle that I don't see them in my inbox.

Let me further NAK it for adding all sorts of garbage to the code --
we're not going to do gaps and stay_in_page nonsense.
