Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E523618FC85
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCWSSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:18:01 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42521 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgCWSSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:18:01 -0400
Received: by mail-oi1-f194.google.com with SMTP id e4so2191270oig.9
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 11:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jYAxmfZ/v7ROdGlJTYxbTuYhqOJ+uPVs8CUXh+vm5HM=;
        b=qLJgYP1n4eWjFuk516x/edfm5D43yHApN18s1TohcyUkWNLgSl+pl7TPCBrZ+9J1m3
         gPkRd2cqYBEjAv9P7yZQxF11r5mZrj2fu0cXjbAnuSiEbMZi7Jq2Lwn2Rj08h6UKGUSV
         wfYPCJm2+eHPe8ZVxopEosWE/2my21n2YbTKf9fMva/ds/poE7fGekww5fEJhP7IoWPQ
         eolkNLLO0Al8diz3ffP8u3v7tUhqjX5fMlisPo6IzjxKPrjafOnG60S47tmx+QTQQMCI
         JUqaNyUxMDlLsc4CX+Az6cSC+AhGpVz3v1uZln9IMTcqN2K7ocznkFKyNosbivlI2WmA
         8eKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jYAxmfZ/v7ROdGlJTYxbTuYhqOJ+uPVs8CUXh+vm5HM=;
        b=NOupT+8O7WlmeYNWuGlex3f3BeNwsP8WaOKwqeJReoJQ/VYtTSeqNxkSJvWte/hf8/
         VXxe8t4aC+mo2/UQL/ERFLhVanXS6tFKyGh+2TYo7Kjk89HZvX4tQtBnbhz9a/+bsHW0
         3BRYEN8dK0UBUg1cLsawkrq+2T7uk+V8/Lquyz0qvt2Lb5eXRyg2EotbS+MWZvIqY4nU
         u5UjivVR44duQmhCQfYSLksXJs10gusIwS4yecDiuBxIUnpmigh++xbD10mOCnzxRYwF
         n5AYVAlBtqzKDvnw8aKT35JpIc5ECjPy9uiu9VoOJtidOalpbgEQO3Y9hB1kkXn8CrST
         eFsw==
X-Gm-Message-State: ANhLgQ08b1r7q83ZwjLwhIQRuT5Pj/kZEaWFq/yBZhSpdeEcocHz+4Ch
        7Ct3DaFDpvLWfG1xsvy5CJXLUZN3RqbZjx1gExE6INz+
X-Google-Smtp-Source: ADFU+vueCfJokYQuQje5OlqlOZH9imVpGv3YxaURmvKR0Xy5PcbttwAGS6hLZokaRx1gM5Gmtgo1wOncVCHn5NMh+Ic=
X-Received: by 2002:aca:4b56:: with SMTP id y83mr517190oia.142.1584987479835;
 Mon, 23 Mar 2020 11:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
In-Reply-To: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Mar 2020 11:17:49 -0700
Message-ID: <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, Mar 22, 2020 at 11:07 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> Hello,
...

> Recently I discovered the existence of perf tool and discovered that
> delay was between tc and kernel. This is perf trace of tc qdisc del
> dev enp1s0f0 root. Notice the 11s delay at the end. (Similar problem
> is during deletion of minor tc class and qdiscs) This was done on
> fresh Debian Stretch installation, but mostly the delay is much
> greater. This problem is not limited to Debian Stretch. It happens
> with Debian Buster and even with Ubuntu 19.10. It happens on kernels
> 4.9, 4.19, 5.1.2, 5.2.3, 5.4.6 as far as I've tested. It is not caused
> by one manufacturer or device driver. We mostly use dual port Intel
> 82599ES cards made by SuperMicro and I've tried kernel drivers as well
> as latest ixgbe driver. Exactly the same problem is with dual port
> Mellanox ConnectX-4 LX, Myricom 10G-PCIE-8B cards too. Whole network
> adapter resets after the deletion of rules.
>
> perf trace tc qdisc del dev enp1s0f0 root

Can you capture a `perf record` for kernel functions too? We
need to know where kernel spent time on during this 11s delay.

>
> When I call this command on ifb interface or RJ45 interface everything
> is done within one second.


Do they have the same tc configuration and same workload?


> My testing setup consists of approx. 18k tc class rules and approx.
> 13k tc qdisc rules and was altered only with different interface name.
> Everything works OK with ifb interfaces and with metallic interfaces.
> I don't know how to diagnose the problem further. It is most likely
> that it will work with regular network cards. All problems begin with
> SFP+ interfaces. I do a lot of dynamic operations and I modify shaping
> tree according to real situation and changes in network so I'm doing
> deletion of tc rules regularly. It is a matter of hours or days before
> the whole server freezes due to tc deletion problem. I have reproducer
> batches for tc ready if anybody will be willing to have a look at this
> issue. I may offer one server which has this problem every time to
> debug and test it. Or at least I would appreciate some advice on how
> to diagnose process of tc deletion further.

Please share you tc configurations (tc -s -d qd show dev ..., tc
-s -d filter show dev...).

Also, it would be great if you can provide a minimal reproducer.

Thanks.
