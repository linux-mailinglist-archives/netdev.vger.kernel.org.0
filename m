Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2034BEEA7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiBVAIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:08:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237463AbiBVAIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:08:41 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CDC24BCD;
        Mon, 21 Feb 2022 16:08:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i21so10238480pfd.13;
        Mon, 21 Feb 2022 16:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=coHO7Y2G2o762gq6efnd02unzJICETXsYkUSXA8USf0=;
        b=RlExrzwcPDbSeUS6Pfl29JM6MuvEnTaQED+oqKbhXSbqQOiXJXtTqm/7bzscc0eQQM
         yn7R5pl6NasQGe1faAOIyVrcvk0sQ+qAdZh74GxoKGkkLv4juugE45d9Js71T2PTutiZ
         Ukq9a46q4Ox7o+vgJO8i1ap2IHfCr9O6ANx47vbu6bmjxIUrJRkTLfEXhjJAqJkcdoU0
         stFcDXxuOxfOC2HkXapydQONu/pNUpLMQW1zMArxoABQ/okVTQynylKaimZBmZmEMSuI
         ISOklSLPVyWhG6rQaa/ailbH/H86DmIAYZvrtsYKn3U8r4DUdk18KP/YlF0Fo5V9wYRu
         U9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=coHO7Y2G2o762gq6efnd02unzJICETXsYkUSXA8USf0=;
        b=vcwDUkCPgM2ylnjDNFKcgeH6PWWFH8ZOCTTg4CiqfYIS65XucFcBRRcbPkzD+4Gj+l
         Ue5q0XBo6iBQL2bodlfpzpWxElypiWylOQOPgiKMoKQQ1ey+0pj/HKJ5itnuztf0P97w
         hqYhA40X0KDuN64Y3MfUHXsQ1RJCCv4h0WCOpQEwtcPDgrMjDyR6nBUamcA6KdaNtl71
         g98bi1qJ1iBg8j0QBUshUtjSA1ubygs3KMY6RioxqkSzLLZ7d13Ci9yrDJuGlO+O87IZ
         /gsxRYogehfLmrcY1Kk46TG+RhVDifoFIIAqjxsWtGLSJNoT5lkrAUms1cNFmRp5WgPH
         PX8g==
X-Gm-Message-State: AOAM533K/eLKB/MgBjGTmJErUNzkuhLFPUzhOb8Vv+HLPb1llyPNoMZS
        nMMR6EWDrSE2Spl/kyELu0AT1Ie3RMttomDlmZcDViNqYFG94A==
X-Google-Smtp-Source: ABdhPJxPGHSCIru3Qob27hd+9rFE/164NQpZfuQ+Z7Z1mhNZ/FlwWLSfbJtsagBJFmAK3dyNXNI7Aop4ZCJJ04UluWo=
X-Received: by 2002:a05:6a00:be5:b0:4e1:9050:1e16 with SMTP id
 x37-20020a056a000be500b004e190501e16mr22483337pfu.78.1645488496707; Mon, 21
 Feb 2022 16:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20220221200102.6290-1-luizluca@gmail.com> <YhQJlyfdM8KQZE/P@lunn.ch>
In-Reply-To: <YhQJlyfdM8KQZE/P@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 21 Feb 2022 21:08:05 -0300
Message-ID: <CAJq09z6dK20UDCM1P09A4KVGqjrHwPy0GTH3ogA27x7PTMtxtg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: dsa: add new mdio property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

> Your threading of these two patches is broken. The usual way to do this is
>
> git format-patch HEAD~2
> git send-email *.patch
>
> You will then get uniform subject lines and the two emails threaded
> together.

Thanks, Andrew, I did something like that. However, bindings and
net-next have different requirements. One needs the mail to go to
devicetree@vger.kernel.org and the other a different prefix. So, I
used send-email twice. Or should I use net-next for both and send both
also to devicetree@? I did forget to set the "In-Reply-To:" in the
second message.

Luiz
