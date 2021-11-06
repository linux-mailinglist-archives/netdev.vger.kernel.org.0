Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D993F446FAB
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhKFSCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhKFSCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:02:47 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A577C061570;
        Sat,  6 Nov 2021 11:00:06 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id v3so23257329uam.10;
        Sat, 06 Nov 2021 11:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2XfxNRZgR4DiadXacP1AebZVGAP3mlK1UDvz8JbFrc=;
        b=ZNVMlILcAi1dKpydgkz1JPgGumaHBhEq9YGnQ5TbrCfU3eH/NOknskdSrvpjxbxWPZ
         nuB6s/IuUngRVFdOrHddFOFu62JLo2EnmdXn/ixzsacTesiwInH5PPB6gM9l98gCAlh2
         zr6syMNAiKxUUOQPsNEP5bnxVoy1rcuIOlHO2jh6GNfIshZF/wpjbyYWfewSG0lN0Nsl
         woF4BRSkgqpiQnDib3GgOSU4GI/VVdtjBneOYjlrlPjA00ZPq2SXF7dykPW/MmoFWXTA
         ncwLeMNES51zNMn30BI/BL7ZPcV5S+xWopxnPhhSbc3CP0mZIffUWyEIfUq8Mv5KI+CJ
         Zluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2XfxNRZgR4DiadXacP1AebZVGAP3mlK1UDvz8JbFrc=;
        b=eg3qABL84uUXhYHVY88DX6U4rDiyadB62A4Nuc7KmuQgpvmvv0/rdPzm1HWiI+CYsk
         vvHnJ6RSY2jEcv1Ddit6OFFZy5bnLB9+5pVG98foNfVM391eGtACUfaagXU1zk06qVCS
         iQL/xCTDel1lvGUac07abO756Vcf4pu4+G+46RWGOwHXzV20NNfu5BVr1/+NA8/4xGT8
         uNIwtHtNg8TV8FkFkOWlXaguvNGlhOOMZy3qkuHdgvX72G7eT4+GuwvlJxHgM/28ynfI
         /2/4H55DwHroozqTSXPcstjY1zxgb27CV1cO8qwWYj4OFUX0W/Sr3j2zp9sCna7CA+z9
         EcSQ==
X-Gm-Message-State: AOAM532Kh8ezhM97FLzwx7R2vClO0ymXXzQy0FAC3iHKt59v33fyQ66x
        Z5y3LeHIHvJwHCQnjLVcWgrVwvj7CoXTt5G7SvQ=
X-Google-Smtp-Source: ABdhPJw0Vk3zsMtsuF9egnB8AZNYXWkYOmpdM17DWb7fQqDj7RqKH9kKpam412QKzgEEUn3Vs08udiAMLTVi3JG99QA=
X-Received: by 2002:ab0:780c:: with SMTP id x12mr72342855uaq.45.1636221605274;
 Sat, 06 Nov 2021 11:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-2-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-2-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:01:08 +0300
Message-ID: <CAHNKnsQg1rgiJHG-O9H5i9D8PGOpO5zdLKZQ-ynHE6xzjwj1WQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/14] net: wwan: Add default MTU size
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Add a default MTU size definition that new WWAN drivers can refer to.

[skipped]

> +/*
> + * Default WWAN interface MTU value
> + */
> +#define WWAN_DEFAULT_MTU       1500

Why do you need another one macro for the 1500 bytes default MTU?
Consider using ETH_DATA_LEN macro.

--
Sergey
