Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96841EB03F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgFAUcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgFAUcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:32:45 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394E3C061A0E;
        Mon,  1 Jun 2020 13:32:45 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m18so9837216ljo.5;
        Mon, 01 Jun 2020 13:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kl6eRAHnGS6Zgv9h2/gbiUrutAQLi7YEmvfv9pD6yrw=;
        b=RfmpOrLT6uWxHE1G6eVU8XWaI4hj6YdQGIG7lCtfSE5ezJhdJisq3QBtWCFFZR/OHs
         Kyh9b0WUm9Oap7yjrhtYW87cPmRywcXdDpgWfX72VewJDKcd+Fi4IJrWZSMT+5UcxY+7
         MBQSXp3hZzfXQ9RmPLDpVb3kdMyaViwo9nKdwsfm6IRS8qH+XS11n2Sv18Wnx4R6KuKz
         7GQx3FM7EpkYjd3F7765hDiuhZW6mzANaNIMDXqnvT0d71BcjLhtr+ccbA+r/MAxeg32
         lbtd5D3rPvF5mC97f6u9mHLR13wltikh42Z490LydIm2WN8AANNb+lOXDALfvo6HbPg7
         1ZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kl6eRAHnGS6Zgv9h2/gbiUrutAQLi7YEmvfv9pD6yrw=;
        b=Av47UjBMYawvPRN1jtDzOljguHoVinIuyOyzUWLi5RDMbP20S5aR5zrztjXlmViQPI
         mN3ds2XhfTil2CJv0SsnSmKY+GkPhbl5DMT7yOYD/a+qJ8QW7m8NAHfZ4StGjEctaqf8
         u4/UNYfUB+GDeIGZzI374Xa9HtgFl6+EWnAS+u+FVS3nzrJaj7VQpZARDa2c+B1+FVFK
         R5w4Atx7XCuHaQhLpWXwD/TZK54y5dJGq2JpjuzXJUVeY6+U6r2Fl4UgEBZ+Q/IhuTKc
         dB9NmdkBKNAiCelRJIBWSb19EdoOfe8b7DDqNWtihOU7Oc+4lPinQzdFZ4AtH+2BuC07
         rx6w==
X-Gm-Message-State: AOAM531w5+D95mnPdDk1lPFFYpXGZi3P0LEIUEHJ576VxErWPygqwWQr
        2FPYXNHLkk287cO+vjG5MA0klcRLNTZeJEZGrfA=
X-Google-Smtp-Source: ABdhPJy3mGXv+JccfWSfav+Q//Ajolk9i6WJJYtTJ66gFLB9ukO3Gfdi3FmqYQLvSH4A3B6cb3WMR0gYMFwtTh8pvn8=
X-Received: by 2002:a2e:81d1:: with SMTP id s17mr11954870ljg.91.1591043563624;
 Mon, 01 Jun 2020 13:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200527195849.97118-1-zeil@yandex-team.ru>
In-Reply-To: <20200527195849.97118-1-zeil@yandex-team.ru>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 13:32:32 -0700
Message-ID: <CAADnVQJ9vD_qfBM21JS-=zdBwK8RoN2grUhaVd2oFmunD+0K_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] sock: move sock_valbool_flag to header
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 1:00 PM Dmitry Yakunin <zeil@yandex-team.ru> wrote:
>
> This is preparation for usage in bpf_setsockopt.
>
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied the set. Thanks
