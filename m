Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A0EBF683
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfIZQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:16:44 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40451 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbfIZQQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:16:43 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so8040387iof.7;
        Thu, 26 Sep 2019 09:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wOj2ubKac/qA8eXhMJEZi/pNxzljbrBKo4ifwNxjQ/k=;
        b=ZaNnDxWdJsWgQTelYjG9TMGf1HPErqrFfZ3TCWYy9XXxpkXZzMJKhq955d6IvM9G2a
         DotfXnFSnnRsLDMrzQAwt+/U9pbDjWCqWw6msnCKhF9cxleMkCCK2mzRo+aiEEW+fPDx
         sSS8LdqODbBWL76e9se8X2M1HyNcmSRvLFtSta6ivY//obRUmsRgo4JWP4AHOKPevnjx
         sFJENYBxEeHO1iQqjLQfx8+Uu27x/hynrscgOW3Da3koCaGCZeac5EmTtm4TKBfKqNXb
         uooktLBUDq6UNYj2LS2qDSTq9Jd6Zdq1HvjayonPlNfHwBWvXeT7M69uxmP7H7FDqDOa
         97bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wOj2ubKac/qA8eXhMJEZi/pNxzljbrBKo4ifwNxjQ/k=;
        b=FE3HeIXTlg0rSIwNjj2+CKieRCpmFLgcJ1RHgstuTp4ZaFVvgt9/eSa45urdHri+vE
         Q3ZMtvDJSYB4DqTLOrCgKdD2wX3qfuqYz07NBpna5/exFPCsupNt9H0xKnlX3iJZr5Cj
         H1643yHdeZO+f1L1bIS2vd/40pjw/ATBkKnURmwty8Y3WolrwjXSMSngB9zHubQAB10O
         QucyPe/gnvnutDrqjObJmEclFkStTo6Qdqqz/qxdo7/0Wy7xOvSCYr72Vg1o0L77Zamg
         PzI8JHxqOj8vwZdAIuf/9gpMFs7anCdOzNVHDhHUsDEYOdppEVxEZKNE3r60/bpg/OPG
         TLjw==
X-Gm-Message-State: APjAAAUzd3wip8wYu2SMyFm9CJcz18k7gHQwEn2kDUo0pd/Kmh5jpB+A
        /GRIokthO6a37pAESM++LgaukGBmL7I=
X-Google-Smtp-Source: APXvYqzLaSLrG+0sY3Df4XKOVK3xF7sJo+qkQMfHUv8BRQBw8Ql6lEIEH1/D8SusS5FKmQQXscEtbg==
X-Received: by 2002:a92:8c0a:: with SMTP id o10mr3373696ild.254.1569514602933;
        Thu, 26 Sep 2019 09:16:42 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i18sm884652ilc.34.2019.09.26.09.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 09:16:42 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:16:33 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     ebiederm@xmission.com (Eric W. Biederman),
        Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, brouer@redhat.com,
        bpf@vger.kernel.org
Message-ID: <5d8ce461cbb96_34102b0cab5805c4b9@john-XPS-13-9370.notmuch>
In-Reply-To: <87ef033maf.fsf@x220.int.ebiederm.org>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <87ef033maf.fsf@x220.int.ebiederm.org>
Subject: Re: [PATCH V11 0/4] BPF: New helper to obtain namespace data from
 current task
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric W. Biederman wrote:
> Carlos Neira <cneirabustos@gmail.com> writes:
> 
> > Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> > scripts but this helper returns the pid as seen by the root namespace which is
> > fine when a bcc script is not executed inside a container.
> > When the process of interest is inside a container, pid filtering will not work
> > if bpf_get_current_pid_tgid() is used.
> > This helper addresses this limitation returning the pid as it's seen by the current
> > namespace where the script is executing.
> >
> > In the future different pid_ns files may belong to different devices, according to the
> > discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> > To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> > This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> > used to do pid filtering even inside a container.
> 
> I think I may have asked this before.  If I am repeating old gound
> please excuse me.
> 
> Am I correct in understanding these new helpers are designed to be used
> when programs running in ``conainers'' call it inside pid namespaces
> register bpf programs for tracing?
> 
> If so would it be possible to change how the existing bpf opcodes
> operate when they are used in the context of a pid namespace?
> 
> That later would seem to allow just moving an existing application into
> a pid namespace with no modifications.   If we can do this with trivial
> cost at bpf compile time and with no userspace changes that would seem
> a better approach.
> 
> If not can someone point me to why we can't do that?  What am I missing?

We have some management/observabiliity bpf programs loaded from privileged
containers that end up getting triggered in multiple container context. Here
we want the root namespace pid otherwise there would be collisions (same pid
in multiple containers) when its used as a key and we would have difficulty
finding the pid from the root namespace.

I guess at load time if its an unprivileged program we could convert it to
use the pid of the current namespace?

Or if the application is moved into a unprivileged container?

Our code is outside bcc so not sure exactly how the bcc case works. Just
wanted to point out we use the root namespace pid for various things
so I think it might need to be a bit smarter than just the moving an
existing application into a pid namespace.

.John
