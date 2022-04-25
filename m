Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403DA50DAE7
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 10:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiDYIO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 04:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiDYIOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 04:14:20 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA4237A37;
        Mon, 25 Apr 2022 01:11:13 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id C71AA30ADE61;
        Mon, 25 Apr 2022 10:10:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=acF+R
        CFmkPfEAHQABcQxj/zPJMa//hEphvOtcoMLl24=; b=JatjlyMzKOW7PiLokLasn
        a/MLvBd5Q0nNkMiVgZ6eyxOeZKELbk7m5A+0sR7+xJHcamCwBMZAHKNsksCt+mWc
        TTgdb/nYKtpy5grtQ5VS4YewvSVicdkCXk/AecIGQj2hjeqamjhYZk9wVIXR/Yoo
        4F5+qhcDRVyZUH5zSITYwJINkSabc/joWsHfQUW2UWLZDkyk+PW7X151GO41mISo
        DbzBBdMExuTy7eCuXpu/5VAWf7ncDbrGC/IuvQqCPUDHfhO+mXckgwrXfbBTC1NO
        zv0JXAV0m8JCyd51EHxoWqMXtkPiBWubz5RiQlgUe14MX4VF1GMYlZ/rYWbBj0zJ
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 0AAB530ADE4B;
        Mon, 25 Apr 2022 10:10:40 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23P8AdcV012813;
        Mon, 25 Apr 2022 10:10:39 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23P8AdZg012811;
        Mon, 25 Apr 2022 10:10:39 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        linux-can@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v1 1/4] can: ctucanfd: remove PCI module debug parameters and core debug statements
Date:   Mon, 25 Apr 2022 10:10:38 +0200
User-Agent: KMail/1.9.10
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz> <1fd684bcf5ddb0346aad234072f54e976a5210fb.1650816929.git.pisa@cmp.felk.cvut.cz> <CAMZ6RqJ1ROr-pLsJqKE=dK=cVD+-KGxSj1wPEZY-AXH9_d4xyQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqJ1ROr-pLsJqKE=dK=cVD+-KGxSj1wPEZY-AXH9_d4xyQ@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202204251010.39032.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincent,

On Monday 25 of April 2022 09:48:51 Vincent Mailhol wrote:
> On Mon. 25 Apr. 2022 at 14:11, Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
> > This and remove of inline keyword from the local static functions
> > should make happy all checks in actual versions of the both checkpatch.pl
> > and patchwork tools.
>
> The title and the description say two different things.
>
> When looking at the code, it just seemed that you squashed
> together two different patches: one to remove the inlines and one
> to remove the debug. I guess you should split it again.

if you or somebody else confirms that the three lines change
worth separate patch I regenerate the series.
The changes are not based on third party patches but only
on indications reported by static analysis tools.
Remove of inline in the local static functions probably
does not even change code generation by current compiler
generation. Removed debug outputs are under local ifdef
disabled by default, so only real change is step down from
option to use module parameter to check for possible
broken MSI causing the problems on PCIe CTU CAN FD integration.
So I thought that single relatively small cleanup patch is
less load to maintainers.

But I have no strong preference there and will do as confirmed.

By the way, what is preference for CC, should the series
be sent to  linux-kernel and netdev or it is preferred for these
local changes to send it only to linux-can to not load others?
Same for CC to David Miller.

Best wishes,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

