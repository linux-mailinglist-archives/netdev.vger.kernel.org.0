Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A6D660E9B
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 13:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjAGMOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 07:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjAGMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 07:14:47 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2642F5C93E;
        Sat,  7 Jan 2023 04:14:46 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g25-20020a7bc4d9000000b003d97c8d4941so5311625wmk.4;
        Sat, 07 Jan 2023 04:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=exh5jhWBBK17Ph+CgJeghRyiOswfcgQCDbeTM4nzuso=;
        b=qNyf3HCSTkCM2x51VV2Cu+6OyAqRfd3jq35pM1Vfsm6rY9XiBPdBC19GjNMmyH+5Ac
         KveKhsFbTtt0aLipgmXmkd1KYHATxwb5Y+Yy4n6P5LtmnqydS3mSKNTnwZa0JPVezlLK
         cJhnUkNNunEbsezDZehWHy2KR1Fgshy/NnetM18edQqr7sruoBq+4zxdzVHJv7FOVYpx
         I7ZwyGGcYuaL+zZx4C1mS0bAWd12tOy3It0EolG+fIFfrFZPcM7PkHOJKCUFp+H0OIuT
         iW4T667dq+pFqkLJaeWAt+slyrQd16MQjDAzZrp9W+GA4R3MLCqrdrlh7+KSA+UqXlVJ
         byPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=exh5jhWBBK17Ph+CgJeghRyiOswfcgQCDbeTM4nzuso=;
        b=cci1SgEZHsRU25kW9ohgxTiLvoTpDs+2HEJBlwoTrEFQ+2Hl79gUsFevJ/eSEuujdf
         qojrwTHdMS113wYGcvR+jT8vVMO/LA5vTXP9xk8pmShSI0M0hvCi2njARw5lhUUnIf+Q
         rPugtvpKBYos1D/dO0VlGqSL3xgpipseu3cL2co2CuXzi4x6J8aCZcsaNNwpA4J07zPW
         BJXM4kAGfSqtBaMbKk4EOJy1iuIBQjSCfBmSa+fQOx5iNzgQfzGQSz/Cv/y++9jTD2Kc
         dw95j3iE34oGzkQl9Ep/ashYJhNojeDg+kjfogkCUUFQ2wvvAYX05w/HIhFNwevmKtP9
         09Gw==
X-Gm-Message-State: AFqh2kpImrBmKHB9Gy3MokH+7sIzzFhQotVD9d2d6Oo67oZjVy+CbYPj
        2Is2q4zUjd/l8IyX/KtlkfTNJtahGjz+8n4lPoQNSKmy
X-Google-Smtp-Source: AMrXdXuztG0SNmH495gPDbzRStX/IndQDUj9OP9rAgDAGEkVoZow/doVDExFB34qKIecc3mpSz3O88mTcRxeBil0l94=
X-Received: by 2002:a05:600c:4b1b:b0:3b4:a6c4:70fb with SMTP id
 i27-20020a05600c4b1b00b003b4a6c470fbmr2999894wmp.79.1673093684612; Sat, 07
 Jan 2023 04:14:44 -0800 (PST)
MIME-Version: 1.0
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com> <20230106220020.1820147-8-anirudh.venkataramanan@intel.com>
In-Reply-To: <20230106220020.1820147-8-anirudh.venkataramanan@intel.com>
From:   Anatoly Pugachev <matorola@gmail.com>
Date:   Sat, 7 Jan 2023 15:14:33 +0300
Message-ID: <CADxRZqwkv=FyzyMvPf_Ou3nMQWOZ1jmAwOT22=9tigVVWfB3Gg@mail.gmail.com>
Subject: Re: [PATCH net-next 7/7] sparc: configs: Remove references to
 CONFIG_SUNVNET and CONFIG_LDMVSW
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 7, 2023 at 1:00 AM Anirudh Venkataramanan
<anirudh.venkataramanan@intel.com> wrote:
>
> An earlier patch removed the Sun LDOM vswitch and sunvnet drivers. Remove
> references to CONFIG_SUNVNET and CONFIG_LDMVSW from the sparc64 defconfig.
>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> ---
>  arch/sparc/configs/sparc64_defconfig | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
> index 1809909..a2c76e8 100644
> --- a/arch/sparc/configs/sparc64_defconfig
> +++ b/arch/sparc/configs/sparc64_defconfig
> @@ -95,8 +95,6 @@ CONFIG_MII=m
>  CONFIG_SUNLANCE=m
>  CONFIG_HAPPYMEAL=y
>  CONFIG_SUNGEM=m
> -CONFIG_SUNVNET=m
> -CONFIG_LDMVSW=m
>  CONFIG_NET_PCI=y
>  CONFIG_E1000=m
>  CONFIG_E1000E=m

I wonder what is the reason for removing the perfectly working sunvnet
driver which is used in LDOMs under sun hardware hypervisor?
Can we please not remove drivers which are actually used? Or either
drop sparc32/sparc64 (whole arch) from linux kernel as well. Thanks.
