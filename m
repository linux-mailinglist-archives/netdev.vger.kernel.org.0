Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEDF187499
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbgCPVPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:15:32 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33263 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPVPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:15:31 -0400
Received: by mail-pj1-f67.google.com with SMTP id dw20so4371382pjb.0
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KaK149mcvHpJfMxye3tXJbFCoSJn6xDOGuQiZnEv0Kw=;
        b=oJl+8nZd+9LHzT40nJyJpJtsqNnnWAFfqgFRQndl19IpKUIGbqNdVNhBE9WEOnIV2g
         2c7b3BSJ2ogdeQ7VuOP3OiFyCQhSdVd4J4VA/4APGFx+yohktiZTEaRER/oQ6B/d0NfX
         sDTXa9db3Gn1XzHA6McRVnzpwTMdcs05FxmGYBXr8VfyQLCCTQ3TcSRAwCg/f18wya2n
         eAgUrOvBOl8xxzXeFDzOJCdbveNC4EF1CJOXWlfSmn30fGKE489oQw+ZujOzTAuarzRF
         Sm/4j7xsi8YJ3N+3bw6oHU/rDwv9zoCOgyZScV7WUyLnnsFloGsOpmt05pPwfivRg5h6
         3oow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KaK149mcvHpJfMxye3tXJbFCoSJn6xDOGuQiZnEv0Kw=;
        b=nyi2JTZx1DYGtiaJv9t+l7FV9pi227Gmg+GTI+CO0M5fVDNd3EpCOimek8mlouDeCZ
         pcH3s+IhL+lQ9TVhJd7umpdLHjdrjL0Uy4Ev+eBSoIKt81yQ9LHBW8bINdTiyUy3aACn
         T0FpTVbCCQhKgPHT6/pGSmJtbeQQ2Gojzpc/BfHpc8hA+TkWiFICmxj6F6Hm6we4AVpm
         HOrSgQg/Lxk4X5TRfyQcTl4fz8xeDLbkRAPg84Jzrhj6MuZpmSPVBkgfVq1zZUR+BMCt
         bT5gv7LRG0icxPU1fE5pt/toQUHhpaC5Qqc5rg058cvop23Y8GUO6QqCKtNYokeX8i+9
         Th1w==
X-Gm-Message-State: ANhLgQ3jWVnXXLWPYklzt3sJI8YSpD5hLfwgIkSfYoGzH7EEhAVLIQfa
        xsje9Bw53xvLVQUeZexy8PzVePVJd7XzwGB8i11meA==
X-Google-Smtp-Source: ADFU+vsLMv4vfYgKJM3UACye15ScgavNMy5rn/D4RIYctClFBjL2Holw5IElKcomCXFXEdmQBRVk31RXNl8gfxVrZiI=
X-Received: by 2002:a17:90b:311:: with SMTP id ay17mr1531492pjb.27.1584393329930;
 Mon, 16 Mar 2020 14:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200130015905.18610-1-natechancellor@gmail.com> <20200211142431.243E6C433A2@smtp.codeaurora.org>
In-Reply-To: <20200211142431.243E6C433A2@smtp.codeaurora.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 16 Mar 2020 14:15:17 -0700
Message-ID: <CAKwvOdkcT6jdFu2Mj5ZKErKmm+MyGAoJ=R_0LatR+_A0j7OtYw@mail.gmail.com>
Subject: Re: [PATCH] ath11k: Silence clang -Wsometimes-uninitialized in ath11k_update_per_peer_stats_from_txcompl
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        CI Notify <ci_notify@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle, I still see this warning in KernelCI builds of linux-next.
Is ath-next flowing into linux-next?  I just want to triple check that
this fix gets sent along.

On Tue, Feb 11, 2020 at 6:24 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Nathan Chancellor <natechancellor@gmail.com> wrote:
>
> > Clang warns a few times (trimmed for brevity):
> >
> > ../drivers/net/wireless/ath/ath11k/debugfs_sta.c:185:7: warning:
> > variable 'rate_idx' is used uninitialized whenever 'if' condition is
> > false [-Wsometimes-uninitialized]
> >
> > It is not wrong, rate_idx is only initialized in the first if block.
> > However, this is not necessarily an issue in practice because rate_idx
> > will only be used when initialized because
> > ath11k_accumulate_per_peer_tx_stats only uses rate_idx when flags is not
> > set to RATE_INFO_FLAGS_HE_MCS, RATE_INFO_FLAGS_VHT_MCS, or
> > RATE_INFO_FLAGS_MCS. Still, it is not good to stick uninitialized values
> > into another function so initialize it to zero to prevent any issues
> > down the line.
> >
> > Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/832
> > Reported-by: ci_notify@linaro.org
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> df57acc415b1 ath11k: Silence clang -Wsometimes-uninitialized in ath11k_update_per_peer_stats_from_txcompl
>
> --
> https://patchwork.kernel.org/patch/11357331/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200211142431.243E6C433A2%40smtp.codeaurora.org.



-- 
Thanks,
~Nick Desaulniers
