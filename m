Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5E0193049
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgCYSYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:24:07 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:47070 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgCYSYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:24:07 -0400
Received: by mail-qt1-f182.google.com with SMTP id g7so3009817qtj.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qDLnUtbgC2zkMMgMhmhGvpjskgGnO5ZqHVVyspKy71s=;
        b=H6aw9+wQLpuL9cLNXLPGGW4LYQPwu/RKkOax8jon+Z0gYiaRNfHxEWUhjTT0z6PQeX
         DLkf7n6L4zzyUeLuzokH6u8wVd8cE+WCR+9mx2tKTfav7Tdn/uMWVO58Z21e0QZNT8rb
         Hj4fTqw975g+JjG2vPWzhuhBLO9OmzcVAyknJ3s701Zd2NSHxPACNmD6uCxm6aw4Gtzg
         ifxvbG7hujJqNg/I4FqYkNUvvQf/JNLjfYYz7YUebzoBcwaRFAXl04GUzUPkgMzR4xLm
         ewKgAfyd6WZWn5iM4c2Rs8XN84kwP4x2YOLsZZH/tYMJ6VIDwezWhPMAsGkl2huQf/Df
         UWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qDLnUtbgC2zkMMgMhmhGvpjskgGnO5ZqHVVyspKy71s=;
        b=P2VCX/tT6KRkm9Y+jzm0/dq5IpZMPq71GLFwG6C7JE2Z81E4jUS1yswKQlX9Ri/3jb
         +tShE7WhuVlSX32/VDK/iv5gWSIP2/Y6F7ieVFnRl9BfLDzRIZqNwdQGsPu8Ixg0vPB1
         nXymnUp3TgFJgPZp/mJF33IeeFzJ+47I+aVdp/OeVOzS0cAYmosN3+ONOsQxipH7sFm8
         pfvAPpdcelpnpWqdCxPkEc0CNGlkACFC2lsPmTon7h2dwimupt4JHw9/r/La9Xx7iyHN
         Z43Q++q9CZvko7X1ChqyE/NLv5POKP1yWDai3/KMCeNdMAjJtbXKRBmfP+5+/nMrkNKI
         Y8dg==
X-Gm-Message-State: ANhLgQ239aUSOSPTU7WF7UJGmCDkqZSCyiLVWyDCpTDCrKdSRcJw3/Nt
        iufU6Ixm9VxGGZV9GEF/RxyzN8n6CkCqGwfuunW8Dw==
X-Google-Smtp-Source: ADFU+vs79xrKFor2HvcB6PMiFh30xv9AuvOeaNEW0k8ISGVPIPqHa2M7fE6GlONDiCTiy37HG16PajOZYDCRpW5Aomg=
X-Received: by 2002:ac8:2939:: with SMTP id y54mr4312932qty.160.1585160645634;
 Wed, 25 Mar 2020 11:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com> <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
In-Reply-To: <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Wed, 25 Mar 2020 19:23:54 +0100
Message-ID: <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 6:43 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Mar 25, 2020 at 4:28 AM V=C3=A1clav Zindulka
> <vaclav.zindulka@tlapnet.cz> wrote:
> >
> > On Tue, Mar 24, 2020 at 11:57 PM Cong Wang <xiyou.wangcong@gmail.com> w=
rote:
> > > Hm, my bad, please also run `perf report -g` after you record them,
> > > we need the text output with stack traces.
> >
> > No problem. I've created reports on two servers with different cards.
> > See here https://github.com/zvalcav/tc-kernel/tree/master/20200325
>
> That is great!
>
> Your kernel log does not show anything useful, so it did not lead to
> any kernel hang or crash etc. at all. (This also means you do not need
> to try kdump.)

Ok.

>
> Are you able to test an experimental patch attached in this email?

Sure. I'll compile new kernel tomorrow. Thank you for quick patch.
I'll let you know as soon as I have anything.

> It looks like your kernel spent too much time in fq_codel_reset(),
> most of it are unnecessary as it is going to be destroyed right after
> resetting.

Yeah, I noticed it too.

> Note: please do not judge the patch, it is merely for testing purpose.
> It is obviously ugly and is only a proof of concept. A complete one
> should be passing a boolean parameter down to each ->reset(),
> but it would be much larger.

No judging at all. I totally understand this as prototype ;-)

>
> Thanks for testing!

I thank you! It may allow me to finally deploy a year of my work time.
