Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F4C5E9BDD
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiIZIVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiIZIUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:20:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56777357FC;
        Mon, 26 Sep 2022 01:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 199C3CE1079;
        Mon, 26 Sep 2022 08:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F18C433C1;
        Mon, 26 Sep 2022 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664180426;
        bh=qE+sUkuGFoPDcFsp8tOmihQKG0t6W0MTW0AZE4mfjB4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jTSGFn25/qVW5yI5AjsbHw3hxCyQW1eSdqbF8FamhZ+FO7QUTqYsunUQnfFaHqQsh
         xU8rSvoK+bA67bFBlE5jLvcbZnbF5E70xl3FExoW0OG5hhPeMh0MCjVGZvHZ0g3EEZ
         nvp8pN4WZgFLEueWXQIUTHML5xQjtgxOxhfZHL8p+/03D1Ja1qV4XryYi03CSRpWdt
         U39icOTT/H1i94HqXT0A9JnwDWq8EYETVdkJn6GSWSDG35b8oWesjE3CqPTL4W7wqS
         GrzGV7LQpshTuWsOxW47tZb8g37dVv2dXqwKsVZjFQZMDlOlaJv/WjJ59LFEvTrNuy
         p/LP3ugRNmhrw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos\/upstreaming\@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka\@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno\@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten\@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen\@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao\, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King \(Oracle\)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl\@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list\@infineon.com" 
        <SHA-cyfmac-dev-list@infineon.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Stockholm syndrome with Linux wireless?
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
        <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
        <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
        <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
        <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
        <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
        <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk>
        <CACRpkdYwJLO18t08zqu_Y1gaSpZJMc+3MFxRUtQzLkJF2MqmqQ@mail.gmail.com>
Date:   Mon, 26 Sep 2022 11:20:18 +0300
In-Reply-To: <CACRpkdYwJLO18t08zqu_Y1gaSpZJMc+3MFxRUtQzLkJF2MqmqQ@mail.gmail.com>
        (Linus Walleij's message of "Thu, 22 Sep 2022 22:18:34 +0200")
Message-ID: <87wn9q35tp.fsf_-_@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(changing the subject as this has nothing to do with brcmfmac)

Linus Walleij <linus.walleij@linaro.org> writes:

> On Thu, Sep 22, 2022 at 3:31 PM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk>=
 wrote:
>
>> I would also point out that the BCM4359 is equivalent to the
>> CYW88359/CYW89359 chipset, which we are using in some of our
>> products. Note that this is a Cypress chipset (identifiable by the
>> Version: ... (... CY) tag in the version string). But the FW Konrad is
>> linking appears to be for a Broadcom chipset.
>
> This just makes me think about Peter Robinsons seminar at
> LPC last week...
> "All types of wireless in Linux are terrible and why the vendors
> should feel bad"
> https://lpc.events/event/16/contributions/1278/attachments/1120/2153/wire=
less-issues.pdf

Thanks, this was a good read! I'm always interested about user and
downstream feedback, both good and bad :) But I didn't get the Stockholm
syndrome comment in the end, what does he mean with that?

BTW we have a wireless workshop in netdevconf 0x16, it would be great to
have there a this kind of session discussing user pain points:

https://netdevconf.info/0x16/session.html?Wireless-Workshop

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
