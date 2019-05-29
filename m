Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1752E1DA
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfE2QES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:04:18 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37041 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfE2QES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:04:18 -0400
Received: by mail-lf1-f66.google.com with SMTP id m15so2552066lfh.4
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 09:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fB+cE1ut8lOVdr24ZDohYBT90Ji3/h8bhXQdn1faj1w=;
        b=C5m+Zu7u/SeSHtGLhmMKET9XoxgFL4mD6irfr1OzHmPMiWJG4UfEnieyQSYkdsDMbz
         NztjNr31dmPXfzZ3lzJfnhB89ckJVnCG+7h6ahdNAD3nNBS4e5GBGT7Q1FfvYy9A/d2t
         0el6ltxCkWdty489akWnO7C/D56fRp/QK9Gq1MjwNH7leTwcZQjo+IlSUGIig8cFaTMj
         0L15j3WZSxzF3+3o5zoKI9TCExfFDg6cBQTBs9JTWpIB8kHa3JpZKusP6gcb+AMIQUQC
         eUDOdkdjk2raExQ1k92WIgMi99ke3kB6JhKgkKl6aj9SVPgmPG4HF7X1pZT7PQ+Y3nOE
         WAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fB+cE1ut8lOVdr24ZDohYBT90Ji3/h8bhXQdn1faj1w=;
        b=DLzKHJlm2s13plo0zqpifHzU0XGuFkKp6q9VF99cLgjC0yM9dS96ICh5RxNVv5OD8x
         jdotycGm+LU5qhQTC4nuTzEcmS6/Pf9Motc5ak3koVjMo7CleVBR78kBS1rHR5rul/de
         yfQ9Iu1tc7TnPdXiAJtyipdsE/Yv6/0vDObI+MuF0u3m2Z5xrJZ2eN76WaBp+9DGAsn3
         QU/nJMw5J30VeErda5CP0hSCX0w35OsRmnchAMXxoVMyoqqDFmagVH1QPZGt5Ls6QYSb
         VHXkLICU5pySK3U9UYlPgcyngLMPUvtP52WFtKTrdACxdUaH24EReSB5v5ihWuxbCdPx
         DypQ==
X-Gm-Message-State: APjAAAUQAoPB1Uf9FRfgA+MVHiMi+as81G/dobI8bAEXl6If2GGBK+59
        JWMR03CtDJFHjI6knPjI+jofKczJqAB/iKYboOtW
X-Google-Smtp-Source: APXvYqyArKmcXTpF9obffp6rqvd9jlGrddtztE9fceghduTlG/S8zQkl5yFpMpSrjd7E8vT35Mvy/bolgsx3MCM9V/0=
X-Received: by 2002:a19:c301:: with SMTP id t1mr4444303lff.137.1559145850119;
 Wed, 29 May 2019 09:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco>
In-Reply-To: <20190529153427.GB8959@cisco>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 May 2019 12:03:58 -0400
Message-ID: <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Tycho Andersen <tycho@tycho.ws>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 11:34 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> On Wed, May 29, 2019 at 11:29:05AM -0400, Paul Moore wrote:
> > On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > >
> > > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> > > > It is not permitted to unset the audit container identifier.
> > > > A child inherits its parent's audit container identifier.
> > >
> > > ...
> > >
> > > >  /**
> > > > + * audit_set_contid - set current task's audit contid
> > > > + * @contid: contid value
> > > > + *
> > > > + * Returns 0 on success, -EPERM on permission failure.
> > > > + *
> > > > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > > > + */
> > > > +int audit_set_contid(struct task_struct *task, u64 contid)
> > > > +{
> > > > +     u64 oldcontid;
> > > > +     int rc = 0;
> > > > +     struct audit_buffer *ab;
> > > > +     uid_t uid;
> > > > +     struct tty_struct *tty;
> > > > +     char comm[sizeof(current->comm)];
> > > > +
> > > > +     task_lock(task);
> > > > +     /* Can't set if audit disabled */
> > > > +     if (!task->audit) {
> > > > +             task_unlock(task);
> > > > +             return -ENOPROTOOPT;
> > > > +     }
> > > > +     oldcontid = audit_get_contid(task);
> > > > +     read_lock(&tasklist_lock);
> > > > +     /* Don't allow the audit containerid to be unset */
> > > > +     if (!audit_contid_valid(contid))
> > > > +             rc = -EINVAL;
> > > > +     /* if we don't have caps, reject */
> > > > +     else if (!capable(CAP_AUDIT_CONTROL))
> > > > +             rc = -EPERM;
> > > > +     /* if task has children or is not single-threaded, deny */
> > > > +     else if (!list_empty(&task->children))
> > > > +             rc = -EBUSY;
> > > > +     else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > > +             rc = -EALREADY;
> > > > +     read_unlock(&tasklist_lock);
> > > > +     if (!rc)
> > > > +             task->audit->contid = contid;
> > > > +     task_unlock(task);
> > > > +
> > > > +     if (!audit_enabled)
> > > > +             return rc;
> > >
> > > ...but it is allowed to change it (assuming
> > > capable(CAP_AUDIT_CONTROL), of course)? Seems like this might be more
> > > immediately useful since we still live in the world of majority
> > > privileged containers if we didn't allow changing it, in addition to
> > > un-setting it.
> >
> > The idea is that only container orchestrators should be able to
> > set/modify the audit container ID, and since setting the audit
> > container ID can have a significant effect on the records captured
> > (and their routing to multiple daemons when we get there) modifying
> > the audit container ID is akin to modifying the audit configuration
> > which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
> > is that you would only change the audit container ID from one
> > set/inherited value to another if you were nesting containers, in
> > which case the nested container orchestrator would need to be granted
> > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > compromise).
>
> But then don't you want some kind of ns_capable() instead (probably
> not the obvious one, though...)? With capable(), you can't really nest
> using the audit-id and user namespaces together.

You want capable() and not ns_capable() because you want to ensure
that the orchestrator has the rights in the init_ns as changes to the
audit container ID could have an auditing impact that spans the entire
system.  Setting the audit container ID is equivalent to munging the
kernel's audit configuration, and the audit configuration is not
"namespaced" in any way.  The audit container ID work is about
providing the right "container context" (as defined by userspace) with
the audit records so that admins have a better understanding about
what is going on in the system; it is very explicitly not creating an
audit namespace.

At some point in the future we will want to support running multiple
audit daemons, and have a configurable way of routing audit records
based on the audit container ID, which will blur the line regarding
audit namespaces, but even then I would argue we are not creating an
audit namespace.

-- 
paul moore
www.paul-moore.com
