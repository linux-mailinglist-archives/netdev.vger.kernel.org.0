Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC214CA243
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241018AbiCBKd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241013AbiCBKdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:33:55 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E44ABE1E1
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 02:33:12 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2d07ae0b1bfso11853047b3.6
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 02:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3UgdP2Dpp/ayPL7kDyX+opL+M19kkYSAxJLDHKMfOjo=;
        b=hgMHnafWoG7jhNO+4dBb8l3Xj0JRlTx7aC4SxY7F+BOKwgMy8u54J0jEjDFQ/zS9tr
         781mmzucZbg+phfSkFd9ySl7bdiWpmEK90ZMbm/HqtqGWlqPpaTtUDEfEcEPlBuR8wsK
         ZvdAp3O/Q0OeHND90mkw42O6HKMQblR7OzOhdcPGYQcFr1fdAl7vIG6NqgsNr+uJYoAA
         rHTsc52QEwB5qJD+5bu1FB0u7n5BSKP6H3gCNGE/L2eJjpqbxvk0HO0Cf3+ioNDf1XzG
         bATChf3BdOc3wtqWiZW9DuWAq/zDC9oJ/zj89BAYnou8MvFFARE+Vk5LghE3cvxrs0Qu
         TkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3UgdP2Dpp/ayPL7kDyX+opL+M19kkYSAxJLDHKMfOjo=;
        b=GrEGE09RRy9t9FNTaWFMMG4OllbOcednMuuurtn+y6rF/ZmQgkCqKaILjhqW37U3IM
         2+tTGXwlm6TtxDHHoDfBEg0u5Ez4uOmURI+wxsBeFLVOj86dhFGfcwgL66ANawiR2sWA
         A8bi9GsSDKF9hI7ZLfkiELTAhGJLP96Zqwu4S6Q+tvc0LW7JDDsrnYi5wPg6wVxoqlbW
         q9HnpuA9VNeeXkW9o47f2sOURVDEKJKaA+9JrtwRkrO0km6/KDdOJ5gGzv+BKI3RnMmr
         K9ZBTYJFTv+9eHKHXlTrHLjlyw54psNA9kKfBG/g1KXmu6qGEIWQy8DsdRGkTJGbSRmW
         EkeQ==
X-Gm-Message-State: AOAM530P31JzXyI5sb+MwIYtvBwymk4KQvCQh0D8TKNCTtxhAgD1fD3g
        02pwBPLR0tJ1fuK4Uk/RddbWVQuVMLNVLHCQtwo=
X-Google-Smtp-Source: ABdhPJw/fyplq0eveO/WZAJ9BKAE58Gzeab43u2IhFVd4Pz56JPXFmPNyZ6iFdCRjIel9aE29x2PRK0WUTlcWe1tgBY=
X-Received: by 2002:a81:4503:0:b0:2db:83ea:6914 with SMTP id
 s3-20020a814503000000b002db83ea6914mr13732773ywa.42.1646217191339; Wed, 02
 Mar 2022 02:33:11 -0800 (PST)
MIME-Version: 1.0
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
 <1jczjzt05k.fsf@starbuckisacylon.baylibre.com> <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
 <6b04d864-7642-3f0a-aac0-a3db84e541af@gmail.com>
In-Reply-To: <6b04d864-7642-3f0a-aac0-a3db84e541af@gmail.com>
From:   Erico Nunes <nunes.erico@gmail.com>
Date:   Wed, 2 Mar 2022 11:33:00 +0100
Message-ID: <CAK4VdL0gpz_55aYo6pt+8h14FHxaBmo5kNookzua9+0w+E4JcA@mail.gmail.com>
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come up
 at boot
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 26, 2022 at 2:53 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> Just to rule out that the PHY may be involved:
> - Does the issue occur with internal and/or external PHY?

My target boards have the internal phy only. It is not possible for me
at the moment to test it with an external phy.

> - Issue still occurs in PHY polling mode? (disable PHY interrupt in dts)

Thanks for suggesting this. I did tests with this and it seems to be a
workaround.
With phy interrupt on recent kernels (around v5.17-rc3) I'm able to
reproduce the issue relatively easily over a batch of a hundred jobs.
With my tests with the phy in polling mode, I have not been able to
reproduce so far, even with several hundred jobs.

For completeness I also tested 46f69ded988d (from my initial analysis)
and setting the phy to polling mode there does not make a difference,
issue still reproduces. So it may have been a different bug. Though I
guess at this point we can disregard that and focus on the current
kernel.

I tried adding a few debugs and delays to the interrupt code path in
drivers/net/phy/meson-gxl.c but nothing gave me useful info so far.

Do you have more advice on how to proceed from here?

Thanks

Erico
