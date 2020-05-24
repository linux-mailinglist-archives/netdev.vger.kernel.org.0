Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881711DFE1C
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 12:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgEXKEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 06:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgEXKEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 06:04:06 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C64DC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 03:04:06 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 190so15182398qki.1
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 03:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/4uOlFNcEo9hHnnj68o/7kmzl4EqZZsXbxLZ4h+0H7k=;
        b=DvA5rBSHmLnO94fkMmbFmKdyWYB/0v8sJd/pAUol/S6brM3AtxJEYe7iRF4//JvLwv
         4X+9Hx/L6m+wwyf/Hhfoz8fIimBRWQujfqfgAX19nOjN76Qt2Jfx/dXjafVmTSqZ3QFq
         SEcjWYSGo5m3zErfkQ1noHSm58cmGAq3H8hidg3bZHv4Uwzd1m9Qpcpf8H8HUb4Df0E0
         qnUi6ibrkhXk/L1KXj4A6mLU+nQ2L3upt8cR/btfpuyteVVsAW+wUO/ZixoBCkKQqitN
         chgnCgkaj7QTcWMJG05yBVsfSG/4EU6H7vEHS1QFLLMr81vh2MCuObEiJUg59SOk0Y6/
         p72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/4uOlFNcEo9hHnnj68o/7kmzl4EqZZsXbxLZ4h+0H7k=;
        b=YNOBrH6NZy+w9+iJoUxkg5OjO9s7mhV+dM6LUHG8+WyBdQaUmnysHS4mPEMJjN2dna
         tqNpCjf/b6/ozKUmF0Et0L8moITn+pHeQ+J7lPqNivDK/LTtJpwmMe26zVnmOAs/OpSL
         vR7k/9VX35hpisYWDC718pAW59ztttJAylVGTLxajCM0HAqWEVRCm6WN/HtZBYb5tjN8
         cmotPLhhg58xwBK+No8vi6OWxvCa4g5Y5rFJeakhS0C2/9LN9OjQlqBTSZ6We1EidGpZ
         IchoIEgOdHT+WQqY9o9AnbLKAyFh0hJh5QoepOiJzX2n3YQdv1+/cIAqXKWu53fGaUSF
         Qugw==
X-Gm-Message-State: AOAM532dzredpr3dl0LRx7IZRrGI0lKSrpolkV0s4QZqRW2j29zv5uIH
        nMmMfGu0a4DZzpHY93jWBOc7jtz8sE1Cx3SM1HpcUO7RKHwxcg==
X-Google-Smtp-Source: ABdhPJzCx7UsUJqpbV5jk3kF06+e+1bk3dZx88aiao84qZVF70hXy7B4jjQQFRkRO80e5Wqc3R4ev8tmvqmyiyLdmq4=
X-Received: by 2002:ae9:f811:: with SMTP id x17mr13576849qkh.71.1590314645379;
 Sun, 24 May 2020 03:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
 <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
 <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com>
 <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
 <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
 <CAM_iQpV-0f=yX3P=ZD7_-mBvZZn57MGmFxrHqT3U3g+p_mKyJQ@mail.gmail.com>
 <CANxWus8P8KdcZE8L1-ZLOWLxyp4OOWNY82Xw+S2qAomanViWQA@mail.gmail.com>
 <CAM_iQpU3uhQewuAtv38xfgWesVEqpazXs3QqFHBBRF4i1qLdXw@mail.gmail.com>
 <CANxWus9xn=Z=rZ6BBZBMHNj6ocWU5dZi3PkOsQtAdgjyUdJ2zg@mail.gmail.com>
 <CAM_iQpWPmu71XYvoshZ3aAr0JmXTg+Y9s0Gvpq77XWbokv1AgQ@mail.gmail.com>
 <CANxWus9vSe=WtggXveB+YW_29fD8_qb-7A1pCgMUHz7SFfKhTA@mail.gmail.com>
 <CANxWus8=CZ8Y1GvqKFJHhdxun9gB8v1SP0XNZ7SMk4oDvkmEww@mail.gmail.com>
 <CAM_iQpXjsrraZpU3xhTvQ=owwzSTjAVdx-Aszz-yLitFzE5GsA@mail.gmail.com>
 <CAM_iQpV_ebQjZuwhxhHSatcjNXzGBgz0JDC+H-nO-dXRkPKKUQ@mail.gmail.com>
 <CANxWus-9gjCvMw7ctG7idERsZd7WtObRs4iuTUp_=AaJtHbSgg@mail.gmail.com>
 <CAM_iQpW-p0+0o8Vks6AOHVt3ndqh+fj+UXGP8wtfi9-Pz-TToQ@mail.gmail.com>
 <CANxWus9RgiVP1X4zK5mVG4ELQmL2ckk4AYMvTdKse6j5WtHNHg@mail.gmail.com>
 <CAM_iQpXR+MQHaR-ou6rR_NAz-4XhAWiLuSEYvvpVXyWqHBnc-w@mail.gmail.com>
 <CANxWus8AqCM4Dk87TTXB3xxtQPqPYjs-KmzVv8hjZwaAqg2AYQ@mail.gmail.com>
 <CAM_iQpWbjgT0rEkzd53aJ_z-WwErs3NWHeQZic+Vqn3TvFpA0A@mail.gmail.com>
 <CANxWus8GQ-YGKa24iQQJbWrDnkQB9BptM80P22n5OLCmDN+Myw@mail.gmail.com> <CAM_iQpV71mVNn30bgOzGyjxKeD+2HS+MwJBdrq8Vg-g2HzM1aA@mail.gmail.com>
In-Reply-To: <CAM_iQpV71mVNn30bgOzGyjxKeD+2HS+MwJBdrq8Vg-g2HzM1aA@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Sun, 24 May 2020 12:03:54 +0200
Message-ID: <CANxWus9v0Xn+RgyELT_fEOXiTUaf=z_GGCC695+Dy2LpXBcERg@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 7:57 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, May 19, 2020 at 1:04 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> > >
> > > Let me think how to fix this properly, I have some ideas and will pro=
vide
> > > you some patch(es) to test soon.
> >
> > Sure, I'll wait. I have plenty of time now with the main problem fixed =
:-)
>
> Can you help to test the patches below?
> https://github.com/congwang/linux/commits/qdisc_reset2
>
> I removed the last patch you previously tested and added two
> more patches on top. These two patches should get rid of most
> of the unnecessary resets. I tested them with veth pair with 8 TX
> queues, but I don't have any real physical NIC to test.
>
> Thanks.

I've tested it and I have to admit that your Kung-fu is even better
than mine :-D My large ruleset with over 13k qdiscs defined got from
22s to 520ms. I've tested downtime of interface during deletion of
root qdisc and it corresponds to the time I measured so it is great.

/usr/bin/time -p tc qdisc del dev enp1s0f0np0 root
real 0.52
user 0.00
sys 0.52

I've even added my patch for only active queues but it didn't make any
difference from your awesome patch :-)

Thank you very much. You helped me really a lot.
