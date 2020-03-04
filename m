Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A3D17870B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 01:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgCDAbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 19:31:53 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40498 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbgCDAbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 19:31:53 -0500
Received: by mail-lf1-f66.google.com with SMTP id p5so4355562lfc.7;
        Tue, 03 Mar 2020 16:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0535QGjciwSzjRFczO8hMlo3JpfPidZ1FORuAyueRYY=;
        b=Pdxgwp2q8OaHvBozqu4AbhMdVXPLkLhWYzqxroyWFYmwUIYQcgZzOyP1+TXB0oxqGO
         Sux2ChcPrb7y8Ys71fi4OuTIynL4EwNbYS98em9pvH9+dpjLrMQQ7CArXxt2FabMjyve
         KDO25Gf7c2Tk/MApcFTcPuRTjRRXkHn5ZZPxEhVPvTN7h28RGfd1c9wExlYcXUP6j0yC
         Tle4IoHI3BOTd8QoqLXae7pnOFPx317lca7b9eVvx2a0TG0oP4ybTLFcoptsIlmzdNq8
         U0ovUOrxgIIBOmbKsq/m+5b6fz1QEJSaFkOGFz1MH3aQmXkKUl9Yvo/1DWVgqcWuPtbN
         NtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0535QGjciwSzjRFczO8hMlo3JpfPidZ1FORuAyueRYY=;
        b=f7oTpEM1TjZ40boOczaIOrUKCbVCJ9vq2TWduuSBE3NB/FNe2HM7jRnCXfnRJ62dmv
         fzl9LpUsdXhpGAJs/xgDz2Mdj3mK8a/59FM1enia1RHC+bJOUTZlYKJ7XuDYZqo8/lB5
         6AFxtjNZeSJVkXyCbIvxZr9m3JQR3HFQfQ2f9vCsV53cXncFg8JwNUysMh/csFBYzpru
         Ngo8XBn8g/JqHhQBOc1SZHOXNbCJxkAc6kWPOxB5+WJWTBMPNb3Ebtv+LMRy6jiPjp9X
         0A14I9vyME2SgwMzx070JgmuQsO8uxV39d1Gt26L0xrOGfgm07GtRgbVwXNnkwe88gXe
         1OAA==
X-Gm-Message-State: ANhLgQ1u6lJGEAF9kJ7WsSoAvQS4Z/LWfNE3Uhq+V13fUlMVPFysZkll
        gYIlikM3FJjug5MiltDx3LdawV9pVhz9QZffbGYQog==
X-Google-Smtp-Source: ADFU+vs9VE5TLCPK+qRWVrvaL2BnKsZ59PC3uMzG6DbCGWVhNAMhkXsyVdnc/of2HgQpAyOzG7Ncy6Pt/r4Ft/Oruoo=
X-Received: by 2002:ac2:5df9:: with SMTP id z25mr315643lfq.8.1583281911470;
 Tue, 03 Mar 2020 16:31:51 -0800 (PST)
MIME-Version: 1.0
References: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com> <CAGdtWsSd8sDoxTfW_Jcwc9u4sfHECKMzxt_GNjMTkWCbvKBr0A@mail.gmail.com>
In-Reply-To: <CAGdtWsSd8sDoxTfW_Jcwc9u4sfHECKMzxt_GNjMTkWCbvKBr0A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Mar 2020 16:31:39 -0800
Message-ID: <CAADnVQ+zbBuM1TYQ93CaGA3nKqVCS0ESKuo8M5NrXEQPPOEWvg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] add gso_size to __sk_buff
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 2:56 PM Petar Penkov <ppenkov.kernel@gmail.com> wrote:
>
> For the series: Acked-by: Petar Penkov <ppenkov@google.com>

please don't top post.

> On Tue, Mar 3, 2020 at 1:46 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > See first patch for details.
> >
> > Patch split across three parts { kernel feature, uapi header, tools }
> > following the custom for such __sk_buff changes.

Applied. Thanks
