Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF54B3715
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 11:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbfIPJZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 05:25:49 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:33910 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729553AbfIPJZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 05:25:49 -0400
Received: by mail-vk1-f196.google.com with SMTP id d126so5110941vkb.1
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 02:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lVvZxMvnkUm7v4Djpl2U0876asmMVjf66fovgS1q9Ug=;
        b=gVXp8UFlHkCIlom8seAltI7o8a13/Hlm/Mrba9+7euLO02gFV09aCzpaMwkeF3hnxy
         k0fLEskzYTy4q0fzku0gOQa/TVB30Y2dKSW4aLTAGpY5f0iNslDRd+2AUbeTIZFrLMuB
         +HZLmGdI8ozvaGzqyyS/xCBTgRRTV3rlWz1TfY58/Ly1KeEMJlxd1TlQpvXm/s/+Tf4I
         L4v9qCZq7b/5OewX8bdBVEZRWiVXXrUCTF4vRXPt2Uadh9AF7LUyg2JXRXAXmYgL9LpM
         sGjnYi5LO/DbO8SVeT6H36hNq6nYPR96VGYq2rNxqUoRaIsW6nUNtJHDHJTATjL7AZyI
         wXYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lVvZxMvnkUm7v4Djpl2U0876asmMVjf66fovgS1q9Ug=;
        b=AcKaVtuytokCnnTq3qy6D2kjfzbn8iMK+mMLGW9ZUPN5Fam2sUvuNyrnW8ZmtgwhXr
         15QwXhulQlhQQ2d6Qi4gwH+eK8k8zYCJnAZxkRyu1Ub04GgLmoLTguZxvFEofbWtvuSG
         PDMsrNsREPhDa8HOC2NrY61HENTbHtghGNPqq8qwuvoYogyZ8Sz17M6RD6a09NeCxVmf
         JSYNnn+P+WqJjtJmo5Nc/RdfNZrnTKNE9xd9jFx1Y3evwVO7pE7frl1iXIMcpRF6k6r9
         fLjo+E49UufJwiHgE1EPNGztWgK000HVD20CyiEDLlCG6RAWmcUNBXWvl9CWgaOXaye9
         f7ag==
X-Gm-Message-State: APjAAAWZFcWGhKFzczW5S9KfQbZRT4F5c2EoYh66S2BBSva+Kq6HLqKt
        wKA1cUP2j08S+46SgPZxWdWLjyLTXugBde3i4pFUww==
X-Google-Smtp-Source: APXvYqz8yNYoxi4lVLbhbNGaX+7YoPtphAV0D2lpTntT8mdxcEuM1NT2n7OYNKP0e1WxjFqDnGY2Wo/FL1nClmIaEw4=
X-Received: by 2002:a1f:8fc4:: with SMTP id r187mr28293588vkd.17.1568625946461;
 Mon, 16 Sep 2019 02:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190722193939.125578-1-dianders@chromium.org>
 <CAPDyKFoND5Kaam72zxO4wChO0z_1XL2KWX6oNjVcMUGA7G8RFg@mail.gmail.com> <CAD=FV=VTLoqGbxFFMT8h72cfHCLupyvZpD75JB0N86+kFA+vzw@mail.gmail.com>
In-Reply-To: <CAD=FV=VTLoqGbxFFMT8h72cfHCLupyvZpD75JB0N86+kFA+vzw@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 16 Sep 2019 11:25:10 +0200
Message-ID: <CAPDyKFrPHguMrMvXN0yHbD9GmEg4m=J1Un=LcpE0PB7WqMRYSg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: core: Fix Marvell WiFi reset by adding SDIO
 API to replug card
To:     Doug Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Andreas Fenkart <afenkart@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xinming Hu <huxinming820@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Sep 2019 at 23:26, Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Thu, Jul 25, 2019 at 6:28 AM Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >
> > On Mon, 22 Jul 2019 at 21:41, Douglas Anderson <dianders@chromium.org> wrote:
> > >
> > > As talked about in the thread at:
> > >
> > > http://lkml.kernel.org/r/CAD=FV=X7P2F1k_zwHc0mbtfk55-rucTz_GoDH=PL6zWqKYcpuw@mail.gmail.com
> > >
> > > ...when the Marvell WiFi card tries to reset itself it kills
> > > Bluetooth.  It was observed that we could re-init the card properly by
> > > unbinding / rebinding the host controller.  It was also observed that
> > > in the downstream Chrome OS codebase the solution used was
> > > mmc_remove_host() / mmc_add_host(), which is similar to the solution
> > > in this series.
> > >
> > > So far I've only done testing of this series using the reset test
> > > source that can be simulated via sysfs.  Specifically I ran this test:
> > >
> > > for i in $(seq 1000); do
> > >   echo "LOOP $i --------"
> > >   echo 1 > /sys/kernel/debug/mwifiex/mlan0/reset
> > >
> > >   while true; do
> > >     if ! ping -w15 -c1 "${GW}" >/dev/null 2>&1; then
> > >       fail=$(( fail + 1 ))
> > >       echo "Fail WiFi ${fail}"
> > >       if [[ ${fail} == 3 ]]; then
> > >         exit 1
> > >       fi
> > >     else
> > >       fail=0
> > >       break
> > >     fi
> > >   done
> > >
> > >   hciconfig hci0 down
> > >   sleep 1
> > >   if ! hciconfig hci0 up; then
> > >     echo "Fail BT"
> > >     exit 1
> > >   fi
> > > done
> > >
> > > I ran this several times and got several hundred iterations each
> > > before a failure.  When I saw failures:
> > >
> > > * Once I saw a "Fail BT"; manually resetting the card again fixed it.
> > >   I didn't give it time to see if it would have detected this
> > >   automatically.
> > > * Once I saw the ping fail because (for some reason) my device only
> > >   got an IPv6 address from my router and the IPv4 ping failed.  I
> > >   changed my script to use 'ping6' to see if that would help.
> > > * Once I saw the ping fail because the higher level network stack
> > >   ("shill" in my case) seemed to crash.  A few minutes later the
> > >   system recovered itself automatically.  https://crbug.com/984593 if
> > >   you want more details.
> > > * Sometimes while I was testing I saw "Fail WiFi 1" indicating a
> > >   transitory failure.  Usually this was an association failure, but in
> > >   one case I saw the device do "Firmware wakeup failed" after I
> > >   triggered the reset.  This caused the driver to trigger a re-reset
> > >   of itself which eventually recovered things.  This was good because
> > >   it was an actual test of the normal reset flow (not the one
> > >   triggered via sysfs).
> > >
> > > Changes in v2:
> > > - s/routnine/routine (Brian Norris, Matthias Kaehlcke).
> > > - s/contining/containing (Matthias Kaehlcke).
> > > - Add Matthias Reviewed-by tag.
> > > - Removed clear_bit() calls and old comment (Brian Norris).
> > > - Explicit CC of Andreas Fenkart.
> > > - Explicit CC of Brian Norris.
> > > - Add "Fixes" pointing at the commit Brian talked about.
> > > - Add Brian's Reviewed-by tag.
> > >
> > > Douglas Anderson (2):
> > >   mmc: core: Add sdio_trigger_replug() API
> > >   mwifiex: Make use of the new sdio_trigger_replug() API to reset
> > >
> > >  drivers/mmc/core/core.c                     | 28 +++++++++++++++++++--
> > >  drivers/mmc/core/sdio_io.c                  | 20 +++++++++++++++
> > >  drivers/net/wireless/marvell/mwifiex/sdio.c | 16 +-----------
> > >  include/linux/mmc/host.h                    | 15 ++++++++++-
> > >  include/linux/mmc/sdio_func.h               |  2 ++
> > >  5 files changed, 63 insertions(+), 18 deletions(-)
> > >
> >
> > Doug, thanks for sending this!
> >
> > As you know, I have been working on additional changes for SDIO
> > suspend/resume (still WIP and not ready for sharing) and this series
> > is related.
> >
> > The thing is, that even during system suspend/resume, synchronizations
> > are needed between the different layers (mmc host, mmc core and
> > sdio-funcs), which is common to the problem you want to solve.
> >
> > That said, I need to scratch my head a bit more before I can provide
> > you some feedback on $subject series. Moreover, it's vacation period
> > at my side so things are moving a bit slower. Please be patient.
>
> I had kinda forgotten about this series after we landed it locally in
> Chrome OS, but I realized that it never got resolved upstream.  Any
> chance your head has been sufficiently scratched and you're now happy
> with $subject series?  ;-)

It's still on my TODO list. Apologize for the delay, but I still need
more time to look into it, possibly later this week.

In any case, let's make sure we get this problem resolved for v5.5.

Kind regards
Uffe
