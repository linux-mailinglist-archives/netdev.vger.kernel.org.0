Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFF84E3D5B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 12:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiCVLT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiCVLT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:19:57 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7385326DB
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 04:18:30 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2e5e176e1b6so109025067b3.13
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 04:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i4zySE/4GVxvhF45QrVT3jTv3VJ/uoCxXdSiF+zWeLI=;
        b=n7PC3rzS4wYCg7qF/JlbCfR38nJgvgIti1Ad09tfhJyVqIe5P761wlPUgTbgC+aaCS
         W68t4Moaklc+tJq91xpcJCiSPjKqmjTnYWWCfmp8nkQ/VtsWfvdg1SE9q3kNOGnUarAg
         BX6jIvzDFaSGSqNIXpxwPcFrPrB2xBJgihVeHIE7D6MXfWYMVqeNMNsigbzgKNyShAVm
         xgFB63Aylg+70B78ESryKTIgB2VYn1LP51lYfGj0Nw4Ese2syk1Zlxa+HqAgYHNO4pES
         hZiFp3sOh0/hKkM0MGF7gHL0bP1X/MYdNYnIYvqc4dzzFAsWH11hDpzpkZNjnjOQQG8i
         ZaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i4zySE/4GVxvhF45QrVT3jTv3VJ/uoCxXdSiF+zWeLI=;
        b=72aqGkEqYhVKLajWP1fT281xcNnnRX9slYYi6XSvOp7H6kvduqhEuL0Qg9xUZBIQH1
         932QtdfcrT5rsxb9plmIMyOxcvF3I5qonLJEMdsx4ZgYoDse4+GYh/UrNCKLs1RYxp1o
         YkA2to5eYrPyEegbhtawQBnDoMG6zGugg8ac75vMQQjXsDhtoFmIJlp2I4zZSNvGsPHM
         E4hWUJcCf8rPsSA+AxTUeYQg+0a+Q8Iyme6FqU77yXastJNTdA4Am0wTA/qLCO29I96Y
         w/qd8N3EXMV8dh8ASDQIqphg6ppx0IYfaEM/b5uocBPHcGakqD3x3zv9V+eKfLckLcA/
         Za0A==
X-Gm-Message-State: AOAM531l0yVvMDyQJ+SA5zK6wTFANjf8yNdVZkMkoGwi7rHj0/cmgfQd
        ZYmsH2IRB83t0WVRA984KSuMhH1NXVZ2rRRUCS2Pzg==
X-Google-Smtp-Source: ABdhPJwN9g00xxnsdElMUfe6BgmNxK3gamstMhCnqHhbmQujBH7aTYnOHgVn2ng0a37HA0+CdTsFddT9lTyUtNN62OM=
X-Received: by 2002:a81:784b:0:b0:2e5:9f35:a90f with SMTP id
 t72-20020a81784b000000b002e59f35a90fmr29094296ywc.278.1647947909388; Tue, 22
 Mar 2022 04:18:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220322051053.1883186-1-kuba@kernel.org>
In-Reply-To: <20220322051053.1883186-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Mar 2022 04:18:18 -0700
Message-ID: <CANn89iJUZeUaFAROBH+icRNXDW+F5+dNineRtAa9+fuvAKiRFg@mail.gmail.com>
Subject: Re: [PATCH net-next] netdevice: add missing dm_private kdoc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 10:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Building htmldocs complains:
>   include/linux/netdevice.h:2295: warning: Function parameter or member 'dm_private' not described in 'net_device'
>
> Fixes: b26ef81c46ed ("drop_monitor: remove quadratic behavior")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Oh right, I think one bot complained about this, thanks !
Reviewed-by: Eric Dumazet <edumazet@google.com>
