Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2236522EFB
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiEKJIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiEKJId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:08:33 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BD625594
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:08:31 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id w124so1317957vsb.8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=SGYBDoLJhEzhgQ5Y2sA34o5zGGp0595H2X2D1a/NEhA=;
        b=LHeCtkoOsMddR18mUIeh0elU+k9jxs87QHoYA+B2wpoiMx9JWQc2NZwivUV2uVeEiP
         cq2GRBjlxPMRWUKhtMUkIJc5AFUINSOivLI3cjbjzaOWWX0R81P3eNlZSc/koVbJMXvv
         TB7VdFPg/tinVBWGrJpXGtb77SN9YOA6EXgvLXJbOFupRN2su1qcRpiH+P/XBTvgWBL9
         bJANrc9eXLHYQjC8L28xEdB77CmCcsZI0d8kbtzIiPleu+4GW86IKKdkCIJtHUvZ4bYd
         k0fm+PyHSvkKNyoBE2AHVFoyLIhsQeGPHCrnRdTDXO04nhZlhdLHsHWunggBnktpOuhi
         IB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=SGYBDoLJhEzhgQ5Y2sA34o5zGGp0595H2X2D1a/NEhA=;
        b=NgLuWUMRV5IyHEo3oh9iY3a3gtcskFHIhSM8CPz9jOCNVU6ugy+i+H0O+A741gZGrA
         fG+/m3B1xmZZDSf8WxCb0LFYAUDwYU21Y6HBlz+meOXTpqI+DYMvKp816GgN04ZbIMXK
         9VemtgTKWBz2wIkbxiaqVk5KKZCP4i2xhiQRYtvtpA1RVM+263mY4pi8bNFJszb03STt
         7DDfPkombny8pa8nbK4aTRq9H1S6KhKEziBriNb9AHUDqH3Ac0fHN9SYGOKQA8QJ8d3h
         QMlDOl3fxhbqayxbNXHTSsz1zpqiyal+W2NmNHV5pmQPmYErurnQKNuHL3TLCtND2ifn
         lrkw==
X-Gm-Message-State: AOAM532r/96ayCutAA91r6mBs+r8XVuE1HJJQcalcRhERdh91EMqJUOs
        jtfq+4yp8f8ULQfTm1cDj0ocgHfBaqSgheIYbwA=
X-Google-Smtp-Source: ABdhPJyuxM01+DNh8RRvZBGvhuqwt84+Fvx38K5fCsQItp7WzOVPYBAOKBUAkVTk14o2Xjb4uiAFVf8AQJKhaDLt3No=
X-Received: by 2002:a67:6f03:0:b0:32d:795b:c8a2 with SMTP id
 k3-20020a676f03000000b0032d795bc8a2mr13226802vsc.48.1652260110682; Wed, 11
 May 2022 02:08:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:bb52:0:b0:2ab:8088:8447 with HTTP; Wed, 11 May 2022
 02:08:30 -0700 (PDT)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <barristermusa32@gmail.com>
Date:   Wed, 11 May 2022 09:08:30 +0000
Message-ID: <CA+gLmc9qrH_f2CRj6xMxQEeVNP4nXo=wNhzF3R95aP5oib56mA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2YXYsdit2KjZi9inINiMINmK2LHYrNmJINin2YTYudmE2YUg2KPZhiDZh9iw2Kcg2KfZhNio2LHZ
itivINin2YTYpdmE2YPYqtix2YjZhtmKINin2YTYsNmKINmI2LXZhCDYpdmE2Ykg2LXZhtiv2YjZ
giDYp9mE2KjYsdmK2K8NCtin2YTYrtin2LUg2KjZgyDZhNmK2LMg2K7Yt9ijINmI2YTZg9mG2Ycg
2KrZhSDYqtmI2KzZitmH2Ycg2KXZhNmK2YMg2LnZhNmJINmI2KzZhyDYp9mE2KrYrdiv2YrYryDZ
hNmE2YbYuNixINmB2YrZhy4g2YTYr9mKDQrYudix2LYg2KjZhdio2YTYuiAoNy41MDAuMDAwLjAw
INiv2YjZhNin2LEpINiq2LHZg9mHINmF2YjZg9mE2Yog2KfZhNix2KfYrdmEINin2YTZhdmH2YbY
r9izINmD2KfYsdmE2YjYsyDYjCDYp9mE2LDZig0K2LnYp9i0INmI2LnZhdmEINmH2YbYpyDZgdmK
ICjZhNmI2YXZiiDYqtmI2LrZiCkg2YLYqNmEINmI2YHYp9iq2Ycg2YHZiiDYrdin2K/YqyDYs9mK
2KfYsdipINmF2KPYs9in2YjZiiDZiNmF2YXZitiqINmF2LkNCti52KfYptmE2KrZhyDYjCDYs9ij
2KrYtdmEINio2YMg2KjYtdmB2KrZiiDYp9mE2KrYp9mE2Yog2KPZgtix2KjYp9ihINmE2Ycg2K3Y
qtmJINiq2KrZhdmD2YYg2YXZhiDYqtmE2YLZiiDYp9mE2KPZhdmI2KfZhCDYudmG2K8NCtin2YTZ
hdi32KfZhNio2KfYqi4g2LnZhNmJINin2LPYqtis2KfYqNiq2YMg2KfZhNiz2LHZiti52Kkg2LPY
o9io2YTYutmDINio2KPZhtmF2KfYtw0K2KrZhtmB2YrYsCDZh9iw2Kcg2KfZhNi52YfYry4g2Iwg
2KfYqti12YQg2KjZiiDYudmE2Ykg2YfYsNmHINin2YTYsdiz2KfYptmEINin2YTYpdmE2YPYqtix
2YjZhtmK2KkNCihvcmxhbmRvbW9yaXM1NkBnbWFpbC5jb20pDQo=
