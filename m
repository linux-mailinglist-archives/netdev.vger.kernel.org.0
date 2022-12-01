Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E3363F9B7
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiLAVRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLAVRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:17:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51792186;
        Thu,  1 Dec 2022 13:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5013B6211E;
        Thu,  1 Dec 2022 21:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9B9C433D6;
        Thu,  1 Dec 2022 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669929465;
        bh=tdCHmZccPVBOw00B52Hg+0Wg5enkxGAqRv7obDTmBSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DmT7B6OgfvmSRTH7So5BnVZjmFmqoe0qJSqHd7Cs9wCpjHDNzLex4CdBWepRqY6fJ
         mW9IQIwzlVzWwHSwAAHa+1UPTg/Ro0bxrpIxHHbZM/K9dVlfTf3KxWbAVLOCJfFAvq
         0FEn7u7Go8Erixv/ede7uK4BQUE7JwaA0GJUK05XhGdHVACIZXEbj8IM03n/+grpir
         IBgpj1/8y603l2oVjg79pkt6sSBwLVNcSq3Un1L34V8oRhci/6Bc8cykXXLhhrTtia
         oFBp1S6ZX0YkGL7dMZLv2okQgh08A8wsTiDY0zQ/dQL0B95sMr4zZS42xki2eWVUxG
         6P1Nfq883ftTQ==
Date:   Thu, 1 Dec 2022 13:17:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Elad Nachman <enachman@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH v2] MAINTAINERS: Update maintainer for Marvell Prestera
 Ethernet Switch driver
Message-ID: <20221201131744.6e94c5f7@kernel.org>
In-Reply-To: <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
References: <20221128093934.1631570-1-vadym.kochan@plvision.eu>
        <20221129211405.7d6de0d5@kernel.org>
        <96e3d5fc-ab8c-2344-3266-3b73664499f1@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 10:39:07 +0200 Taras Chornyi wrote:
> On 30.11.22 07:14, Jakub Kicinski wrote:
> > On Mon, 28 Nov 2022 11:39:34 +0200 Vadym Kochan wrote: =20
> >> Add Elad Nachman as maintainer for Marvell Prestera Ethernet Switch dr=
iver.
> >>
> >> Change Taras Chornyi mailbox to plvision. =20
> > This is a patch, so the description needs to explain why...
> > and who these people are. It would seem more natural if you,
> > Oleksandr and Yevhen were the maintainers.
> >
> > Seriously, this is a community project please act the part. =20
> The Marvell Prestera Switchdev Kernel Driver's focus and maintenance are=
=20
> shifted from PLVision (Marvell Contractors) to the Marvell team in Israel.
> In the last 12 months, the driver's development efforts have been shared=
=20
> between the PLVision team and Elad Nachman from the Marvell Israel group.

Ah, damn, I was worried that's what you'd say :(

> Elad Nachman is a veteran with over ten years of experience in Linux=20
> kernel development.
> He has made many Linux kernel contributions to several community=20
> projects, including the Linux kernel, DPDK (KNI Linux Kernel driver) and=
=20
> the DENT project.
> Elad has done reviews and technical code contributions on Armada 3700,=20
> Helping Pali Roh=C3=A1r, who is the maintainer of the Armada 3700 PCI=20
> sub-system, as well as others in the Armada 3700 cpufreq sub-system.
> In the last year and a half, Elad has internally dealt extensively with=20
> the Marvell Prestera sub-system and has led various upstreaming=20
> sub-projects related to the Prestera sub-system, Including Prestera=20
> sub-system efforts related to the Marvell AC5/X SOC drivers upstreaming.=
=20
> This included technical review and guidance on the technical aspects and=
=20
> code content of the patches sent for review.
> In addition, Elad is a member of the internal review group of code=20
> before it applies as a PR.

I see 4 mentions of Elad Nachman in the entire git history.

The distinction between the kernel community and the corporate Linux
involvement is something I don't quite know how to verbalize.
And I don't know whether my perspective is shared by others.

Linux has taken over the world (at least the technical world) so having
Linux kernel exposure is common. But building a product based on Linux
which is then packaged and shipped to customers, in the usual corp
product development methodology, translates very poorly to developing
upstream. This is more true in networking that other parts of the
kernel, to my knowledge, because we attempt to build vendor-independent
abstractions.

While I do not mean to question Elad's expertise and capability as an
engineer/lead/manager, and very much appreciate Marvell's investment=20
in the upstream drivers for Prestera and in DENT -- I think the
community involvement is lacking. Short to medium term we should try to
find a way of improving this situation, we can clarify what we expect
from you and if you have ideas on how we can make the involvement**
easier - we'd love to hear them.

** community involvement ideas, less interested in how we can make the
   "ship products" part easier, but you can share those too

> Finally, do note the fact that I will continue to maintain/support this=20
> driver, but I would like to have someone that I can share the effort with.

Understandable. I hope PLVision does not disappear form the picture.
We are really allergic to the "push the driver upstream and disengage"
or "throw it over the wall open source" model, if you will.

Unfortunately we only have one nuclear button for discouraging such
arrangements (git-rm), which will hopefully never be used.

To conclude, I think we should have a call first, and then decide
who the best choice for a maintainer is.=20
