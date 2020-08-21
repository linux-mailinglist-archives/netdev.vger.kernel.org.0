Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4815224D2E1
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgHUKge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgHUKf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:35:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A2C061388
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:35:57 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so1716147eje.7
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 03:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UfDTMgAoZ6HDZRHxm7H17YcOG20MI+Jb1kNrrrwvdB4=;
        b=uUtixurF6KTDM6kpP2HNvJvSk9/Kjf3Tgp89eSeGR0liq1fB9l4tFE9fSEiFCEmJGS
         qfPJ1rLHNYFHiPkkqyA8IcY2zmFf+2k2MJYYr8TAtOyYTvppon5YJNU3DPRUQhodo0Vu
         GgfH9tYi0sj55bzF/gRqycDLW4yeDMiPuzh0DJIKsQX8/9dHm85Eio0TnFiBMW+45fAs
         Q++sCkGn0qccLQxJLIoe2PAP8d1/Iijhg1xnrKo8AaX0Z9K+irt0rmouhV6GZkhQ3xD1
         qjugGKyChHvXEAlaAUSzcIWjzqohu4ZtElkvFc29vfC5LHkBw82CkOvjL/x1WX2ldoEM
         TxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UfDTMgAoZ6HDZRHxm7H17YcOG20MI+Jb1kNrrrwvdB4=;
        b=EdLBSmye8L5pBr1HifIiCmugc2joqHKs9uy+FffbxCDR78dn2z6BH/Z0vCZ39Zg8QB
         /LMA87av/74GgZAuW1tK8k3sK+dV09wK0M3eARhg4Kcc7Sj5TFZrMx/BRCG+G9s6J1mC
         rRIKNYU7/ddu3wa70Xr4hm/UWqGjt7g4GxeWhd5slZ23mM7pb/yRjZaupsPU371vE8Ui
         rgs833JWhNCeAgJ9tCcqG6AAuhZnlEaQCTDHvIlYxwI1X8T89F6s/r7fWGt7N23jBNPU
         3xAHDG/WdzSDIekfFc0ATTgjgzUpiHRHc7+ACup9jqxhIBXPVGNp4tTbbSLjd856ACXP
         fHYg==
X-Gm-Message-State: AOAM530MYnPFXoTTKqoaDxgeC5OlcLk/py2ZfoaK0NgAN7tSUZB+to0C
        zxCOokQVQKAs6BnrQFgNzuk=
X-Google-Smtp-Source: ABdhPJx/xuJMa6TwJUt5ZLmBomCMnuO1W69z2G6lpocP8YAbX/RsLQYFGPqo/Z5IMOUaWHEcYXKxwg==
X-Received: by 2002:a17:906:b108:: with SMTP id u8mr2198268ejy.249.1598006155542;
        Fri, 21 Aug 2020 03:35:55 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id be25sm854785edb.18.2020.08.21.03.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 03:35:55 -0700 (PDT)
Date:   Fri, 21 Aug 2020 13:35:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Thompson <dthompson@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com,
        Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20200821103552.witwag6kgyfue6od@skbuf>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
 <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200820230439.5duakpmsg7jysdwq@skbuf>
 <20200820171431.194169ee@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820171431.194169ee@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 05:14:31PM -0700, Jakub Kicinski wrote:
> On Fri, 21 Aug 2020 02:04:39 +0300 Vladimir Oltean wrote:
> > On Thu, Jul 30, 2020 at 05:30:59PM -0700, Jakub Kicinski wrote:
> > > On Thu, 30 Jul 2020 18:53:58 -0400 David Thompson wrote:  
> > > > +
> > > > +	/* Tell networking subsystem to poll GigE driver */
> > > > +	napi_schedule(&priv->napi);  
> > > 
> > > _irqoff  
> > 
> > Hmm, I wouldn't be so sure about this particular advice. With
> > PREEMPT_RT, interrupt handlers are force-threaded and run in process
> > context, therefore with hardirqs enabled. This driver doesn't call
> > request_irq with IRQF_NO_THREAD, so calling napi_schedule_irqoff would
> > create a bug that is very, very difficult to find.
> 
> Doesn't PREEMPT_RT take a local_lock or some form thereof around the
> irq threads then? If it doesn't then we probably need one around NAPI.
> 
> Regardless even if that's the case this is an existing issue, and not
> something that changes how the driver API would look.

So the thread function is surrounded by local_bh_disable:

/*
 * Interrupts which are not explicitly requested as threaded
 * interrupts rely on the implicit bh/preempt disable of the hard irq
 * context. So we need to disable bh here to avoid deadlocks and other
 * side effects.
 */
static irqreturn_t
irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
{
	irqreturn_t ret;

	local_bh_disable();
	ret = action->thread_fn(action->irq, action->dev_id);
	if (ret == IRQ_HANDLED)
		atomic_inc(&desc->threads_handled);

	irq_finalize_oneshot(desc, action);
	local_bh_enable();
	return ret;
}

but that doesn't really help in the case of napi_schedule_irqoff.

You see, one of these 2 functions ends up being called (from
napi_schedule or from napi_schedule_irqoff):

void raise_softirq(unsigned int nr)
{
	unsigned long flags;

	local_irq_save(flags);
	raise_softirq_irqoff(nr);
	local_irq_restore(flags);
}

void __raise_softirq_irqoff(unsigned int nr)
{
	trace_softirq_raise(nr);
	or_softirq_pending(1UL << nr);
}

And the "or_softirq_pending" function is not hardirq-safe, since it
doesn't use atomic operations, that's the whole problem right there. It
really wants to be called under local_irq_save.

#define or_softirq_pending(x)	(__this_cpu_or(local_softirq_pending_ref, (x)))

So the only real (safe) use case for napi_schedule_irqoff is if you were
already inside an atomic section at the caller site (local_irq_save).
Otherwise, it's best to just use napi_schedule.

By the way, I tested on a 10G link and there wasn't any performance
impact on non-RT to speak of. This is because hardirqs are already
disabled, so local_irq_save() translates to only a check and no action
being taken.

Hope this helps,
-Vladimir
