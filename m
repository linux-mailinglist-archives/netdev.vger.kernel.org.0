Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43F645BF7
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfFNL7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:59:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45947 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfFNL7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:59:52 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so5016200ioc.12
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 04:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LLLgmpoTVXv6y43WLYITULgAsXmLrY9yKnDRgLQ0kQM=;
        b=VbPnXASnlOA7KTEDpriBv20pEF6G0ki48xfikrfZGXqGDkTM/RjVSM/QTWdggUEqhB
         HF7V5MuwwVxoG8zygbwFXf6rX9yxJIpIDoAIYE9ya7uDjf4H1b9z3NmPPMbG6KDiymVc
         wor+ITruvDPmv5iMKLIpseJSdHWIx4TI16pTN3pZoQqUp+AlYKwiywFdWfUDab7KdGp6
         MwBqPcQkM776GiDeV4g2By9NQ7uyb14X5o0Dscg6tDjblFl852QYcnoUq45gqOB2KuX+
         urYp51pJ23yGmoNl6X3TNAT10Oil9RiUA7Bfw5P0Hnc3D3UicWXdKEw79+rtUzEqMqUs
         h10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LLLgmpoTVXv6y43WLYITULgAsXmLrY9yKnDRgLQ0kQM=;
        b=gTQMm/5uS0JKTon+k7mfk8/upcl4UXdzyp11vXekFzcDzWzsyh7O/q71uoAJnTAhc4
         GaW/legLP5lu/eiFAyWsdp+DUtIFbvW2yAkS5Tq6YyfG0k3XhSzmuhgys2p+Dwe3IKic
         6c2LhWf77Wb2GCu1m0TOsYXqDnSTnUG0ZeLIo7t7V5bac33cX0MAEqOK/G0A2dNpP9cZ
         IpSvYWF51CzeLV8Waw4J3nTX9wwoGEHjLwxaSZYMEKEa1s3ljD3aRZpOxJa5OpK/UgJ0
         vYGxpiE+/pnVJIMdCQZ800WfzY46fWO+7oT/+6fC5LQG/5ugMy5fbtL43XiLaQUDNRzB
         4pJw==
X-Gm-Message-State: APjAAAXGTux97tRFnCyJcR1hegYtDyl2WYcpVrGqchd8pM1Oo19en1Lm
        uJIqIYrv4ijLwcJV0g+rPGQDI33j4SsqyInsMqJ9Fw==
X-Google-Smtp-Source: APXvYqwdhhifa/6jrjHgAC7jKjxdAxN0RQ2SpaYxmsJ5d2sxuw7U1yaDEUXsm+ze+2d3zHATZDPZDAAzHTD52EKQ/Zw=
X-Received: by 2002:a5e:8210:: with SMTP id l16mr12903159iom.240.1560513592031;
 Fri, 14 Jun 2019 04:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
 <1560447839-8337-2-git-send-email-john.hurley@netronome.com> <20190614081004.GC2242@nanopsycho>
In-Reply-To: <20190614081004.GC2242@nanopsycho>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 14 Jun 2019 12:59:41 +0100
Message-ID: <CAK+XE=nojwLVmTd+LcAz8corC6zJD5SkVUSraW-FK3f3kAZK4Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: sched: add mpls manipulation actions
 to TC
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 9:10 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Thu, Jun 13, 2019 at 07:43:57PM CEST, john.hurley@netronome.com wrote:
> >Currently, TC offers the ability to match on the MPLS fields of a packet
> >through the use of the flow_dissector_key_mpls struct. However, as yet, TC
> >actions do not allow the modification or manipulation of such fields.
> >
> >Add a new module that registers TC action ops to allow manipulation of
> >MPLS. This includes the ability to push and pop headers as well as modify
> >the contents of new or existing headers. A further action to decrement the
> >TTL field of an MPLS header is also provided.
> >
> >Signed-off-by: John Hurley <john.hurley@netronome.com>
> >Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
> [...]
>
>
> >+              if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC]) {
> >+                      NL_SET_ERR_MSG_MOD(extack,
> >+                                         "MPLS POP: unsupported attrs");
>
> No need to break line here and couple other similar places in this code.
> Anyway, looks good otherwise:
>

Ok, let me respin with these line breaks removed.
I'll also retract patch 2 and repost when driver changes are there.
Thanks


> Acked-by: Jiri Pirko <jiri@mellanox.com>
>
> [...]
