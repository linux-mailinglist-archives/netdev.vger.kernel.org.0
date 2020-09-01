Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59560258E4D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgIAMim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgIAMfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:35:41 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7274FC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 05:35:41 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id q13so491087vsj.13
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 05:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rvscO42kTLE4I55y39xCrJn+ERkQJ5/Mglmm1ABv6fE=;
        b=fj7YuGE4s3HT171PfHKRgaqj5y9ov0rSIJxTPu/dgpeBGHlAi7SPgNuN3r/gdnnGWZ
         9f21yGtcZsv9R6QLGiOeRZH0yIRRgCDIpEPY+oSRqMY776YcFWNlWroBliy69cbegphF
         5NxiFIHdWFLbptH98lVdXeYgK7wdVm4DZEXcKqDH2j20cq5U2t+2lfk2q7Ztctypcfcz
         5+T7SY924p0hFNQrrMyXIEB3GWHctPt0MClenBVb5hlGTwOgoQwk8hqrt4Q/v4pzQoEK
         hp9jvYCvt9Z5Dq6sy9sL/0tUwicvbYYI7atGOZt2Mz2fTJ4qCFoQ6u7RmOEuevmKWFiJ
         LscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rvscO42kTLE4I55y39xCrJn+ERkQJ5/Mglmm1ABv6fE=;
        b=ovo+FlkwF/owPA8IPVX08EKmBdx9G3gljs0+oPy3broaTJN/1mf2H9XDWFgXuOVCTH
         RvLJB9rwMTccpyddMr7uSY4wQ7BZd8fJ1JoP/y4gsIKi9aTb3LKjsg3PlNts6fLr4DRx
         CgQ00J+G+cOsCtss3TZXRiMwvgmtlb7GElA1S/7s58mtKEXqGZdgTQ7+aSoD+kvYsvsY
         Oj+W5s8vd1V1ahcufunWMWwqbwThLJsjoRrtk0DoyGIlGbkS0k9ue5gP7icpizYxiQtx
         CLHu/0dImTABzrYmg7MkfyTfaJKn9tETTcfNoWSz47i3RpMyhSpUwTe7Wwb9PoGCZdmb
         dtzA==
X-Gm-Message-State: AOAM532IHAlRbaAeJ0OqUjed3V3+QPKN3XsDvKjOod17DuTWRdUlHRwL
        e0qZFQkIRrQlGRRp7mIEqvhtMbNNuhX1nhpIHXA=
X-Google-Smtp-Source: ABdhPJyWjOtI6453HAt+DdwV2HLTLsPeYtgICu6UXJHWC4zhVY3P/0vwedvxlcOvOzUBJ/ht+wyI/dXvbdePx8K8GbE=
X-Received: by 2002:a67:7d43:: with SMTP id y64mr991871vsc.3.1598963740764;
 Tue, 01 Sep 2020 05:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200824073602.70812-2-xiangxia.m.yue@gmail.com>
 <CAOrHB_BaechPpGLPdTsFjcPHhzaKQ+PYePrnZdcSkJWm0oC+sA@mail.gmail.com>
 <CAMDZJNU47t1TuqWt+HLBcdiPhTyiYWJeG3y4xFTrnysKcLOALQ@mail.gmail.com> <20200831.114111.792327686991920286.davem@davemloft.net>
In-Reply-To: <20200831.114111.792327686991920286.davem@davemloft.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 1 Sep 2020 20:32:31 +0800
Message-ID: <CAMDZJNVugB7g8C=QP+1TAMy2PoJhwj8gvuSzkXPG1ita59JaXg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: openvswitch: improve coding style
To:     David Miller <davem@davemloft.net>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin Shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 2:41 AM David Miller <davem@davemloft.net> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Date: Mon, 31 Aug 2020 21:00:28 +0800
>
> > On Thu, Aug 27, 2020 at 3:23 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> >>
> >> On Mon, Aug 24, 2020 at 12:37 AM <xiangxia.m.yue@gmail.com> wrote:
> >> >
> >> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >> >
> >> > Not change the logic, just improve coding style.
> >> >
> >> > Cc: Pravin B Shelar <pshelar@ovn.org>
> >> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>
> >> Acked-by: Pravin B Shelar <pshelar@ovn.org>
> > Hi David
> > This series patches were ACKed by Pravin. Will you have a plan to
> > apply them to the net-next ? or I sent v4 with ACK tag.
>
> In v3 of this series Stefano Brivio asked you to add some more curly brace
> changes as feedback.  So you must address this feedback and post a new
> version of the series.
Sorry for that, I update the patch 1 in v4:



-- 
Best regards, Tonghao
