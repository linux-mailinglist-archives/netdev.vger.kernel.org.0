Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAFB5A46
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 06:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfIREUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 00:20:49 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39262 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfIREUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 00:20:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so7288593qtb.6;
        Tue, 17 Sep 2019 21:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPRk8Ltt/rxBY02wM0hyQQPeWRaW6k6EkP3BDo16FyQ=;
        b=KFDuX1PXpLWWIazN6/ioyRAch+g6ExS7Mi1eJP7n+2GTjzyKZJXpHxHiZvbfIw5rqQ
         1FuUiZCchmNjby9OGOw9M3whMMclD2EoqWoAscDh8fcY6oXHkMwHSaBA452+zG+nCQRb
         G6AwVzYIjyPCVzOxujsBeTapvy5uDNXW7Lud5SzA4ddU9eeMSDN4qeEZoNnXQlZV0m7U
         jogRvj7v8RswnXcdHb7ERgxyXWUhmPBLRenKC5npsfPo96KaL+haPApMgJT7l+Vddd3I
         AQGJTK0dDHJ3fUhZk6wGvs+f1jb2kzvIaf1p/d4RnXBoHoktFgw6ujELhd8kXi4oaWmk
         72QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPRk8Ltt/rxBY02wM0hyQQPeWRaW6k6EkP3BDo16FyQ=;
        b=a7hRzDSLhoEvp8mNupDJpYs782IimjQDhqTK60+fti7dCwxpNjlGtX+fJirFCGNl4X
         m1prQXjUO/MSlsH3gaN4qLHaua7XhBWtBlt3HRmNCiD1NCscYfpdjZLt/86h9ZQUKhdf
         m1eB/DTfSWs5OpDsta1qhpZXorTMDrWUj6YDOReiXoJ/oaRXxjtDZty5REY70JOASCtu
         JPKHLA+fX41NDMvRXx2DwtpWYM7zZNOE05/8pVEfaM9/9hNtn+B4pd1Hu9EdSNosgT+L
         tqRv/SQ1WvwzH8m+ug9ExRNiKS5I7r6NpfgyWKupqXyeWrUlLevFZz3Q1TCfNzPIEjMQ
         Z6qw==
X-Gm-Message-State: APjAAAUvtGu2eXEhR7Kr3Ti/x/JIHX+6DtBvISZl9IjHqHMP1aRGK+Tk
        MV/zxXa9a0qo+gDl/2ANA5g/J6Ar+2zxkmLfW8E=
X-Google-Smtp-Source: APXvYqxiiKvseCHPfAVRHjwSoUfPxvktprCcCOjau/D3GUt52yYMNjL2XT2qePP6phobolINXgPdQ61WvVbmtjBFu+A=
X-Received: by 2002:ac8:c01:: with SMTP id k1mr2214859qti.59.1568780446767;
 Tue, 17 Sep 2019 21:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-11-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-11-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Sep 2019 21:20:35 -0700
Message-ID: <CAEf4BzYzorwyZdmy=2vwuvmACOJoCY5c0EGzDA3n48FXZs1FYQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 10/14] samples: bpf: makefile: use target CC
 environment for HDR_PROBE
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> No need in hacking HOSTCC to be cross-compiler any more, so drop
> this trick and use target CC for HDR_PROBE.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>


[...]
