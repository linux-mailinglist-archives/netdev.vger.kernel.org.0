Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52EA4E96A4
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbiC1MdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbiC1MdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:33:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BD135AA1;
        Mon, 28 Mar 2022 05:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC688B80DFE;
        Mon, 28 Mar 2022 12:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A869FC340EC;
        Mon, 28 Mar 2022 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648470682;
        bh=fLGdb7dSfAqcoc7SmA0DtwuG5S8J1UMKX6NM0JYvlbE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=vR3sm0Sym9PNeV1iKQGwMQbPO6yRDwohIBCSBdBAAXuDDO0SWpja6OgX6EnOvgTmq
         TjnzAmmgRqAI7VMMqH2O7CUJ6XEWGQoPVF1AN2lYHSalQOuTT+xH3TeXiapzkBoDDY
         tTzTYQ5GBWa2GALcTzd9hSykzmqjjHuEIfoQNXYeYukvQqZVWjJgo1IrRVnWgagObl
         g/dwjiafO/fytUgqLw8IWTrjQWjo/zqFAaNAJAQ8gjKtytzwyaZGjuidRKQhih/yde
         bDhRRLmxOXxLsSy40enpsfgnUm8nwGiwmrDs+aoLJB2mBmG7Pk8oHcDE3szRC3iHWp
         ESPsCuNOlpy8A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Benjamin =?utf-8?Q?St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/22] Replace comments with C99 initializers
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz>
        <87fsn2zaix.fsf@kernel.org>
        <cc104272-d79a-41e1-f4de-cb78fb073991@stuerz.xyz>
Date:   Mon, 28 Mar 2022 15:31:14 +0300
In-Reply-To: <cc104272-d79a-41e1-f4de-cb78fb073991@stuerz.xyz> ("Benjamin
        \=\?utf-8\?Q\?St\=C3\=BCrz\=22's\?\= message of "Mon, 28 Mar 2022 13:51:42 +0200")
Message-ID: <87bkxqz2b1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin St=C3=BCrz <benni@stuerz.xyz> writes:

> On 28.03.22 11:33, Kalle Valo wrote:
>> Benjamin St=C3=BCrz <benni@stuerz.xyz> writes:
>>=20
>>> This patch series replaces comments with C99's designated initializers
>>> in a few places. It also adds some enum initializers. This is my first
>>> time contributing to the Linux kernel, therefore I'm probably doing a
>>> lot of things the wrong way. I'm sorry for that.
>>=20
>> Just a small tip: If you are new, start with something small and learn
>> from that. Don't do a controversial big patchset spanning multiple
>> subsystems, that's the hard way to learn things. First submit one patch
>> at a time to one subsystem and gain understanding of the process that
>> way.
>
> I actually thought this would be such simple thing.

If there are 22 patches and a dozen different subsystems it's far from
simple, as you noticed from your replies :)

> Do you know of any good thing where to start? I already looked into
> drivers/staging/*/TODO and didn't found something for me personally.

I work in wireless and one my annoyance is use of BUG_ON() in wireless
drivers. There just isn't a good reason to crash the whole system when
there's a bug in a wireless driver or firmware. You can get list like
this:

git grep BUG_ON drivers/net/wireless/ | grep -v BUILD_BUG_ON

It might not be always trivial to fix BUG_ON() usage, so it would be a
good challenge as well. See the wiki link below how to submit wireless
patches. But just send a one patch first, don't work for several hours
and then submit a big set of patches.

We also might have a todo list somewhere in the wiki, but don't know how
to up-to-date it is.

> Should I drop this patchset and start with something different?=20

Like Mauro suggested, splitting the patchset per subsystem is a very
good idea. And first try out with one subsystem, and after seeing how it
goes (if they are accepted or rejected), decide if you send more patches
to other subsystems.

> If yes, what would the proper way to drop it? Just announcing, that
> this is going nowhere in a separate patch?

Replying to Mauro's email and telling your intentions is a good way to
inform everyone.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
