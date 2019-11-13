Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF93FB0F4
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfKMNBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:01:03 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44162 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfKMNBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 08:01:02 -0500
Received: by mail-qv1-f68.google.com with SMTP id d3so735155qvs.11
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 05:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=FQZlZJfwGx5T8+OiXhUNJJSa05RBpNm89aoqb+QrgWA=;
        b=DU2qjGpBBELIAQFZkyE46qRhJAUoFIBCHdQYwgs1smwq9qhQ134AO5258AAhy6U+4b
         hHtwkJsqIleRzE/0LC+H+vO25MhzEcw1pjJvbx+UbVZ5mTvJ8vAiS/+w5ZYJrjlP+kz/
         bebgA00fmr0N2yJcI+r+pEfs6dpHO1OPHkXCHmPYfBHrXkYcE+I8oY5mh6OQL+uA2aqq
         1fgQ2c7ih8kH1wjsrtyxu9NYY82Trx2YP+hALT8CHz3zgrOxjMciLECdlsclQ+CIjFmu
         63CHsWQ4Nl90nKOW1k9bcFGfV4c1eSbBHJfHN6vleEc+G/TtI1L7nGwRoERmV4Dcl5zg
         tyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=FQZlZJfwGx5T8+OiXhUNJJSa05RBpNm89aoqb+QrgWA=;
        b=J6FbjcfgXEZakdg0bNl15O2cE3EJQxsbYAVoJbcpAe6FqmSAsB1VBLcG+BiUGvt/q8
         iz96lUc+JXRc/0R3gm14Za4wJA6jTd97cmTvuO4XpfvI4sUzsfJIY5WzisAAwUh/RY3k
         fsadbG0+0x7q8lnQBJgsgVfm7DfvnrNRwyg+VskFBAwFD7cJaS9AoQ9fvrWyeBpLi71u
         xHP+o3xPJME46Q3A2w2/6viPMTj38TpAJum3jNbWKuNy9cGJEdxPIXpMQKRzVLzWFvWz
         h2QYDHJ+xOkzkh1EOi4Jscci6PQp5CS0d44EcTntW/b783R/zhaaC4V1zxui1WzR3eIm
         tCgw==
X-Gm-Message-State: APjAAAUwlclzT846NOGd2qmED4csZVoGa7wtedzjXoB9lHD3rDC0A4J/
        /I1Zao5SFpeqqKRBHlcELbAYBQ+fpYaBFa30y8eNvV8XDiY=
X-Google-Smtp-Source: APXvYqyIW8ptob9SReFWK+XuQ3JsHSLEoBmPOmv3YAUtrmjUp7W7kujPT0J81cw3o1Kf88CUyj849W98YgNyqKn1OOQ=
X-Received: by 2002:a0c:baad:: with SMTP id x45mr1616938qvf.230.1573650061074;
 Wed, 13 Nov 2019 05:01:01 -0800 (PST)
MIME-Version: 1.0
References: <CABT=TjGqD3wRBBJycSdWubYROtHRPCBNq1zCdOHNFcxPzLRyWw@mail.gmail.com>
 <CAM_iQpUpof_ix=HJyxgjS4G9Mv5Zmno05bq0cmSVVN9E_Mzasg@mail.gmail.com> <CABT=TjGn8S3jy4bw6ShRpYJdcE3-H4fNaxEPGfNaxiEcxBtPrA@mail.gmail.com>
In-Reply-To: <CABT=TjGn8S3jy4bw6ShRpYJdcE3-H4fNaxEPGfNaxiEcxBtPrA@mail.gmail.com>
From:   Adeel Sharif <madeel.sharif@googlemail.com>
Date:   Wed, 13 Nov 2019 14:00:48 +0100
Message-ID: <CABT=TjEWnpD3oJCJXUUN9P+gGM+k1iS84LXdebfOTOCM+vHeCA@mail.gmail.com>
Subject: Re: Unix domain socket missing error code
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eventually Kernel OOM will start and kill the process:

[  581.134746] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1ubuntu1 04/01/2014
[  581.134816] Call Trace:
[  581.135550]  dump_stack+0x46/0x5b
[  581.135580]  dump_header.isra.35+0x5b/0x23c
[  581.135590]  oom_kill_process+0x20f/0x3d0
[  581.135603]  ? has_intersects_mems_allowed+0x6b/0x90
[  581.135623]  out_of_memory+0xe9/0x580
[  581.135630]  __alloc_pages_slowpath+0x9c9/0xd10
[  581.135640]  __alloc_pages_nodemask+0x237/0x260
[  581.135647]  filemap_fault+0x1eb/0x560
[  581.135656]  ? __switch_to_asm+0x40/0x70
[  581.135662]  ? __switch_to_asm+0x34/0x70
[  581.135667]  ? __switch_to_asm+0x40/0x70
[  581.135672]  ? alloc_set_pte+0x252/0x2f0
[  581.135680]  ext4_filemap_fault+0x27/0x36
[  581.135689]  __do_fault+0x2b/0x90
[  581.135694]  __handle_mm_fault+0x67e/0xae0
[  581.135704]  __do_page_fault+0x239/0x4b0
[  581.135713]  ? page_fault+0x8/0x30
[  581.135719]  page_fault+0x1e/0x30
[  581.135867] RIP: 0033:0x561979ac3050
[  581.136120] Code: Bad RIP value.
[  581.136140] RSP: 002b:00007ffe528f8668 EFLAGS: 00000246
[  581.136162] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00007fd49d85615d
[  581.136170] RDX: 000056197b832ac0 RSI: 000056197b832ae0 RDI: 000056197b82da30
[  581.136177] RBP: 000056197b82da30 R08: 00007ffe528f86e0 R09: 00007ffe5292d080
[  581.136184] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000245
[  581.136191] R13: 0000561979b357e0 R14: 0000000000000003 R15: 00007ffe528f86e0

On Tue, Nov 12, 2019 at 9:56 AM Adeel Sharif
<madeel.sharif@googlemail.com> wrote:
>
> It should but it is not used when two different sockets are communicating.
> This is the third check in the if statement and it is never called
> because the first unlikely check was false:
>
> if (other != sk &&
>         unlikely(unix_peer(other) != sk && unix_recvq_full(other))) {
>
> Thanks.
>
> On Tue, Nov 12, 2019 at 1:12 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Nov 11, 2019 at 5:41 AM Adeel Sharif
> > <madeel.sharif@googlemail.com> wrote:
> > >
> > > Hello,
> > >
> > > We are a group of people working on making Linux safe for everyone. In
> > > hope of doing that I started testing the System Calls. The one I am
> > > currently working on is send/write.
> > >
> > > If send() is used to send datagrams on unix socket and the receiver
> > > has stopped receiving, but still connected, there is a high
> > > possibility that Linux kernel could eat up the whole system memory.
> > > Although there is a system wide limit on write memory from wmem_max
> > > parameter but this is sometimes also increased to system momory size
> > > in order to avoid packet drops.
> > >
> > > After having a look in the kernel implementation of
> > > unix_dgram_sendmsg() it is obvious that user buffers are copied into
> > > kernel socket buffers and they are queued to a linked list. This list
> > > is growing without any limits. Although there is a qlen parameter but
> > > it is never used to impose a limit on it. Could we perhaps impose a
> > > limit on it and return an error with errcode Queue_Full or something
> > > instead?
> >
> > Isn't unix_recvq_full() supposed to do what you said? It is called inside
> > unix_dgram_sendmsg() to determine whether to wake up the dst socket.
> >
> > Thanks.
