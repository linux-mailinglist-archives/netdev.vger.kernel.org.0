Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A331CC34D
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 19:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgEIRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 13:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgEIRp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 13:45:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D2EC05BD09
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 10:45:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t12so4467724ile.9
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 10:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nnruQUz5/Ril9x9+et0TLddIG/QJeMyZppa0fmv1kmY=;
        b=ewmptzXF+Gr1mvJITodTVkNElEYdKg5jRnl91FvwUHJe4vyWVABLXUZMS1PTvY2axY
         iN3Xk52UbDXBzJkk7MeXxJimn+8+2Zv1T0pAfzNpm7A7tC65SJBp1x68NCsrgEKe2cIC
         GRkZamJemjOVxmQnLe3TYgyv/j+57v3p1NZc24lDZedwImSM7LVWsocRHXzmjyF5JjYm
         FAbjuStMPC5LX9QdI6RGUlUZY+GI0CqgTRzwQO9q3R734AzS5VxzIVEDiy1QsNuwxN2W
         FPwS/wBHaRkYPKduow8hiu1KxABcxm0z5Hw9PYfFPY1LCBWQVy8wPmdT0T1KHimQm28f
         JjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nnruQUz5/Ril9x9+et0TLddIG/QJeMyZppa0fmv1kmY=;
        b=lDDK4FAkrJNWXFfMH1bZlQKRAt4HTxoABdYPbRJfvQt/suPBSpekR4cWM92TiHvPGF
         hHBKNpD2KoplJTn5gyBodHvGz41OBEg8i6ridYV9I77rAH1CzOL8SFr1JGjRIL/uk81L
         4aNxb4yMmtMqVC++/aE3NEa8eP+qavrZ/IvZqmzz6hGndUokMSLsk9jJDU9garxTWVx+
         G5CB5r1v8FlURI5UsAo1kCzJUAKebtB6i75SLb+t4nmCupfDIiWRZARtdsKCLoiTRd0p
         gFRLXbHhismgNyfkjUJv4BGAJWrA6R1Q7siuw9vLJOyu2bMLjzH3yxKo7nIgLPv4M7mF
         4A4A==
X-Gm-Message-State: AGi0PuYPgB7da5a2Hr9rHGx0PToADsr4tq3btSRv2D4ympS7R6Al7zmp
        m+a+U0tNg6Ql8SFwDV2O0t58AWTWdKoK6psWuqrX5A/5CdQ=
X-Google-Smtp-Source: APiQypJB2lv2thv585LZL2I5v6+62peH9ODSQonegDK2nVlaRSaVFKyCf/+STGJF88FEByehfzZpZEMpwE6FbtEn0Bo=
X-Received: by 2002:a92:af44:: with SMTP id n65mr8230372ili.61.1589046355692;
 Sat, 09 May 2020 10:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200509052235.150348-1-zenczykowski@gmail.com> <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr>
In-Reply-To: <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 10:45:42 -0700
Message-ID: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
Subject: Re: [PATCH] document danger of '-j REJECT'ing of '-m state INVALID' packets
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So I've never tried to figure out how things break, just observed that
they do - first many many years ago (close to 15ish) - between my wifi
connected laptop at home and my university server in the same city.
I've kept an INVALID->DROP rule in all my firewalls since then and not
had problems.  I vaguely recall seeing delayed packets when I debugged
it back then.

See for example: https://github.com/moby/libnetwork/issues/1090 for
others running into this.

Now we've hit an issue at work where a network misconfiguration has
asymmetric one way pathing with a result that some packets were
getting *massively* delayed, and it's been causing user firewalls to
generate tcp resets for 'too old' 'already ack'ed' packets (ie. dups).

While this is of course a misconfig, and it shouldn't happen, in
practice it sometimes simply does.
All it takes is for a packet to get into a long queue, and the network
path to shift (immediately after it) to a less congested path.
Due to bufferbloat those long queues can take seconds to drain and
exceed path rtt by orders of magnitude.

I *think* what happens is:

A non-final tcp packet gets massively delayed, the packet past that
makes it through to the receive, and triggers an ACK with SACK, which
makes it back to the sender and triggers a retransmit and the
connections keeps on making forward progress,  then eventually the
delayed packet arrives and it's no longer considered valid and
triggers a tcp reset.  Massively of course depends on the rtt and
retransmit aggressiveness.

Here's my attempt to demonstrate what I believe the problem to be:

(on a freshly booted clean/empty/idle fedora 31 vm)

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
modprobe ifb
ip link set dev ifb0 up
tc qdisc add dev ifb0 root netem reorder 99% 0% delay 10s
tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress u32 match u32 0 0 action mirred egress
redirect dev ifb0
wget -O /dev/null https://git.kernel.org/torvalds/t/linux-5.7-rc4.tar.gz
iptables-save -c

...
/dev/null                             [     <=3D>
                           ] 169.58M  2.93MB/s    in 45s
2020-05-09 10:35:44 (3.81 MB/s) - =E2=80=98/dev/null=E2=80=99 saved [177819=
073]
...
[31750:181080717] -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
[244:1403178] -A INPUT -m state --state INVALID -j DROP


Now if I reboot, and run the same script, except instead of the
INVALID/DROP rule I do
  iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
then the download never finishes (it hangs after 15MB @ 2MB/s and
eventually times out).

[4170:16758894] -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
[37:147454] -A INPUT -p tcp -j REJECT --reject-with tcp-reset

(arguably since this is a VM, and thus NAT'ed by my host, and then
again by the real ipv4 NAT, the setup isn't entirely clear, but I hope
it makes my point: INVALID state needs to be dropped, not rejected)
