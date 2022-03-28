Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A74E916F
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 11:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbiC1Jfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 05:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiC1Jfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 05:35:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07C0DFAE;
        Mon, 28 Mar 2022 02:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 763D060F04;
        Mon, 28 Mar 2022 09:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B4C004DD;
        Mon, 28 Mar 2022 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648460036;
        bh=vyhorH3ReopEjyyeOaqNXz1F+fuDMA3PtzKea0coFV8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N7gslZiAbUk2K0itCjecfsI/RWbD921JgzGNP2Kjob9tlNWKxpcv0XxXJfPNZin/w
         A0IR7YQPjfgzcF8nfIw2Qp9ZjcFTNb7LTztL9AYoQlq+D0DFSUCrNS2qiH6JPnE1fC
         d1KCYuVMQdA55JmSSOhMn38gdsnsuJiIvXS7xjuBjd+D58bh2S8/2S5hzqSNDwuMtF
         wL6A4k/3MHLny+7jUG8f45x9h9oK0icdinMC+NM7pK2YaZF62B/PFs4TG4m+pXcVBe
         gM+xB7pqzFL7oswhmEfyYWWLVgaR1DNvn0CsMhOvyHk4QEK83ayzd9+XQz5ZI40AA0
         C+vN55O6TsHMw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Benjamin =?utf-8?Q?St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, pkshih@realtek.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-input@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/22] Replace comments with C99 initializers
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz>
Date:   Mon, 28 Mar 2022 12:33:42 +0300
In-Reply-To: <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz> ("Benjamin
        \=\?utf-8\?Q\?St\=C3\=BCrz\=22's\?\= message of "Sun, 27 Mar 2022 14:46:00 +0200")
Message-ID: <87fsn2zaix.fsf@kernel.org>
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

> This patch series replaces comments with C99's designated initializers
> in a few places. It also adds some enum initializers. This is my first
> time contributing to the Linux kernel, therefore I'm probably doing a
> lot of things the wrong way. I'm sorry for that.

Just a small tip: If you are new, start with something small and learn
from that. Don't do a controversial big patchset spanning multiple
subsystems, that's the hard way to learn things. First submit one patch
at a time to one subsystem and gain understanding of the process that
way.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
