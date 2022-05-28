Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0583C536D6C
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 17:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiE1PJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 11:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiE1PJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 11:09:46 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A2213D5A
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 08:09:46 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 137so6370486pgb.5
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 08:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qQfdIJnbH8+PYGMSBd5BFbExL8lmFzgzIMpmTwXoAGo=;
        b=leiG/v3ifQTVh33QfJmGtmgBI4iIj1iNukkMRehA7l40P5BNbZAZYfaCShGgEwfwt0
         Up3ByrxCim6EWeNliWP4/iabFcL2aRp8i9SivbhpVs1vznKoXYtJGM5V4c+TvU60kbH3
         Jo+RQMe4qcHvi/kSbwwJWJdjKy4JG5gt/J5l9b9CwNGC7/9PptFYFEAsGZh28X9YCq7P
         MG7xSAjgzH+nSF2rlMFe3MmgKq+pWSF3Ob1FC7ds+HK+bYoEAKQDqze9bpkeXusGs1N1
         ttaL3sVnNN7bmz7c43zWKyzx1cJEXkLXA0FOAdh71jQ8yTSfJD72ql8jKOgIOmXWQBt8
         kYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qQfdIJnbH8+PYGMSBd5BFbExL8lmFzgzIMpmTwXoAGo=;
        b=GwRkpTTnv8s6RZGdEgpQB2IdtFOVSw5wK7G4s3derA2XmXtoLlZq4VjtkZM9ADRcaS
         jY6TkCny0Vi62EFK4wXkmz4Qtr1/OyRL8D2YvYxUnxVLrvvHty+Nci8yniC0IAjNxENr
         CQoXyZZJMZoelLRV/b2fDUd5HlvSSDOwVw+1hpvk0ieH8fhrIEdvoIU3NS3tD2CAldzb
         liItEy1ppo3xC1oXbJeRw7n9TwwQbT+vEMq7KXsb1hMFjhG9C0Qfkm7yXv5MN9pqfdeW
         H5vYXWkhTTd1gxU7iPiidqriumX0Qd5AJPR3MPZ9h6yqCR9X/j5cjYYnqRaU1oWe+Sse
         V25Q==
X-Gm-Message-State: AOAM531dYdBBtKYOKmKbH5tZ+IRGh33SOcbJ6w+Cm3w95ns34mFxVIFp
        HJFruW8VU1BEIeHnDLt1UBZHmaQ1NjAAC2Lk4Mg=
X-Google-Smtp-Source: ABdhPJxMVbrxRnfZJzeSBxifZgpfNIUOxGKCiGBUGUL5kQ1WLJW0XiHzOWpasIEtTJX9sCZrIdmiNeyNwpZavdN3F3E=
X-Received: by 2002:a05:6a00:2345:b0:518:929b:ce8b with SMTP id
 j5-20020a056a00234500b00518929bce8bmr33898045pfj.5.1653750585569; Sat, 28 May
 2022 08:09:45 -0700 (PDT)
MIME-Version: 1.0
From:   Jack Joseph <jackjosepheq@gmail.com>
Date:   Sat, 28 May 2022 15:09:15 +0200
Message-ID: <CAByw9EWoRt7E1ZK4O7MqsgaBw3hSZ0kJWkB4vZ+Yk7XeL7Fi_Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2YrZiNmFINis2YrYr9iMDQrZh9mG2KfZgyDYo9mF2YjYp9mEINmF2YjYsdmI2KvYqSDYqNin2LPZ
hdmDINmF2YYg2YXZiNmD2YTZiiDYp9mE2LHYp9it2YQg2KfZhNiw2Yog2YrYrdmF2YQg2YbZgdiz
INin2LPZhSDYp9mE2LnYp9im2YTYqQ0K2YjYp9mE2KzZhtiz2YrYqSDZhdi52YMuIFBsZXNhZSDY
p9iq2LXZhCDYqNmKINmE2YXYstmK2K8g2YXZhiDYp9mE2KrZgdin2LXZitmELg0KDQrYqtit2YrY
p9iq2Yog2KfZhNit2KfYsdipLg0K2KjYp9ixLiDYrNin2YMg2KzZiNiy2YrZgS4NCg==
