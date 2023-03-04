Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2B76AAA94
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 15:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCDO5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 09:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCDO5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 09:57:42 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4355116AC8
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 06:57:41 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bi9so7239494lfb.2
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 06:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677941859;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BCMxvXTOvNz+5QDNTiUB45+zEGRQgS3+aPbwVPvpKW8=;
        b=nRc2DZ4212b11dQPWqcCjJvi2OZ/wBus2jCeIOvcHZRVpJCc+6lTamwO6fr3sq2UGw
         MTiDDFH2d6R+uRAAS4TkhPNzwaQeS0/u8M06P90hTaAwmUyqBPk0KhKLT6yOc0gdZWEe
         ZbtwWkzydIniNfrSPvsuzx+8C0gdM3XClgn/hmfdPrNh2rtOauCMOjhQ27Xxjeep6qdd
         dkruEqvcojBbA2UFJjKOZpeLoWXq0l170K61sziLaJCuBhAORiI91OhnDh2RJV3bP4lz
         P7BD68dTIEWtighMkzy2wxJ/GlkM8dkGvNun34TSGfMUdrZc5+HfMkQl+100Ic9dOJPv
         I11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677941859;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BCMxvXTOvNz+5QDNTiUB45+zEGRQgS3+aPbwVPvpKW8=;
        b=gJW1Ia88th047zWrw5tPDjWvBZpiqF8zjyfsORBOeZHgXF+wW6/DL6gC46EpKn134B
         Gdya2eNj+67OOOb8huWkv7X+Z0M8Jf4ee8Ic8nzuwEX1tP6VUbfhIs11EXSg5JSgmnG4
         7nMmSwkWhWOr3XX4fimZesWgmCzznv4hrJC5Bc+gJme+AANu93JKbuv+sB6NnzhioI8+
         8wO1pKqmNER+srYH8qBLqUcNQg1kUKpEo0k0m8iM3svyObf0Ko0M+Y3ZJELpNBTIAaDl
         oqi31EWGPBukKOBe/PwN4Ro4JV9gfkVBO789b5xhumrKBxNMmJWINGuOs6lDEiGCcGcH
         18dQ==
X-Gm-Message-State: AO0yUKU9d6UjmI9xhT+vzOqjmKljcsgTEN3Kjo8cK8JorWHQQPkYvaxO
        fTI0JnP+3np24dio/op9aW83YwOo/ITUn9R3kIw=
X-Google-Smtp-Source: AK7set8Y3cOk9fECKOxW359HVaNUHaMLIZ/HqeIUS7fuCmxZwGi90TEBdSn2hRtMVfxQJmW+OwtkKY8xWYumtWdfke8=
X-Received: by 2002:a19:750f:0:b0:4d5:ca43:704a with SMTP id
 y15-20020a19750f000000b004d5ca43704amr1593766lfe.13.1677941859337; Sat, 04
 Mar 2023 06:57:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:bc17:0:0:0:0:0 with HTTP; Sat, 4 Mar 2023 06:57:38 -0800 (PST)
From:   Kokou Amouzou <kokouamouzou01@gmail.com>
Date:   Sat, 4 Mar 2023 14:57:38 +0000
Message-ID: <CAAun06YOsyRPHdA7QxbfhX-tq0uuPrTTt+KKYsAk4__Qt79YVw@mail.gmail.com>
Subject: Re: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day,

I officially invite you to your late relative's investment cla!m.
Permit me to give you more information .

Yours faithfully,


-- 
Michael Louis. Esq
Principal Attorney,
Dominion Associates,
Chambers Barristers & Solicitors
Public Notary, BTD/SORT-CD-00247901
