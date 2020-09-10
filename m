Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3EA2648F6
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgIJPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731028AbgIJPkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 11:40:05 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E2FC06138E;
        Thu, 10 Sep 2020 08:40:04 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c2so8749957ljj.12;
        Thu, 10 Sep 2020 08:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zzicv2Qa2DNfJdJPFjCRGIVBrkLEN8FAzv3CfrAcc6A=;
        b=QZh8rorQ5yQxBZTjb4hhiRlMwcK2Hzrbl2lrmCMA2e0wGb0iVPIGpV88LOyE5A2i8a
         DmtWmepBqG3+EtjEcXZmuLPQs7A5HelsYiiTB5OUbWva6b/lwZfnZ/+VF51qE/Nh+bSa
         B6Y2Fk5hUwWzUPeopqZebjgYnntJ46Kv8VAXACSk9pEvS0ow7OcLTaGYDkgJpWV1e7Oq
         bIwAvITZUk6XZavj1hazFU8eNX0KgdtitvkuS3eJR3ltWve8gk+MD0HeOWrobsCdbdl9
         RxV2KIMYZAI0vEwGexiCBWBY7QQsl4fnk2Yg73qghjLWnpliotZ384yHVKFrDTALS3v0
         n+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zzicv2Qa2DNfJdJPFjCRGIVBrkLEN8FAzv3CfrAcc6A=;
        b=grj6Y0sNAWw6lAiNjiX4Q5lAnUUFmVT6Mzt7d4AbE58dZiA9E3A0l9TOrdsQOS+zEK
         SE4MV9TPi5m45eXybPZt90XcDX/6OWKMQz5+fz4Ha8uf4tfMMVt/c2Vsol208sNz8k0x
         y5/7biFqsl3v9hjht+5wd+wLEEt58iaN3QLZnf9m/4dBIWpBHJza5RKCroz2tHY3YvP6
         uwcu359ionU/8le+xpBUOAX0OZOGiNd9TNKNvwizPwPU0GLB61sx4Qsbe6UOINVzLnzY
         /sDsYRZaeFzvUate3OYLiWjrwDPExsOw+OW9j5Tx9zwipDN4byZ/h1RNBKeGUcNn36bH
         omnw==
X-Gm-Message-State: AOAM532NoTlCh9l6ZwYJESwgNT8cR0ixNYBe15NNlgcBKJY94Qpe8w8j
        LHsZ6J8PwIqrojMf9W4hm3uF/+uQY2sUhOTrPbk=
X-Google-Smtp-Source: ABdhPJywjDOGUxixtn0n3d5YaaC1fnLxiGWM/sGvzMXKqP+3qbSDH/g2jPGLvW9L0l9Jq+8FOpHhbz7g8pPPoQCtpGI=
X-Received: by 2002:a2e:4554:: with SMTP id s81mr4970394lja.121.1599752400920;
 Thu, 10 Sep 2020 08:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com> <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
 <20200910023506.GT2531@dhcp-12-153.nay.redhat.com> <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
 <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com> <87o8mearu5.fsf@toke.dk>
In-Reply-To: <87o8mearu5.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 08:39:49 -0700
Message-ID: <CAADnVQLqCavfY6g7AYg=uJNE+236FQC1scJ9fcNRuAp_6Nmk6w@mail.gmail.com>
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 2:44 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Wed, Sep 9, 2020 at 8:30 PM David Ahern <dsahern@gmail.com> wrote:
> >> >
> >> > I think the packets modification (edit dst mac, add vlan tag, etc) s=
hould be
> >> > done on egress, which rely on David's XDP egress support.
> >>
> >> agreed. The DEVMAP used for redirect can have programs attached that
> >> update the packet headers - assuming you want to update them.
> >
> > Then you folks have to submit them as one set.
> > As-is the programmer cannot achieve correct behavior.
>
> The ability to attach a program to devmaps is already there. See:
>
> fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")

ahh. you meant that one.

> But now that you mention it, it does appear that this series is skipping
> the hook that will actually run such a program. Didn't realise that was
> in the caller of bq_enqueue() and not inside bq_enqueue() itself...
>
> Hangbin, you'll need to add the hook for dev_map_run_prog() before
> bq_enqueue(); see the existing dev_map_enqueue() function.

If that's the expected usage it should have been described in the commit lo=
g
and thoroughly exercised in the tests.
