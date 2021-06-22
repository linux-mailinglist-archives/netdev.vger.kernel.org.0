Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4462B3B05F2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhFVNlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhFVNlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:41:22 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3FAC061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:39:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i6so444348pfq.1
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IhbJd31hjVGVEzqcAkQbpwiGiSWU+stpnmXw0QqxiBw=;
        b=B/1zpyrf4+3+I6zpkRyNYuIx+Ib+6bAbV9gGBpqkvP0fGiJNQ8OZlOjZBrRZRJHdXN
         z+gbN5pUnvF0dIsATfBnIXyaI/sW4oS+m8lK0XTyEVFdR/4mpNAjnEtYgVKtgqUePyH7
         LrAJ8Jl4SB1JZvAqg0PtSJsbByMDoO2EitnLjco8WmLhTuZ/BZwy24uPaUIAUb7O3+GJ
         KiruVF01+GnqnGaOJdsZXOGM4Y/G/IA5wqH19meCXyz5CEiLdBHblMpeydzCQ5jbBC0b
         jZN7q08mI6/Zkn6U5M0WgILtDuA98rc5LXrIaBoT4xWbZGd2ygVWk/GNvu3LTwyccRo0
         bpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhbJd31hjVGVEzqcAkQbpwiGiSWU+stpnmXw0QqxiBw=;
        b=CquB3BhNz0aGUh5EpeM9rKazPz9XXVQLPiuIwAjhpV4FWnp5qxuwISEctQtqBztOgI
         +L/HDDx1IYyKVx4wiksH6VBQhKvrX1xf1YKM55DXGd3qMNMfW6o0wXXII0X42fdU+x8k
         Uj9kEFfeulV6smKWKb8qpDObdPWRUC3qfB/nif2iI5zeqbWWw2LMEm02ZNsHxsKAUqVn
         I2t6hcXcS5xJUDVsrk4DtaxnbQK9NWDLlaDqeAaxfBcAdM10M4wu7MOws3586bVod+3w
         kzNPem1wrkmYLnZWEpguscx0kzXNf10luryFVZ/z1X8B0klznTdTKXC2I8egehOAW74X
         8ChA==
X-Gm-Message-State: AOAM5315iMNATFMkcSp1ZIT5cVI/amLjdKr+1SYC+nlYBVEEPa2M8OzK
        lmAVpWGkfvD+kSXQv5cORndYxurhCEWaT3cqPK/rgQ==
X-Google-Smtp-Source: ABdhPJweZh3m2OuRRqr/6sSOatSn9QIDYL0ccCHMhDzYint2tTxZSh36nLS0BSXdjKA79wwBCY1HSMqN2PcpFnqxb/s=
X-Received: by 2002:a63:e309:: with SMTP id f9mr3786922pgh.443.1624369145441;
 Tue, 22 Jun 2021 06:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com> <20210621225100.21005-4-ryazanov.s.a@gmail.com>
In-Reply-To: <20210621225100.21005-4-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 22 Jun 2021 15:47:58 +0200
Message-ID: <CAMZdPi-Smy7ygQeYTiEgWdXJ8=MOMGAUcA6F94r_qystK8_HCw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 03/10] wwan: core: require WWAN netdev setup
 callback existence
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 at 00:51, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> The setup callback will be unconditionally passed to the
> alloc_netdev_mqs(), where the NULL pointer dereference will cause the
> kernel panic. So refuse to register WWAN netdev ops with warning
> generation if the setup callback is not provided.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
