Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D9DEB4A1
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfJaQYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:24:19 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39434 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbfJaQYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:24:18 -0400
Received: by mail-vs1-f65.google.com with SMTP id y129so4474352vsc.6
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPIDo2fSmnVpiauzvpAAbaK4lF2gIAi5NghO5p90Ozs=;
        b=khzDIJIPRAGhIdZTay7i4L5qhMiwaisFOVhQwT9VB0W5RAwk50WnAC+s9lN4QBmjet
         S7nW7xbAJsHQj/lREQfdyhdToFzSWNsG6Nmzoa8CYnhTNFRyVJzi8KdEOAiZagzomntK
         SvI9itLHPv9NBi04RsumdCRqAEYfHRgcDUD7Ih2vFEfb0DBwd86oieQekamm/PIJQF9y
         uHJdXeFqkylwDT+4BlpG1idBPSeXoomT0mr64+OlZ9yH9o9FDVe7dRR20+DP/cuCTObZ
         l71VczynWJnlq6y4ZzHfL6HNCs+XxS4+9ksqEFfqGvufglrkApqnwWLEmTLZ9QkBcYv6
         iEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPIDo2fSmnVpiauzvpAAbaK4lF2gIAi5NghO5p90Ozs=;
        b=QjzidbXb8c030VVRVRrF6pRumu/c6AFEoaQ8TfAY3GdEO3BCWOitmulMJIBVKdmzw/
         PSy4SiC+uKBd+7U6E3ojA25GR9Qu3HtYhoLJtq+o/nWFiaPTuBC7Dep5dpAAqrxGY9ML
         l5/iwtYXqi4p7wBWSMmO4rd0FgSulO2v5BVlL9SIZHi+LL5Z8mLe5SlT6FOqxtow9hSC
         IGyP/lDiun5VO4NHqkwO9xue7eExjC0U+Bf0NXq71L8OmEOoQg9FwSyKVx1G+5p65fq1
         GOiDE9FpY/vSyiicVV12uPS8jFY43KCNclto8XSixUNWhaVjDCViQb6sMIw1AOOO2xCy
         g1rg==
X-Gm-Message-State: APjAAAXxiTXgMdA5vyga6/RA6gSOpZ2O5ezj3yHmEAcUcU+vynYzS5uS
        FrEcloDlhw1uUa0KLfDlErdtw+yQSoQFWQAbUhHQ0w==
X-Google-Smtp-Source: APXvYqwALcYbrmJQuMMQV7datNl1JuMFD5T9xVx+oBGGYVorWljG30SurqydJbjDqFGCToghHd7hGUnpIqW5lZBfwrE=
X-Received: by 2002:a05:6102:36d:: with SMTP id f13mr3268985vsa.34.1572539056794;
 Thu, 31 Oct 2019 09:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571510481.git.hns@goldelico.com> <0887d84402f796d1e7361261b88ec6057fbb0065.1571510481.git.hns@goldelico.com>
 <CAPDyKFp3EjTuCTj+HXhxf+Ssti0hW8eMDR-NrGYWDWSDmQz6Lw@mail.gmail.com> <607E3AE4-65BF-4003-86BE-C70646D53D09@goldelico.com>
In-Reply-To: <607E3AE4-65BF-4003-86BE-C70646D53D09@goldelico.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 31 Oct 2019 17:23:40 +0100
Message-ID: <CAPDyKFr3oh9HcExn4Sx0Cd2e0oBTsxz+L4tDvypRFP8=hQP=cg@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] mmc: host: omap_hsmmc: add code for special init
 of wl1251 to get rid of pandora_wl1251_init_card
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 at 18:25, H. Nikolaus Schaller <hns@goldelico.com> wrote:
>
> Hi Ulf,
>
> > Am 30.10.2019 um 16:51 schrieb Ulf Hansson <ulf.hansson@linaro.org>:
> >
> >> +
> >> +               np = of_get_compatible_child(np, "ti,wl1251");
> >> +               if (np) {
> >> +                       /*
> >> +                        * We have TI wl1251 attached to MMC3. Pass this information to
> >> +                        * SDIO core because it can't be probed by normal methods.
> >> +                        */
> >> +
> >> +                       dev_info(host->dev, "found wl1251\n");
> >> +                       card->quirks |= MMC_QUIRK_NONSTD_SDIO;
> >> +                       card->cccr.wide_bus = 1;
> >> +                       card->cis.vendor = 0x104c;
> >> +                       card->cis.device = 0x9066;
> >> +                       card->cis.blksize = 512;
> >> +                       card->cis.max_dtr = 24000000;
> >> +                       card->ocr = 0x80;
> >
> > These things should really be figured out by the mmc core during SDIO
> > card initialization itself, not via the host ops ->init_card()
> > callback. That is just poor hack, which in the long run should go
> > away.
>
> Yes, I agree.
>
> But I am just the poor guy who is trying to fix really broken code with
> as low effort as possible.

I see. Thanks for looking at this mess!

In general, as long as we improve the code, I am happy to move forward.

However, my main concern at this point, is to make sure we get the DT
bindings and the DTS files updated correctly. We don't want to come
back to this again.

>
> I don't even have a significant clue what this code is exactly doing and what
> the magic values mean. They were setup by pandora_wl1251_init_card() in the
> same way so that I have just moved the code here and make it called in (almost)
> the same situation.

Okay!

>
> > Moreover, I think we should add a subnode to the host node in the DT,
> > to describe the embedded SDIO card, rather than parsing the subnode
> > for the SDIO func - as that seems wrong to me.
>
> You mean a second subnode?
>
> The wl1251 is the child node of the mmc node and describes the SDIO card.
> We just check if it is a wl1251 or e.g. wl1837 or something else or even
> no child.

The reason why I brought this up, was because there are sometimes
cases where an SDIO card is shared between more than one SDIO func.
WiFi+Bluetooth for example, but if I am correct, that is not the case
for wl1251?

That said, I am happy to continue with your approach.

>
> > To add a subnode for the SDIO card, we already have a binding that I
> > think we should extend. Please have a look at
> > Documentation/devicetree/bindings/mmc/mmc-card.txt.
> >
> > If you want an example of how to implement this for your case, do a
> > git grep "broken-hpi" in the driver/mmc/core/, I think it will tell
> > you more of what I have in mind.
>
> So while I agree that it should be improved in the long run, we should
> IMHO fix the hack first (broken since v4.9!), even if it remains a hack
> for now. Improving this part seems to be quite independent and focussed
> on the mmc subsystem, while the other patches involve other subsystems.

I agree.

>
> Maybe should we make a REVISIT note in the code? Or add something to
> the commit message about the idea how it should be done right?

Just add a note that we should move this DT parsing of the subnode to
the mmc core, but that we are leaving that as a future improvement.
That's good enough. Then I can have a look as a second step, and when
I get some time, to move this to the mmc core.

However, there is one thing I would like you to add to the series. That is:

In the struct omap_hsmmc_platform_data, there is an ->init_card()
callback. Beyond the changes of this series, there is no longer any
users of that, unless I am mistaken. Going forward, let's make sure it
doesn't get used again, so can you please remove it!?

[...]

Kind regards
Uffe
