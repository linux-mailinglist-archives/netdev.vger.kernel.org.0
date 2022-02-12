Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A3A4B3284
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiBLByx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBLByw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:54:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530FFD99
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:54:50 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ki18-20020a17090ae91200b001b8be87e9abso5336079pjb.1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c4ZN0XwpJM1MOs7CK1yo11Sj3POpQz95IMswwBH76C0=;
        b=BtkYnwoBry11fEeMyv+K81b8CVly78SYIc51+35RGnfyvoW/rbQCfw1Jyo8DCB/TJ9
         SsVMcc0e3dAJoMDLO2ZW0TcmxUjH0bOdPpZQJN6exoAZlTjvCYPP2TyWNfnm69jEQRuX
         M3WBlDsnSHU5JrEeKXuz9NTo3tOKFdYYi7Zw4wW2CiozgLViZYHmZJ5UFX8zMiudOq86
         +KokD56vyvCn9uxQidUEfwQrTY8bfNbwkcW41Tdnz7MftgpwvWJES7F1jqxlhZGTLj86
         cojxIh/Fa+bhhmkEk7cTYdkNloEbetDWptvDWglhNlvEKSHZWD8qdj3tKtdK3ZiBJf92
         Dx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c4ZN0XwpJM1MOs7CK1yo11Sj3POpQz95IMswwBH76C0=;
        b=2xymKSKOX7sUwApTXAckCIxC0vDVlDk122B9jHRDkjvSo8MSGIcnXf7Uss7aEiINo8
         LRhqpaCv9zsAuavR78Gtrr5uJ8aoZsELD+tIPb0vDr6J6LpAVt1ikbxLqaNCrVywlwqw
         XGc6bQq1RRqy8bYFRGZmz6jf5H9Z1rCLBU+4eg3UdzIlMGsuErcJAEEsrYT1WRjBctC3
         1tGQgDw4iDFikqw6RslTdHGP6sDhRnU35MqpRjHZSjUCKzdETLJc0LNqSc8pzaMkQJIj
         a5Y+7tsAaxFr0e5w5XlU/Ib9iV6xoG3RnBOyhlTphJ7n+wb8iukR4tUcnHwz6F4CWEHy
         pzkA==
X-Gm-Message-State: AOAM533aRN0tLaXhWA3FbZvXNgnHYA34Xb9Fh3GrcVFAaQ390hOrq/Oo
        5WGGBoP2sjE+VcIHAxoz7pLHo7iYurJkPSM2JvAvxIwUj05S3R1L
X-Google-Smtp-Source: ABdhPJzGnmCypEDWdEqSFpkNVXsSy1ZWXjkvTya7kKsYnVROJ9dycDr8iXR9TEweBN5VNTVQDtVfunEIoTfmKuT0wTA=
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr3203020pjb.183.1644630889796;
 Fri, 11 Feb 2022 17:54:49 -0800 (PST)
MIME-Version: 1.0
References: <20220208051552.13368-1-luizluca@gmail.com> <YgJtfdopgTBxmhpr@lunn.ch>
In-Reply-To: <YgJtfdopgTBxmhpr@lunn.ch>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 11 Feb 2022 22:54:38 -0300
Message-ID: <CAJq09z4asRpbCY15ysH65uTVXALD5qJ6FsCkTKVR=BcrLh7mkw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
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

> Please also update the binding documentation:
> Documentation/devicetree/bindings/net/dsa/realtek-smi.txt

Documentation/devicetree/bindings/net/dsa/realtek.yaml was merged
