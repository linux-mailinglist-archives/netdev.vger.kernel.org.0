Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B929311FB2
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBFTaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFTaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 14:30:21 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF62AC061756;
        Sat,  6 Feb 2021 11:29:40 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id m2so265999pgq.5;
        Sat, 06 Feb 2021 11:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xGSjaRmx2p2JR0P8vIgapMMPpiVSYCegoLT/8AClYHY=;
        b=eTmhq1wYHDxwnWkINjqlEtu842O9Rnb4Ox1dUXr7x6hCqNBx6Jqw+WMnO2U5a6DJja
         xFMJea3Fty0UhCrr+D/MqhyAF4rEt6sJRZBqU/JP6Xqw17ClaO/QwUbW3wiVbzj97/b3
         wHXHBBYFgXdwfwNLIf5myXcMxMhyOsM6/uatRD9sqfyAsAX2ql/oSUUv7ixUnuVkjPVO
         JJJDtm8MGcFP6bk6lEjfsNpSKhIVwA8JgsOAj1Evhvu3NLzB2HZYAJoYy3N+zcFl6Eyx
         2D4qPvGME5PJZkZ1u9dOd0wDxRzcFFPWk0orOWYc4Bg+eDBwAllBBm+aNHILje96NV00
         UPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xGSjaRmx2p2JR0P8vIgapMMPpiVSYCegoLT/8AClYHY=;
        b=TNKcddET+DtVw2pk/4fGMOJqVlTzYBEhhaKX5SEZ3RMDpaR9+5sjlJ+ndPh5aqSQ0S
         Z4HPQep6dUHAi+hg0dT6bAVGl0u5VUq1eKt/4oWWYjdFv6x2wJM27TybXbhmjHmBIRaT
         2ND33QdUBA/hjpkNCzi6OE0bh7DGUomTgeHDpipbcxRuyPqTnjcOUoygF60BcNE3dNAi
         cqNSR2jWVdAM3tWxndJ3CkQRI2ZqyuitC3tEXzfzvAQvSNDzUjSKDJIymRJaLXC0RzFO
         6rpEFbopuo8s/c5ak39ddK0PtoHPwW8WOlRho1n4RTm5wwqib8ReZzotS6t6yAZnojd2
         l4cA==
X-Gm-Message-State: AOAM532eQr7D5mSIF3lpLhUGRaZWm2HPXCKl+Nb4Ow9zcT0vOG+IQEpf
        hYxG8PA4HrzDUAmNRDc4h5ZZQltzWxqOZmst3Js=
X-Google-Smtp-Source: ABdhPJwAkLN8g10OlB3QOqMgWP+3nVzA6UYe+ANY+hUE4aeH0D3U+oF7O3tc+4pwhT+YzAAE67o0QCfgQChml0WNbb0=
X-Received: by 2002:a63:2cc5:: with SMTP id s188mr10811983pgs.233.1612639780483;
 Sat, 06 Feb 2021 11:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20210205224124.21345-1-xie.he.0141@gmail.com> <CA+FuTScLTZqZhNU7bWEw4OMTQzcKV106iRLwA--La0uH+JrTtg@mail.gmail.com>
 <CAHsH6GuW-xYp01ovBBC7+j8_v_WfiDmYznxW3Ajzo_qSFLy93A@mail.gmail.com>
In-Reply-To: <CAHsH6GuW-xYp01ovBBC7+j8_v_WfiDmYznxW3Ajzo_qSFLy93A@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 6 Feb 2021 11:29:29 -0800
Message-ID: <CAJht_ENLsfykXgz7jV6QNpEragQKueGTXy8yDbs=W_yZgDvHXg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Improve the comment about LL header
 visibility criteria
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        John Ogness <john.ogness@linutronix.de>,
        Tanner Love <tannerlove@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 7:43 AM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> As such, may I suggest making this explicit by making
> dev_hard_header() use dev_has_header()?

That is a good idea. We may submit another patch for that.
