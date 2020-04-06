Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5111819FC88
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 20:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDFSJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 14:09:09 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:38002 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgDFSJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 14:09:08 -0400
Received: by mail-yb1-f194.google.com with SMTP id 204so347425ybw.5;
        Mon, 06 Apr 2020 11:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YerZdcxcQmsmPmbc7x3l9FNg9tmvbjAIdH163TSG1LM=;
        b=C3hh1cS14KFIfA2sbb6OW61jKT6Zea0KasgKyB/5198Mh0GTyceREUQ3TXh1fJoy60
         aqmMe+gR+t3Dt0EER1JxbS4MdKJGWi4dVaX/TUL+ye28lSgk1mgGVT9boLVvLMSx2L8y
         Vg7uqev+kgFvU46OX16LWH2RWg9DCSCYtNvspZAVTxHu6/o2p96pmo9xBryiQ9f8cnBi
         cNdRV359X/j2lCSFrbjMr4OIK3J6oEDoCk7sELPLvjv+2CrYfBsdar1rPFsiIknc5yVt
         mvXiO11tk1AIye2stB2lE/Pvst7v56WhBZdW7fsmhBcbDlhew1SqVZcwOZBjlSuVaRtK
         z1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YerZdcxcQmsmPmbc7x3l9FNg9tmvbjAIdH163TSG1LM=;
        b=Gc6UuhEVh82b4GgcaCEFs2Q+EG+rBNz8fxCaJejz06aYMI33IOgVxqASNAyh9jtGKX
         NqOlse9IzOL879sledZqgRv2FdWKvhJXYHyg+7+KK8azzi+da8/p3pBzwqwogSU1aykM
         i1KDh1pZsZ7NUKa4Gwn917DXvk0yHqudk+RAuogW3qAzB/Eil6i6L6HZQmqMQEi4udwm
         3KieRfKPo3woFQvBbwMeuU+s+OxFIPOQOfa7RlmCYiTc1c3lWnDnh0QfkyP2513nHZSL
         vqKiy6cCdtIOZ9G0zwsVHNSUeO05/Hvd+wJgnJ4h6b0g8a95EwYPkseMtLXtigl92Cnt
         8FwA==
X-Gm-Message-State: AGi0PuZES+9N8uB01LEkmjl0M9uNjT0rHjpSyPPmDccAViSJSG9an2wY
        k2AO9ltIspqCHOTXt6h+tWNK4krnSol2Vvaytuc=
X-Google-Smtp-Source: APiQypJNh0gfrRG+aUIvtwyV5pyFGfJIwXgdUOU3PFRpUCcp7aUGELXyXGkqfsUeqnbL0YixSStkauVyExmNu0ZwAhk=
X-Received: by 2002:a25:bb0b:: with SMTP id z11mr35630837ybg.400.1586196545618;
 Mon, 06 Apr 2020 11:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
 <87ftdgokao.fsf@tynnyri.adurom.net> <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
 <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com> <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
 <87imiczrwm.fsf@kamboji.qca.qualcomm.com> <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
 <CAFA6WYOjU_iDyAn5PMGe=usg-2sPtupSQEYwcomUcHZBAPnURA@mail.gmail.com>
 <87v9mcycbf.fsf@kamboji.qca.qualcomm.com> <CABPxzYKs3nj0AUX4L-j87Db8v3WnM4uGif9nRTGgx1m2HNN8Rg@mail.gmail.com>
 <35cadbaff1239378c955014f9ad491bc68dda028.camel@sipsolutions.net>
 <CABPxzY++YMBPTV4quAkYvEAMfULjMXLkVfNzwocwubno5HO2Bw@mail.gmail.com> <5575dfe84aa745a3c2a61e240c3d150dc8d9446f.camel@sipsolutions.net>
In-Reply-To: <5575dfe84aa745a3c2a61e240c3d150dc8d9446f.camel@sipsolutions.net>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Mon, 6 Apr 2020 23:38:54 +0530
Message-ID: <CABPxzYJHjaLH+ozyFZx1hwXrNxdHgJaardk-kn7d72y7RC-=hw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 8:36 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2020-04-06 at 19:55 +0530, Krishna Chaitanya wrote:
>
> > > iw phy0 interface add wlan0 type station
> > > ip link set wlan0 up
> > Ah okay, got it, thanks. Very narrow window though :-) as the
> > alloc_ordered_workqueue
> > doesn't need RTNL and there is a long way to go to do if_add() from
> > user and setup
> > the driver for interrupts.
>
> True, I do wonder how this is hit. Maybe something with no preempt and a
> uevent triggering things?
Probably, it might be specific to the dragonboard410c configuration

> > Again depends on the driver though, it
> > should properly handle
> > pending ieee80211_register_hw() with start().

> It could, but it'd be really tricky. Much better to fix mac80211.
Sure, anyways it is a good change.
