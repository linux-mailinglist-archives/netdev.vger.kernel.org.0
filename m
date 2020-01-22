Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12BF145DD3
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 22:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgAVV2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 16:28:20 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37063 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgAVV2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 16:28:16 -0500
Received: by mail-lf1-f66.google.com with SMTP id b15so734415lfc.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 13:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UlbIRxeN9Q76SjfgK7QR1Vwr+MWjG4ms1YscK+m3ZzA=;
        b=sjR3KohyzTMBY/tFrzlS/cG22yQtz+Kj0wlR28uWlOMMS98+mdyhDRY4wdLlRbRBWQ
         4VlXyQi9Pw2NSmQ8fvwn9NxitppXBQTEWwjARvDbpiJhj/K0Y2i1EITeGLzwZ9AH5V63
         j8XDebSAcj8dY4OSKlnr8BS/HvXVTvkfh1v1rMq9jtjpDyFdJqJ5TCN1NW8CiCsvMp5t
         Xhb80Ol0PeyJlSg/G7BNimSobNlNwIOJ510Xic8jSS7FVl0FfJkgEVDeG1eadjiSlAeb
         Czd8yw50v5cUx1XPONGfCW8/GGWBMBpXhutQp8L57JTt9oNAhGO4n84vU5u8OGXSD6G4
         ZanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UlbIRxeN9Q76SjfgK7QR1Vwr+MWjG4ms1YscK+m3ZzA=;
        b=joflQpHWoGVFXl2ExzyG0U0m8p2jMbCYQgMCHtPYrUnULigGQyQF0hGeJlWtwjep3Y
         cxsWXjvTuIXjsQZmf9uyt61PPjalbQJBqrc1oZ9nZlb8ti4WdF7+w68IiYMaPIbUkUsx
         ibGQjk3hlmEIRmhtmnWmGUVDM0kbIpD8yb5xIs1PrfrVQ1V1fpR2BJxyO2SG5yxZf0rb
         vDjvLxZj/6VyQ60MCNC5Y3PMLRkbgQba9KXNIENVgUPIjkhL/kOkMcB1E9D5BC1Q9tWC
         2B2QKJkfUP33WJyzO3XzB9c8YxechJMWPJAtNMAd9s3c47Nll6OsPr4VlAuv0TmScVMe
         MMUg==
X-Gm-Message-State: APjAAAXDpW7IQGqIrzmcoyyGwwtnKCxeo7gMAVzckY81wafq3Pk0XqSg
        EbD+0KtKtUISaYaCft3lMVJyZ2u02KrcxTNnUUZ/
X-Google-Smtp-Source: APXvYqzmCy0bZf7U/H8d37zLwqEk/uVU9XMfs5fLgp38rC119ErDsvdLgD7EkL0RZ3pxjNI9STqxXeIxXnoeDiUoytM=
X-Received: by 2002:a19:dc1e:: with SMTP id t30mr2878129lfg.34.1579728493389;
 Wed, 22 Jan 2020 13:28:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <70ad50e69185c50843d5e14462f1c4f03655d503.1577736799.git.rgb@redhat.com>
In-Reply-To: <70ad50e69185c50843d5e14462f1c4f03655d503.1577736799.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Jan 2020 16:28:02 -0500
Message-ID: <CAHC9VhTKE_3bOXs+UcpKDQhatKH92uY3Hy=JA4sXXVGOC0ek8A@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 02/16] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 31, 2019 at 2:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Implement the proc fs write to set the audit container identifier of a
> process, emitting an AUDIT_CONTAINER_OP record to document the event.
>
> This is a write from the container orchestrator task to a proc entry of
> the form /proc/PID/audit_containerid where PID is the process ID of the
> newly created task that is to become the first task in a container, or
> an additional task added to a container.
>
> The write expects up to a u64 value (unset: 18446744073709551615).
>
> The writer must have capability CAP_AUDIT_CONTROL.
>
> This will produce a record such as this:
>   type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 contid=123456 old-contid=18446744073709551615
>
> The "op" field indicates an initial set.  The "opid" field is the
> object's PID, the process being "contained".  New and old audit
> container identifier values are given in the "contid" fields.
>
> It is not permitted to unset the audit container identifier.
> A child inherits its parent's audit container identifier.
>
> Please see the github audit kernel issue for the main feature:
>   https://github.com/linux-audit/audit-kernel/issues/90
> Please see the github audit userspace issue for supporting additions:
>   https://github.com/linux-audit/audit-userspace/issues/51
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/proc/base.c             | 36 ++++++++++++++++++++++++++++
>  include/linux/audit.h      | 25 ++++++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 58 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |  1 +
>  kernel/auditsc.c           |  4 ++++
>  6 files changed, 126 insertions(+)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 397f8fb4836a..2d7707426b7d 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2356,6 +2358,62 @@ int audit_signal_info(int sig, struct task_struct *t)
>         return audit_signal_info_syscall(t);
>  }
>
> +/*
> + * audit_set_contid - set current task's audit contid
> + * @task: target task
> + * @contid: contid value
> + *
> + * Returns 0 on success, -EPERM on permission failure.
> + *
> + * Called (set) from fs/proc/base.c::proc_contid_write().
> + */
> +int audit_set_contid(struct task_struct *task, u64 contid)
> +{
> +       u64 oldcontid;
> +       int rc = 0;
> +       struct audit_buffer *ab;
> +
> +       task_lock(task);
> +       /* Can't set if audit disabled */
> +       if (!task->audit) {
> +               task_unlock(task);
> +               return -ENOPROTOOPT;
> +       }
> +       oldcontid = audit_get_contid(task);
> +       read_lock(&tasklist_lock);
> +       /* Don't allow the audit containerid to be unset */
> +       if (!audit_contid_valid(contid))
> +               rc = -EINVAL;
> +       /* if we don't have caps, reject */
> +       else if (!capable(CAP_AUDIT_CONTROL))
> +               rc = -EPERM;
> +       /* if task has children or is not single-threaded, deny */
> +       else if (!list_empty(&task->children))
> +               rc = -EBUSY;
> +       else if (!(thread_group_leader(task) && thread_group_empty(task)))
> +               rc = -EALREADY;

[NOTE: there is a bigger issue below which I think is going to require
a respin/fixup of this patch so I'm going to take the opportunity to
do a bit more bikeshedding ;)]

It seems like we could combine both the thread/children checks under a
single -EBUSY return value.  In both cases the caller should be able
to determine if the target process is multi-threaded for has spawned
children, yes?  FWIW, my motivation for this question is that
-EALREADY seems like a poor choice here.

> +       /* if contid is already set, deny */
> +       else if (audit_contid_set(task))
> +               rc = -ECHILD;

Does -EEXIST make more sense here?

> +       read_unlock(&tasklist_lock);
> +       if (!rc)
> +               task->audit->contid = contid;
> +       task_unlock(task);
> +
> +       if (!audit_enabled)
> +               return rc;
> +
> +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> +       if (!ab)
> +               return rc;
> +
> +       audit_log_format(ab,
> +                        "op=set opid=%d contid=%llu old-contid=%llu",
> +                        task_tgid_nr(task), contid, oldcontid);
> +       audit_log_end(ab);

Assuming audit is enabled we always emit the record above, even if we
were not actually able to set the Audit Container ID (ACID); this
seems wrong to me.  I think the proper behavior would be to either add
a "res=" field to indicate success/failure or only emit the record
when we actually change a task's ACID.  Considering the impact that
the ACID value will potentially have on the audit stream, it seems
like always logging the record and including a "res=" field may be the
safer choice.


> +       return rc;
> +}
> +
>  /**
>   * audit_log_end - end one audit record
>   * @ab: the audit_buffer

--
paul moore
www.paul-moore.com
