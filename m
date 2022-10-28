Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8EE610FAA
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiJ1L2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJ1L2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:28:02 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0831D1AA2
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:27:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id io19so4589704plb.8
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0HMbZDfJkzxDt8t6tkGh8qKcf5CzAyAEVlEe8Aizvjo=;
        b=MdwwOkJj4soIDiFQnRY5ZcG7fTNE1sYEecyOK4Eri4U2qeOuRGSte5OuPGM0p02k5X
         Xo8QBPvZ6Fj7vZQUWFXp6QWhGbeiKnv6TMvyE5eDcOpNc9eoBJ0lvmnIQU+RNY+lPSNp
         licnntjq3Za+j1lEmcc7C/0itRAyfAKiwqW3OUYA+tfnhVURQxWHveiyVfPxpl8WKrmS
         6kjxvYOdBchJdxZ3xoCDSG7kbYkwWQJYr2mpIXCn8baRxaMIJCfwlwbjbvDQ2gyD3uaO
         0z2hitCOoC++FUHn0rFsRVus/rjVw6TBRm6Fba8ufs6YoHkKQuS/bMJQhayyfIzIcd9p
         fonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0HMbZDfJkzxDt8t6tkGh8qKcf5CzAyAEVlEe8Aizvjo=;
        b=qh9knNpC2XiHILidb7Nl2m2kzzc/U1YVjWuslPwjnIsuw1dplQ9uv2T1/Sy859H/89
         f882nTzO2zzgc6NyNsrXw6kxwG9IZ2AU4u4CXekHEyJrwgc2z7v6huMag1g65Dn7WDYI
         aJG0CihIHz3WcFVy+Btqgvm+q9FRpAeMDN8NNNBAY7EPAw53z8a516iVhZnoV7PmMtZi
         7ISXo89Uik2torLYIRIn4W7Zor0Au+meBWPjVHgP6lX0VdXYCx8pxmCbO5DyPKO4/TgR
         eCmAIw79IbsLSJfZnYm5sYBJ52xXlILZHmy9T7SeaQ0K0qGckD+d0wcT4iMaIxh8qyCj
         qcDg==
X-Gm-Message-State: ACrzQf0+vitURBS1LSIObnt0KxkvUyyQg21ixMbwtIVSOV/k2zIJZlye
        ARonvVvPjpKmpnvlK8ID7czt2aXzoug8kILqvRk=
X-Google-Smtp-Source: AMsMyM6wGoeoywSwu2ZcXcHSD7MKieRZBNRw5frNO9MotUD1mjW19i1E18qKLAB1ei2ni17fvKzcXoKnuw4o+oJ9GO0=
X-Received: by 2002:a17:902:c944:b0:186:a7d7:c3b with SMTP id
 i4-20020a170902c94400b00186a7d70c3bmr26682111pla.55.1666956479268; Fri, 28
 Oct 2022 04:27:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
 <Y1p6ex85pFapxz3s@lunn.ch>
In-Reply-To: <Y1p6ex85pFapxz3s@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 28 Oct 2022 08:27:47 -0300
Message-ID: <CAOMZO5BYN3ckaLguvK+Xj+dsTet4vSSwsDr6P8J_tG2_-VOniA@mail.gmail.com>
Subject: Re: Marvell 88E6320 connected to i.MX8MN
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Vladimir,

On Thu, Oct 27, 2022 at 9:33 AM Andrew Lunn <andrew@lunn.ch> wrote:

> You have rgmii-id on both the FEC and the CPU port. So in theory you
> might be getting double the needed delays? The mv88e6xxx driver will
> apply these delays on the CPU port, but i don't know if the FEC does.
>
> The other thing i've done wrong in the past with FEC is get the pinmux
> wrong, so the reference clock was not muxed. Check how the reference
> clock should used, is it from the switch to the FEC, or the other way
> around. If the FEC is providing it, is it ticking?

Thanks for your suggestions. It is working now.

mv88e6320_ops misses .port_set_rgmii_delay.

I will submit a fix upstream soon.

Thanks a lot!

Fabio Estevam
