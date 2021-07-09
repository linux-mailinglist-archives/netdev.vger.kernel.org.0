Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4AA3C295F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 20:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhGITCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGITCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 15:02:39 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F68C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 11:59:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j9so3895176pfc.5
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 11:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tBSQITawjpspC3A2Aq4W4PlvlkeI5kBDB+ThDTXHlZw=;
        b=NqJeNbgCur9kwP9ZmyoB8fZet+oGQ6laqq5EXfAqLgJ/lfnIG/VdT+h+4ciCdyK5BM
         HBxxFOAd9De3S9qcpbAhYTwYnNnwy9Txq4u/urTNaRVj2BubxZ7rv4378sNcnRYNCiZn
         /wCoGxa1e7sqwXgwXr66d1U/D2idZ3CkuZ10IOu6QWaHXjScnD4ceggR4S8zZE5Qpcu1
         F2EM16njeX0cGyLmaN20yYgQC+5E2VlPsYUHORlrL0bDeqX0gNgcxpqVOxOgpOCGHz6s
         l3X36pH/eLb/afBo/z435RcuVrE55t70liVnfwSs1W8UCJSfMhlcgXK/2U7Xd9kLc8Gx
         49aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tBSQITawjpspC3A2Aq4W4PlvlkeI5kBDB+ThDTXHlZw=;
        b=XUIP0h7GiiOOn6HfPh/p8oOR5W9xbIjEBUsWUnSDhU8vh09JmOAfikPSdinmpwefqp
         R/0Nz6Z1ykXfKNbdjH39EZAiON2N1X31yrXxlqCCcWbv5Fj1/tt6WFJjHZPFeEpH3BAq
         XVgCdnNHK0jUIvj6jaVzew8ss+QKxfZpHNLnHPMRF7JMQPgltuE0X0MX2IlMGM1GUz0v
         lLG00UzsS5bweWEh+x/cRn7/VL2BQ+yx0qlR2ZyyYegKbI/ljUODG8RpPF1aOYS9QvbS
         87HCG6WTOreqTbFDlH41/MXUrsgUsc10O19Fgidb4QHafyTsHx/XHjdLIRSDJmIqBiX/
         X7dg==
X-Gm-Message-State: AOAM530MaU4pQsGhHODqCNGWbGbPInxSnisWZY7nwU5r40pJ3Vt5Nucx
        LVZRkshqhJVjrr0VC7mDK1r6hebVVch+iJ+7HK61+3nD
X-Google-Smtp-Source: ABdhPJzOBF/qLdwn9qgLvHmCF1Ic02yYHmMbiHgGmpdr6au8mVmr5ELI7ty3FW42iO5HyLOj6pKIthhyDWz36wqbxM8=
X-Received: by 2002:a62:804b:0:b029:328:db41:1f47 with SMTP id
 j72-20020a62804b0000b0290328db411f47mr4257667pfd.43.1625857195092; Fri, 09
 Jul 2021 11:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210709051710.15831-1-xiyou.wangcong@gmail.com> <20210709.011625.1604833283174788576.davem@davemloft.net>
In-Reply-To: <20210709.011625.1604833283174788576.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 9 Jul 2021 11:59:43 -0700
Message-ID: <CAM_iQpUaZg9rGz_e0+UcnaT5-iLK5G5LUeViTnpcZHWzWS5g_Q@mail.gmail.com>
Subject: Re: [Patch net-next] net: use %px to print skb address in trace_netif_receive_skb
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Qitao Xu <qitao.xu@bytedance.com>,
        "Cong Wang ." <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 1:16 AM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Thu,  8 Jul 2021 22:17:08 -0700
>
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > The print format of skb adress in tracepoint class net_dev_template
> > is changed to %px from %p, because we want to use skb address
> > as a quick way to identify a packet.
> >
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
>
> Aren't we not supposed to leak kernel addresses to userspace?

Right, but trace ring buffer is only accessible to privileged users,
so leaking it to root is not a problem.

Thanks.
