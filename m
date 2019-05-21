Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F582571A
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 19:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfEUR4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 13:56:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45885 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfEUR4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 13:56:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id i21so8935983pgi.12;
        Tue, 21 May 2019 10:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FbUU/EROxa+2gIry4MHohDpJnUD0iabB83okgZNIc04=;
        b=A9l63JLobrODFKSiZjPIwZQwRFFUX/GwQzTZ02aEzGt3720G+1fRDJpZmxQH9KWP/t
         oXuT/hzpOTcCJAgBGHN63EmpNPuI3lcNWXJ7gO+i72zueZSPTi+X+AoyX6WPAurrOExa
         IHxk+dneIbgnWAYF7bZr2xjb0TGwtqmTk26VMK68efrkSIrm67ziYaz8XCey733yfORK
         3blPoWofHrXEgHwt2x0pBRBgbgPJmi6IhnvZBukzfSs/zNffyTtnyz9vLu3/pq24S/i4
         lMW2j3pyeLVb1jhTamJC51XNc6dhDaFkQulDMtqkbgdy3RSSXWuIDubblJoHDhz89Hl8
         DqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FbUU/EROxa+2gIry4MHohDpJnUD0iabB83okgZNIc04=;
        b=ZaAzbNBhzBfT2aexHpqDFAWLx135LPtFbXIgmCEMXrb1nxWslkBnLMmLUTH95E57Sj
         CCmDduoNsIle7oiiLRmkVkgRPpfpJCKnDDqbjL3zYyXI/ufXYSlzpu3AEkMCgH7Dp08m
         j7NFa30RdxpJUHvk/OrmAjYv63CmxB5fAmHuLmeH48XhzCS7oLzJwAmYfIz6deNZ9OsY
         D9LLq4YzdvOwdcwXDZwXtgmbDABrtrNxLbEB1rmZ9VKYJne+99giL71A/7qOE/e0V5Pn
         TFIkiW5Q0vwLePXVZCIVQVY5Bl861+Vhavh/9kT2XH+YmDOTSf8AlK62lglaDmkASKj6
         R5lA==
X-Gm-Message-State: APjAAAWnAYjpaDzM6NPEVLy6pVPHzZ/B4IB7L8sm+1cSUmmJEShTWBBk
        j8Q/I9ey5FCcgLIHKSkyt2VLbW5S
X-Google-Smtp-Source: APXvYqwr6le7YzXOZE6He2lQYhAYaDm+QCOjOj/OX5MLAxhb48XQUgkTIPzNV6vdjmNTb4OXp4eUlg==
X-Received: by 2002:a62:1b85:: with SMTP id b127mr61348467pfb.165.1558461380471;
        Tue, 21 May 2019 10:56:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:1eff])
        by smtp.gmail.com with ESMTPSA id i12sm26796352pfd.33.2019.05.21.10.56.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 10:56:19 -0700 (PDT)
Date:   Tue, 21 May 2019 10:56:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 11:47:00PM +0000, Kris Van Hees wrote:
> 
>     2. bpf: add BPF_PROG_TYPE_DTRACE
> 
> 	This patch adds BPF_PROG_TYPE_DTRACE as a new BPF program type, without
> 	actually providing an implementation.  The actual implementation is
> 	added in patch 4 (see below).  We do it this way because the
> 	implementation is being added to the tracing subsystem as a component
> 	that I would be happy to maintain (if merged) whereas the declaration
> 	of the program type must be in the bpf subsystem.  Since the two
> 	subsystems are maintained by different people, we split the
> 	implementing patches across maintainer boundaries while ensuring that
> 	the kernel remains buildable between patches.

None of these kernel patches are necessary for what you want to achieve.
Feel free to add tools/dtrace/ directory and maintain it though.

The new dtrace_buffer doesn't need to replicate existing bpf+kernel functionality
and no changes are necessary in kernel/events/ring_buffer.c either.
tools/dtrace/ user space component can use either per-cpu array map
or hash map as a buffer to store arbitrary data into and use
existing bpf_perf_event_output() to send it to user space via perf ring buffer.

See, for example, how bpftrace does that.

