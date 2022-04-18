Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9492506049
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiDRXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiDRXjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:39:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8A7286CE;
        Mon, 18 Apr 2022 16:36:36 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id be5so13565503plb.13;
        Mon, 18 Apr 2022 16:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xPs4QDUainXwod04yjAn9nHJX89dMP6cjDoaZShd9Rc=;
        b=NV4dfJJWa78YKgKXSm9oCpIUt+0wOaosgJMJeeHJ5MWFME59W8eeVxxTK72FyJN1Lq
         myd3p3ZOrHRMbKOjZomnGuHXDdWka7XywpAGzzbMGjB6KzOoG+oIO6zcSR8kWtEKBhwP
         qJcGOSGOJTuh6Ghxgu+yd4nXw/KSkYB8v45DZiu2ZVe7+QtrsBt9yRuKLbamYryKNGih
         xmgJaWRcsYckNrxLc8XzS2EkztO1i56IfVuHtPXOdt/CuGZ/mU5ji13g626VL9S/dj7Z
         gFmWfNx9P+qmdgxVD2epsvNCPP/vis0HayXajZ0ntYGHZVPHJRpCMDnjz6/+Bti2NMCc
         HbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xPs4QDUainXwod04yjAn9nHJX89dMP6cjDoaZShd9Rc=;
        b=lQAKo8dOa2ulbiAWCdATzeytTAUdWy2/cgNA13p5YRLk86lqcUPe75ACKS/cbrrFBf
         5M+YDRIYzN4Y9t2pyrsNIuGB1qcE7pMyJXc8bhFlbwIimSDgeUXGS9HB4IapulVrIZH9
         op4v9U1ZvLHdYvGzxmdH4mS+EAS71A/MN4yh92J+FTbZkM97HXbJkJCKJh0zCkZ8W4j9
         fQgSiZS2x2QRUSLAXlcilCzXaG9wZlyB/SMWn9pP4eT9kJkkYkabnGocYS30owfzHSLo
         z8zW/XjX5DTZ4QRfDQO26bi4tNjfYhxBlCWfjeW2Jl021D0RzILGX1zpLWEBDvFU9Hc9
         R/0w==
X-Gm-Message-State: AOAM5318CB3o3JvcS0CTRzUW/sQX35Rff3U0KLtyoArm0NwNe+YxvxoW
        yJrA5ROsAOqlKckyvdVXq+YzxFR0BN6vOY0w33g=
X-Google-Smtp-Source: ABdhPJxtA7a+JqgKA1ZUKHkpH8QDcnud3J9xQ73g/6gJSJtm0OZ6WUhQ56PC8fs7ipFBnCoz1GCIYEgJsYuiIJY44aI=
X-Received: by 2002:a17:90a:db16:b0:1cb:9ba8:5707 with SMTP id
 g22-20020a17090adb1600b001cb9ba85707mr21287452pjv.32.1650324996142; Mon, 18
 Apr 2022 16:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220416062504.19005-1-luizluca@gmail.com> <CACRpkdaZUiYcw2FekoZLvn7LbVUD-_sJkHu-FLcEpJAueVCN9w@mail.gmail.com>
 <CAJq09z5PoaOUW22k_8Raw07-jyC45ZpgiojgL1WP59oDQC3REQ@mail.gmail.com>
In-Reply-To: <CAJq09z5PoaOUW22k_8Raw07-jyC45ZpgiojgL1WP59oDQC3REQ@mail.gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Mon, 18 Apr 2022 20:36:25 -0300
Message-ID: <CAJq09z6Bp6b7hwhyBQOY+6e=UAZe0Y6stsZqEwRSdTjn1bqkLg@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Ar=C4=B1n=C3=A7, Alvin, Andrew and Linus for the reviews. I just sen=
t v2.

Regards,

Luiz
