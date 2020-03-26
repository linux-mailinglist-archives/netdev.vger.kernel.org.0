Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F761194D7B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgCZXsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:48:50 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40033 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZXsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:48:50 -0400
Received: by mail-lf1-f65.google.com with SMTP id j17so6371575lfe.7;
        Thu, 26 Mar 2020 16:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxfsuJxUwQgyHeL6ML1Ets48AkLBPa97SvcuT6O+r2w=;
        b=HAyV60qBe3SD5OX4zLRd4QxQKBdm76OMz7aCv0yF0aj3KPd4/r7kOo6qnAwu/ZAF1/
         eLn/MJhS9Axh75Ww/wSveVhWZzii5tBVlpQLMybJYFbXPEPu5Bz6n9OoJbHftph+tJkW
         3EWuHUDVLo7CF+Uyydqv6bWzIsdAed+fCIUef+47qS3LgFUg4/KMl12NqsiOACYGfcGQ
         VM3Jf5Lt/RQOdZv9R5TqRy9uLZznlnYTxUBKaEQcPjT2dMLUonFn+v3nuRPA3M7iPYhM
         73rhbOBrJvUs4zCeCbHbT1WPQw92bjaredJkoRBunWqfvZEIgGg+OVeVNjiA3r2zvk2t
         HUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxfsuJxUwQgyHeL6ML1Ets48AkLBPa97SvcuT6O+r2w=;
        b=oQ/rqfgilGvM8/kaJemIrOck5fZ1Upq5NhhmX9Pg5yy8nDdRBI8HqBmXBwqItZYxAe
         Pciw51mAvOdsx1sKfTelHz+VlNmuX5c9xDU76IKj9AH2rI/BUVCxyfmELV1zgcTavLHu
         +Z3T5u0A63POTskqsSEhCsaD9ae4srTijvdJd3GAVfa338A3K/IQe94WPsdiiMKkiyjG
         WX8ScOVjuaaIO6MXWQ3RM7P/QhmzZug56DhAF0LJ8tsXfmivO5kpDFyN/2Y32B35q4hG
         qeroJ0PUxxoJGh79q4qg6w1bmZnIa1Ci9ZnnVQg0hzSjZ9F2RCiBnMqMNlG6DF4OTeav
         bCfQ==
X-Gm-Message-State: AGi0PuZ04azbDJFtVyFS9TR/vVm66paeo3KyyyGHCqnAvUPT3hPt7dTb
        VqKWvK8HpE/QFYuJm1HTXs9LWHzScutrqGV6K4Y=
X-Google-Smtp-Source: APiQypLmMGgk3Zqm7RhdrseYvQYa7UrVl29HUF1yy85h+6Zn9zyRg4mh8uaAzG74LZm0mcl3tFheM7MCdI2V5eeSNMs=
X-Received: by 2002:a19:6f02:: with SMTP id k2mr1378706lfc.119.1585266527281;
 Thu, 26 Mar 2020 16:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200326031613.19372-1-yuehaibing@huawei.com>
In-Reply-To: <20200326031613.19372-1-yuehaibing@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 26 Mar 2020 16:48:35 -0700
Message-ID: <CAADnVQL=jcJAKwcNarjL8-=+9HxhPuRtYOWH_qZ8wGRbNmpbYQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: remove unused vairable 'bpf_xdp_link_lops'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 8:16 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> kernel/bpf/syscall.c:2263:34: warning: 'bpf_xdp_link_lops' defined but not used [-Wunused-const-variable=]
>  static const struct bpf_link_ops bpf_xdp_link_lops;
>                                   ^~~~~~~~~~~~~~~~~
>
> commit 70ed506c3bbc ("bpf: Introduce pinnable bpf_link abstraction")
> involded this unused variable, remove it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied. Thanks
