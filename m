Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C077585AA4
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 16:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiG3NwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 09:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiG3NwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 09:52:17 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3782C1E4
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 06:52:16 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l23so12883071ejr.5
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 06:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=JJ82LD1nJDqE35xyfgAVRzYEpg7OOqUuJdDiRjkUZUS+0ZRvtj44tSfs8toTKoh2BX
         P7AUu/7XXr49mQHdQn0s1IVXh9mAxw1J/lZlMW7qQnJ9d4qVhAXyZ4p7jRmO8b7+dfpr
         3S/r0yJbC0G8mj0rnOIb+YOUXVlW2bjI2Ts5oQRoYadNTi5d0UmJ3RUum1P4cFNNCXMw
         sI5V/wlsT2m0s0U9+hh4WgjBqU9IFqYWUTGEtt7Q4YOfNGJ8gAA3IbEgtM49JzK00Eat
         T86vpgqh98q0enP+/l8f8KCQplI77EGTZD42HVoBb35mS5oM8O9uobau7yAZZHO/3ks4
         pUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=HUzhjGkNDCBnDhj2tYgrT3IO4g4ULEiM0eYQVzCrM9kJHdoVuYyBRsL2KM0k+QN1cM
         7DHK16bydoSW8vXvaTwGU/bCvJYgERxwPXn5n4uZzj1r5q2lnQAZaE8lh3w+oikUqc2w
         vLhAfFr3YZnCwIVrGrcUZYhXzp78I9PCUZ9JsIL9BPXDjspRzMdbKMA1Vr4wBVtpK0nI
         ZWBbt/xnaPR+5niCJDE24BTa2eRkxueXe5OTxjDMUSuzNAwFHSLKufSGb2exk5eaVAch
         ehkO/ZwzERDJk0Lef+4TvVHCiRIudCWZ/mKDSgo5uINznULhz1YBPh6WlJZZg4+hiYZc
         LEBQ==
X-Gm-Message-State: AJIora97z0CvHdvhOD9rU7FGa98aIgn72d7yHzH9idfwN5qcKurZLawV
        TEtogGiE4uCN6xlBqe6ps53jwBxTATRG3aBB6MM=
X-Google-Smtp-Source: AGRyM1vWqJTVROV0g7sInZSoScNp7r5uSIQcKByt+NMX9trKq0JxirTnmJ3dmo8zuK+uotCxJQJgdtrqJrnZA/U+b5k=
X-Received: by 2002:a17:906:6a0f:b0:72b:64ce:289d with SMTP id
 qw15-20020a1709066a0f00b0072b64ce289dmr6106269ejc.663.1659189134165; Sat, 30
 Jul 2022 06:52:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:2d2b:b0:72b:4fbb:174f with HTTP; Sat, 30 Jul 2022
 06:52:13 -0700 (PDT)
From:   Morris Omayi <infobarrattipoeq@gmail.com>
Date:   Sat, 30 Jul 2022 13:52:13 +0000
Message-ID: <CAOCqcS=5N+pbkKvCgHF4Y-eFQQHo3mex8s+UdfkXKGrJXorZ2Q@mail.gmail.com>
Subject: Willem, How are you today? .
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


