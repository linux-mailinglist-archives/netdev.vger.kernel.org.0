Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6888425E9CD
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 21:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIETE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 15:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbgIETE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 15:04:27 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2582CC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 12:04:26 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t16so9167326ilf.13
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 12:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dFaezmMyH3AdaomyI0zH83WRJn/Tkg1whxOqDup+KIQ=;
        b=ewzSghobnWJ2OjUJeZIqRWE180chG6Ipr2Sz7PFegcUcTy4Vdh10SP3ORp3X8le0cn
         L1KtTa2q69aC9pNWQrQ0T3CH4qVUwRoLOzX3Wl1Qpq9XzGb55bH98bbpAFBf0mW205br
         HdvK0mC/dFNfOHJv3Bf56JGx9DiWBktbi4y3mHaOva7PUGO03Vhtyh/RbpdK+2Bbklne
         9znzfDwHwkPSZNadjzRG5Ex1B4NojB6/KqJYdIlnJhYsdYYl8c66aqj/Odf2VloDOp57
         cSjiYk6l5Qb5KUwEoPxYTvWQNkYzYniQb9VqesBEXnVaBXMYpy2fQIwKmA244Zjw+m/l
         TZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dFaezmMyH3AdaomyI0zH83WRJn/Tkg1whxOqDup+KIQ=;
        b=WTUHA+AUcyuyCZGFW3Gt8+4PLyVpW/3qL3YGn5Z3Us9ADO0U9CT/0AtO81gCmigaWU
         GAAz29R8b0HWfrQVQ8tSHiR3D4Nhkfb5l1VNQoqKfhrAKiIXI5OebQ8P+zEPnRFfCkwr
         YQvJkwYTm8FdMH+D2CpxKLJk0Vq5O1IVcO/7sW82Ck2i189jQFuAiABCdvnWFdeG0XH+
         QsgzBnz8ihr/BZAlejJ7PXz7uZ+G3U9TJxHgCuDVDpj2iwrpOwB+ubC3vPPhX4p8n2Wg
         Z1f6a/A2le97Vq57FKUTZPchuf+TM6qkuQzILi1j+z5vEDEv5lrESJlvseS4wVLQuKPV
         /07Q==
X-Gm-Message-State: AOAM5339mEaMcNGWV1oPktt+RNh8Hv4FTQ2KdNJJjhdA+M8RtbfSpCAQ
        zVStiPij0IY+18Ai0Wn4O9wZ+HWm1l7Q1TB77A4=
X-Google-Smtp-Source: ABdhPJyun6DmSidU3cAU3LCt56jej5fuWOYzNIri1gwbk2Zv1uh/EN5yd5EqdavPgUaoUmNDNQDHPoOP+AxKBm5USZ4=
X-Received: by 2002:a92:dad1:: with SMTP id o17mr13067639ilq.22.1599332663619;
 Sat, 05 Sep 2020 12:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200905072550.886537-1-yangyingliang@huawei.com>
In-Reply-To: <20200905072550.886537-1-yangyingliang@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 5 Sep 2020 12:04:12 -0700
Message-ID: <CAM_iQpWg6-PzzqRJMV3To+EEqj=m5wLf+=rmAwjn2i26uzrmtg@mail.gmail.com>
Subject: Re: [Question] Oops when using connector in linux-4.19
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 5, 2020 at 12:28 AM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> Hi,
>
> I got some crashes when using connector module in linux-4.19:

Can you test a reasonably recent kernel?


> The invalid address[0x000000030000004c] is the value of nlmsghdr from cn netlink, nlmsg_type is 3 and nlmsg_len is 0x4c.
>
> It seems the skb->data pointer is freed wrongly:
>
> Process A                                                   Process B
>
> calls cn_netlink_send_mult()
> skb = nlmsg_new(size, gfp_mask);
>                                                         unknown process calls kfree(skb->data)
>                                                         //put skb->data pointer back to freelist of struct kmem_cache_cpu or struct page
>
> nlh = nlmsg_put(skb, 0, msg->seq, NLMSG_DONE, size, 0);
> //set (*skb->data) to 0x000000030000004c,
> //so the freelist is broken here.

This does not make sense. The newly allocated skb is only visible to
process A at this point, it is impossible to be freed by another process.

I guess there might be some buffer overrun on heap, you probably
need to turn on other memory debugging options like SLUB debug:
https://www.kernel.org/doc/Documentation/vm/slub.txt.

Thanks.
