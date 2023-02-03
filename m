Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67A05688FA1
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 07:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjBCGX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 01:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjBCGX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 01:23:56 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31CA51C6F
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 22:23:55 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id j7so4346244vsl.11
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 22:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=87XVyWNqDZs7OnynGfVzLfoOyWepgm8p9Mf1bGJRDhA=;
        b=R+yrD6SZeW3NvQBjviyOyHYp6ou3qyz5Ef+Q1DOKtEcnv5KLX2fJ8IYoW2fAiLuwvn
         M8HpKfYkv6EDwINyv1bjkZVZrUvV6BvZ+S20c8cqG7VvhYupNPsggSIZWCsRApY9lkCi
         ijuc4soU+v7kDYz8Q5eQSBHNJw0OTeMtcIRRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=87XVyWNqDZs7OnynGfVzLfoOyWepgm8p9Mf1bGJRDhA=;
        b=oj+4/Ybsw6AUpflEa+PRsWCcFSAO3qUuqRfXtNToCsgZIpCNh8wfkhkNtD2b6tjMpi
         roF7TsAW/7TlHVERUifvtyz1yMjV7kZf0nFtjsypCvEjR1WQij1TrEmslNlgm470gGbb
         trjU58BBue54sESicoS8JZQxrtKCJ/jqYWWoKrwVzAJlDHEQ5ikoAYL5ppB6P/BV+xAD
         XFKUuIYREeoW37kOs7hDtZ898HHgnMtdE/99VbdcZbg0Maq08zMY6ljNGKDg5Ggba0L3
         bPKPDN0SnfbEfP0UuMIpiZz0kmEbTpaUUCKDfmvE4PqS0W08uSDeSz/sucwXPuYoOv4t
         zuKA==
X-Gm-Message-State: AO0yUKXD+FCMveS9GcEcVBeAVWPyt7+lAqLxh93feHCu1vku0ONUkUT9
        pmXyOM/vPIbOwFGbSikQRi2494kaw5Gmxry7HYqGtg==
X-Google-Smtp-Source: AK7set8tKApF3KpW1F9+oUsByrETerJjqd7LwwHR/1bzmqGkRDHXiULZXnQLIlhRK3pyp8ur/uPZ2RsN4nlsQmw4Zls=
X-Received: by 2002:a05:6102:23f2:b0:3ed:89c7:4bd2 with SMTP id
 p18-20020a05610223f200b003ed89c74bd2mr1649078vsc.26.1675405434514; Thu, 02
 Feb 2023 22:23:54 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 14:23:43 +0800
Message-ID: <CAGXv+5F-4Tyf1Yn7BYYMkPVyRQffEpx709F6+T65M1J+LfUPvg@mail.gmail.com>
Subject: Re: [PATCH v5 00/19] MediaTek MT8188 clock support
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:49 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Base on tag: next-20230119, linux-next/master

There are some recent changes to the MediaTek clk driver library
that makes this series incompatible. Could you rebase onto next-202302xx
and send a new version?

Thanks
