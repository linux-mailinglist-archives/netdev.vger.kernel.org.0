Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8431B6E34A7
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 03:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjDPB2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 21:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDPB2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 21:28:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CEB30E2
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 18:28:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p17so11058391pla.3
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 18:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681608497; x=1684200497;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBgMMuS3S+nXOdAGD5zD1EDLkW0bCURYfUeSPB7KubA=;
        b=dnqW5/vphgmkeuguYaVpe4tWrq6vYSHIcEZzqRjYTi15xOByCnS+mtyE2Fw9Vszgur
         YjdF6OqQqrOJhLJrXweUO8IPc079Iqn8MiDbkjoPT6ILEcRYlxBVL74YaWKVnEdeZh+G
         B3jqun4aebR3upPC3dePC4P32C4H7Hla2zmTw7HKm/ztFNlnPZUt2ThZv2RoV4FUjjGl
         0/i6kMvte7M4UBRco2vCHG76hdVIcvUPw4JI90HsmoiRrUIVXkej0aIZvRvjBQn4O5Zp
         S3gQxLdrx1P1nRl9OvGW5q1c4vwEixcyOlZgvW76YqnhqajvT7CVveq58pLKkJK44YdU
         WTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681608497; x=1684200497;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBgMMuS3S+nXOdAGD5zD1EDLkW0bCURYfUeSPB7KubA=;
        b=M2sydjNbx8lB4DaclId8+WDgX8tpvQg23+4wdXf+nIYcv6OU6ViJTv+RD+TLH3dHpY
         zf3pIdL0pcjG4TPyXADgdI3bSrWqjnMgZFO4wdxZVouFdD93+3hIKoW7mrAfFFZWnGa7
         sCkw0+fAHLFvCnO15vhfcOUn6xgTBKV1JCwrrJctK6SdN0VJkheXnc7vXVGNgOKLOvhU
         w5wZZeLUqYDNbqdekj1dFGfOp8PHVztGWFoUAXTpFtCcMkwSGote97xRknNmPZLOJWRK
         V8Ia16eeoaYH8Lb59zOh7SWKj6xC1kXT0XNrTklx+hkfin5zc8LJ3sx5V3euYZzIKB3s
         YDLA==
X-Gm-Message-State: AAQBX9f6/7ByLtayFb/gDYeVG6Sw/V6QibMJxqvrqJ8vDxDmtyR2fLHX
        S6JaeyTlxovNxMXnhAzZJZj4MU2epQST5COoOOQ=
X-Google-Smtp-Source: AKy350ahINZufA/zohs3zAC317UJ52JErBKGs7JILXVjeVZQ4j2fesrPt12SUS4N5N5bVeLR00Y8XENgl5MCx15ivXc=
X-Received: by 2002:a17:902:fb46:b0:1a2:1ec5:e11f with SMTP id
 lf6-20020a170902fb4600b001a21ec5e11fmr2346592plb.6.1681608497395; Sat, 15 Apr
 2023 18:28:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:515:b0:47b:3dd5:bf6c with HTTP; Sat, 15 Apr 2023
 18:28:14 -0700 (PDT)
Reply-To: mrskumarprince@gmail.com
From:   Aisha Gaddafi <albertwilson06751527@gmail.com>
Date:   Sun, 16 Apr 2023 01:28:14 +0000
Message-ID: <CAFpECLeaYPD+v6pVVH5YA5CJqWU3RoFE9YzOe8QuHHKZ1KSNVw@mail.gmail.com>
Subject: Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am Ms, Aiisha,,I am currently residing in
one of the African Countries, unfortunately as a refugee..I need your
assistance please.

Best Regard
Mrs.Aisha
