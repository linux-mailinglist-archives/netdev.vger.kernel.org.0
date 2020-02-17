Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67E9F161B91
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 20:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgBQTYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 14:24:43 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36052 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbgBQTYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 14:24:43 -0500
Received: by mail-qt1-f196.google.com with SMTP id t13so12830308qto.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 11:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JIJCYoeJZi1BF4DfYx9tVVCS/hUoszz7+fHwROsJ/sg=;
        b=XhfvhwYnBIK/WesduUEBtjCLLyg3HK5iR0ADqhQf7XKcPzSMZ9DoPvWMTwo8CVK9hd
         K92GqoXzrg79sURfb1CFsaHPXP3fWZWih+xbekMovSOT5URkz+zM4Mmi93FQiwPvwPSQ
         3QB8/m0jb9Le4OUoZ+RR6H6vOV7b/RK4a6EQHlA+jgjM8oHHUYW2g0ovMSAThXIex9M5
         sSAsbCOpNXhwERWCtSo2z5ji5yWD65fD70bqqS7jElMIHKSmaa0a0qABHDm0nIL8XrGX
         b5mHKLKhOjywqoFjKP4cWDPIRRNSNiFFrqqqQ/NcHDEQyu6UZcA7P0hSQ9MjzKcThyg1
         akRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JIJCYoeJZi1BF4DfYx9tVVCS/hUoszz7+fHwROsJ/sg=;
        b=Hp4SAnkXrMAJG4UmpuHsIVKHNxybLkvsIe7Nj2SBap0w6ucCD0MEKeRDQJ5rqDXa9Q
         mCgjUcLEp8ab2YxX/YDH1NutRYQpYhODdBQoXGysCbIrocicY1fcOG/+47mIT93Yaxw2
         wkbey9oVYJiF+h96lJsvdNMck05yd/w/McKU81f1WJj9FvZhbKYD0ElN0gumEB8SlE3O
         3B+JMZiWx/30YibhANEuOcN8nLJzm4jE9RM1ExmEKlTW4/Ysr40dqN66efPIaKE6fgCD
         t8Niwq0joqR97v6myRhvrQLje+LcthGZ62fGqW5ah7qUxIDGSuQnbyB5UAJhBMUi+ggA
         VDZA==
X-Gm-Message-State: APjAAAW011qgdxsU3WWc97qE5wVccwRC+R2OG1sfcSV0Nd2EuGPHVU4E
        pcpgDKXgRulIebHYlRytDCeIuPOf+YUzhKw/PTaL6A==
X-Google-Smtp-Source: APXvYqxzV0kH2vSIgFPc02FvrnF/SPy8sz7uAskPUxbXNJCk+2tUtc7DjPEHrVOaM6ByqoCgeGeTp2teVfzLlb5yhLI=
X-Received: by 2002:ac8:7159:: with SMTP id h25mr14505780qtp.380.1581967481700;
 Mon, 17 Feb 2020 11:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
 <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
 <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
 <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
 <CACT4Y+a8N7_n4t_vxezKJVkd1+gDHaMzpeG18MuDE04+r3341A@mail.gmail.com> <CACT4Y+atqrSfZuquPZcRUKNtVbLdu+B5YN3=YmDb38Ruzj3Pzw@mail.gmail.com>
In-Reply-To: <CACT4Y+atqrSfZuquPZcRUKNtVbLdu+B5YN3=YmDb38Ruzj3Pzw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 Feb 2020 20:24:30 +0100
Message-ID: <CACT4Y+bMzYZeMvv2DdTuTKtJFzTcHhinp7N7VmSiXqSBDyj8Ug@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 4:42 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > Observation:
> > >
> > > It seems to be starting to synthesize packets sent to the wireguard
> > > socket. These aren't the proper handshake packets generated internally
> > > by that triangle commit, but rather ones that syzkaller creates
> > > itself. That's why we have coverage on wg_receive, which otherwise
> > > wouldn't be called from a userspace process, since syzbot is sending
> > > its own packets to that function.
> > >
> > > However, the packets it generates aren't getting very far, failing all
> > > of the tests in validate_header_len. None of those checks are at all
> > > cryptographic, which means it should be able to hit those eventually.
> > > Anything we should be doing to help it out? After it gets past that
> > > check, it'll wind up in the handshake queue or the data queue, and
> > > then (in theory) it should be rejected on a cryptographic basis. But
> > > maybe syzbot will figure out how to crash it instead :-P.
> >
> > Looking into this.
> >
> > Found the program that gives wg_receive coverage:
> >
> > r0 = openat$tun(0xffffffffffffff9c,
> > &(0x7f0000000080)='/dev/net/tun\x00', 0x88002, 0x0)
> > ioctl$TUNSETIFF(r0, 0x400454ca, &(0x7f00000000c0)={'syzkaller1\x00',
> > 0x420000015001})
> > r1 = socket$netlink(0x10, 0x3, 0x0)
> > ioctl$sock_inet_SIOCSIFADDR(r1, 0x8914,
> > &(0x7f0000000140)={'syzkaller1\x00', {0x7, 0x0, @empty}})
> > write$tun(r0, &(0x7f00000002c0)={@void, @val, @ipv4=@udp={{0x5, 0x4,
> > 0x0, 0x0, 0x1c, 0x0, 0x0, 0x0, 0x11, 0x0, @remote, @broadcast}, {0x0,
> > 0x4e21, 0x8}}}, 0x26)
> >
> > Checked that doing SIOCSIFADDR is also required, otherwise the packet
> > does not reach wg_receive.
>
>
> All packets we inject with standard means (syz_emit_ethernet) get
> rejected on the following check:
>
> static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> {
> const struct iphdr *iph;
> u32 len;
>
> /* When the interface is in promisc. mode, drop all the crap
> * that it receives, do not try to analyse it.
> */
> if (skb->pkt_type == PACKET_OTHERHOST)
> goto drop;
>
> Even if we drop IFF_NAPI_FRAGS which diverges packets who-knows-where.
>
> Somehow we need to get something other than PACKET_OTHERHOST...
> Why is it dropping all remote packets?...
> How do remote packets get into stack then?...

I've managed to create a packet that reaches wg_receive, that is:

syz_emit_ethernet(AUTO, &AUTO={@local, @empty, @void, {@ipv4={AUTO,
@udp={{AUTO, AUTO, 0x0, 0x0, AUTO, 0x0, 0x0, 0x0, AUTO, 0x0, @empty,
@empty, {[]}}, {0x0, 0x4e22, AUTO, 0x0, [], ""/10}}}}}, 0x0)

Had to enumerate all possible combinations of local/remote mac,
local/report ip, local/remote port.

However, this is only without IFF_NAPI_FRAGS. With IFF_NAPI_FRAGS it
reaches udp_gro_receive, but does not get past:

if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
    (skb->ip_summed != CHECKSUM_PARTIAL &&
     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
     !NAPI_GRO_CB(skb)->csum_valid) ||
    !udp_sk(sk)->gro_receive)
    goto out;
