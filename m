Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09E6135311
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgAIGJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:09:30 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38011 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgAIGJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:09:29 -0500
Received: by mail-qk1-f195.google.com with SMTP id k6so4999191qki.5;
        Wed, 08 Jan 2020 22:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X+RhLbVc3KJZZjKfiDgwDLr/Cdtt/34QV4MsKViVdGg=;
        b=OqiPkOt9FJmPq8svPyvQB/Eh/HkjS965/26GzpewZtw4twZtJYZ+V5Va+jsNJI9hEx
         C1Kbhz+FzWHMWfKy5+MPObB5T9kugUpgiVBI9fmqYkCnEJe0KmnzzigJT6aj63UnKFHp
         vpf1o7ww9G5pn6bFvdUbcfz4kyL/sBzJ8DOyNY4bLsAuJCbENGR8CUvwJlZxH7ApLwxN
         Kqb4s55v6KUPQlNUhzFY3Ec2yRTn2wTMBh0kzFsHF66wKfQzUkeXMLZ3TEbpbZIduDQp
         IrpseRuJsiBFqudr9Ws9UYa58bTQocoq0IyiuY7AgZXGoJaWnSQcL5Y8PA0ZNQCBVHHN
         tKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X+RhLbVc3KJZZjKfiDgwDLr/Cdtt/34QV4MsKViVdGg=;
        b=qv7TVETjCNiCQ/+oRPYTanqzKV1ArADHCciTS0ClKMdHLiuGfZAhaIPOf7ZATyKAZq
         NZy53byVic7dcETXUd4NrlvGyYZn1kbAC6WykZmOSA7Q6HCQm1n5LQpU6+cQEvKOhNN0
         3W8Ghj7gLf5qHjzMXqS7tPVEguWJqsjN330xQTu1YJo8XPbp7GbTt183h7LsZw24tupQ
         VtFJLpeYZ30IyrVDNsTZ1B9K7TVHcxW4mkGJD+DVWs/2OKRJwn77goJDQmSo6+dEE+ID
         oQlqqKV1tSFx8UyTLee0du07mkMl3/f5Wic0eiFP4VQFLNIKoAWCeBDF14+u6bifH8hc
         uWkw==
X-Gm-Message-State: APjAAAVbP3o0ApZQicW3nJ2MTeHm8R1ebnoVClXgATMwoMwqFZDTmlpW
        MP/o8tCUZBHOqX8wI59+4FYRbpqQkFNcaDtSCJ4=
X-Google-Smtp-Source: APXvYqzCE9JoeRyZ8YZ6++pQz1TRJTqR3biFwZkc62cyUb2OyjvsnNox9uyPDyPeQid7XpVrRKhJZ0G71AtbcKyWTXk=
X-Received: by 2002:a37:63c7:: with SMTP id x190mr7926002qkb.232.1578550168691;
 Wed, 08 Jan 2020 22:09:28 -0800 (PST)
MIME-Version: 1.0
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
In-Reply-To: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 9 Jan 2020 07:09:17 +0100
Message-ID: <CAJ+HfNiK4g9Ak_ZBSMP1bQXSOLJELu1=Hfs+o02MXVWy1H2z3g@mail.gmail.com>
Subject: Re: [bpf PATCH 0/2] xdp devmap improvements cleanup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jan 2020 at 22:34, John Fastabend <john.fastabend@gmail.com> wrot=
e:
>
> Couple cleanup patches to recently posted series[0] from Bjorn to
> cleanup and optimize the devmap usage. Patches have commit ids
> the cleanup applies to.
>
> [0] https://www.spinics.net/lists/netdev/msg620639.html
>
> ---
>
> John Fastabend (2):
>       bpf: xdp, update devmap comments to reflect napi/rcu usage
>       bpf: xdp, remove no longer required rcu_read_{un}lock()
>

Thanks for the clean-up, John!

For the series:
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

>
>  kernel/bpf/devmap.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> --
> Signature
