Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3D4506012
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiDRXIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiDRXIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:08:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464511DA59;
        Mon, 18 Apr 2022 16:05:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id j70so746000pgd.4;
        Mon, 18 Apr 2022 16:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bnXZNKJ0lqG/REF5S1zs8nwjxJedTJNHRhYxnhtELJ0=;
        b=RvOPM/4dacw0btYIObMPJauAhZWHVxOndKn7yaIaylfyYpRr739cK3q4VSLvxz9ZVl
         c8bXKxR8WnP28Qs4vj/vx80uyPsWpYeSi3Emnbl2VZzNLTmLKhEP0RCvsVBprEeJCztV
         ihA9L/eBtJ/AG03h4BZGPY+Vt/TJ8koDoe6V38S4wxUexjLDbMRrXK5xvft6AjiNB/ZF
         sWK6T5oQoxL3xG1Mh/wWaKFuXaE5sznkRb72612oA7kNNuiVnvUQJOsB2au5m62EBj0N
         IKPOA6UtYUrPxpczFUDr8oYpRXxjd5aWHSypDY9gPoot9hq8nuSzEV6mwfg2CFew4RT4
         pnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bnXZNKJ0lqG/REF5S1zs8nwjxJedTJNHRhYxnhtELJ0=;
        b=8N/cv5XGpTa/AKWXNuzTUKjc01enW0Vu7tkdDOke32sh69BcA2CipoTb+pB1cVQf+h
         XY7sUohx1JKlzfai5cfgB+9l3ILAHBzD8GmP42kUuFzHbSyInWn5Pk0l7KQ4bmQfxy2H
         CvqPYe7GM/ufdLyhkIdhxj31XZXIufZqCJbImV/kem2VEr9GydVMeJDMDLmnnWnDcxqj
         V16G9YWSO2IdTQs+G/a5oE3UrjyzbWr3zXdvt406vtmx4J9Xtnt9RwOSna8fRhYBiGiS
         5B/KdbIldsccAFIL4PKIb6q8Wt6kc6enyZ4pOnxext0nKoU/R9vczzmz3G1lRcru0RSW
         0ddQ==
X-Gm-Message-State: AOAM531zl8RgdiS0Q9uhUJmZqSoQ5s0zDZa8dvMs7wAdcsYzwGMPBtN/
        p0F9bZJgzTtEYpLKrywjNIitSK5Unt9RqdoBK68=
X-Google-Smtp-Source: ABdhPJxPu99TBd/RNqb2gVnSmQXxG8P+pPy4L1EWmA1gW2tHOYNAfNK3m8q8Yl/YSfOx5b1Gemd/arFUiwWhjdkpvtw=
X-Received: by 2002:a63:7c42:0:b0:39c:c333:b3d4 with SMTP id
 l2-20020a637c42000000b0039cc333b3d4mr12045371pgn.456.1650323138736; Mon, 18
 Apr 2022 16:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220416062504.19005-1-luizluca@gmail.com> <CACRpkdaZUiYcw2FekoZLvn7LbVUD-_sJkHu-FLcEpJAueVCN9w@mail.gmail.com>
In-Reply-To: <CACRpkdaZUiYcw2FekoZLvn7LbVUD-_sJkHu-FLcEpJAueVCN9w@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 18 Apr 2022 20:05:27 -0300
Message-ID: <CAJq09z5PoaOUW22k_8Raw07-jyC45ZpgiojgL1WP59oDQC3REQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, krzk+dt@kernel.org,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        devicetree@vger.kernel.org
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

> On Sat, Apr 16, 2022 at 8:25 AM Luiz Angelo Daros de Luca
> <luizluca@gmail.com> wrote:
>
> > Compatible strings are used to help the driver find the chip ID/version
> > register for each chip family. After that, the driver can setup the
> > switch accordingly. Keep only the first supported model for each family
> > as a compatible string and reference other chip models in the
> > description.
> >
> > CC: devicetree@vger.kernel.org
> > Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> OK, I suppose we know that Realtek has always maintained the
> ID numbers in the hardware? Otherwise we will end up where
> bindings/arm/primecell.yaml is: hardware ID numbers that were
> supposed to be updated but weren't, so now both DT and the
> kernel has to go through all kinds of loops and hoops to make it
> work by encoding the number that should have been in the
> hardware is instead in the device tree...

Thanks, Linus. The rtl8367c driver seems to depend on information
retrieved from registers, mainly chip id/ver. If they forget to update
a chip id/version, it might be the case that it does not really matter
from the driver's point of view.
Anyway, if deemed to be necessary, adding a compatible string is much
easier than removing one after a kernel is released.

Regards,

Luiz
