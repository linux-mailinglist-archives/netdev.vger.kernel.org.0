Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861A42747BB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgIVRuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgIVRuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:50:17 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527DEC0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:50:17 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id c18so16289322qtw.5
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVqxL2owg2kDSpSts9aypi+G5FFY2GmKeEfU085U83Y=;
        b=KSIMJ50P2g5c+zdsX3OlgRaXG4s9ZIitZhumJ4SRpbbXmLwqs/emuUBxlr5SP97yDg
         WVeWpTL14BeASFSREXxjK1skzELOW8DhwBsV5po53MEjXLAJOeVaejuHTfC/BSut8j8x
         7PMKst/YNnQ7LGgSIPPxx1GLygEuNgnDvvy0eLj8a8HCG0G39gB17mL/67FwX+mg1G3F
         XayZDShHeAk5QkEXT3bcAMD8KklY/kKRT9RxzARRbWXuIyAzaWc7nWLqI/Ff0ZLUDd2P
         AE0FriiMcabZApft3bx43BIR6GXQK3y5CS83rXr41VP5afBrWQYyYhiUjD5RFTjgLcmr
         RYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVqxL2owg2kDSpSts9aypi+G5FFY2GmKeEfU085U83Y=;
        b=Tjuj/4CcaoArW2VTffV1XT5EkAqrcyaD6sf8c7JZg2NiKTAJvxsK2YOMxIFeGjxzaq
         /pC9Ej3OriAfvzjXoMyG2vVAggZklU/BaAynDhpC0pW8x+U5jzPlNonFaZpV/zQgvuqI
         RIk4JDo8nNHM28awFQKbDJPBz/qqMm05RfFlbFwbcLVQiyPZx8x3GuYkrozqkkyNQtn3
         Rc+SO3O6iPDwj5k4WAm+wV4tlxtfY3GWQyjvV5E9KwQ4kFuXD4bLPGexOWcexiQOs+js
         8X55XRKYQ7bpFTsL3crShgpNCLgj+oLeeuG5md/yTRAuKzMBUg/6D7YNnUYHkHduTmdY
         jxmw==
X-Gm-Message-State: AOAM533JPZg5iaYBNvYFjVGt9RmLjRwzgQ/Ys/lmN3rfQ3AsTbzM1O3L
        t3OM3g4cCMZSKCOuypM+m7XHVsVFvSOzemElrjVRyA==
X-Google-Smtp-Source: ABdhPJzcHCCx4i3x532DghjgMG9V9lFw0EQjpowLAmLV8FQ1OrArugK0rbakIqePo5op6GFYjtIeWUVm0gT5ceMbjU4=
X-Received: by 2002:ac8:165d:: with SMTP id x29mr5734327qtk.117.1600797016466;
 Tue, 22 Sep 2020 10:50:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600773619.git.mchehab+huawei@kernel.org> <dbe62eb5e9dda5a5ee145f866a24c4cfddbd754f.1600773619.git.mchehab+huawei@kernel.org>
In-Reply-To: <dbe62eb5e9dda5a5ee145f866a24c4cfddbd754f.1600773619.git.mchehab+huawei@kernel.org>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 22 Sep 2020 10:50:05 -0700
Message-ID: <CA+HUmGhxP7HkhhQoqQ+wpM2V-qYTRq13aXntK6SGDyRLyVkCdQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: fix a new kernel-doc warning at dev.c
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 4:22 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> kernel-doc expects the function prototype to be just after
> the kernel-doc markup, as otherwise it will get it all wrong:
>
>         ./net/core/dev.c:10036: warning: Excess function parameter 'dev' description in 'WAIT_REFS_MIN_MSECS'
>
> Fixes: 0e4be9e57e8c ("net: use exponential backoff in netdev_wait_allrefs")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Reviewed-by: Francesco Ruggeri <fruggeri@arista.com>

Thanks for fixing this!
