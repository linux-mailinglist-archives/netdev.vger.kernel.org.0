Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763011AA436
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbgDONUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2506285AbgDONTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 09:19:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EDCC061A0C;
        Wed, 15 Apr 2020 06:19:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b11so7742306wrs.6;
        Wed, 15 Apr 2020 06:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=lfpK/xOIlDnyJhSEQBBYKy273A0qYIk6KaRxAULUFas=;
        b=Xy0NAs50nauKNzelhrgCoZ1oAYS0by3FW/Xaw2GPXjjbxeHr7P51WtKfCf1iVTlDao
         1cOOPmWg97iJ76qPu3Zf8K1JeiI+rzszWGk02qVHLNvlaAePVcN0Z1ZL+XQNVE5e9274
         GYzX7MjCAThNITca93dboFwAqeKUQEJNeSp75p0d8awYnOijpfDLDm0N9I+yyxD6oci7
         AUyJfwQuq1AqKugkFVaK5DG/Twamt2jjtWUBC/Q78V6LlzCa56wRZOhfgAQvg26w7Zfk
         Ki+dfNNizSoeEwHuWdzLPllpRX8OzyQKILZp1EwCutUgg3ED3sqXDlxRzrDrAzQvSFX9
         Bp/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=lfpK/xOIlDnyJhSEQBBYKy273A0qYIk6KaRxAULUFas=;
        b=bBHeMvd4p6pfzZqUQ5yM8GBAZuuS/BtWb31bb32ABhqN6PUzGkDYSa0oWCCDPohrxD
         BwZ1Fdv3wskLVDfKER+qhlsWGKPFDAZUjbuOAoIUlMzgRfxb/qLPkYAH/uTq3KgwuWkK
         k/xowWap+PdKC3DTaJ3/oTkV5KOor9wXYFVibyiWuKGmEjsBeEdFevzUvO59ikxLVHEq
         p3ELX/MQHAWVpJZIdgpw/GoCP3kyv6+ntp3CcjWwlV4djrWj+XGwRGEBsEygVLceArz4
         Kzl/Gw1n3H6tTPVTUcUz/9nKQ0GJ23TT0aCpa9Vzoi2u5TAyn2w+s8Mq2vhaRy17Q68a
         4oRA==
X-Gm-Message-State: AGi0PuZ3MSLAa2hREzCktIdd/tShzn5rlfWHKSID5unkgZN9H13bkmxR
        ztMB5Vo1dADsOcE7JxYNc9q81JybyWGRIAqsypM=
X-Google-Smtp-Source: APiQypIW8Pb7KI2m47zG2TSNaiw4mMtQU1+5Wz2hxAJY83V2FfpcUzk0ZWhEopuJDFTjiX0vj3fcibyWGzm0sC1HtaI=
X-Received: by 2002:adf:ef51:: with SMTP id c17mr28624905wrp.130.1586956782339;
 Wed, 15 Apr 2020 06:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
 <CABPxzY+hL=jD6Zy=netP3oqNXg69gDL2g0KiPe40eaXXgZBnxw@mail.gmail.com>
 <CAFA6WYMZAq6X5m++h33ySCa6jOQCq_tHL=8mUi-kPMcn4FH=jA@mail.gmail.com> <CAFA6WYOW9ne0iffwC1dc48a_aSaYkkxQzyHQXTV2Wkob9KOXQg@mail.gmail.com>
In-Reply-To: <CAFA6WYOW9ne0iffwC1dc48a_aSaYkkxQzyHQXTV2Wkob9KOXQg@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 15 Apr 2020 15:19:30 +0200
Message-ID: <CA+icZUUDm=WPjmwh5ikp8t+xt7dqTgghCeB8F0+czaUh-sHXxA@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix race in ieee80211_register_hw()
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 3:10 PM Sumit Garg <sumit.garg@linaro.org> wrote:

[.. ]

> > In case we don't have any further comments, could you fix this nitpick
> > from Chaitanya while applying or would you like me to respin and send
> > v3?
>
> A gentle ping. Is this patch a good candidate for 5.7-rc2?
>

Hi Sumit,

it's in [1] (see [2]) with slightly mods by Johannes but not in Linus tree.

Johannes requested a pull-request means will be merged in a next step
in net.git and then hopefully land in Linus tree after Dave M.
requested a pull-request.

Thanks for your patch.

Regards,
- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/tag/?h=mac80211-for-net-2020-04-15
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git/commit/?h=mac80211-for-net-2020-04-15&id=52e04b4ce5d03775b6a78f3ed1097480faacc9fd
