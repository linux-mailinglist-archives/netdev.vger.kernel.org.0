Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86591582833
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiG0OFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiG0OFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:05:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F31CDED3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:05:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o14-20020a17090a4b4e00b001f2f2b61be5so2221128pjl.4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5QpkZo7bMURdJaAczFVda56NOl19v0PL506fYfIlKCE=;
        b=IdM0wPuF0cHXmOK9yNblwUoBNCNNv9Hb+s1EM2KCS1ajWF02Nj+QqgxuyznlI4TEq1
         d/zWujrduGZF8hD8m+SL8kkValc+AzuICi8Kgz7Qzjq9OVG43Ilwwo/Cr4uxG3xtukiY
         5cnxlEQfisK6kh24Y2oL8RTgAb3LDU82Fd3o3G86K4oWItPNQti4GBs1FWJ/oWj1cmSg
         AJi43ZOSPd8gLvzYlnHhWNAhqQsssdZN0ksRNI17zCLe07MQx9GfmT1aH5KYXkRK7VpG
         2SxESm1LM3nqxi4Ch4Zb9LiS8LriiVhLoOtEBC9/7VvQK6YOVK/oGZdLsxoVKRSZlYQk
         8jEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5QpkZo7bMURdJaAczFVda56NOl19v0PL506fYfIlKCE=;
        b=LKV34OtMWazbka40wchK5tqXglo/ZTbflFmc0mvDMnzMmKgO7DEmaO8KkHyy3Z5/Ni
         JYSCBbwVp0Ise+vpOcHQsaa0VlRHXR6KpFh8g3eFtvzT3qHhXAWL0UpUQP5doSubBUTe
         UEAFoYqw4uNargf6qOHl/a9W5uzNaKZpbL6B1gT/LT1IZvAiowUvfWTXQnGXJp0CFeZL
         CUy3RotU4uWzYd/eIULd6mzjQSnP5hSakd/wFGaGRgFIg9DXfWY/cjfyACuEfjnWPFhF
         MmD/U+AOVDOE94FNFM6aYXXRRWiIy0rQTgQ2dWParu3lVEoDHlEOpqHI+PLBjnXvY0Ha
         gxRw==
X-Gm-Message-State: AJIora9HSHvFB/mN8yViEtn2AbeppzZXJKmTsLKEXg5+sowCzqA7xUr1
        SyldKk4g4oxfLl+5icz3a3F9WGKDUOM=
X-Google-Smtp-Source: AGRyM1v+V4iMl5tOU+kjya/U+sPvQ82BqbZ22bXl1DKaiaZ9IUZDwpnUNMNeswQvhmGMdjuhKhKnDw==
X-Received: by 2002:a17:902:d54c:b0:16d:9d52:2cb1 with SMTP id z12-20020a170902d54c00b0016d9d522cb1mr7857652plf.29.1658930746766;
        Wed, 27 Jul 2022 07:05:46 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u3-20020a626003000000b005289eafbd08sm14401778pfb.18.2022.07.27.07.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:05:46 -0700 (PDT)
Date:   Wed, 27 Jul 2022 07:05:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and
 newer ASICs
Message-ID: <YuFGN/WBzVgae/cf@hoboy.vegasvil.org>
References: <20220727062328.3134613-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 09:23:19AM +0300, Ido Schimmel wrote:

> Spectrum-2 and newer ASICs essentially implement a transparent clock
> between all the switch ports, including the CPU port. The hardware will
> generate the UTC time stamp for transmitted / received packets at the

The PTP time scale is TAI, not UTC.

> CPU port, but will compensate for forwarding delays in the ASIC by
> adjusting the correction field in the PTP header (for PTP events) at the
> ingress and egress ports.

If the switch adjusts this automatcally, then the time scale in use is
not relevant.

Thanks,
Richard

