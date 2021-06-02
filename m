Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635DA397FAA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 05:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhFBDsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 23:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFBDsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 23:48:31 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9224EC061574;
        Tue,  1 Jun 2021 20:46:47 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d9so1068192ioo.2;
        Tue, 01 Jun 2021 20:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2TC9lXN4UJvwqVAhSqc21INyQWxK5qbYrtHS8/wDgPE=;
        b=jHfzfa2oRd/caEHPDmbO0u78O58FtSh4yc8LuoKmgCrm+S0wilmpz9+vQGpk+hY1if
         aD5v/L5ISG7SGJqIb0Vd5brm8X4KM6nnOI1Y1KWziTfVY+dF/t8IVzkA34X0VljRRDE9
         uw2GrOEDyaBgaE07xXDPVSi9k7UmLCkdGlzGhuinPeaCkEVcWM2qPVdhnXz6si0Axiju
         7bhYtDbMvvr9ljLT7PEaqydUESTRZ8f4vNSCrZtd5hddzfLkw1XySG2HqIMNRw3qBBER
         0V7my8K+rVdaPF0y2GbpPskgohx9ej/7tqxsyMrPZ2iFMGyN1dvg7MVyOeJagVHhJIU5
         9kcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2TC9lXN4UJvwqVAhSqc21INyQWxK5qbYrtHS8/wDgPE=;
        b=Q0fTduxd0/ewNe7tpRA8BiWyZCdeRva11/bv7hnK6Qso0nCmphak1kjMXDU0hSrLWp
         MwOsTJB5VXSspiF1u70gWJgtmmk1TeywT0GzQEwkwugfjmkQEK/rJwKZwoMM1qCZJRrr
         ZkB6CrzXglLNezpAnL36OtTv5aDhurp3YkZ4oM/cWQQmPIZMLtmc1aJsZ38eH0lYmhzr
         AG6uuXIQVt4CrtNRBOrhguiMwJ/BNdaP8dugwKsz1dyxz7BSnztOZFFynfjcVsCZajj9
         9xYL9SVoiSgrQH0OLdgQ9yjkQeUquB7QNTpA6BcZjncUtRJz1hPKNXIF4/uRTSAXHRfG
         3rVw==
X-Gm-Message-State: AOAM533uyOyD+N+FRYcJQJgJLpcLnWnCS7z1kIkOdA3uQOO77dfNO56I
        h2JoZiu/MnPN4J7W2rwWW1g=
X-Google-Smtp-Source: ABdhPJyLXu4c8a1PYK6hGdsGI+gibtoN+C2NlJ1KYQuoWR8z4yCTlyDM0faQyB58G5SM9Opv5Tzi8Q==
X-Received: by 2002:a05:6638:148c:: with SMTP id j12mr11704978jak.74.1622605606855;
        Tue, 01 Jun 2021 20:46:46 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x6sm10936413ilc.59.2021.06.01.20.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 20:46:46 -0700 (PDT)
Date:   Tue, 01 Jun 2021 20:46:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Message-ID: <60b6ff1e45070_38d6d20881@john-XPS-13-9370.notmuch>
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v3 0/8] sock_map: some bug fixes and improvements
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patchset contains a few bug fixes and improvements for sock_map.
> 
> Patch 1 improves recvmsg() accuracy for UDP, patch 2 improves UDP
> non-blocking read() by retrying on EAGAIN. With both of them, the
> failure rate of the UDP test case goes down from 10% to 1%.
> 
> Patch 3 is memory leak fix I posted, no change since v1. The rest
> patches address similar memory leaks or improve error handling,
> including one increases sk_drops counter for error cases. Please
> check each patch description for more details.

For the series. My initial concern about marking BPF drops as
socket drops appears to be common so I guess lets do it.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> ---
> v3: add another bug fix as patch 4
>     update patch 5 accordingly
>     address John's review on the last patch
>     fix a few typos in patch descriptions
> 
> v2: group all patches together
>     set max for retries of EAGAIN
> 
> Cong Wang (8):
>   skmsg: improve udp_bpf_recvmsg() accuracy
>   selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
>   udp: fix a memory leak in udp_read_sock()
>   skmsg: clear skb redirect pointer before dropping it
>   skmsg: fix a memory leak in sk_psock_verdict_apply()
>   skmsg: teach sk_psock_verdict_apply() to return errors
>   skmsg: pass source psock to sk_psock_skb_redirect()
>   skmsg: increase sk->sk_drops when dropping packets
> 
>  include/linux/skmsg.h                         |  2 -
>  net/core/skmsg.c                              | 82 +++++++++----------
>  net/ipv4/tcp_bpf.c                            | 24 +++++-
>  net/ipv4/udp.c                                |  2 +
>  net/ipv4/udp_bpf.c                            | 47 +++++++++--
>  .../selftests/bpf/prog_tests/sockmap_listen.c |  7 +-
>  6 files changed, 112 insertions(+), 52 deletions(-)
> 
> -- 
> 2.25.1
> 


