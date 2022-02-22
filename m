Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC184BFC53
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiBVPVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiBVPVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:21:39 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFFC1617E2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:21:13 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id j2so42012415ybu.0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HVdVMfysf95jTHRvOxuNoVjxuB0CjZvhXhqlbIHuN0Y=;
        b=KTh8aFNGaoyntsSAxBWClVP9/nSFTBS6irzubM66J/T39Yf6IABij0qQupUfuzzdZH
         ihIj4SU7EJtHUp3eNKbXfhrrfrdHCRjI06QOYhuWfa0CrRe5czKlGZ0kFgPhNtdusiE/
         0cWGtj2Eo8LQ48RmeuO5gh48DJcz9Ic28mn3vkGeynwoJm2hTtHUmOW3NPXIa4x6jgsf
         6IVhC3O85FyU1YztP8Nj8fRJuiHPBP5iQXLzDxOET1eFSu7QBjKPOJvhBmaOXJMJnFLm
         a5nEmVP4VCmsyQ2WvCMH6N508jNFlxP3rso6X+xul9CMCySIXCetVpdBnk8Y2gRuOE2p
         bnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HVdVMfysf95jTHRvOxuNoVjxuB0CjZvhXhqlbIHuN0Y=;
        b=btAL3PukERPU4iZG6BS4QHEQX7Poo9MjTZO2tapYWrbjNlqwutHXhjQ60A/gS8dufr
         Xkv503mnMt/FUNnOaCoroY9JoLGo9FOhNjGVbh2pCmIsYTU+IzGMsrTPxLz7C5NdZ4A2
         B1i8Vt2a/wd3vZLCNkArJLykK40xgRy99r/HOBWk7RuzmVCSSQVRLS6YEx6TQXPbkrgk
         jkUgE0T0br3OrW3oLgLFi+/T3QshygAxCtl3v+neuf+ST7iZPBZ/CHOnYJICtY207aeA
         bpvX/T9PgtkbAciOVRluFrsz+2+uHIhPoPoLMs07BW7c7HgduI5/5gVY4u+9BKcNscuo
         2hbA==
X-Gm-Message-State: AOAM531XOpqtBtBsclyQQHSjudkWrAjpySTy0eoY0IFVUImN3ROyHvyF
        e+pbrlyIqEHWfzPUW66YsG3v9xgSVd/8GoI8TEVdcA==
X-Google-Smtp-Source: ABdhPJyCcJARRbkiTPXc35f6YTtpOe1UTQH526CZggy98Wmxv6UfuXKgc5itp4zRkLxISttmSWvkXXI+3Fq9wJhPrqM=
X-Received: by 2002:a25:aac3:0:b0:624:ab10:49dc with SMTP id
 t61-20020a25aac3000000b00624ab1049dcmr6967837ybi.291.1645543272820; Tue, 22
 Feb 2022 07:21:12 -0800 (PST)
MIME-Version: 1.0
References: <20220216212433.1373903-1-luca@z3ntu.xyz> <20220216212433.1373903-2-luca@z3ntu.xyz>
In-Reply-To: <20220216212433.1373903-2-luca@z3ntu.xyz>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 22 Feb 2022 16:21:01 +0100
Message-ID: <CACRpkdZhtdyni0cKT43nd9YVSnA_Dza6=kuECuXLJKbDG2rbEA@mail.gmail.com>
Subject: Re: [PATCH 1/5] dt-bindings: bluetooth: broadcom: add BCM43430A0
To:     Luca Weiss <luca@z3ntu.xyz>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 10:25 PM Luca Weiss <luca@z3ntu.xyz> wrote:

> Document the compatible string for BCM43430A0 bluetooth.
>
> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>

Looks good to me:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
