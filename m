Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4550ED00
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiDYX6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238826AbiDYX6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:58:09 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC1110544;
        Mon, 25 Apr 2022 16:54:52 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id i186so15926109vsc.9;
        Mon, 25 Apr 2022 16:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ygHRAcXKSNnyDR6Da7gfgj/tiRifZ/4RyPSCU5nFBfE=;
        b=EXXo3fcXzzjHxHCXs8G2z+U2Cojz2xs85qnpdjjLo8lEqXFgz544jGAyEt584fnNGw
         FewStZutiFSNM/SoMmAWTdSljXfZuO5g93Cpp9HshLF8brJ+dXvFVOjxRV2WcecBLVgF
         1i7J9ba0aMDte3tzPUi3VTqCbOGmkaT4pW79IeEeva+HjhhVcUQKXQp2se1WUqW2OHoM
         OP+xwzTYn0bU5kYDfquBvXVtlE1sgD7lDkdZnie/QUNpb9NAT+SkD/0Hmjtpe/mCq0A+
         cjwwuHf6PYTV+C6S5LwpMFy0jROven0mhY7q8U+R1JKK3TkSkSFoa9+TF2ykG3UPYSe2
         XMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ygHRAcXKSNnyDR6Da7gfgj/tiRifZ/4RyPSCU5nFBfE=;
        b=wKuiGC70WPFjisTo1RwugCf6QxtLttfChKc7sxN7GGNaxc9SBle/6rfyfcew3Qtdhk
         S2baKIt0onY9CMA0lr8JxbbIjuYG5/sfE43B25+tMM3GK4rr4m/6TCZz6UcYp0BGPOwv
         nHtz46h3UHSoXCrwVY/njfZBZtLKJ0tPcpKZejOyp1QPj8fgIhbBkJfpmfi8fCKL4ZU3
         LaeheS5PwlCxJQI/sJHY5UKxeiH/illqL5Q8mp6uHweOsyHxS7sGe2wAWSbxlXmHQIV1
         45h4d84P8VfhHfPFZrMogbReX1a96+uE1pJZzrRwHDUA1wTMmGSg5KN81cl5gi1nv3JJ
         mcag==
X-Gm-Message-State: AOAM530c0MhfZZDeLxZVBKtQb+H5nNxrb6ghCR4DRHSa5BONZxygomZA
        /UvTUQb6gBD5hENpQ6B05SlMhTvouBNYVOkAsd4=
X-Google-Smtp-Source: ABdhPJz/UbJ4DISisYHY5rZazBDHI/k03rsoomysS1VUejzx5aa0lg121O7tB/n9J25+ozzetlyeuutLjj0ar08bHIU=
X-Received: by 2002:a05:6102:158c:b0:32a:4a6a:318c with SMTP id
 g12-20020a056102158c00b0032a4a6a318cmr5421422vsv.39.1650930892174; Mon, 25
 Apr 2022 16:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-8-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220407223629.21487-8-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 02:54:51 +0300
Message-ID: <CAHNKnsSEeEwi8R1wYHycDmZ8LS90outAvKpxTfSEk+Dz9cvxfA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 07/13] net: wwan: t7xx: Data path HW layer
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
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

On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Data Path Modem AP Interface (DPMAIF) HW layer provides HW abstraction
> for the upper layer (DPMAIF HIF). It implements functions to do the HW
> configuration, TX/RX control and interrupt handling.
>
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>
> From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
