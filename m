Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBFA28E5C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 02:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfEXAbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 20:31:55 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32788 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731488AbfEXAbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 20:31:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id h17so4016473pgv.0;
        Thu, 23 May 2019 17:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lLQfizO5S1jeLuBK8ynQ0IvaQmS9BQxkxCqtOoGCSCY=;
        b=L0LNNWnJnUIN2+yQZywgfLB5J3tMyi7KeNcTJAQAgtp9m1rQhqCdmqJqTNzKsF8qz/
         r6bFDq4KAZ8kKYpIMs1sc8KBN/rlgvwSiuuNMJV1S/lRKcKYuAP7vmi3U5aZ0oUwL6HO
         NWzNSQUVxyANl01QM5FyagHT9RmoTKfnf7N/+gW1utKK1TdlPkGeyhZHjPWspW32mNZg
         aE4x1LGZ33qlID81d9l+PkYzMccniA9NVlXRawFrj3KZosHo3K6/s33GpHvNKS8Z87fe
         oGtn+B1xlhRuNjdzWEi891wpKGoG3dUI6dXqoL+eLJfiHXian7EZQNy8mAXGrQZBZuKO
         e9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lLQfizO5S1jeLuBK8ynQ0IvaQmS9BQxkxCqtOoGCSCY=;
        b=VPwceux6/EHv3ijctOTFL0/yNeE1TL7q8V3umjP1l/pejsz+K7Ma4KkrN0V2Phoeg6
         H3nQ/iUNT/E1Tjh2zsA28EUyeP+9BbHL0+5IFZTUwsJ9cqz0XG5qztnj+FzAlvDUVmz7
         YKg4OmU09DQgkuhKEFmqa70idJxQn9EWIvXK3HP0DCQw9T+dGzOnQxe+hYX5EF9Htq16
         JpcBioXjhR8fKNA9cid29KfHqamfCZbvp/btAXXTVGDFZLowVrVm2PTvKrWqu9L+fQQj
         i9lQEiGTr01hJF1SIS0/wQ2/GSLfCXpCUe8ZifyFFmmnaifbxvGWAKznmixjeP8Gqtgo
         JE9Q==
X-Gm-Message-State: APjAAAW8Bq/NXROn+79/HBa8vLqTNT9m1fya7JSuamdkAtQbTsfYgx1s
        8TetTf1XEJKDsur16IiQ/Eo=
X-Google-Smtp-Source: APXvYqyP+i+hlBQ6YeZP0DdBtBgKcBfw/Lads6VZVc0D+fnqYzQQq6sIdzpR9PuwuU1dy2TICm5Pyw==
X-Received: by 2002:a63:1a5e:: with SMTP id a30mr4551646pgm.433.1558657913224;
        Thu, 23 May 2019 17:31:53 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:d5a9])
        by smtp.gmail.com with ESMTPSA id o11sm422964pjp.31.2019.05.23.17.31.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 17:31:52 -0700 (PDT)
Date:   Thu, 23 May 2019 17:31:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190524003148.pk7qbxn7ysievhym@ast-mbp.dhcp.thefacebook.com>
References: <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
 <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
 <20190523054610.GR2422@oracle.com>
 <20190523211330.hng74yi75ixmcznc@ast-mbp.dhcp.thefacebook.com>
 <20190523190243.54221053@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523190243.54221053@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 07:02:43PM -0400, Steven Rostedt wrote:
> On Thu, 23 May 2019 14:13:31 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > > In DTrace, people write scripts based on UAPI-style interfaces and they don't
> > > have to concern themselves with e.g. knowing how to get the value of the 3rd
> > > argument that was passed by the firing probe.  All they need to know is that
> > > the probe will have a 3rd argument, and that the 3rd argument to *any* probe
> > > can be accessed as 'arg2' (or args[2] for typed arguments, if the provider is
> > > capable of providing that).  Different probes have different ways of passing
> > > arguments, and only the provider code for each probe type needs to know how
> > > to retrieve the argument values.
> > > 
> > > Does this help bring clarity to the reasons why an abstract (generic) probe
> > > concept is part of DTrace's design?  
> > 
> > It actually sounds worse than I thought.
> > If dtrace script reads some kernel field it's considered to be uapi?! ouch.
> > It means dtrace development philosophy is incompatible with the linux kernel.
> > There is no way kernel is going to bend itself to make dtrace scripts
> > runnable if that means that all dtrace accessible fields become uapi.
> 
> Now from what I'm reading, it seams that the Dtrace layer may be
> abstracting out fields from the kernel. This is actually something I
> have been thinking about to solve the "tracepoint abi" issue. There's
> usually basic ideas that happen. An interrupt goes off, there's a
> handler, etc. We could abstract that out that we trace when an
> interrupt goes off and the handler happens, and record the vector
> number, and/or what device it was for. We have tracepoints in the
> kernel that do this, but they do depend a bit on the implementation.
> Now, if we could get a layer that abstracts this information away from
> the implementation, then I think that's a *good* thing.

I don't like this deferred irq idea at all.
Abstracting details from the users is _never_ a good idea.
A ton of people use bcc scripts and bpftrace because they want those details.
They need to know what kernel is doing to make better decisions.
Delaying irq record is the opposite.

> > 
> > In stark contrast to dtrace all of bpf tracing scripts (bcc scripts
> > and bpftrace scripts) are written for specific kernel with intimate
> > knowledge of kernel details. They do break all the time when kernel changes.
> > kprobe and tracepoints are NOT uapi. All of them can change.
> > tracepoints are a bit more stable than kprobes, but they are not uapi.
> 
> I wish that was totally true, but tracepoints *can* be an abi. I had
> code reverted because powertop required one to be a specific format. To
> this day, the wakeup event has a "success" field that writes in a
> hardcoded "1", because there's tools that depend on it, and they only
> work if there's a success field and the value is 1.

I really think that you should put powertop nightmares to rest.
That was long ago. The kernel is different now.
Linus made it clear several times that it is ok to change _all_ tracepoints.
Period. Some maintainers somehow still don't believe that they can do it.

Some tracepoints are used more than others and more people will
complain: "ohh I need to change my script" when that tracepoint changes.
But the kernel development is not going to be hampered by a tracepoint.
No matter how widespread its usage in scripts.

Sometimes that pain of change can be mitigated a bit. Like that
'success' field example, but tracepoints still change.
Meaningful value before vs hardcoded constant is still a breakage for
some scripts.

> I do definitely agree with you that the Dtrace code shall *never* keep
> the kernel from changing. That is, if Dtrace depends on something that
> changes (let's say we record priority of a task, but someday priority
> is replaced by something else), then Dtrace must cope with it. It must
> not be a blocker like user space applications can be.
> 
> 
> -- Steve
