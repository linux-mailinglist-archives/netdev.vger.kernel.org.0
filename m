Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A64363D1D
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 10:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbhDSID3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 04:03:29 -0400
Received: from mail-vs1-f41.google.com ([209.85.217.41]:44909 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhDSID0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 04:03:26 -0400
Received: by mail-vs1-f41.google.com with SMTP id t23so788928vso.11;
        Mon, 19 Apr 2021 01:02:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRE7kUfgnyAkLcXnn28/l9BglZanciveXxOogGBkKYA=;
        b=gbQqLesm1el/IA5e0SjWJjQW+nJzz0LSVH2i1Jo4EoU3EKjvEAUJbqrWkBaorJMNbj
         uM9nYaLzds+a9QjapGruGt8+j0yaBfPN9q3h1lxbYaOSnnFDNOAS7yICZwurBCiorxhr
         STeqJV9o8CsRudc+klsEcb3Z2nOod5QONLbsvv+v7vncAqOyJ5iCNjddNItsZRQgzPm5
         zTN9Q1/lTyvgG1qWnOVdzhDFXQ4NFhgH4UV3mLXhMbeLiU4ytCY2N/8Oqr8MOOB9T9uh
         X1SORJVoS7vEN9Lmg1qijjRWq0YCWUIFK/7ILH/21bz60Ejd900J3Q9rRVJ4iBbxVEAa
         qUYA==
X-Gm-Message-State: AOAM533dOpzSwITZRKFoFdsVsXMwJW0khWpz8ug43vRiacslFo6Ychf+
        9JTt4An9JPbtjwTIzJfOxPNvqO7xCNr99AaD4Lk=
X-Google-Smtp-Source: ABdhPJy7REj0RnwsC0BmC4LayU/iKxq10ifb4FvZKHMY+ozOYrogO74Rl4V4Kli3EDWHBjKXGqJivciBrwVoQCb4shA=
X-Received: by 2002:a67:f503:: with SMTP id u3mr12324042vsn.3.1618819375153;
 Mon, 19 Apr 2021 01:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210417132329.6886-1-aford173@gmail.com>
In-Reply-To: <20210417132329.6886-1-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Apr 2021 10:02:44 +0200
Message-ID: <CAMuHMdXPj-p++EAkq=nUKqQB4_FM7whi8BbFm+1OG5EPF98hLg@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: ravb: Fix release of refclk
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 3:23 PM Adam Ford <aford173@gmail.com> wrote:
> The call to clk_disable_unprepare() can happen before priv is
> initialized. This means moving clk_disable_unprepare out of
> out_release into a new label.
>
> Fixes: 8ef7adc6beb2("net: ethernet: ravb: Enable optional refclk")
> Signed-off-by: Adam Ford <aford173@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
