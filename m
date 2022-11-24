Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28FF637D8C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiKXQUc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Nov 2022 11:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiKXQUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:20:30 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A954816FB27;
        Thu, 24 Nov 2022 08:20:26 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id a1-20020a17090abe0100b00218a7df7789so5502438pjs.5;
        Thu, 24 Nov 2022 08:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0BkNyHsdK5EhuCvLhdwhaYfgUVTMQg7nIU62vJxeb0=;
        b=E8m/Kbynuk37GfNUgO1aml1VDCxZINPbQhw9nMXnA0XDcZ9ZyyfBsysaNw+odPDp3l
         EdRf6rNEoZ0TcTxsXhs4Tw66O9AgY/uiEqZTcXU3cLZoCbBbOu8oMojXfTyU3PFgSLqK
         Bu5D5DB4B5KaKeGCPxcBVLXitUzWXB970DByctkHGgF9K3DZwxbD1vWf53Wk9zTOpOWZ
         Kqd92u36CaiWDyC3V0kNdocZxpj4eFq9zgnaguJ1YIoT3/T2TBMXB76S9aH5mEE7BhPD
         vy4gB8XMNH4VBpQ4b345FgPij6TmKFLZj67dXIjcCJJe7BMvNDItWw5yebKIP7XPdotv
         qRWg==
X-Gm-Message-State: ANoB5pnG+bVAZkMkglWyigNISFMaK8nh+Gw8onG0y92kDDsCLhDHqZbu
        fiy/FiBrEMUEH/YTPyQb9BeKmwcFYc3M8wu2CTp5jsYLh8vh3A==
X-Google-Smtp-Source: AA0mqf6jVCbr+f3m4gv1lQXCwzTXn15ZpJUUGOG8BMyjPRbXk1V43nfTOBH9NtZB/nFoAcNVB1d2jDScorP141PrQ2Q=
X-Received: by 2002:a17:902:ca04:b0:175:105a:3087 with SMTP id
 w4-20020a170902ca0400b00175105a3087mr14857729pld.65.1669306826132; Thu, 24
 Nov 2022 08:20:26 -0800 (PST)
MIME-Version: 1.0
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <Y33sD/atEWBTPinG@nanopsycho> <CAMZ6Rq+jG=iAHCfFED7SE3jP8EnSSCWc2LLFv+YDKAf0ABe0YA@mail.gmail.com>
 <Y34NsilOe8BICA9Q@nanopsycho>
In-Reply-To: <Y34NsilOe8BICA9Q@nanopsycho>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 25 Nov 2022 01:20:14 +0900
Message-ID: <CAMZ6RqJ6dBxBOBETim5aY-by2qpfHpqffwtKpYGS6K6K5=jvag@mail.gmail.com>
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default information
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 23 Nov. 2022 at 21:10, Jiri Pirko <jiri@nvidia.com> wrote:
> Wed, Nov 23, 2022 at 12:00:44PM CET, mailhol.vincent@wanadoo.fr wrote:
> >On Wed. 23 nov. 2022 à 18:46, Jiri Pirko <jiri@nvidia.com> wrote:
> >> Tue, Nov 22, 2022 at 04:49:34PM CET, mailhol.vincent@wanadoo.fr wrote:

(...)

> >> >+      if (!strcmp(dev->parent->type->name, "usb_device")) {
> >>
> >> Comparing to string does not seem correct here.
> >
> >There is a is_usb_device() which does the check:
> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/usb/core/usb.h#L152
> >
> >but this macro is not exposed outside of the usb core. The string
> >comparison was the only solution I found.
>
> Find a different one. String check here is wrong.

After looking again, I found no alternative and so I asked the USB
mailing list and got an answer from Greg. There is no ways to do so
and the class code is not supposed to do this:
https://lore.kernel.org/linux-usb/Y3+VfNdt%2FK7UtRcw@kroah.com/

So I guess that there will be no code factorization for device specific values.

@Jakub, with this in mind, does it still make sense to add the bitmap?
Aside from the driver name, it seems that there will be no code
factorization for other types dependent values. If we only set the
driver name at the core level, I would rather just clean up the
existing. (Side comment, I finished implementing the bitmap just
before receiving Greg's answer; I guess my code will go to the trash
can...)
