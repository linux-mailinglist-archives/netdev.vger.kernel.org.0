Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4EE4A31E8
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 21:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347096AbiA2Uwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 15:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiA2Uwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 15:52:47 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29940C061714;
        Sat, 29 Jan 2022 12:52:47 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so14261394pju.2;
        Sat, 29 Jan 2022 12:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rG3r5ZbC2x1JmoZsR1mSi/6qN848gdvRGNssZE6aO9s=;
        b=GNChJEYOfjxlgNGB9V2NmQKpXGZ1FjUV/jXeKynb+4pUCuwEi5Gj3qR95Q+5aQwJcx
         ocwaZD60eTtDgPT1EN4x8ZnmZAMGGoCJX6xa1Uqt6lF+HPDaweGcgZ5Uk8AzOHPo5sWV
         LsaeCnVnxmM25Z96MGAsZCJkcz8zy6YTMT0dT95fc6MM6YHAZDHUEB5J7+3Qq/tEOboG
         7ietO+DIAijhSUhmdFOIyd1b/5FXU3ivcxwCc4GTOeVjWyCXKYhF4uetHEUfBHurAjJ6
         HhuGySOFrLh92lnf4PpI05zsgqz6X7bq8Q0k2eS7TjRIKlzsd2NVihaoCzDC0IV2wqHR
         ewgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rG3r5ZbC2x1JmoZsR1mSi/6qN848gdvRGNssZE6aO9s=;
        b=FWatXw8uVZdH0Qxn2RiPkJTR8DD0lD9vPuzgWQ6QlFfTMvGaELKJq4tIQ3PZp0urp5
         Pupir5cy/eJ2yD77tfsEkIKbKvD3AuU6AbWTHn52Xf8US31WDWpKGrJgOhYTXFj/TZ6D
         FbxJJoKZlSqiqett5mSrzcis4xX793+db0+FLsxyg3R8suI+5U+ZqG2V0rgaRZ/GN7u4
         02GS7Plm0gaNNw5/LjUdwzzhn7oyCCGcgEtchdkj1Qh2rCOx1ARN+Igyccogstpze0A9
         NnhGLsf82Hyn3jx8AlvlAZgKxLgzzOMz+C5fywDz85okGpz8fNqYOqdUdzCSmsauOxWK
         7w/w==
X-Gm-Message-State: AOAM531+0tAlQozaec41s8wfkeQ87BC0FfzGZxDUTLadGfVhYZmXJEzJ
        lFyryAiXSSN7KdKOpDk+zFPX9jCgtDXx+5UFhu4=
X-Google-Smtp-Source: ABdhPJz2eqoeVk5C7Poy+sLiUNhkwS7jXXPniyR8qaRU9UvBft5kRdpjSwRs2uX0LMlCriraErPiAYfYg9UzpI2GiSA=
X-Received: by 2002:a17:902:da89:: with SMTP id j9mr13905186plx.66.1643489566450;
 Sat, 29 Jan 2022 12:52:46 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com> <7d6231f1-a45d-f53e-77d9-3e8425996662@arinc9.com>
In-Reply-To: <7d6231f1-a45d-f53e-77d9-3e8425996662@arinc9.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 29 Jan 2022 17:52:35 -0300
Message-ID: <CAJq09z7n_RZpsZS+RNpdzzYzhiogHfWmfpOF5CJCLBL6gurS_Q@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Why not turn realtek-smi.yaml into realtek.yaml which would also contain
> information for the mdio interface? The things different with using MDIO
> are that we don't use the [mdc,mdio,reset]-gpios properties and don't
> handle the PHYs to the DSA ports. Couldn't you present these differences
> on a single YAML file?

Hello, Arin=C3=A7

realtek-mdio is an mdio driver with a couple of less properties. They
do share a lot of stuff. But I don't know if I can fit the schema
validation into a single file.
YAML files are not simply documentation. They are used to validate DTS
files. But that's still off-topic. Let's finish SMI version first and
then discuss
if the MDIO version should be standalone or merged with SMI.

Regards,
