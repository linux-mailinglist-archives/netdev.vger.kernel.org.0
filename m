Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADA8E4626
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392981AbfJYIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:48:44 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42741 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389425AbfJYIso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:48:44 -0400
Received: by mail-oi1-f196.google.com with SMTP id i185so1050033oif.9;
        Fri, 25 Oct 2019 01:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uA6lSNHDRCatiJVJ/bgW4yuf0LByUeyt0njk9B4ukrc=;
        b=pB1+s7USrm2jK85Akcv2CH3fUw/7POfgi/pgDdjS44HoqmOwhRJtXlOBQHZ2MEEmZz
         zu9xxhWTFFKoHoaQMdR60oyEToi9uPlwzM1BBa2FNJ2D58lrim6ylC/Z1eY04ZZg6Fi4
         yXdYkFlm7DbQBtjVP2+uFUxx+0qkSBCyk3gYQuXKGl/yTFANNMvx1reHErjCeQePx++4
         8wY3yEAY+hSwF4/cEGQxXi8/Q6yJIXeITmGmxUARPAP4I+TM3sLtu3MgrZmOM1wpvbQg
         FtcJRprTvebpzrS4IP17JXY7ad5Vw6O52Pjz8/W6o05yoDGNbPO3HcFv+5oFuSAfmDwv
         K69A==
X-Gm-Message-State: APjAAAXd7HRybCHuKR49gUG/tXaXd9tT+IRTL99HwWmVJ6M1pCcKlTS7
        cJgcweT4SFuFCbApgqlqv7rlhXFWaEQDhZF7W+c=
X-Google-Smtp-Source: APXvYqy3g9SYZvOxsJVmghtKOBqa12cq3/vF5Q6/wloURwxegziLuCjjGM4yxIDdlwF02aQ5tVVijREi3KOgNM/I0d4=
X-Received: by 2002:aca:882:: with SMTP id 124mr2027997oii.54.1571993322988;
 Fri, 25 Oct 2019 01:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191024152201.29868-1-geert+renesas@glider.be>
 <878spaqg2k.fsf@kamboji.qca.qualcomm.com> <20191024.095709.187911510311520475.davem@davemloft.net>
In-Reply-To: <20191024.095709.187911510311520475.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 25 Oct 2019 10:48:31 +0200
Message-ID: <CAMuHMdXLyoxpjYYVhnZ35hwD25+MPXkte5QV_YYOadPVTf9_zA@mail.gmail.com>
Subject: Re: [PATCH v2] [trivial] net: Fix misspellings of "configure" and "configuration"
To:     David Miller <davem@davemloft.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jiri Kosina <trivial@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, Oct 24, 2019 at 6:57 PM David Miller <davem@davemloft.net> wrote:
> From: Kalle Valo <kvalo@codeaurora.org>
> Date: Thu, 24 Oct 2019 19:11:15 +0300
>
> > Geert Uytterhoeven <geert+renesas@glider.be> writes:
> >
> >> Fix various misspellings of "configuration" and "configure".
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >> ---
> >> v2:
> >>   - Merge
> >>     [trivial] net/mlx5e: Spelling s/configuraiton/configuration/
> >>     [trivial] qed: Spelling s/configuraiton/configuration/
> >>   - Fix typo in subject,
> >>   - Extend with various other similar misspellings.
> >> ---
> >>  drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 2 +-
> >>  drivers/net/ethernet/qlogic/qed/qed_int.h                | 4 ++--
> >>  drivers/net/ethernet/qlogic/qed/qed_sriov.h              | 2 +-
> >>  drivers/net/ethernet/qlogic/qede/qede_filter.c           | 2 +-
> >>  drivers/net/wireless/ath/ath9k/ar9003_hw.c               | 2 +-
> >>  drivers/net/wireless/intel/iwlwifi/iwl-fh.h              | 2 +-
> >>  drivers/net/wireless/ti/wlcore/spi.c                     | 2 +-
> >>  include/uapi/linux/dcbnl.h                               | 2 +-
> >>  8 files changed, 9 insertions(+), 9 deletions(-)
> >
> > I hope this goes to net-next? Easier to handle possible conflicts that
> > way.
> >
> > For the wireless part:
> >
> > Acked-by: Kalle Valo <kvalo@codeaurora.org>
>
> Yeah I can take it if that's easier.

That would be great, thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
