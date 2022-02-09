Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175924AFF6C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiBIVsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:48:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiBIVr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:47:57 -0500
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D135DF28AD4;
        Wed,  9 Feb 2022 13:47:59 -0800 (PST)
Received: by mail-oi1-f178.google.com with SMTP id ay7so3946947oib.8;
        Wed, 09 Feb 2022 13:47:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kGhpnlTbtjYsSq5zazJhFiflsCrF3KnRdsz6OiouwQI=;
        b=qamdzFMud5U9X6Dh77p2qVmFHBbrbG/ER9S6KqlKMHeR0MNqurKVMROqexQf+kgO/c
         yAvim34/YW2Ufteo5NjJWe+l7+duN3Y/FBpjOdsQHgqqIIh7PtLgHZmsj+5Wiuz8bvyK
         2xH1ElYu8L7ZOtO9eXE3O28sgfceL4SfDqNb2QHSZMEbw7xoTemWKymTs3QxOwllKHlu
         zTQ4z2qbMAJGdcBiPca1pTwszQx0keIfg6CKPATfT+0qzdz9+QGMNF7kODc0jy2peSLb
         /tRuyg+2H3nM61d8PrYrtZh29O770O1KecqNJXQg+2Y9RHrdVxbyKy7egXPxb667LW9K
         rpdA==
X-Gm-Message-State: AOAM531DLmSSGYfft3JP46BoAXYOUumN4c5RrU+8qq7Wo5Pk+FrmKsgY
        nDxasUlz4cW6jy5pLyz5tw==
X-Google-Smtp-Source: ABdhPJwR4IULQkZYDWpmYiVNM6/vuOdPEw5tt9Mv3+Z+92V+CtzPO1gVjBgSpEoPjs579T2nPQK4Mw==
X-Received: by 2002:a05:6808:1304:: with SMTP id y4mr2082906oiv.29.1644443278920;
        Wed, 09 Feb 2022 13:47:58 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bc36sm7314731oob.45.2022.02.09.13.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:47:58 -0800 (PST)
Received: (nullmailer pid 981849 invoked by uid 1000);
        Wed, 09 Feb 2022 21:47:57 -0000
Date:   Wed, 9 Feb 2022 15:47:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     linux-arm-kernel@lists.infradead.org, kuba@kernel.org,
        robh+dt@kernel.org, linus.walleij@linaro.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        ulli.kroll@googlemail.com
Subject: Re: [PATCH v2] dt-bindings: net: convert net/cortina,gemini-ethernet
 to yaml
Message-ID: <YgQ2jTOI96In6tAs@robh.at.kernel.org>
References: <20220201144940.2488782-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201144940.2488782-1-clabbe@baylibre.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Feb 2022 14:49:40 +0000, Corentin Labbe wrote:
> Converts net/cortina,gemini-ethernet.txt to yaml
> This permits to detect some missing properties like interrupts
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Change since v1:
> - fixed report done by Rob's bot
>  .../bindings/net/cortina,gemini-ethernet.txt  |  92 ------------
>  .../bindings/net/cortina,gemini-ethernet.yaml | 137 ++++++++++++++++++
>  2 files changed, 137 insertions(+), 92 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> 

Applied, thanks!
