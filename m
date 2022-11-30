Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C985363DC76
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiK3Rwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiK3Rw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:52:29 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1D9252;
        Wed, 30 Nov 2022 09:52:29 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id v3so16773348pgh.4;
        Wed, 30 Nov 2022 09:52:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AK8P6Fl6Gl8hJBklqr3lYKP7boOFbdA07yIc5/BbDqg=;
        b=6X8YncQRGlE0XHdc1b3knET9M7FwaKOlVghZq7Fi7I3bh9nLsTVVcIwTfbaMYCyM83
         H52wGLZ/wnC+z59CmgWuQ1dJQ3hcaTvauDII7K9kcwzO4nJhLnADkb5pu1/HaJiDBXHh
         eWc7Idvv9/zsbNkeX7YAWUx8VfvRNm0DiwAtc+7XBORNBGGi+db8jsstQAsmPHTaJJsw
         ZKGggdORoI4tkwJFuPY9fg8amGI3DZSXbUdrDcP//aoU7x/nvkuc9MT3xEfA3rv+w2RM
         49puIkS8ZVT31CcKryM+r6wy6HjmaeS6/O1clZbmaS4tX+SMd4cN/Hgp464MdJ6ejzrN
         W/jg==
X-Gm-Message-State: ANoB5plLsjgHeFq/Sq3KKVU+DteBcVYHg9UbLYN3YmV/zcIQM20wgU+k
        1YgAkMQ4UJ54zuXXTn1jhiqnGrXiQw+yn+vn2Do=
X-Google-Smtp-Source: AA0mqf5JHUZ4VH1l7y3UQOWl6cSZftofpIQTDhvTXCDPtlZ8sE0xLJUWAhZOxj+Hmn9Nf307yRTWa63fJ5BygTGXdY4=
X-Received: by 2002:a63:1955:0:b0:477:50ed:6415 with SMTP id
 21-20020a631955000000b0047750ed6415mr45496852pgz.535.1669830748612; Wed, 30
 Nov 2022 09:52:28 -0800 (PST)
MIME-Version: 1.0
References: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr>
 <Y4XCnAA2hGvqgXh0@nanopsycho> <CAMZ6RqJ54rfLfODB1JNaFr_pxWxzHJBoC2UmCKAZ7mSkEbcdzQ@mail.gmail.com>
 <20221130170351.cjyaqr22vhqzq4hv@pengutronix.de>
In-Reply-To: <20221130170351.cjyaqr22vhqzq4hv@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 1 Dec 2022 02:52:17 +0900
Message-ID: <CAMZ6RqLy_H-A-=_jgPh6dUdHa_wMLB20X0rCFY7vkgBwvS1Uyg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        linux-can <linux-can@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 1 Dec. 2022 at 02:14, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 29.11.2022 18:28:44, Vincent MAILHOL wrote:
> > On Tue. 29 Nov. 2022 at 17:33, Jiri Pirko <jiri@resnulli.us> wrote:
> > > Tue, Nov 29, 2022 at 04:14:06AM CET, mailhol.vincent@wanadoo.fr wrote:
> > > >As discussed in [1], abbreviating the bootloader to "bl" might not be
> > > >well understood. Instead, a bootloader technically being a firmware,
> > > >name it "fw.bootloader".
> > > >
> > > >Add a new macro to devlink.h to formalize this new info attribute name
> > > >and update the documentation.
> > > >
> > > >[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/
> > > >
> > > >Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > > >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > > >---
> > > >* Changelog *
> > > >
> > > >v1 -> v2:
> > > >
> > > >  * update the documentation as well.
> > > >  Link: https://lore.kernel.org/netdev/20221129020151.3842613-1-mailhol.vincent@wanadoo.fr/
> > > >---
> > > > Documentation/networking/devlink/devlink-info.rst | 5 +++++
> > > > include/net/devlink.h                             | 2 ++
> > > > 2 files changed, 7 insertions(+)
> > > >
> > > >diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> > > >index 7572bf6de5c1..1242b0e6826b 100644
> > > >--- a/Documentation/networking/devlink/devlink-info.rst
> > > >+++ b/Documentation/networking/devlink/devlink-info.rst
> > > >@@ -198,6 +198,11 @@ fw.bundle_id
> > > >
> > > > Unique identifier of the entire firmware bundle.
> > > >
> > > >+fw.bootloader
> > > >+-------------
> > > >+
> > > >+Version of the bootloader.
> > > >+
> > > > Future work
> > > > ===========
> > > >
> > > >diff --git a/include/net/devlink.h b/include/net/devlink.h
> > > >index 074a79b8933f..2f552b90b5c6 100644
> > > >--- a/include/net/devlink.h
> > > >+++ b/include/net/devlink.h
> > > >@@ -621,6 +621,8 @@ enum devlink_param_generic_id {
> > > > #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE  "fw.roce"
> > > > /* Firmware bundle identifier */
> > > > #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID     "fw.bundle_id"
> > > >+/* Bootloader */
> > > >+#define DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER    "fw.bootloader"
> > >
> > > You add it and don't use it. You should add only what you use.
> >
> > I will use it in this series for the linux-can tree:
> > https://lore.kernel.org/netdev/20221126162211.93322-4-mailhol.vincent@wanadoo.fr/
> >
> > If it is a problem to send this as a standalone patch, I will then
> > just add it to my series and have the patch go through the linux-can
> > tree.
>
> As you have the Ok from Greg, include this in you v5 series.

This is a different patch. Greg gave me his ACK to export usb_cache_string():
  https://lore.kernel.org/linux-usb/Y3zyCz5HbGdsxmRT@kroah.com/

This is a new patch to add an info attribute for the bootloader in
devlink.h. Regardless, I added it to the v5:
  https://lore.kernel.org/linux-can/20221130174658.29282-5-mailhol.vincent@wanadoo.fr/

@Jakub (and other netdev maintainers): do not pick this, it will go
through linux-can.


Yours sincerely,
Vincent Mailhol
