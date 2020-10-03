Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B574D2826CF
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgJCV1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgJCV1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:27:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2ECC0613D0;
        Sat,  3 Oct 2020 14:27:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so3912707pfa.10;
        Sat, 03 Oct 2020 14:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sUHyLZFz0jS3AnouRiNsniEHZ9CbCLAeNrY1gYQCiZ4=;
        b=APH2r1rrROFQPv4JYeMvai8cfdHgIz/5wz6Rd7SoigXP/qZN9xqJfaMKntL1Bwk9vG
         KLAF09EfwDh3nYZG79fYnAPQ2T476z1h1Zw/6n9vR40+SHwjmr/39Np3fSvI7wttYOfi
         p084kK79EGxwFVMnlUOH+rQiAbfY6y2i0tO7jYisziBUlWJ0JtN6wWakf9StAukQ8iqC
         UFoY+TrEEdeFloH7p5SB7Y9Y/6OJT/PzY0tppc34khcwWIJbzpcK+E5F+PpBK0RIp7I6
         mtmFcjnIshZ8MF/8mwmoE4N0d4UIS/oZad3T3AE96MPqWlTBrlivAeCvMwwDeP2+kcMc
         xa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sUHyLZFz0jS3AnouRiNsniEHZ9CbCLAeNrY1gYQCiZ4=;
        b=ccUsYtnFur8MvAQjMzI6Bg6quwHZ+evtoNvgVC/24CJxuA0ylaqATi/MPjjx1k2Vx+
         F30rhlrAWVoYOafdDmnmO3jVVxJGutaHf+skOoHj1T5mbZKGmMgVb7MqaswWREKqICEb
         x0tTx8lcnVN8UgKKY+eDnQJESJCwb6Li4xpqO6eN+EB3FJeIqMHnkTXZhEpTjvGiPr3w
         YF2hoqC3hFTab8eHab1e4SuF4FF7cNHl3uGpxVarBJ12hnK7Pwl6qUkEsFmdAicxCuKs
         DPC2Az+E/6AAHa3BpRAEj6gJ3KN9XAJck/Q19TyUT/IMlDWx2eoCD7Aznz37+P2n7cDD
         8Nag==
X-Gm-Message-State: AOAM531sdVdUeqwDa4UouBP0LME8HqXEHXNl7xc7a800iQb5qcoH/H77
        vrhO213VrqfyZzSIbR7+jB0F2f2/BAdlCmVz6j2BM/Aq
X-Google-Smtp-Source: ABdhPJxy6/LYXaQnWAND4ztoCQ/zfhtCHBlnFKRt0omN4ZiXtZGsRvepRQs24FOaqxJZ9qqrgwowG0C1dnipcuvz4fw=
X-Received: by 2002:aa7:8c11:0:b029:151:b0bd:d607 with SMTP id
 c17-20020aa78c110000b0290151b0bdd607mr9129197pfd.76.1601760468649; Sat, 03
 Oct 2020 14:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201003173528.41404-1-xie.he.0141@gmail.com> <20201003110958.5b748feb@hermes.local>
In-Reply-To: <20201003110958.5b748feb@hermes.local>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 3 Oct 2020 14:27:37 -0700
Message-ID: <CAJht_ENGQNFoD23G9QR6ETH_AZZS8p5Zw4y=+=nHKrhbNe3H0A@mail.gmail.com>
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Reduce indentation in pvc_xmit
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 3, 2020 at 11:10 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> This code snippet is basically an version of skb_pad().
> Probably it is very old and pre-dates that.
> Could the code use skb_pad?

Oh! Yes! I looked at the skb_pad function and I think we can use it in
this code.

Since it doesn't do skb_put, I think we can first call skb_pad and
then call skb_put.

Thanks for your suggestion. I'll change this patch to make use of
skb_pad and re-submit.
