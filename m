Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B7B852A9
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbfHGSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:06:11 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36623 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388207AbfHGSGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 14:06:10 -0400
Received: by mail-ot1-f65.google.com with SMTP id r6so107874666oti.3;
        Wed, 07 Aug 2019 11:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+5R4J1htvoOqukWiNkz3TUtersJFfhNaT6AsqrjW57o=;
        b=KjN3suuas12IfPpzJiwu38i8FC/GaRazpBW95nkRJbm+EIUzSpvfOTZ1rSYD8n6N18
         8PnNCu/WbOvVcg/toTe5mDYDN4AKO5PrBxi+WZRS6cRg64sl8nzeW6ZmxxTBY+LdXIHM
         D7UBOZRQ4V3daSLunb0zxIz0RbOcYygJVgV3Tbzwio41TDv+mNdABhqerR33LrYrbuFE
         4TOqZxRea9UC+gZz5uHZHU5ZOJh/WqMAqgKp5WH56ahz14/MCce+3Im0+35yIsOtNV1J
         QcA017FIiDogdXS21PfYcDSj7KOZfkfv08JS8IMyMppnbBLGVUZdXt3HBkSST5cnDVit
         fryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+5R4J1htvoOqukWiNkz3TUtersJFfhNaT6AsqrjW57o=;
        b=qV7TzERehwX8zLCnsHsiQjt/AbDxbQLrSy5BCGlrPYAUsr9SsTnGRF014iigOC/Rh4
         /m5gLl1+pmGByJMtFfR7dkvQvOP/LSBq8rpDnKR0dQykJiXYJzGQ64BfetXSrkXdbezS
         8usMae2NaebV7ihEKKiSKhXWp0I3Ntw8r7B0QoK7yYezUZamSnA8ZfBJAgApgMA8u2lJ
         mMZMh/A10aS02HqWhvY9AsCCSrEb6jT5SQy3p0Pnx7qisNpWaEqcPGA2sGl+mDPzswuV
         9nFAiyk/jRgL7nLBqWEhWSasW375uLLWIOYtFLH7Ucwc8L1yqFarRfj1fMZHYGDP1y/n
         NAJQ==
X-Gm-Message-State: APjAAAUB+a/dUZcsKxXQ0GHSOIYPVuFT+ioAqNQ7+4BSwivwbK4mVV88
        z8dvw2ZVg4JLyqQ7UO447uCne38FIYjPLGWR/yc=
X-Google-Smtp-Source: APXvYqzVlu3RnsadhUtEJwhwxBtuPAxbbIuftA4oZS8arPvawcxIEbC10cg+nnmxUucFPlH4u5i7ZTLiJggwundIQgc=
X-Received: by 2002:a5e:8a48:: with SMTP id o8mr1447804iom.287.1565201169430;
 Wed, 07 Aug 2019 11:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <156518133219.5636.728822418668658886.stgit@firesoul> <156518138817.5636.3626699603179533211.stgit@firesoul>
In-Reply-To: <156518138817.5636.3626699603179533211.stgit@firesoul>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 7 Aug 2019 11:05:33 -0700
Message-ID: <CAH3MdRV+LUuKpbUJFzqFrodEDbfm5aif+qmzWsUJYSFGQyCMow@mail.gmail.com>
Subject: Re: [bpf-next PATCH 3/3] samples/bpf: xdp_fwd explain bpf_fib_lookup
 return codes
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Xdp <xdp-newbies@vger.kernel.org>, a.s.protopopov@gmail.com,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 5:38 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> Make it clear that this XDP program depend on the network
> stack to do the ARP resolution.  This is connected with the
> BPF_FIB_LKUP_RET_NO_NEIGH return code from bpf_fib_lookup().
>
> Another common mistake (seen via XDP-tutorial) is that users
> don't realize that sysctl net.ipv{4,6}.conf.all.forwarding
> setting is honored by bpf_fib_lookup.
>
> Reported-by: Anton Protopopov <a.s.protopopov@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
