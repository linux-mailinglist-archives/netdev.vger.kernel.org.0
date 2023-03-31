Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508986D1F5B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 13:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjCaLpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 07:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbjCaLps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 07:45:48 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7311D933
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:45:44 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p204so27018366ybc.12
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 04:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680263144; x=1682855144;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etDsOsklTFhdv20/ihPgdxxbpxkX/HMYSlW+AO+gqjs=;
        b=GW/mUCUjfIHsb0OH9tjsntvW4/CmFR/F8xdKF9rslr77zxJo4xcB+7vO+oT/Tp0g95
         CWKr9/bs9R0exXmyBzCBiJCR/s+4tLYt8arY4hA3d6n6P+lXuXxMikSBu+HOslgAR+m8
         9a/5Vv6LF0j+RO7ZsBQgrhSDp/R6NNzheO/nWG8TiW3/PnBUiqHr61Vt9D7yUqjkA9sH
         jZGLb/UaRvYjoU6TLaAfI88hdtOh6+alp+YwziX9jYlh31oApcWZAP+fpjgUISygnZlu
         2sgCUG8SdO7fchlmTnsgNxCCh2rKty5NSr2N5RDlegP+db41W8RltlcSGWtRxKYQ+srR
         xjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680263144; x=1682855144;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=etDsOsklTFhdv20/ihPgdxxbpxkX/HMYSlW+AO+gqjs=;
        b=CYzJrQJMH8/L413RWfp96YuYR0PFmSuofKrUa3GRO8P5TmlkNbAs5YN8zsik01ASNC
         TF/7XCEWTnOTY/ql63SraRYQHiii/7Lk3W5qMlE1xFI7zhw8FPtAuQxw7tPSgXkCVBz3
         JYcvClQ2sqMIt9LkIKFGcK0myaluQ53BvAyPqy/CgAdj84WOtq30oj5/EWB//uc20rTW
         09A+9flM9j8Jp2GGO9hl8YuiBl8Gy9wHrBLe/xJ5Aq8yBkD6EO708GdWJkI77b+Au3vk
         E9t+2dFYgt4wZMiwQN05QBczqvrRqYyRQu17qhevab1LdsI6qQySQo43oI7Pt9BFqJUG
         Q30A==
X-Gm-Message-State: AAQBX9dbNzo3Jn2SbGJxY27ulRQUwgoH+tQfJm42wXZPjZqjoNfwCZFg
        KH0zlej3SojbgzdiHwc+KFfiQpOTmFq7B5Y9HBQ=
X-Google-Smtp-Source: AKy350YvcDYNjhPV8w/HkXEiohfaXG+7VhjnOHA2+wyXsFbRw6SyoZudgBd6aTme5K2phaa1YiEt9EOIlQKtNmQoJcY=
X-Received: by 2002:a25:c407:0:b0:b82:d2d:a0bc with SMTP id
 u7-20020a25c407000000b00b820d2da0bcmr220970ybf.9.1680263143895; Fri, 31 Mar
 2023 04:45:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:b20e:b0:494:4a7c:3608 with HTTP; Fri, 31 Mar 2023
 04:45:43 -0700 (PDT)
Reply-To: fionahill.2023@outlook.com
From:   Fiona Hill <lorijrobinson589@gmail.com>
Date:   Fri, 31 Mar 2023 04:45:43 -0700
Message-ID: <CAKXTXJxygiKASAZgusi-0qHMVyZNhwGwHvvdfd=A4SJp+nAAhg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello did you see my message i send to you?
