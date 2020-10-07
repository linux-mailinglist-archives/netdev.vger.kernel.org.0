Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC0286626
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgJGRop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgJGRoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 13:44:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA81C0613D2
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 10:44:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y20so3272175iod.5
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 10:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pfDC6ggIxducMqfO00QLvs/+qts4BSr0MlBGQbUF5sI=;
        b=vMFVbnksLSPZMnYebhjUT4pIxkgnHQScv8TXqKYiHD7Tey0mttN6Jm7YgvKE112q6c
         V7Q3MnJr+DMM2vKK/VWBDd8U5bl2THi+iIx+Lc2Ih54oUyZo2j+ToXDbehTA3UYBGU2k
         Y9zYLFsSc9cVNwkxQ5FXkYmtSG3AZbcEUf62DMtG/bwnvvC96Aep8hHpQbqXvWwsZUvx
         ZqtD+LmKNwdVyfmSqD0QR3kFigx37oPHFwg12PIRzHUg85vCCVYgH9Cr5KhNoffqMJZg
         +RWJo0prz/wxD9AWFoOAwaPA9QvehFDpaEgL01gmuQnQ/louWCmUMokQurAOuA6XCWU7
         z6iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pfDC6ggIxducMqfO00QLvs/+qts4BSr0MlBGQbUF5sI=;
        b=tRPzXwn/MStgizsUIQyI8oGmjo2nJ2Yfp6p7sESwP3NbIGR+VGlZmYuCXyPefWKleg
         PSHp7od0ReNWL1P6zuo0rjgq6RCRQMqI4kq+cBG4XS+M5D5NWNVT0Cd1kbZEHlkMWq8d
         jSBgqw2PzIVpneaQCxe+1va7p+Eky4r7qdKiiZT/2odxV5KaSU3Pk0S/6QBt0o/8khG1
         uUKqcd9QSw4jt2ZYFmg1bw3469dK5mQLYVa5RbJw6JNUFTj7VKwscXihFoO/x2k4UtX2
         EobmZqmi9PQOEeW+7nirxZ5ufHXI8+yy5YNjAD7iMK/ud1p/9dxqpRMEmLWqPvXSUUNH
         PU9Q==
X-Gm-Message-State: AOAM533wVkSzK5hqST1KTRV+9Rs3s61aSxuqUb8CsvKlTI/wGFEhKMvS
        oOmViKTrQt806iVF/uLQWcQLz3bH4QEBDIDz+NasSQ==
X-Google-Smtp-Source: ABdhPJw56KeOvZD9f3lZerZIs35wHKjo02gHP4gf/z4zmdfhC7ZiyVYKxDFnV+0Cn95g24vnsirmCVTGtaprjEOvTDo=
X-Received: by 2002:a02:82c8:: with SMTP id u8mr3789531jag.61.1602092683565;
 Wed, 07 Oct 2020 10:44:43 -0700 (PDT)
MIME-Version: 1.0
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
 <160200018165.719143.3249298786187115149.stgit@firesoul> <20201006183302.337a9502@carbon>
 <20201006181858.6003de94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANP3RGe3S4eF=xVkQ22o=sxtW991jmNfq-bVtbKQQaszsLNZSA@mail.gmail.com> <a8b0dd01-bd6a-2a28-154e-c30a79ce3c83@gmail.com>
In-Reply-To: <a8b0dd01-bd6a-2a28-154e-c30a79ce3c83@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 7 Oct 2020 10:44:30 -0700
Message-ID: <CANP3RGcyTV2iWpSWt=Ekf9naE3sF3sKSz7j2jDaMV1AKYMVaNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1 3/6] bpf: add BPF-helper for reading MTU from
 net_device via ifindex
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > FYI: It would be nice to have a similar function to return a device's
> > L2 header size (ie. 14 for ethernet) and/or hwtype.
>
> Why does that need to be looked up via a helper? It's a static number
> for a device and can plumbed to a program in a number of ways.

Fair enough.
