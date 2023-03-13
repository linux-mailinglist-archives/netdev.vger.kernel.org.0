Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0879E6B72D3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCMJlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjCMJlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:41:46 -0400
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9072C9034
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 02:41:38 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id g17so14880281lfv.4
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 02:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678700497;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vMrIqUBXz3YTEgqjipRMKyUAUTLHieIOJm0BIwaHCQ8=;
        b=f/ZXP9YRZlUVwXXxT/dhvfx9VYrmz54Z0bhFmn9TtUkiNkq0wiiwr/ViVJTl3YHzvo
         cOm/mo5mP7HH+c/ObqDDnPcZEmwTM/beOhzUpqI+znwKyZEpg+0OQcB/jSjat7OIAAad
         pw9wlRVIaJpm0y5u0mZqt9qOHd/hxNCXJ4E2wr1XfTrzTn06tDDEub2l+xHy4GQzUUHR
         9Mnc1VzuoOgZFvUqTtOjtLUovheF+94vXnSRALwrIFtVdJ8bN+XZ+jxFyrY9BTBZU6iY
         f7VNHkTf7f34bV5//MK8x6T8LDfHvEMh3ebfzNKrGlPsxOtOgFJ04/Pld/hK1po5V5XV
         +tvw==
X-Gm-Message-State: AO0yUKVEFBIjSrrBWAxHf31XFQsR+AjWUaSAAk2A32+yIhWEwtQsrndW
        lyOQznA8XjE37Qdcd19Nn9YdK3H1vjFZuC9O
X-Google-Smtp-Source: AK7set99mDckgndmdGJ1RYutfjlGjgc29zb6urEh2Ff/SxhrDAf2VQu6v035zlzU6M+LIHJT8unLzw==
X-Received: by 2002:a05:6512:2191:b0:4e8:3f1b:fcea with SMTP id b17-20020a056512219100b004e83f1bfceamr1568401lft.10.1678700496581;
        Mon, 13 Mar 2023 02:41:36 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id u7-20020ac243c7000000b004e849f6836csm30950lfl.167.2023.03.13.02.41.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 02:41:36 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id bp27so4562018lfb.6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 02:41:36 -0700 (PDT)
X-Received: by 2002:ac2:52a1:0:b0:4db:1989:8d92 with SMTP id
 r1-20020ac252a1000000b004db19898d92mr10558058lfm.10.1678700495996; Mon, 13
 Mar 2023 02:41:35 -0700 (PDT)
MIME-Version: 1.0
From:   Thomas Devoogdt <thomas@devoogdt.com>
Date:   Mon, 13 Mar 2023 10:41:25 +0100
X-Gmail-Original-Message-ID: <CACXRmJj9bVwpd6bj2GdsUmUJrsSRT5Kfy6f-DQ5BUZEu04cbNQ@mail.gmail.com>
Message-ID: <CACXRmJj9bVwpd6bj2GdsUmUJrsSRT5Kfy6f-DQ5BUZEu04cbNQ@mail.gmail.com>
Subject: Re: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on
 Linux < 3.12
To:     Thomas Devoogdt <thomas@devoogdt.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Thomas Devoogdt <thomas.devoogdt@barco.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

It has been quiet on this mail for some time now. Is it still being looked at?
I see on the upstream git repo
https://git.kernel.org/pub/scm/network/ethtool/ethtool.git,
that there is not much movement. Probably I'm looking at the wrong place?

Kr,

Thomas
