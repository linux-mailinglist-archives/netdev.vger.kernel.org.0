Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E184F4FCD7D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345081AbiDLEPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbiDLEPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:15:18 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56163334C;
        Mon, 11 Apr 2022 21:13:02 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 66so16009470pga.12;
        Mon, 11 Apr 2022 21:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XouaEdZvcBl5JhcLfEJdOoGq2NdIyzNMfNEZQJatq/s=;
        b=EFtFdZ7y4d13N2ivMRqIIqqb0JnEdeAjfMBunTmTBHSVRLOCkZ8A35Pmfl7mk6nBkl
         1T6oLQQdzOj2n5aYZ3G14GivC+RkV7+R+d3enlq5p+oZvr2jprgNl9VVSmJ4YanHYmPO
         nymegQKgDIcSR3QFqtRmULd9e5gS0PTBrQjil6e/KE89qGNJls/s1OpVPftVhUYT1J3c
         b1F0kzj98KKiX8QGGi6mkIW9aukbuJ78xXhkHNZ6LlFVxWW2dPFwV1QPTjR/yaSrQOsn
         QdYGRc22GyxFbIIYtuDn8ozF94K3sZPMHRz8V5dHS2iVu3g/uMQhRx+k4NyH8nrk51I+
         wghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XouaEdZvcBl5JhcLfEJdOoGq2NdIyzNMfNEZQJatq/s=;
        b=432BEBxsawf4oJNgxQ2Gb5UuVe9ir25uf4MuXNZ4PF5A1V1m2igXTOuHIpAt064TPv
         UsgVrMZwr5KwcHrFyXDmU4G5Sv18QfTGhB+jDd43Woz7S72AqUR67ccKUmI6l2wPJE5B
         B69iCRKJjdJkgtsDcNTcPAdZw7BStX7hO0mi7MT7m58/aU/Bfr/gDPW0XLZzm2shADHH
         bnfwHfkIRPfFxhEugbzdFIE6KBTN6TOag7v7sFLYx/nQ5k92O9y2/5hkhW5b6K3d6Net
         Vs2oux31RvUIJMaOsO7BuY13LxEbdsEcyCcAqxFtNbxZZvHxyTII8/oQrc2cl7ZIe5mO
         pZbg==
X-Gm-Message-State: AOAM531kcCQSwdPciS4RV9lEjl7z0q6YnG7BWc6+5rO7p4i4HZ9Pp+wf
        UWC8QAYahSqrrbRU5TDj3yWX0X5A8MUm1lrq8WI=
X-Google-Smtp-Source: ABdhPJyU8FMCZHe4yhFNHb0YvmqzAdA518x9UtFgy1jOoHQkCjon67AUbe2wxlR/3Ds+P80ii2RgzZcstbQcQA6Hxy0=
X-Received: by 2002:a63:3d0b:0:b0:37f:ef34:1431 with SMTP id
 k11-20020a633d0b000000b0037fef341431mr28767860pga.547.1649736782072; Mon, 11
 Apr 2022 21:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220411210406.21404-1-luizluca@gmail.com> <YlTFRqY3pq84Fw1i@lunn.ch>
In-Reply-To: <YlTFRqY3pq84Fw1i@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 12 Apr 2022 01:12:51 -0300
Message-ID: <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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

> On Mon, Apr 11, 2022 at 06:04:07PM -0300, Luiz Angelo Daros de Luca wrote:
> > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > Kconfig help text.
> >
> > The driver still detects the variant by itself and ignores which
> > compatible string was used to select it. So, any compatible string will
> > work for any compatible model.
>
> Meaning the compatible string is pointless, and cannot be trusted. So
> yes, you can add it, but don't actually try to use it for anything,
> like quirks.


Thanks, Andrew. Those compatible strings are indeed useless for now.
The driver probes the chip variant. Maybe in the future, if required,
we could provide a way to either force a model or let it autodetect as
it does today.

There is no "family name" for those devices. The best we had was
rtl8367c (with "c" probably meaning 3rd family). I suggested renaming
the driver to rtl8367c but, in the end, we kept it as the first
supported device name. My plan is, at least, to allow the user to
specify the correct model without knowing which model it is equivalent
to.

Regards,

Luiz
