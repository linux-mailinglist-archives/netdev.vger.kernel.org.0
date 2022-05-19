Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7672252DE08
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244571AbiESUAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbiESUAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:00:48 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA8D1B4
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:00:42 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id f16so10866230ybk.2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 13:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oRViwz3jVtsB9Viu0WY/n2LQib2ShqvF0DI/2+Zjl84=;
        b=lSkFo2eWTgLDpA+1tN2OwGTtWBwLCPVdUmIE59qRV0YgwbCCWZX0dACY0qseoBF0WY
         2m/uj9ppO4xQYopNxJ2UIjokEin586PRA1TOsMwISarOEMEkHuY0mGmSBLy5vUEGeuZN
         T9jCH5Rj4b5tQVeA9bnH8IEFl48FxoMKlukUzv+FQAZKSpovrtJOUG9Afg0lSFxjP149
         jLqFsrARHf+K0vzomuCqn9E085iE09XQbqlAoa67JE9ncARhn9Us7D4Nu9ZQXrofCrxR
         qaS/e81ndcQ4zt+oo6lIGdGU+Mv9lHFKowbns999nSwk+wIgPD6Tibl4eqPQoJEcxNCP
         /Psw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oRViwz3jVtsB9Viu0WY/n2LQib2ShqvF0DI/2+Zjl84=;
        b=e5KdA61lOWC6Z//+yj2fdjibuO6bir/5ocJf5TI3rSYH3wonNZBGVHiHyNHmZTx/fD
         DTU90hh0Ku48yB+YSfHMYrZVhYEEuHvtIhValaligfFf9bpmpMDtWcwcpnNFBK5v1JkB
         /0yULjtgirwS1lfGGXC+QLqXgE+Po4zsgi1H2/9b+7iGwIKiTzYrhPvmvSJRZcITcTaI
         mSkyzAbZe570HvAv73h6nFTKVYmOIkR7Ax9UrYVVZwaQgGZYy4hxDvedP0Q+ezzTv4F/
         /ThaD46bpD4kITVUrijeidsY8N5LUPpdBIjStFiC6k4E25sMjs72bPA9lst/i6nHL1Hc
         h76Q==
X-Gm-Message-State: AOAM531SCQyHIXRlPuHXULxzjoCpIe/meKNFM6INQRadhzM+uCYbBcVB
        b5pq7m5olWvyg7pEjjfLUwWOsPKCg8zFiBaXJkEJqw==
X-Google-Smtp-Source: ABdhPJyLMbFn52Xmabi/arl8EgkptAwhMNqS8YjxbQzjf/Snha02irAGr3xIj5f203zuc3f1yvHRU4rIuxR3o1H/X1I=
X-Received: by 2002:a25:838e:0:b0:64d:d090:1783 with SMTP id
 t14-20020a25838e000000b0064dd0901783mr5905795ybk.242.1652990441821; Thu, 19
 May 2022 13:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220513201243.2381133-1-vladimir.oltean@nxp.com>
 <CAGETcx9vjrh_ORhGq0g5oH5kUE8MbcyEW4Mv9i=S8m9PLzBkhA@mail.gmail.com> <20220519151529.qkhlsjfkh6mebpqw@skbuf>
In-Reply-To: <20220519151529.qkhlsjfkh6mebpqw@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 19 May 2022 13:00:05 -0700
Message-ID: <CAGETcx_eiuKnyTgzxGBzgakV7reQOEdfpsvVjAsUXVmCSvSttQ@mail.gmail.com>
Subject: Re: [RFC PATCH devicetree] of: property: mark "interrupts" as
 optional for fw_devlink
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?B?QWx2aW4g4pS8w6FpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 8:15 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Fri, May 13, 2022 at 05:26:19PM -0700, Saravana Kannan wrote:
> > On Fri, May 13, 2022 at 1:13 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > >
> > > I have a board with an Ethernet PHY whose driver currently works in poll
> > > mode. I am in the process of making some changes through which it will
> > > be updated to use interrupts. The changes are twofold.
> > >
> > > First, an irqchip driver needs to be written, and device trees need to
> > > be updated. But old kernels need to work with the updated device trees
> > > as well. From their perspective, the interrupt-parent is a missing
> > > supplier, so fw_devlink will block the consumer from probing.
> > >
> > > Second, proper interrupt support is only expected to be fulfilled on a
> > > subset of boards on which this irqchip driver runs. The driver detects
> > > this and fails to probe on unsatisfied requirements, which should allow
> > > the consumer driver to fall back to poll mode. But fw_devlink treats a
> > > supplier driver that failed to probe the same as a supplier driver that
> > > did not probe at all, so again, it blocks the consumer.
> >
> > This is easy to fix. I can send a patch for this soon. So, if the
> > driver matches the supplier and then fails the probe (except
> > EPROBE_DEFER), we can stop blocking the consumer on that supplier.
>
> Ok, FWIW I tried this but did not succeed. What I tried was to pass the
> error code to device_links_no_driver(), and from there call
> fw_devlink_unblock_consumers() if the error code was != EPROBE_DEFER.
> But the relevant links were skipped by fw_devlink_relax_link() for some
> reason I forget, perhaps the MANAGED flag was already set.

My fix would be different so as to not break when you have more than 1
matching driver but the 1st one fails the probe. But ignoring that for
a moment, wouldn't you want the result you got?

If fw_devlink_relax_link() skips a link, it's because:
1. The link was also requested/created by the driver/framework, so
it's not fw_devlink's place to ignore it.
2. The link is already a type that won't block probing.

Anyway I'll send out a patch for "if all the drivers that match a
device fails to probe it" then don't block probing of its consumers
AFTER the timeout. We can't ignore it before the timeout though
because a better driver might be loaded soon.

>
> > > According to Saravana's commit a9dd8f3c2cf3 ("of: property: Add
> > > fw_devlink support for optional properties"), the way to deal with this
> > > issues is to mark the struct supplier_bindings associated with
> > > "interrupts" and "interrupts-extended" as "optional". Optional actually
> > > means that fw_devlink will no longer create a fwnode link to the
> > > interrupt parent, unless we boot with "fw_devlink.strict".
> >
> > The optional flag is really meant for DT properties where even if the
> > supplier is present, the consumer might not use it.
>
> This is equally true for "interrupts", even I have an example for that,
> in commit 3c0f9d8bcf47 ("spi: spi-fsl-dspi: Always use the TCFQ devices
> in poll mode").

Then stop doing it :P

> > reasoning, fw_devlink doesn't wait for those suppliers to probe even
> > if the driver is present. fw_devlink outright ignores those properties
> > unless fw_devlink.strict=1 (default is = 0).
> > For some more context on why I added the optional flag, see Greet's
> > last paragraph in this email explaining IOMMUs:
> > https://lore.kernel.org/lkml/CAMuHMdXft=pJXXqY-i_GQTr8FtFJePQ_drVHRMPAFUqSy4aNKA@mail.gmail.com/#t
> >
> > I'm still not fully sold if the "optional" flag was the right way to
> > fix it and honestly might just delete it.
>
> Yeah, probably, but then the question becomes what else to do.

Once the patch I listed below settles down without issues, I might go
ahead and just delete this optional flag thing. Because the other
fw_devlink logic should cover those cases too.

There's still work to be done that might make this easier/cleaner in the future:
1. Adding a DT property that explicitly marks device A as not
dependent on B (Rob was already open to this -- with additional
context I don't want to type up here).
2. Adding kernel command line options that might allow people to say
stuff like "Device A doesn't depend on Device B independent of what DT
might say".

> > > So practically speaking, interrupts are now not "handled as optional",
> > > but rather "not handled" by fw_devlink. This has quite wide ranging
> > > side effects,
> >
> > Yeah, and a lot of other boards/systems might be depending on
> > enforcing "interrupts" dependency. So this patch really won't work for
> > those cases.
> >
> > So, I have to Nack this patch. But I tried to address your use case
> > and other similar cases with this recent patch:
> > https://lore.kernel.org/lkml/20220429220933.1350374-1-saravanak@google.com/
> >
> > If the time out is too long (10s) then you can reduce it for your
> > board (set it to 1), but by default every device that could probe will
> > probe and fw_devlink will no longer block those probes. Btw, I talked
> > about this in LPC2021 but only finally got around to sending out this
> > patch. Can you give it a shot please?
>
> This patch does work, but indeed, the 10 second timeout is not too
> convenient,

I was being very conservating with 10s. For my test set up in a Pixel
6, I think something like 5s or even 3s worked fine (no device links
that would have worked fine were dropped). So maybe try a smaller
number for your case?

> and the whole idea is to not disturb existing setups, i.e.
> those where things set up by the bootloader (kernel cmdline, FDT blob)
> are fixed, only the kernel image is updated.

I'm not sure I understand the concern. With my patch merged, if you
jump to a new kernel, the old DT should still work because of the 10s
timeout. If you add a new DT with new dependencies (but no driver for
them), it'll still work.

Btw, my patch is helping other instances of missing drivers outside of
your issue too. It's just a general "after most drivers are loaded you
can take a chill pill fw_devlink" patch.

> > > for example it happens to fix the case (linked below)
> > > where we have a cyclic dependency between a parent being an interrupt
> > > supplier to a child, fw_devlink blocking the child from probing, and the
> > > parent waiting for the child to probe before the parent itself finishes
> > > probing successfully. This isn't really the main thing I'm intending
> > > with this change, but rather a side observation.
> > >
> > > The reason why I'm blaming the commit below is because old kernels
> > > should work with updated device trees, and that commit is practically
> > > where the support was added. IMHO it should have been backported to
> > > older kernels exactly for DT compatibility reasons, but it wasn't.
> > >
> > > Fixes: a9dd8f3c2cf3 ("of: property: Add fw_devlink support for optional properties")
> > > Link: https://lore.kernel.org/netdev/20210826074526.825517-2-saravanak@google.com/
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > > Technically this patch targets the devicetree git tree, but I think it
> > > needs an ack from device core maintainers and/or people who contributed
> > > to the device links and fw_devlink, or deferred probing in general.
> > >
> > > With this patch in place, the way in which things will work is that:
> > > - of_irq_get() will return -EPROBE_DEFER a number of times.
> > > - fwnode_mdiobus_phy_device_register(), through
> > >   driver_deferred_probe_check_state(), will wait until the initcall
> > >   stage is over (simplifying a bit), then fall back to poll mode.
> > > - The PHY driver will now finally probe successfully
> > > - The PHY driver might defer probe for so long, that the Ethernet
> > >   controller might actually get an -EPROBE_DEFER when calling
> > >   phy_attach_direct() or one of the many of its derivatives.
> > >   This happens because "phy-handle" support was removed from fw_devlink
> > >   in commit 3782326577d4 ("Revert "of: property: fw_devlink: Add support
> > >   for "phy-handle" property"").
> >
> > The next DT property I add support to would be phy-handle. But to do
> > so, I need to make sure Generic PHYs are probed through the normal
> > binding process but still try to handle the case where the PHY
> > framework calls device_bind_driver() directly. I've spent a lot of
> > time thinking about this. I have had a tab open with the phy_device.c
> > code for months in my laptop. It's still there :)
> >
> > Once I add support for this, I can then add support for some of the
> > other mdio-* properties and then finally try to enable default async
> > boot for DT based systems.
>
> The problem with relying on fw_devlink for anything serious is that it
> will always be self-defeating until it is complete (and it will probably
> never be complete).

I honestly don't think it's self-defeating in its current state with
the timeout patch. It tries to enforce as many dependencies as it can
and then gets out of the way. I also think fw_devlink support for all
DT dependency bindings is not that far away from being complete. I
trawled through all the DT bindings several months back and didn't
find that many remaining DT properties that need to be added.

> I tried to explain this before, here:
> https://lore.kernel.org/netdev/20210901012826.iuy2bhvkrgahhrl7@skbuf/
> In summary, if there's any parent in this device/fwnode hierarchy that
> defers probe, the entire graph gets torn down, and fw_devlink won't hide
> the -EPROBE_DEFER from phylink anymore.

Well, the parent is deferring the probe because it's waiting for the
child devices to probe successfully before returning. That's not a
guarantee driver core makes, so it's not on the top of the list to fix
as long as fw_devlink doesn't block the probes (it doesn't). Is the
"won't hide the -EPROBE_DEFER from phylink anymore" a serious problem
for you? If so, I can try to fix that for you.

Seriously, the biggest blocker right now is the use of
device_bind_driver() in the networking code. And that's on my top
priority of things to fix whenever I get a few days of uninterrupted
time to work on upstream stuff.

> This, plus I would like something that works now (i.e. something that
> can make existing stable kernels accept a new DT blob with a PHY
> converted from poll to IRQ mode).

With the timeout patch, you have this right? Maybe + my patch to deal
with the driver returning error case (I'll send that out soon).

-Saravana
