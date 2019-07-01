Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDB45C416
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGAUBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:01:47 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38551 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAUBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:01:47 -0400
Received: by mail-yw1-f68.google.com with SMTP id k125so454445ywe.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 13:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z52fwXUGOv1uI+LHSwu6+nskjzSWxtA6lYRPnJpF6Ig=;
        b=hdy8bncgi9gqMKyhoh1aDgpIDOYGT2io1BkvrzBJsKD40sWUiyQGgyl8xAzF2K2YGg
         OM0Jl30I7CnukgsKo8BkbKzGkedM8Y023h1rdbFb6hgrtBXPcP2uJM+cETNswvwLo1HX
         6MGAEsY7EhDsWM4eg6NLGmP1u1Xx3X7AkIJtkOQ8agSiJW0f5A2MAXMftYbs52eJZApJ
         puSM2cw605qodEugCOhpMM83d4emVVcjKai5dneJ9knn/Q+bcM3JppJ9JHtR44ymwspV
         Z663O5N79Yr+5DIkeQnvuzvABtDMXC2AJmsgo9+tqCspP9hI2drKNKgn0QtxddEotK7n
         zsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z52fwXUGOv1uI+LHSwu6+nskjzSWxtA6lYRPnJpF6Ig=;
        b=m6K0G6zPrSgJHu49jliyhDUdLGc/D14nTBPYPW0WKFx2wY/d/UeWybnYo2m4H/nIyy
         /Guh10E6SUAh/vtdbTUvjbKdRh081SeEOjdVB/STKO0hPFEMH3S9EPoJFnveDLL8LKu0
         nFZO6v6V9wfu0uokdwNJmBoQpn2WHBQoMGQmzyB43ipgI3xDxjtp5RW3AFBH/tXS+pNc
         QaSiQse7dfEnTn614az8Lq/JNHGms/VyI1G3qNNo/X9wFfPsQKYnhXOUCTOoLnHWlrWI
         jMF0A+21zHSvju3gaGMYovWi956iB2vI9RIOujIsslO6VPicm2XvzHBJUdIYzzGGGJDQ
         Pz6w==
X-Gm-Message-State: APjAAAXFcHnIskqTZvKQzZ8/klUKeuHR19kX4LTJ6Y6Y5Q5AitKaGXtw
        jx8vV5u7arw3jc2kksoaTw29vWj+keFYYIZytg==
X-Google-Smtp-Source: APXvYqzaCS2sToI0Lay2nCC/A2et3CPVyU0qCz9EwDn9tOse+CttogXYH+wK8YYCPgGcoab3E2ywZ5h8c5CcKnniYf8=
X-Received: by 2002:a81:5e0a:: with SMTP id s10mr15243603ywb.369.1562011306399;
 Mon, 01 Jul 2019 13:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190629133358.8251-1-danieltimlee@gmail.com> <20190629133358.8251-2-danieltimlee@gmail.com>
 <20190701170819.548a7457@carbon>
In-Reply-To: <20190701170819.548a7457@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 2 Jul 2019 05:01:35 +0900
Message-ID: <CAEKGpzhB7joH5=F4ZQ70WeRQ4bey4Kw_14JkYqe343k67ou2cg@mail.gmail.com>
Subject: Re: [PATCH 2/2] samples: pktgen: allow to specify destination port
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Robert Olsson <robert@herjulf.net>,
        Jean Hsiao <jhsiao@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review!

About the equivalent port in the same burst thing, I didn't realize it
would work in
that way. It doesn't matter in my use-case, but thank you for letting me know!

On Tue, Jul 2, 2019 at 12:08 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Sat, 29 Jun 2019 22:33:58 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > Currently, kernel pktgen has the feature to specify udp destination port
> > for sending packet. (e.g. pgset "udp_dst_min 9")
> >
> > But on samples, each of the scripts doesn't have any option to achieve this.
> >
> > This commit adds the DST_PORT option to specify the target port(s) in the script.
> >
> >     -p : ($DST_PORT)  destination PORT range (e.g. 433-444) is also allowed
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> Nice feature, this look very usable for testing.  I think my QA asked
> me for something similar.
>
> One nitpick is that script named pktgen_sample03_burst_single_flow.sh
> implies this is a single flow, but by specifying a port-range this will
> be more flows.  I'm okay with adding this, as the end-user specifying a
> port-range should realize this.  Thus, you get my ACK.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> Another thing you should realize (but you/we cannot do anything about)
> is that when the scripts use burst or clone, then the port (UDPDST_RND)
> will be the same for all packets in the same burst.  I don't know if it
> matters for your use-case.
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
