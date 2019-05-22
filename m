Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0151227129
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfEVUxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:53:35 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43323 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfEVUxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:53:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn7so1624844plb.10;
        Wed, 22 May 2019 13:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/Ss3XekhoAeJW501j2lZN9cRIVhRSBmA8AmuXwTseos=;
        b=RjfDSqdM7JMfp+j0CLByP8ahJAWw1TNDM1Ig/33Xu+MNPw7uUoZlzfGFyiC1/rAXnw
         bC9LRKWe99q/8iAuluWjaUwIsAWXloDLd2LpOh3T4hnwzNdFRWf0RCBefdvaxkNMAlan
         lrpbYo12CMIlAtogUcyLXP3p7bvlL9ZksNTNb7j3HqeTG3dKGBTPQx+xTEY09zdzh6ZO
         HA1AzXVmIV4k5BLBgXc5pNFFDyhDi6r3k4IC5A0Y+LKcmx7DTs3MZaekoWUeVF4OgaMx
         clsjLITtQYnJPVC1/iizueodZvd5gA5QRIcsLS0FbphKeNoHbJzvlI3ge3UZuYbPouzC
         Vi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/Ss3XekhoAeJW501j2lZN9cRIVhRSBmA8AmuXwTseos=;
        b=pUlRO0jcmoZXCg/uIGDh0OiP9FeIzTR/55HtJEVz05UIAB2vO2hMs06oDsjUXDW3WC
         UB4Tf9amuUT0bWWaOmzaZNqyXFJyo2J5VrBHIlUiJ9dNucUsaAKKg3TOzbiB5QRm+fBZ
         mYAiUHAzFTrxRy6wCFcTRjswHDvK8hr86jx3Uzopv9syAj36olfIO8qtf/jp7htCq2A0
         ljSoHe5hrtWqR6sKzm2Lz7EcYsAOuC27C32RwC1HdmuvmtQJUcS5hQIJsNiUryUyQacF
         t8+69jMuPMhkj4pfqjGP0m2Dz0M415v5E6/CPHfpyP3Rksk/9rVDhya++0FI0fmteW36
         E+mw==
X-Gm-Message-State: APjAAAVH7pzV8SGAOI5sEOZ9RRud+UhN4PsXZVxUyoZQKvvkPJIFO340
        M7E7Qnmk6XXWj5tIXqJpnCwmw2oI
X-Google-Smtp-Source: APXvYqzVG7hCS6Nzs2QqDdx1m8Y/SSCXSMRoPwHkzq4oMVA8lyuBeEmOOJAy6Q2Rx3dmKvansvlUMw==
X-Received: by 2002:a17:902:e7:: with SMTP id a94mr67793430pla.182.1558558413947;
        Wed, 22 May 2019 13:53:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::6565])
        by smtp.gmail.com with ESMTPSA id y16sm3811085pfl.140.2019.05.22.13.53.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 13:53:32 -0700 (PDT)
Date:   Wed, 22 May 2019 13:53:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522205329.uu26oq2saj56og5m@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
 <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
 <20190521174757.74ec8937@gandalf.local.home>
 <20190522052327.GN2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522052327.GN2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 01:23:27AM -0400, Kris Van Hees wrote:
> 
> Userspace aside, there are various features that are not currently available
> such as retrieving the ppid of the current task, and various other data items
> that relate to the current task that triggered a probe.  There are ways to
> work around it (using the bpf_probe_read() helper, which actually performs a
> probe_kernel_read()) but that is rather clunky

Sounds like you're admiting that the access to all kernel data structures
is actually available, but you don't want to change user space to use it?

> triggered the execution.  Often, a single DTrace clause is associated with
> multiple probes, of different types.  Probes in the kernel (kprobe, perf event,
> tracepoint, ...) are associated with their own BPF program type, so it is not
> possible to load the DTrace clause (translated into BPF code) once and
> associate it with probes of different types.  Instead, I'd have to load it
> as a BPF_PROG_TYPE_KPROBE program to associate it with a kprobe, and I'd have
> to load it as a BPF_PROG_TYPE_TRACEPOINT program to associate it with a
> tracepoint, and so on.  This also means that I suddenly have to add code to
> the userspace component to know about the different program types with more
> detail, like what helpers are available to specific program types.

That also sounds that there is a solution, but you don't want to change user space ?

> Another advantage of being able to operate on a more abstract probe concept
> that is not tied to a specific probe type is that the userspace component does
> not need to know about the implementation details of the specific probes.

If that is indeed the case that dtrace is broken _by design_
and nothing on the kernel side can fix it.

bpf prog attached to NMI is running in NMI.
That is very different execution context vs kprobe.
kprobe execution context is also different from syscall.

The user writing the script has to be aware in what context
that script will be executing.
