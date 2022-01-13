Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7710E48D869
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiAMNAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiAMNAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:00:54 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F01C06173F
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 05:00:54 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id x6so19190187lfa.5
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 05:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=G/ND3tntpBgwv8HQkehUDejMVtobvIq7mZphn2wM5KU=;
        b=Du1G+ThJ9pmInvEXZb3s0abnI3M7e78S1RiKj3hgM0OhtOSm2XVYVf+Fn5JrgZWbnN
         VM6mwGObo0VBTcw9UZPYtbQe9VnDqOx9u2FTqjT0zaz/3Zxr188dpf6iB3ZYzIbYSNUl
         ruRpp4jv4IYFDFwbH4zL4BVctR1rBuFC3uu+dQJwX8psd4bckrkvVuPSS+ESkAs2BlMs
         iyOidqMKyGe0n2bPrN7T2Hgvg8LH3/AkhBpa7Ep1kjBMkMO0sq6LisHefKlt2pi9FbOr
         VMwV+l9x6COt19KCCt0n7yt7c+6leSRGaHlOk3Net4VfUn5oaOnmcWvzNyv2/NFXtj1w
         7PrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=G/ND3tntpBgwv8HQkehUDejMVtobvIq7mZphn2wM5KU=;
        b=hikN4pdp1rvGDqu8xz/t91xvPtevuXZjgHM3S86C09XoIyUlyr3RMRfdlPhTMZf9vi
         Z1hRBB/Hf1HdjPynj4IaKyyYpUwOrfPEySG6xsQodR4VOuCk6XKSPo4zmxJ4izf/eYih
         +5dW5P6crIL2rBiUlQOrYKuRlwn7hwuQ2oBGgdHxxzkROg7Dr5ckk9azA25gClz2+/Eg
         Bed1DI9XPzY9tWWcgL0xiAaO3ozo0TQtWSjxkgRf94XpCQzfDiBcYpfcAFGAcielo3wN
         e9Hl+at0t9SSBOf8WXfRknvT7cdB9vgKk9ekcgmvKpqNJXqts0DZAQHFf3XGjo41v3jN
         4+4w==
X-Gm-Message-State: AOAM533Yk1JYGzHLWyQDs5nz+sv1KLz3sIXsfVX9TrR7gRVQ9B+eOk3K
        u88I5ayhK6JV0VkAJXO67Sv+OcSshGkDC9DpaF0=
X-Google-Smtp-Source: ABdhPJzCAuzxywr49tHseyf7tIpf1BGOtDSh2d6pWTCVdVXfJO567/vo2W1IjOOVRWhnKRcOIkhGIMWDZ1MBJ1fwMiw=
X-Received: by 2002:a05:6512:2394:: with SMTP id c20mr3058139lfv.399.1642078852432;
 Thu, 13 Jan 2022 05:00:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:aa6:c781:0:b0:185:86e8:9da9 with HTTP; Thu, 13 Jan 2022
 05:00:51 -0800 (PST)
Reply-To: egomihnyemihdavidegomih02@gmail.com
From:   Davids Nyemih <curtisdonald95@gmail.com>
Date:   Thu, 13 Jan 2022 14:00:51 +0100
Message-ID: <CAFnUQ=m0X0hEzM9XPbO7YixWmKF9UvXzPj8Vbi=cv_zoqcYNyw@mail.gmail.com>
Subject: Re: Happy new year
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEksDQpHb29kIGRheS4NCktpbmRseSBjb25maXJtIHRvIG1lIGlmIHRoaXMgaXMgeW91ciBjb3Jy
ZWN0IGVtYWlsIEFkZHJlc3MgYW5kIGdldA0KYmFjayB0byBtZSBmb3Igb3VyIGludGVyZXN0Lg0K
U2luY2VyZWx5LA0KRGF2aWRzDQoNCg0K0J/QoNCY0JLQldCiLA0K0JTQvtCx0YDRi9C5INC00LXQ
vdGMLg0K0J/QvtC20LDQu9GD0LnRgdGC0LAsINC/0L7QtNGC0LLQtdGA0LTQuNGC0LUg0LzQvdC1
LCDQtdGB0LvQuCDRjdGC0L4g0LLQsNGIINC/0YDQsNCy0LjQu9GM0L3Ri9C5INCw0LTRgNC10YEg
0Y3Qu9C10LrRgtGA0L7QvdC90L7QuQ0K0L/QvtGH0YLRiywg0Lgg0YHQstGP0LbQuNGC0LXRgdGM
INGB0L4g0LzQvdC+0Lkg0LTQu9GPINC90LDRiNC10LPQviDQuNC90YLQtdGA0LXRgdCwLg0K0JjR
gdC60YDQtdC90L3QtSwNCtCU0LDQstC40LTRgQ0K
