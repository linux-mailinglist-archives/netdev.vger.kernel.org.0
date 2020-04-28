Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E761BC5B1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgD1QsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:48:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49074 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727957AbgD1QsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588092489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5gNsilDZQsJ69/kYoRFbJeYZPPecgDjxJ95W33Atd50=;
        b=Uvl75/FPat9+WZR26Pb/SC+/fIB5anl32EELAvh+Z+1wAzJL18kd07ZLVx5jWgnyD0Yg5h
        4d2Tg7wh5MqV+pf27/bYrLPTlEuB7z9kfqO+xGiAEtdjEk71XvuZvhTdWcFz+3MhuUvhyB
        UdywbBD9QFjbT5aeNW3VADtmd4pYpJE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-RWgXT6k9PU6ppbCZTGRdyA-1; Tue, 28 Apr 2020 12:48:08 -0400
X-MC-Unique: RWgXT6k9PU6ppbCZTGRdyA-1
Received: by mail-ed1-f70.google.com with SMTP id v18so8650379edr.15
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 09:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5gNsilDZQsJ69/kYoRFbJeYZPPecgDjxJ95W33Atd50=;
        b=kr8BDKw33bJMfKoQk6dxOgqEnG8xA9GGYXDqdieaVb4a1zPy1ht+lY1JwOgqAJgHkN
         wuJ7EtPpAQTN26Ke9sY+FgUW3S2OxWP5pVM9PEwGqLJ+xdsAgz8rplGRcV8IW2E3xd9I
         uD+zh4JfZbWXxzkl7puhvTqN0Evywo6D6yFl2xG3xSygeTlL555Pf7+N08Fw/2ygF08c
         7HeD7VpF1t/8DPc8QLoe07iStECcGJTWQXfC/4Fy6NVy0tcbtk3H02N66SnvhS1NZHyJ
         APUJvqM5Vzve5ildeUvZundWZImlocOzI7ANdLAkMdi2R+h5AK3AVaWbSvLUWlK6z5y+
         QfTQ==
X-Gm-Message-State: AGi0PuYFlBE3+B+kq0e6XiIk4WxjqbBVazVGMV6zKFo+XaYKVRGArsB3
        6HQ2eCQINBpwgZG192jGtvyk+g4VCfGwt5DYSkY0/6It/WQSPuNMpRj5RLfz53tfZjAly2Edycd
        oi/6hRJqVJn3hN8+J58eUSaO7TUONiBtb
X-Received: by 2002:a05:6402:1bc8:: with SMTP id ch8mr22996590edb.53.1588092486723;
        Tue, 28 Apr 2020 09:48:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypJUVzwIeXSdr8ltJYNXlVyyFpiyKv0hohKO6MH0z7qXa++lb+bnN6G7ZwP9fgNkE+JNLKtbbxskkYTNABwkVJc=
X-Received: by 2002:a05:6402:1bc8:: with SMTP id ch8mr22996575edb.53.1588092486476;
 Tue, 28 Apr 2020 09:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587572928.git.pabeni@redhat.com>
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Tue, 28 Apr 2020 18:47:55 +0200
Message-ID: <CAPpH65wNThD4Z5a1UMpkUpEPkgi5t6yDib14w-DR=+E4iuceHQ@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 0/4] iproute: mptcp support
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 3:39 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> This introduces support for the MPTCP PM netlink interface, allowing admins
> to configure several aspects of the MPTCP path manager. The subcommand is
> documented with a newly added man-page.
>
> This series also includes support for MPTCP subflow diag.
>
> Davide Caratti (1):
>   ss: allow dumping MPTCP subflow information
>
> Paolo Abeni (3):
>   uapi: update linux/mptcp.h
>   add support for mptcp netlink interface
>   man: mptcp man page
>
>  include/uapi/linux/mptcp.h |  89 ++++++++
>  ip/Makefile                |   2 +-
>  ip/ip.c                    |   3 +-
>  ip/ip_common.h             |   1 +
>  ip/ipmptcp.c               | 436 +++++++++++++++++++++++++++++++++++++
>  man/man8/ip-mptcp.8        | 142 ++++++++++++
>  man/man8/ss.8              |   5 +
>  misc/ss.c                  |  62 ++++++
>  8 files changed, 738 insertions(+), 2 deletions(-)
>  create mode 100644 include/uapi/linux/mptcp.h
>  create mode 100644 ip/ipmptcp.c
>  create mode 100644 man/man8/ip-mptcp.8
>
> --
> 2.21.1
>

Acked-by: Andrea Claudi <aclaudi@redhat.com>

