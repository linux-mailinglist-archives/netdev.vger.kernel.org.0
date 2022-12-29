Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88A3658BCE
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 11:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiL2Khw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 05:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiL2Kha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 05:37:30 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F01911832;
        Thu, 29 Dec 2022 02:37:26 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id t17so44066379eju.1;
        Thu, 29 Dec 2022 02:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8yN2UOeep6Dr0AKjJEFzftya+Rk2XU0VFFUWitWBRu8=;
        b=KLxed4jWUMjHhYAAv2olw9q+/vOBhFUwvDZFKN+4MHCYBzqjeUhNCj8s1EuqQxK1GP
         iXuUPh82qNH9a2PUUlF89hyd9Uair4QwwniGNXjaDQlO+1kBBPFxMXRFDcRbqosIQ3Er
         2LcnwzxMA3/MQ2XMSh7tl4IjrkvAphdljwcXQ45Wvim2ilKAl5wMlmxLXIZAjtQu8wT3
         FUY9hZMcTZdbAbfwRLZG/flQgKjQHC/BzioAEPoJ7suXdqC+cbMruK3ZLiNZ2NJTidUd
         +AnBkxDjfMejwLoDAKfEBl9rwa2ZesS/QhU/9P35AWParBCKeCFfT/HDb6ikvnsMAd2x
         1hkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8yN2UOeep6Dr0AKjJEFzftya+Rk2XU0VFFUWitWBRu8=;
        b=1wtCQQQHWQKmYuZGyB4DFF7AYhFu5eogHLHb+hBSuQVbDLQzKxvyaHZB8et+1kviJg
         lMzQZxRIzJ26OY7UnVvK/3oYMOlrQBUkcfi1SrnWzLPr64cMffydBRP9WGTly2334v+C
         BExAZUKn7m/AkGZvseXyG2Xf3AoYeI586pr7bPGjUIkgcJNzMfvX00vZ4oFxr2B32ShB
         aQ477tAPXaVw53ruFOpiXTdrt8crSReIU9B0I9xLuHvH3WBL1Bv5jjfsymOtiv8fKzje
         McwK0C2GiR3qxxkUyjxjapP4h0mwXWKoAz5+/ZjBIdtAamXptJ/8e+O++mEL6rvwGzP/
         q/Fw==
X-Gm-Message-State: AFqh2kqzO4aP6ooCF2I54eCBno1g8P24jxbZUMgFkyLK/cHQkgiI9Krn
        J86/ArMvplKDybICLWjbNRf1TeTFNcM9ZezVo2A=
X-Google-Smtp-Source: AMrXdXumH0x9Lc4+ttBAXwDIaxE+/hVpA2oQOIazaE3IX4tIJJZeZX9N2LLEEU9+nwxLZmdQh7lxPdYrVahjjbuwdr0=
X-Received: by 2002:a17:906:3989:b0:7c1:1f28:afed with SMTP id
 h9-20020a170906398900b007c11f28afedmr2308471eje.678.1672310244665; Thu, 29
 Dec 2022 02:37:24 -0800 (PST)
MIME-Version: 1.0
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com> <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
In-Reply-To: <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 29 Dec 2022 11:37:13 +0100
Message-ID: <CAFBinCBKuTsK21CxEhth5js4Quyy0iUg6ctZwEQwwarePgghaQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

Hi Ping-Ke,

On Thu, Dec 29, 2022 at 10:25 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
>
> > @@ -43,13 +43,13 @@ struct rtw8821ce_efuse {
> >       u8 link_cap[4];
> >       u8 link_control[2];
> >       u8 serial_number[8];
> > -     u8 res0:2;                      /* 0xf4 */
> > -     u8 ltr_en:1;
> > -     u8 res1:2;
> > -     u8 obff:2;
> > -     u8 res2:3;
> > -     u8 obff_cap:2;
> > -     u8 res3:4;
> > +     u16 res0:2;                     /* 0xf4 */
> > +     u16 ltr_en:1;
> > +     u16 res1:2;
> > +     u16 obff:2;
> > +     u16 res2:3;
> > +     u16 obff_cap:2;
> > +     u16 res3:4;
>
> These should be __le16. Though bit fields are suitable to efuse layout,
> we don't access these fields for now. It would be well.
My understanding is that it should look like this (replacing all of res0..res3):
    __le16 some_field_name;                     /* 0xf4 */
How to call that single __le16 field then?

I also tried using bit-fields for an __le16 (so basically the same as
my patch but using __le16 instead of u16) but that makes sparse
complain:
  error: invalid bitfield specifier for type restricted __le16


Best regards,
Martin
