Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1673EC443
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238807AbhHNRys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 13:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhHNRys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 13:54:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428A1C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 10:54:19 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id z20so24272056ejf.5
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=M9Sbx/BZ0kWJVLhLoafGzwCCRCgh4U2iaQh/gu2gce0=;
        b=UF7az8hXq/4x/mLUDJMimnZRsjq3Z0n4mTTdiNb2gi0a0f84FXwaLhWkZ72Simnm9Y
         Zi2NV84a1lVTiGTDxtBih46T0tZaccqXBc56HHIJdswOcx7kR6SIg/gHepsY99s8DTeM
         J18ZUxdqGYRp6j8I86xVUmZXNJTaJrvQwXi1yrEnC4V83ayIm6he+KYp68sV0jwuJgKl
         G1mX5DFPzk8VxXgvNbVewb3DSmiss4PnYN1LWvj8SfEc14oKrg0NLl5KvqzPZcp89m8N
         jjXvyXv//Dcb3x4yJ0c9chbaXELdgPp+Vmf8hQRXg3PCz4OOlnSOFNG3VwBHvePjssTW
         SMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=M9Sbx/BZ0kWJVLhLoafGzwCCRCgh4U2iaQh/gu2gce0=;
        b=btVbvzr73RwJuGOgP4ukyGLOUsQObe3HyrQ4jWgjV4ArcVGagOzsXYd5t/jqVWPeqO
         89JGSgHPhfkVXJTCNqywTPBAWg6HoP8m5O3X7TB+F5zX8YyWS2WHugR/gI0JOMk5U8Hy
         7vnM0hTfFFzinZhZjyXQuOKcwGdnbMzyd3Iga77T/BRJrJeldjXY1qpP30Lxme6LovYE
         1UgZQe9G1h6lgA4u9xzfLR/bSozxdJb2T8TvaeUVzolZKMYTXx5csufcV9BDXSRzT766
         uEC1rGFyKL7RsYkuf3PV2McmtiglxzVQc1BNhNVHsTHp8xIFEkXKNcLR7jK5o0FCgdK8
         q1pA==
X-Gm-Message-State: AOAM530a4YMhQJ+P+h4uGq5hqQKnDJPWA0oGIzJnD8dxZW7ReXFr7Pvz
        Hw2Ih3NKTUcs4CcHJjMyMfYtkAU89l02tRTGWpE=
X-Google-Smtp-Source: ABdhPJzWFMXuQaC1FblmgZb+7kvaXwHHoX0sb3ruYWwQsaE4iechvfC+HcGaO3bo6kvn+2Bxdqrgq9UsRhWULGDj6Oc=
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr8438876ejb.519.1628963657840;
 Sat, 14 Aug 2021 10:54:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a4a6:0:0:0:0:0 with HTTP; Sat, 14 Aug 2021 10:54:17
 -0700 (PDT)
Reply-To: abraaahammorrison@gmail.com
From:   Abraham Morrison <sambchambers06@gmail.com>
Date:   Sat, 14 Aug 2021 17:54:17 +0000
Message-ID: <CA+RS1P1_LSK-KcSM1R-UCafwsvUkjV6wtgqKJc_1bHgF32QnGw@mail.gmail.com>
Subject: Good day!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0JTQvtGA0L7Qs9C+0Lkg0LTRgNGD0LMsINGPINC80LjRgdGC0LXRgCDQkNCx0YDQsNGF0LDQvCDQ
nNC+0YDRgNC40YHQvtC9LCDRgyDQvNC10L3RjyDQtdGB0YLRjCDQv9GA0LXQtNC70L7QttC10L3Q
uNC1INC00LvRjw0K0LLQsNGBLCDQtdGB0LvQuCDQstCw0Lwg0LjQvdGC0LXRgNC10YHQvdC+LCDQ
v9C+0LbQsNC70YPQudGB0YLQsCwg0YHQstGP0LbQuNGC0LXRgdGMINGB0L4g0LzQvdC+0Lkg0LTQ
u9GPINC/0L7Qu9GD0YfQtdC90LjRjw0K0LHQvtC70LXQtSDQv9C+0LTRgNC+0LHQvdC+0Lkg0LjQ
vdGE0L7RgNC80LDRhtC40LguDQrQkNCy0YDQsNCw0Lwg0JzQvtGA0YDQuNGB0L7QvS4NCg==
