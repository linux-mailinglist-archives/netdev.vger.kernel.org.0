Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4400750E8AE
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 20:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244511AbiDYSvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 14:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244534AbiDYSv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 14:51:29 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40A57DE11;
        Mon, 25 Apr 2022 11:48:24 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id l203so7278942oif.0;
        Mon, 25 Apr 2022 11:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E7+qqJB63mXfv1I9ZyZ82CdaTtl77oA8ve2t/8awZD0=;
        b=1oUmDJ9NvxFP6zRJ7UOSirFJ9EPpfQGuz34FAEfLJ2VjoeHCQNpQiEgg4GOuCIzf3g
         73R4jKWox1hL7AG3Aj4v/okG68Oyg0MAf4Kts3chEbMxw2UAFm96eN09L8JExrjgI8ne
         g7A3rfzNFI30K7GZAtD1jHOm65vb27pqH9FqTPgi6Kj326aNq42id39T2mJGbP9bpmCY
         nNyDvQVPUc9GVdNuNmB1/9FZjEi8pKGg1D7gS3bErjvemQV3qycDSpH8CxyvpDhk8rTa
         yNvBC2NsCK8x4Yff5d1Z+xgX2Dc2OnxA1oAKv/txxvioCPqE6yPaodJF0AgrJuhcdNaa
         xgxw==
X-Gm-Message-State: AOAM532rmE0wR0yuKR8yO8lZTMW9ZZ0iDKqmF0QcdkFHo//iH/wG/Ulh
        ZzU3BVczoS6nPuG2cflqdw==
X-Google-Smtp-Source: ABdhPJy91WJP08hAy2BugOgNRO26g8C6EPpxyxgWgE6Zb3IHFmkpckdknpdi5T+rLoNswplT46NBqQ==
X-Received: by 2002:a05:6808:13cd:b0:322:95c8:9e7b with SMTP id d13-20020a05680813cd00b0032295c89e7bmr9173632oiw.67.1650912504024;
        Mon, 25 Apr 2022 11:48:24 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t22-20020a4a8256000000b003332a0402f5sm4690305oog.23.2022.04.25.11.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 11:48:23 -0700 (PDT)
Received: (nullmailer pid 45348 invoked by uid 1000);
        Mon, 25 Apr 2022 18:48:22 -0000
Date:   Mon, 25 Apr 2022 13:48:22 -0500
From:   Rob Herring <robh@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        alsi@bang-olufsen.dk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, krzk+dt@kernel.org,
        arinc.unal@arinc9.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Message-ID: <Ymbs9ri8JJXTM8XO@robh.at.kernel.org>
References: <20220418233558.13541-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418233558.13541-1-luizluca@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 08:35:57PM -0300, Luiz Angelo Daros de Luca wrote:
> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.

The power supplies needing power before you can actually read the ID
registers are the same for all the variations?

The RTL8366s has a serdes power supply while the RTL8370 does not. Maybe 
that doesn't matter as the PHYs probably don't need power to access 
registers, but I didn't look at more than 2 datasheets. If there's *any* 
differences in power sequencing then you need specific compatibles.

Rob
