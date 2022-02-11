Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557694B2CFB
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352689AbiBKSbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:31:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiBKSbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:31:12 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955D4184
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:31:11 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q8so10511808oiw.7
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=SEcNjOSXP8wGpHSIQOVacqlW5iquJAh9dHc2B4bb5SE=;
        b=WzBaBthys2WwkdMCXDTNsF06V+ATy+meZh0VGXC+3ORYJ1qLDj5cnS8j4pFENsIv7a
         k1+JAimDXla8L78+BTOWl6AFxj5icKUQqUjshI66RzP9gqfAQ+85fm60kZf/ZT+mPHYU
         jC0RIoJjgojv0SuFTjXNokbRP/kJMr9RdxroSykj0GMYJtNHOiGGWRAKQmE3W26+AjWE
         x+WPG1QT5VbKyVGt/Sq//HAQlqMATpRO/E1D73Q0Ho5Rmx296h3jjmGGOnGIasO+sjTa
         iXXsoN7/4f4TeOz6t6DG3zjfCPL1NDAjdz4m3TZz0MrQ4+/RrNt6aMMdO/yCC8WxA0tI
         ftgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=SEcNjOSXP8wGpHSIQOVacqlW5iquJAh9dHc2B4bb5SE=;
        b=dO7tABvugkkTfc9Kazp0d8Mnv5Hb15FFXcIYDE89q8TvLkGPeG0VP0I9+RpGBPG+am
         pUoEHP2eP8V6ID9ek+FJxPTHnxWL3dcHOyJLy7uqjKqHRlwvCyNwbp1bbmiJYc6157cw
         sjNgVgyr8JQo/2Z/cegnXVjqBW54QoTJWkB3Uzy7+bu8fCuxq0cTuRTZjnLXWncHWoi6
         G+0OEJmPk3iwPcSCO+LgMDcxK1dTwJZgl70dtEuw5fPXeiEBcUP5m0e9AtUxWRiwelJ3
         BCZ+QyMKX6CiBuOTlYhFx2hzrpO294uUfGtCuPEjW3ggcbQwAxwFAAQUAIR5C+XYZSO+
         JWXQ==
X-Gm-Message-State: AOAM5310S/QXhWM0m6nS/A/xvDuNt+JxVgRqgAZkGZ6fONER8oDei3RC
        KGmCdcyirjfgjcxGHDbO7BfQblquk/teo9MOmqA=
X-Google-Smtp-Source: ABdhPJz037wQeoXY0T8vq+PSd7fTgW+wK1jrJJeu/YIHXs6gDY35SGiynFF4HqxSdMJPwcl28L2gS/ZC7QTPu/VDOoE=
X-Received: by 2002:a05:6808:2199:: with SMTP id be25mr819516oib.303.1644604270902;
 Fri, 11 Feb 2022 10:31:10 -0800 (PST)
MIME-Version: 1.0
Sender: dongheiram@gmail.com
Received: by 2002:a4a:c118:0:0:0:0:0 with HTTP; Fri, 11 Feb 2022 10:31:10
 -0800 (PST)
From:   Aisha Al-Qaddafi <aisha.gdaff21@gmail.com>
Date:   Fri, 11 Feb 2022 10:31:10 -0800
X-Google-Sender-Auth: d3-6AF-IANxD6EONIiqGilSDBqo
Message-ID: <CAJGwrKGYT_yjD7xE_FRExCnU2Uvae3e32L+MZH715P+8EX8Pcw@mail.gmail.com>
Subject: My Dear Friend
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_HUNDRED,MONEY_FRAUD_5,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh
I came across your e-mail contact prior a private search while in need
of your assistance. I am Aisha Al-Qaddafi, the only biological
Daughter of Former President of Libya Col. Muammar Al-Qaddafi. Am a
single Mother and a Widow with three Children.
I have investment funds worth Twenty Seven Million Five Hundred
Thousand United State Dollar ($27.500.000.00 ) and i need a trusted
investment Manager/Partner because of my current refugee status,
however, I am interested in you for investment project assistance in
your country, may be from there, we can build business relationship in
the nearest future.
I am willing to negotiate investment/business profit sharing ratio
with you base on the future investment earning profits.
If you are willing to handle this project on my behalf kindly reply
urgent to enable me provide you more information about the investment
funds.
