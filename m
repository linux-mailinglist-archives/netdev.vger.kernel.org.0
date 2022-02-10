Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957014B10EB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243221AbiBJOvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:51:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiBJOvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:51:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67F2EA1;
        Thu, 10 Feb 2022 06:51:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 725C361AC3;
        Thu, 10 Feb 2022 14:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A231C004E1;
        Thu, 10 Feb 2022 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644504669;
        bh=lRD3lBDFEjNGr8K6VaXM+s1gigm4CwkCeahOEMFr7wI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KMZqYCBbcthMl1mXPaGgp3+weM0K5VQvzyDdObE8aENPyWjeaAK/cWrH/bEV9yujA
         BndPt2/E0Kdtf2JHJKPGO7K343yIuOlkBm1bWhltGfDLYWnWOdR14AMw9lmyDl5nE7
         tACxdqbHzYrRGCsBRfRUq4B0SapvMn8dgJanC8aNzBD0BHURduPhVDaf5bpZF+WV9/
         npsY+Nbnnvnwm3j44WnYbu3FMdoqdRS6FRp/pH7pbSh2JyOLl9SDDnaOG3B4Q0KsQj
         aAct2uel6hwPigln7QwJB0ASNo/qj4idSNBLgXdLF2NmmHjasrkUI1rMe+uc8weZEg
         bkMYhlD2Bl9sQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
        <2898137.rlL8Y2EFai@pc-42> <87r18a3irb.fsf@kernel.org>
        <4055223.VTxhiZFAix@pc-42>
Date:   Thu, 10 Feb 2022 16:51:03 +0200
In-Reply-To: <4055223.VTxhiZFAix@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Thu,
        10 Feb 2022 15:41:39 +0100")
Message-ID: <87ee4a3hd4.fsf@kernel.org>
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

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Thursday 10 February 2022 15:20:56 CET Kalle Valo wrote:
>>=20
>> J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:
>>=20
>> > Kalle, is this function what you expected? If it is right for you, I am
>> > going to send it to the staging tree.
>>=20
>> Looks better, but I don't get why '{' and '}' are still needed. Ah, does
>> the firmware require to have them?
>
> Indeed. If '{' and '}' are not present, I guarantee the firmware will ret=
urn
> an error (or assert). However, I am more confident in the driver than in =
the
> firmware to report errors to the user.

Agreed.

> If there is no other comment, I am going to:
>   - submit this change to the staging tree

Good, it's important that you get all your changes to the staging tree
before the next merge window.

>   - publish the tool that generate this new format
>   - submit the PDS files referenced in bus_{sdio,spi}.c to linux-firmware
>   - send the v10 of this PR

I'm not sure if there's a need to send a full patchset anymore? We are
so close now anyway and the full driver is available from the staging
tree, at least that's what I will use from now on when reviewing wfx.

What about the Device Tree bindings? That needs to be acked by the DT
maintainers, so that's good to submit as a separate patch for review.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
