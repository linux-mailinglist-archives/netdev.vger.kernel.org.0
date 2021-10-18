Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C32432441
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhJRQzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbhJRQw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:52:28 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437D6C06177B
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:50:06 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g39so5178840wmp.3
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=fLqIPEBaRNOdjfMHVTUzcLno6ImGHaWY2L/hpqGEyjA=;
        b=jvtp6AO5JB4bWRFlNzFoWWvmAX6SBknXI5mpuU6cuU0kb0uzCt1dhEKNVeGyC6ar2j
         hj9TVB+MrFKbLGbUxEEUVPvxsLb9sJMopuMXl1Lx8RDPDN97aOpf94r2Pr/UAng/rvCg
         jCQlqo8nu3yLDAO3HtCxu2JMrBBhQs2F6jxpnqeH7uIhNDDs69hNc9ycClUOU7FYyUV4
         KWw89g7/YqPgooW0AKXBucTHqdscFWdZT11YWGMlEQ9mBSQQyXmsS1t0fihZbIWcaRuQ
         tUnouWdYFwj38GJfZAv00fbV9/HPa+ic6ro52KHvQRbCSYNKghkwjJvJFl0pGojvH3iI
         DXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=fLqIPEBaRNOdjfMHVTUzcLno6ImGHaWY2L/hpqGEyjA=;
        b=6AQEvCRs5fPniLAUOT8QzOkfpzyhmaJ7/NkQnPWD/+9LckcQMp5LyWYpLdPGED1lye
         Rx7blbLBPYVNtri1/klAJsNYqIqhAtcMCBB8m91JXCCewJVF5rNfMWifSes7cVdMNFJw
         mP4Gw+s0uFTKfjVX0Q0SCau1SVGvmdh6CSHJRW5kpvW0uSopFoJ8tctCblhyjY6zyJ2b
         UfSfFEngKXOtO6roFFns1cO627wEOu638fqPGQNRMhHfiEgkf+4i6STmNxfA1x70oEfA
         lgZ4qFV4e6mQ7tRiLK04Bh+5cYEU/IkyThmd4jvDCC49mWxMadUCrsRK7hLf9DyD3oEh
         b3Yw==
X-Gm-Message-State: AOAM533j9NsThKD4YWJ5waGirLXIs4M0+VkGIxFgvdT64cHrtDZZwNY8
        PPOYrco9CDMo6hzoBPL84H0r1iOnfyJ/MKhB4Mo=
X-Google-Smtp-Source: ABdhPJxaY3kZI2FzqRihRotdNFpWDCgdkCRa3/L+7eDBkq/VEQyiN3CEYvwQqG7nMM6x02vBusfm+Xp5rRnsZamstqI=
X-Received: by 2002:a05:600c:4646:: with SMTP id n6mr18778wmo.134.1634575804839;
 Mon, 18 Oct 2021 09:50:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:4385:0:0:0:0:0 with HTTP; Mon, 18 Oct 2021 09:50:04
 -0700 (PDT)
Reply-To: mrjoshuakunte@gmail.com
From:   Mr Joshua Kunte <kuntemrjoshua@gmail.com>
Date:   Mon, 18 Oct 2021 17:50:04 +0100
Message-ID: <CAFhr1xBOVHOuuM=97OqAOV-_E5HaAdWbJjGUQObErf8EwgW2Rw@mail.gmail.com>
Subject: =?UTF-8?B?7JWI64WV7ZWY7Iut64uI6rmM?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQrsp4Drgpwg7KO8IOyWtOuKkCDrgqAg64u57Iug7JeQ6rKMIOuplOydvOydtCDrsJzshqHr
kJjsl4jsirXri4jri6QuDQrri7nsi6Dsl5DqsozshJwg7ZqM7IugIOuplOydvOydhCDrsJvslZjs
p4Drp4wg64aA656N6rKM64+EIOuLueyLoOydgCDtmozsi6DtlZjsp4Ag7JWK7JWY7Iq164uI64uk
Lg0K7J6Q7IS47ZWcIOyEpOuqheydgCDtmozsi6Ag67aA7YOB65Oc66a964uI64ukLg0KDQrsoJXs
pJHtnogg64u57Iug7J2YLA0K7KGw7IqI7JWEIOy/pO2FjCDslKguDQo=
