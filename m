Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33DD39671A
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhEaRcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhEaRbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:31:39 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26619C022582;
        Mon, 31 May 2021 09:23:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o2-20020a05600c4fc2b029019a0a8f959dso285506wmq.1;
        Mon, 31 May 2021 09:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pf9JOeuGnWxTtpGd/Tm8paJ7v83AlOEMeE+3fXLdQ/w=;
        b=kGRIshQ0J2HFgrUGH2HM+jIRiRC2yJ7Gryf3Kkr8tr1CKGUYphIrs9ugJrxm0KnFKy
         D3Kvhq3gCRa9HDpAaUhmVEESlIbiicifSHvY20Kfm5XAnGERKFECVBfCNZVmElXErTRp
         3z2yZKarnFhRKmnghNb9HolGtqp43VKVqFGN/9/NQPreLukUmZqxTsEkKv56YQobdBwQ
         uFTObV5Qjz9LmbJtR6Jsg2hiO6mi3La6AAsVf9zRbc9wyJ4/SKHCzWgF9AztkADi7HD+
         V8BjUdpy9GoACtHave43pM5mRLVvRNFrX+vC55qNIDr3o1yUj2yraMXvUjFoWHdO7IXb
         308g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pf9JOeuGnWxTtpGd/Tm8paJ7v83AlOEMeE+3fXLdQ/w=;
        b=kJD6eXB2KwZvfBvw4B/6GYy8GqmL7mGVMYP0wYD/juwBemDr+ZJoPlzri/IZ9h5ono
         u6TmwH5kl0tnau5v4eaWtLFiZbqNAUwNXD4wrfUqWlM6bv5EvfKvCreMD/uKzOjAelmt
         hW5+6AnAG7M1ZREbfAAhJtzHuTnuJDl0AGc7/RMfBmB4uTvEKxBLlgjdCRhld68fsR23
         FT9JI2fdJuRx44hy3trcPeOSZedQk0rCoNEZfmaZqAUejCByRcUk9bcos0TzY+TnkgQR
         UjirsIZaJOjzuE/xlQH0yGr2Jy+ZiRwa91qj5XXO0shX3Cx7yfTtzHS8WUMjAqyFOvZK
         24NQ==
X-Gm-Message-State: AOAM530z0YYWF2UNCWhtDQjyCBiId01ktNxpA4WaLvTRJB0G/i32l88P
        2ZZgv6vgnA44KSXTm//GdkmPgVn6k3rTt6nRVrs=
X-Google-Smtp-Source: ABdhPJxe3CDBegSvNgnvY+CUpeT0x4bUhMtrUTp7VL/Hg4T2C0qI0r1yJNSCIMCSx4P41EialqiUjRSOgQ7/FM2mo2U=
X-Received: by 2002:a1c:7402:: with SMTP id p2mr26614461wmc.88.1622478229806;
 Mon, 31 May 2021 09:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210531020110.2920255-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210531020110.2920255-1-zhengyongjun3@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 31 May 2021 12:23:39 -0400
Message-ID: <CADvbK_eCmDbAZ6_tppe=q3aW76OAnfZd3TXoAafDTk0h=JaTAg@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: sm_statefuns: Fix spelling mistakes
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 30, 2021 at 9:48 PM Zheng Yongjun <zhengyongjun3@huawei.com> wrote:
>
> Fix some spelling mistakes in comments:
> genereate ==> generate
> correclty ==> correctly
> boundries ==> boundaries
> failes ==> fails

I believe more mistakes below in this file could hitchhike this patch
to get fixed. :-)

isses -> issues
assocition -> association
signe -> sign
assocaition -> association
managemement-> management
restransmissions->retransmission
sideffect -> sideeffect
bomming -> booming
chukns-> chunks
SHUDOWN -> SHUTDOWN
violationg->violating
explcitly-> explicitly
CHunk-> Chunk

Thanks.

>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/sctp/sm_statefuns.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index fd1e319eda00..68e7d14c3799 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -608,7 +608,7 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
>         sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
>                         SCTP_STATE(SCTP_STATE_COOKIE_ECHOED));
>
> -       /* SCTP-AUTH: genereate the assocition shared keys so that
> +       /* SCTP-AUTH: generate the assocition shared keys so that
>          * we can potentially signe the COOKIE-ECHO.
>          */
>         sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
> @@ -838,7 +838,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
>
>         /* Add all the state machine commands now since we've created
>          * everything.  This way we don't introduce memory corruptions
> -        * during side-effect processing and correclty count established
> +        * during side-effect processing and correctly count established
>          * associations.
>          */
>         sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
> @@ -2950,7 +2950,7 @@ enum sctp_disposition sctp_sf_do_9_2_reshutack(
>                                                   commands);
>
>         /* Since we are not going to really process this INIT, there
> -        * is no point in verifying chunk boundries.  Just generate
> +        * is no point in verifying chunk boundaries.  Just generate
>          * the SHUTDOWN ACK.
>          */
>         reply = sctp_make_shutdown_ack(asoc, chunk);
> @@ -3560,7 +3560,7 @@ enum sctp_disposition sctp_sf_do_9_2_final(struct net *net,
>                 goto nomem_chunk;
>
>         /* Do all the commands now (after allocation), so that we
> -        * have consistent state if memory allocation failes
> +        * have consistent state if memory allocation fails
>          */
>         sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
>
> --
> 2.25.1
>
