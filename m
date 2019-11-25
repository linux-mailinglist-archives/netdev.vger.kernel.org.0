Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16844108BE9
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfKYKj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:39:58 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32892 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfKYKj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:39:57 -0500
Received: by mail-ed1-f68.google.com with SMTP id a24so12237167edt.0;
        Mon, 25 Nov 2019 02:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ViDyXNSpHaaH3OFubVRo3F6v5gJ1fGy0QZqshSl5CQ=;
        b=MYWBLphnvYufVWnC/3FBql5ADo2y+o1lvjxPAR4CEu32RqPiwS7qbvjMmDQfC7YHg6
         VvX1fjUibqYhd5B9WjXuraaLF2QOvOc+gQsddkD9XE1kiBWxqX19RL0wJMYlLb11kA7U
         t7EoK/xRRycLKMoTraotgCq5mVxE3e2JG9eenl6PGvV3Q4KP8dqjVdXQGyIwyDBgR+s7
         VWB9xCnzkCS9jzcvLFlmRrtGoFDt4iP11eAlKQrOtZH0y729yPoSM1S+v/kTOtipm5zm
         ITlCi0FlsDc1gV+SiAUW21AS8N0ynffblujM/oHUi7j4OHlinr0gOf2q4vfHo0QLctWU
         XDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ViDyXNSpHaaH3OFubVRo3F6v5gJ1fGy0QZqshSl5CQ=;
        b=NU5gVQdIIe+jVitNAv/fDAjvBLJjXEM0Innl+pzKaMPIm4o4grYsPqPmcK8gEBa+yD
         kcORa+8ORZySpTGO8RgJme2CBiHgZH1lv13+QdXmUDgBcQeEgVCvlNF0u59nA2DBK37T
         tL8DsYzZAkP/N91dSoTDcbU7tEpALO0SfyZnzZJ3kjyvdeShZ2ObfVDq/IfFyVhBfwLq
         +GcMqY5n20qKghzPqdV9O7omFPqfaSAI5Jb1gGhp0GAmDpLscQvrx4sPA/Y1P2czWCdo
         HzDeH4scPSjwiJxvPRAra3dLUODqYz5mkHhfLiM4OZNME1vdOaxa44zryaBAf5CRIzSs
         qdxA==
X-Gm-Message-State: APjAAAXiALOufQicF4Rek/c7VCFjvSKvzao5Tggb+4ujF75EVEfsAJup
        RTi7gIcvQkLTZAsD5m9OeWBnDzwylq/84VEHtUc=
X-Google-Smtp-Source: APXvYqz1CR0mxqDb3+qFk6F6u3U+5Rt32RCF09Q5JzaDRy2yIySTZJrmUJaTiwIO/PS5WHgr2zy4mLyY7MrR0DeZV04=
X-Received: by 2002:a05:6402:2299:: with SMTP id cw25mr11723620edb.36.1574678395405;
 Mon, 25 Nov 2019 02:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
 <CA+h21hrwK-8TWcAowcLC5MOaqE+XYXdogmAE7TYVG5B3dG57cA@mail.gmail.com> <caab9bcc-a4a6-db88-aa23-859ffcf6ff85@pengutronix.de>
In-Reply-To: <caab9bcc-a4a6-db88-aa23-859ffcf6ff85@pengutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 25 Nov 2019 12:39:44 +0200
Message-ID: <CA+h21ho9bJsaq8e-gRhRpM+kXARNJ6tyL10vKVf2+7YOtaJGXw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] net: dsa: sja1105: print info about probet chip
 only after every thing was done.
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 12:32, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> On 25.11.19 11:22, Vladimir Oltean wrote:
> > On Mon, 25 Nov 2019 at 12:03, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >>
> >> Currently we will get "Probed switch chip" notification multiple times
> >> if first probe filed by some reason. To avoid this confusing notifications move
> >> dev_info to the end of probe.
> >>
> >> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >> ---
> >
> > Also there are some typos which should be corrected:
> > probet -> probed
> > every thing -> everything
> > filed -> failed
> >
> > "failed for some reason" -> "was deferred"
>
> Ok, thx.
>
> should i resend both patches separately or only this one with spell fixes?
>

I don't know if David/Jakub like applying partial series (just 2/2). I
would send a v2 to each patch specifying the tree clearly.
Also I think I would just move the "Probed...." message somewhere at
the beginning of sja1105_setup, where no probe deferral can happen.

>
> Kind regards,
> Oleksij Rempel
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Thanks,
-Vladimir
