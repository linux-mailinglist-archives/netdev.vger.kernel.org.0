Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F601E2A2F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgEZShj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgEZShi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:37:38 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EECCC03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 11:37:38 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id w18so21469344ilm.13
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 11:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F6msjQph68W2RGzDe20+vAdeH/W1RpEOKzHMFnrwvYc=;
        b=HkUwzTXvpoyZKK9pXNw06/P19GTwIVTOSeWUMb0M1/+bVmQBPSxNTkZdOeuwJaHhtt
         rd7qQQsP9j9UzcxqvO+cLBx+I3G2neK3kogpoUIEcTgIw2qH6PwQN1TV7fqk9/EXKCDj
         D463D2kMZLyRlni0BHn8wIHYp8BZU6nV3FUZaVe+dzoKmQhTniICSNgT/GGUDY8uKa1K
         BqvQcGebxhuDtO9eJvm94P/nei1FwP4eYrBammt1VTrJ37+O4QA7gslSQgQBE2t9cdKl
         mTwahhDgOKUTbC8PQutNBmjqFiYFXgZvIfuNedvM7uAqVNToy12XVf6uu5UyCIzxdawT
         VUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F6msjQph68W2RGzDe20+vAdeH/W1RpEOKzHMFnrwvYc=;
        b=mRGR8zEdD8prGpVrWsRCg6n/YOffQxMQwEehUW9XPc6PaKbh9TbK6B+SLzPvu94u1+
         HUOawQxqOVpp/8Jthd2gcfrTNeTc3EjSeoX8i/UWOhW9kGawH3H1olWMJwBmxNJ6+BAs
         iBBlMD3oRy5bQWL3lPWgwc1ZkeJJgS5/e4Q167EbFMpJR4Bp7ECx5rqQ/tWErsY9eCgC
         bJmrcGOO7m7bSUOQFSsNod/SyrTGHbzfGyUfEZ3t4zIJgbIWp9Cx+IRJ2gNj5o/SZxVn
         BkPbpaC3tYA7H5Lt4v2UKFiKTp1tQ1TyLhq4wzB+VWAZyi6n7/eXoTYctHzLI+t+BuVc
         1w/Q==
X-Gm-Message-State: AOAM531FXenhrS6vuE5oFqiA/C/jXt3pjPZNXDJyOcTBT7wAtG1ahxLL
        PnnAdNbUp75MbGCcWRU3IQB+jINRwsOvT5MyzY92/w==
X-Google-Smtp-Source: ABdhPJzYnDXX/zXEohZ+4KUZ/tvx5tUC+emcCt9p/YBKAFaxSqK3MYPGvYOLwS9Layruak6BtYfIo3m7rYpRNKCAGN8=
X-Received: by 2002:a92:9e51:: with SMTP id q78mr2518272ili.268.1590518257677;
 Tue, 26 May 2020 11:37:37 -0700 (PDT)
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
 <CANxWus8GQ-YGKa24iQQJbWrDnkQB9BptM80P22n5OLCmDN+Myw@mail.gmail.com>
 <CAM_iQpV71mVNn30bgOzGyjxKeD+2HS+MwJBdrq8Vg-g2HzM1aA@mail.gmail.com> <CANxWus9v0Xn+RgyELT_fEOXiTUaf=z_GGCC695+Dy2LpXBcERg@mail.gmail.com>
In-Reply-To: <CANxWus9v0Xn+RgyELT_fEOXiTUaf=z_GGCC695+Dy2LpXBcERg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 26 May 2020 11:37:26 -0700
Message-ID: <CAM_iQpVY0rN4M8YTeYqXFH_hzMj2XXewyt6Mq5JYPE5oWc42BQ@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 3:04 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> On Tue, May 19, 2020 at 7:57 PM Cong Wang <xiyou.wangcong@gmail.com> wrot=
e:
> >
> > On Tue, May 19, 2020 at 1:04 AM V=C3=A1clav Zindulka
> > <vaclav.zindulka@tlapnet.cz> wrote:
> > > >
> > > > Let me think how to fix this properly, I have some ideas and will p=
rovide
> > > > you some patch(es) to test soon.
> > >
> > > Sure, I'll wait. I have plenty of time now with the main problem fixe=
d :-)
> >
> > Can you help to test the patches below?
> > https://github.com/congwang/linux/commits/qdisc_reset2
> >
> > I removed the last patch you previously tested and added two
> > more patches on top. These two patches should get rid of most
> > of the unnecessary resets. I tested them with veth pair with 8 TX
> > queues, but I don't have any real physical NIC to test.
> >
> > Thanks.
>
> I've tested it and I have to admit that your Kung-fu is even better
> than mine :-D My large ruleset with over 13k qdiscs defined got from
> 22s to 520ms. I've tested downtime of interface during deletion of
> root qdisc and it corresponds to the time I measured so it is great.
>
> /usr/bin/time -p tc qdisc del dev enp1s0f0np0 root
> real 0.52
> user 0.00
> sys 0.52
>
> I've even added my patch for only active queues but it didn't make any
> difference from your awesome patch :-)

Great! I will send out the patches formally with your Tested-by.


>
> Thank you very much. You helped me really a lot.

Thanks for testing!
