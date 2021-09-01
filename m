Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD093FD197
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbhIAC5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241648AbhIAC53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:57:29 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3EC061575;
        Tue, 31 Aug 2021 19:56:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q68so1273909pga.9;
        Tue, 31 Aug 2021 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=P909qM3GriJXOMBE2UzD0eEKIV6Rucgk31rWOM3ko20=;
        b=UJIdyRpj2VdZ31P6PGyQrLjENQu2wGCdFgwqHQyiL85KfvWsDfoMv/kdX36NGHxoQb
         R86AqShbIlV8nUNDfIv7OBPpl8MIo+N7WXd/UEzK11AIq/p63KEYwuiyyU4WwfCwpn0e
         ijpW3EXqIchb+bjVjQ7Xoj492BaDBMaqXCAIB9rnpAxy6YMoy5nBwO0MAp2sgH4nYrwm
         Tb71jXbMj+x1MTPKI13BoX9CVuJS8kZlonHciOePA881OAM2GQxoqQI4a81D5Yo6wZeu
         +SK60o6g7vA0JOeB/iHa5TAqMarNwcA68aMBrrwdQ6cmdielBbrN0PWHGwNZMNtpSmyG
         ClBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P909qM3GriJXOMBE2UzD0eEKIV6Rucgk31rWOM3ko20=;
        b=gz47ShsG9YWWRm9s844H+MAaVpJVnXVWkBqOhlyfh4ZbVp/QG3QtRpF1aDmdsiru5c
         kGFklAHqMhsPQvKBRnNQbyn5JlbeK9iemrbaL9Kg/WDWXK4dyD5a1TKbqPzaHdw02rjj
         9pB1RwCU40zjYuc8doZAKR1Lt8r2bc+yLAgjlaBqbW2PvAM3zav6wofYqmo86PmqL1ma
         a9uOqfEE521/M2Ms1haxzmXjfIb9bPxwhu1yLllNA8mUpfcR++2m2+4vqd2GmX1+vGiD
         U6MEmsZ6N3LNFyDsYjJYtibAfGILto6VtfHKOGThV+dvOFQHq3BIxKcijAqpLd2OwibG
         FU4Q==
X-Gm-Message-State: AOAM5326AK7Mr5aJdI459ypnSScURCeRrhu0Im8rkvIy+/C8hWpu2q2L
        Em5k+TnR1N9mqK9EcqNnFYLtHZ34Pupf+BJayaE=
X-Google-Smtp-Source: ABdhPJyOPkYEgZTwYHXIkHbGdvtfffCDWg3vf3xDaA6Vrl3zhHvkyXYgbGNg6EC4zkTlxo+ISoQkK6Kx7aDV64y+MNc=
X-Received: by 2002:a63:b59:: with SMTP id a25mr29469814pgl.373.1630464993271;
 Tue, 31 Aug 2021 19:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210901023205.5049-1-wanjiabing@vivo.com>
In-Reply-To: <20210901023205.5049-1-wanjiabing@vivo.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Wed, 1 Sep 2021 10:56:22 +0800
Message-ID: <CA+WQbwvjzadxGi2yCs+PRdJpwYnj64jkXdgiYset8oX0PZX6xw@mail.gmail.com>
Subject: Re: [PATCH] mptcp: Fix duplicated argument in protocol.h
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        "To: Phillip Lougher <phillip@squashfs.org.uk>, Andrew Morton
        <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Coly Li
        <colyli@suse.de>, linux-fsdevel@vger.kernel.org," 
        <linux-kernel@vger.kernel.org>, kael_w@yeah.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiabing,

Wan Jiabing <wanjiabing@vivo.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=881=E6=97=
=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=8810:40=E5=86=99=E9=81=93=EF=BC=9A
>
> ./net/mptcp/protocol.h:36:50-73: duplicated argument to & or |
>
> The OPTION_MPTCP_MPJ_SYNACK here is duplicate.
> Here should be OPTION_MPTCP_MPJ_ACK.
>

Good catch!

Acked-by: Geliang Tang <geliangtang@gmail.com>

Please add a Fixes-tag here in v2 like this:

Fixes: 74c7dfbee3e18 ("mptcp: consolidate in_opt sub-options fields in
a bitmask")

Thanks,
-Geliang

> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  net/mptcp/protocol.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index d7aba1c4dc48..64c9a30e0871 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -34,7 +34,7 @@
>  #define OPTIONS_MPTCP_MPC      (OPTION_MPTCP_MPC_SYN | OPTION_MPTCP_MPC_=
SYNACK | \
>                                  OPTION_MPTCP_MPC_ACK)
>  #define OPTIONS_MPTCP_MPJ      (OPTION_MPTCP_MPJ_SYN | OPTION_MPTCP_MPJ_=
SYNACK | \
> -                                OPTION_MPTCP_MPJ_SYNACK)
> +                                OPTION_MPTCP_MPJ_ACK)
>
>  /* MPTCP option subtypes */
>  #define MPTCPOPT_MP_CAPABLE    0
> --
> 2.25.1
>
>
