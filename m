Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2333A191D28
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCXW55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:57:57 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45557 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbgCXW55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 18:57:57 -0400
Received: by mail-ot1-f66.google.com with SMTP id c9so184515otl.12
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AJW26+FaFvNw6dpRvcPnzmxmMPZWjWADWyHns5E1WKM=;
        b=i4LSfAAVIqG7PF4d5YFMIhwJRgN+Wqdo/g2634QLASg4mleAOwMaDA14pDlKDMxb0y
         Sq1kU6zQqtdg5/WHrSlsvgUmVgseMW+9EB4xyCtyM7b+Ftc4BRm9mlNUm5u1xxR9ixvs
         W0ePndgXAznhD7HkjeLaXOZWuWNQJDgS+EyDILAWhTwLq5RgrlgGgXXM1o7ZV5TSgip6
         eWMtzuuRMh3xoFbjPj2fLSLU7rpvOyyqxOouFPdFx4GUk29D3aovy8Xz9n6CyzlE7SMb
         zlBR+ry7oMSqefjHiOgU9h6hvKyK1sooxXLcmyge2denB2gmVylcrlcKgMaiLld+vBPD
         tg6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AJW26+FaFvNw6dpRvcPnzmxmMPZWjWADWyHns5E1WKM=;
        b=jYGWuBbVlnSuznmsTMP3GKQmckkRMY2AoKTrzt/nyPfGXm6s05RDjp5mYY2wWZ0LF7
         m1ot63zUpxPe555DH5YU5wBiKA8L5TtRu4me13SBQ3cLSS93FCZM9pBcVkBppwHFOzVS
         g82U/hg0V0ymRn/n07DrLF5eYvIyfxtRdJEwestJ4N58sweh3umU48jGsXCgiRNUyl7K
         emPe+sUTEhoW554+KmpjCUY4PK/pCe8opbIYSJpcTg4+HoGKZpRI92R9Q3mDZ7Ky83qo
         p0DRBJN0F1N5tfrPNXhgmOUk45MWj5EIAQlbzEAwqI8oPToHDTpF2Qzl8v4lU4b7IDpF
         eGcQ==
X-Gm-Message-State: ANhLgQ1jfeUsOhbn2kH2PUBSRqctmLHr4D7Kn0yJD3Mf6UXYj3tzDnf2
        OD9I8jk4/f8XTW4jMoCNIgwh76nbXWJDdZMAzzsq3QTc
X-Google-Smtp-Source: ADFU+vsUGbEPhQiQT9XWMCYc7DsFrxkVjAa+NWQB/kCu44et3bGlEcBmrYtlXP+p6xH9WyB/TZyqnovPiQIpIHbXbvk=
X-Received: by 2002:a05:6830:1e96:: with SMTP id n22mr303459otr.189.1585090676338;
 Tue, 24 Mar 2020 15:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com> <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
In-Reply-To: <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 24 Mar 2020 15:57:44 -0700
Message-ID: <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 9:27 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> Hello,
>
> Thank you for the reply!
>
> On Mon, Mar 23, 2020 at 7:18 PM Cong Wang <xiyou.wangcong@gmail.com> wrot=
e:
> > >
> > > perf trace tc qdisc del dev enp1s0f0 root
> >
> > Can you capture a `perf record` for kernel functions too? We
> > need to know where kernel spent time on during this 11s delay.
>
> See perd.data.{ifb0, enp1s0f0} here
> https://github.com/zvalcav/tc-kernel/tree/master/20200324. I hope it
> is the output you wanted. If you need anything else, let me know.

Hm, my bad, please also run `perf report -g` after you record them,
we need the text output with stack traces.

Also, do you have a complete kernel log too? If your network is completely
down, you need some serial console to capture it, kdump could also help
if you know how to setup it. The kernel log usually has some indication
for hangs, for example if we have too much to do with RTNL lock held,
kernel would complain some other tasks hung on waiting for RTNL.

>
> > > When I call this command on ifb interface or RJ45 interface everythin=
g
> > > is done within one second.
> >
> >
> > Do they have the same tc configuration and same workload?
>
> Yes, both reproducers are exactly the same, interfaces are configured
> in a similar way. I have the most of the offloading turned off for
> physical interfaces. Yet metallic interfaces don't cause that big
> delay and SFP+ dual port cards do, yet not all of them. Only
> difference in reproducers is the interface name. See git repository
> above, tc-interface_name-upload/download.txt files. I have altered my
> whole setup in daemon I'm working on to change interfaces used. The
> only difference is the existence of ingress tc filter rules to
> redirect traffic to ifb interfaces in production setup. I don't use tc
> filter classification in current setup. I use nftables' ability to
> classify traffic. There is no traffic on interfaces except ssh
> session. It behaves similar way with and without traffic.

This rules out slow path vs. fast path scenario. So, the problem here
is probably there are just too many TC classes and filters to destroy.

Does this also mean it is 100% reproducible when you have the same
number of classes and filters?


>
> > > My testing setup consists of approx. 18k tc class rules and approx.
> > > 13k tc qdisc rules and was altered only with different interface name=
....
> >
> > Please share you tc configurations (tc -s -d qd show dev ..., tc
> > -s -d filter show dev...).
>
> I've placed whole reproducers into repository. Do you need exports of rul=
es too?
>
> > Also, it would be great if you can provide a minimal reproducer.
>
> I'm afraid that minor reproducer won't cause the problem. This was
> happening mostly on servers with large tc rule setups. I was trying to
> create small reproducer for nftables developer many times without
> success. I can try to create reproducer as small as possible, but it
> may still consist of thousands of rules.

Yeah, this problem is probably TC specific, as we clean up from
the top qdisc down to each class and each filter.

Can you try to reproduce the number of TC classes, for example,
down to half, to see if the problem is gone? This could confirm
whether it is related to the number of TC classes/filters.

Thanks!
