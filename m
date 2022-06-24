Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4E655A11E
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiFXScl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 14:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiFXSck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 14:32:40 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA7D7FD14;
        Fri, 24 Jun 2022 11:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1656095550; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9ymJhhAk5CJyVp4Q5xijWVQG2xULEuBtYjgBkRWlJFA=;
        b=D1E8UHUpvscjO4QUep6E7FgQRsid5sBy9GeA6feJcL9MhUhnokIfZP4pd/DwwXgKs648c7
        Iy2kC+nFFHfbW1whnwZlFDh/ZZqX1UKvxgmdFBUGiXE31eV6v0QfwP54mpxW6+fmP6NVxy
        H7bfe4uFk4kxnN2m9LEWLFTbY9CR1n8=
Date:   Fri, 24 Jun 2022 19:32:20 +0100
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v2] brcmfmac: Remove #ifdef guards for PM related
 functions
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Arend Van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <WHVZDR.GB0H9SQC9PDP@crapouillou.net>
In-Reply-To: <3013994a-487c-56eb-42d6-b8cdf7615405@quicinc.com>
References: <20220623124221.18238-1-paul@crapouillou.net>
        <9f623bb6-8957-0a9a-3eb7-9a209965ea6e@gmail.com>
        <3013994a-487c-56eb-42d6-b8cdf7615405@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Le ven., juin 24 2022 at 09:31:22 -0700, Jeff Johnson=20
<quic_jjohnson@quicinc.com> a =E9crit :
> On 6/24/2022 2:24 AM, Arend Van Spriel wrote:
>> On 6/23/2022 2:42 PM, Paul Cercueil wrote:
>=20
> [snip]
>=20
>>> -    if (sdiodev->freezer) {
>>> +    if (IS_ENABLED(CONFIG_PM_SLEEP) && sdiodev->freezer) {
>>=20
>> This change is not necessary. sdiodev->freezer will be NULL when=20
>> =7FCONFIG_PM_SLEEP is not enabled.
>=20
> but won't the compiler be able to completely optimize the code away=20
> if the change is present?

That's correct. But do we want to complexify a bit the code for the=20
sake of saving a few bytes? I leave that as an open question to the=20
maintainer, I'm really fine with both options.

Cheers,
-Paul


