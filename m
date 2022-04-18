Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2628F50601E
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiDRXSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiDRXSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:18:01 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2A9DFAB
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:15:17 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 203so2542623pgb.3
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RrhfhZGPffquYLME6QtUqceBp8LFNUZRkEv6wy05wTc=;
        b=nItNq4Yd5giPB5S6Ajzna4fYFp6zt9eLWcttB/afck8bhHFfKUsvZ93i6NMSuJtxYQ
         GnynQOqxUbKbyF+trgO/PqHskrDiWLS2a853vpdxRqX7Dl2TsN6gKso/XDxU6f4c7AJ6
         qfGYA5clU/qHmrzBA8QWWD35kA5gSFF30CWH4fIf7G4K5Js3hl6I8ksu9qJ1xNtSsVJL
         y2BASiSr5C5wahDdSrolLbmDsA5kRlk0JN1EvOXy838xvWURzO81rTcUIelw96jaDlLN
         wZzWfUWqS1I3XQa0qAiMP+aqnTwWAYnbJ0d78n4sVFc5vjOpjhYmtPcmqpmsdiWK4c+n
         z83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RrhfhZGPffquYLME6QtUqceBp8LFNUZRkEv6wy05wTc=;
        b=fHFMQS/epf5uDhpZd4TAKbla4W3Y9UIryGdBtBt/O/yFKXgKxn4zKQZiNsUFcTDxbb
         jgBKJ3jx/9q0ZOWPSfAVjPysui5hDyLtVlO8eQtZucUJ5lc8d0KId6NKDavNB5Xd7v+C
         2EXrpNnLywHQbzUiostnyTESmiBV7Vhkos36k6zUe9m/UOGRryeXQQBiLIqFx/GBm74j
         ZNUCGKLaxln3YlOC42JFdeAiTGg8FgpI1FtSYiZ/BIajlG/tH1T3nMSVtcjzXkd169k4
         fbeemUPcMQKS5ojG78pSkkoTTkdt5GPNHKzEg41EXPrNYBNuJ7FmS204JxL+4QBmptpt
         aSdA==
X-Gm-Message-State: AOAM531oVX6hD/CLyQ30uBVnpQRsSQCJTAZhsJ+l+/i5gQPyHLmNVC6b
        w0LyKGXmk/tg4G1NMrwQCrY8aw==
X-Google-Smtp-Source: ABdhPJwOQWZk9I23o5Zm0FgWRr1Yu6DLBN/QZsdzy7YRIiuEuR3Ngft5iOEC6pqC8efsMPrX2UGGFQ==
X-Received: by 2002:a63:5317:0:b0:399:58e9:882b with SMTP id h23-20020a635317000000b0039958e9882bmr12033784pgb.306.1650323716994;
        Mon, 18 Apr 2022 16:15:16 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id y26-20020a056a00181a00b004fe3a6f02cesm14639781pfa.85.2022.04.18.16.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:15:16 -0700 (PDT)
Date:   Mon, 18 Apr 2022 16:15:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baligh Gasmi <gasmibal@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v2] ip/iplink_virt_wifi: add support for virt_wifi
Message-ID: <20220418161513.1448e5f9@hermes.local>
In-Reply-To: <20220418221854.1827-1-gasmibal@gmail.com>
References: <20220418080642.4093224e@hermes.local>
        <20220418221854.1827-1-gasmibal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Apr 2022 00:18:54 +0200
Baligh Gasmi <gasmibal@gmail.com> wrote:

> +/*
> + * iplink_virt_wifi.c	A fake implementation of cfg80211_ops that can be tacked
> + *                      on to an ethernet net_device to make it appear as a
> + *                      wireless connection.
> + *
> + * Authors:            Baligh Gasmi <gasmibal@gmail.com>
> + *
> + * SPDX-License-Identifier: GPL-2.0
> + */

The SPDX License Id must be first line of the file.
