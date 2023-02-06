Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FE868BA98
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBFKnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjBFKnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:43:12 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BA6F74E
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:43:01 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ee13so4563787edb.5
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 02:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Wpsskz2SivsZUco1t0YKV2a7AFik8RIi9dnXkHdD6Ac=;
        b=TTvdJtBfQkvM1+vpVQEGvstlcfywKZ74hDPtkVS5dI5gwhhZidofqxk4ZmYDw2tyr4
         te9ooXqJrBtXQQaJ3R22sXYAPYYHlCiQmJ1dWXF1mgIn4NbfZII5Ac0WlwWaX3fn1AMC
         ktrcdjuQkLp3jJGSyPu0BZnqV1UMCKIVo/zSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wpsskz2SivsZUco1t0YKV2a7AFik8RIi9dnXkHdD6Ac=;
        b=4Iy3s2crt9oPdh6g3pntvMRKqms9hUq/K+NZUn9yQddUBiHPGMfGBdR5Dr/OiLbELx
         h2q0Uia/4MmpKdpPT1MvAnQjptk6670nAOdURTKP3twdGj6H2wYOdG2V9k8ymgHQ0vLA
         QuSwI+3MxzDy2e4kOCOH6/08gGz83wpneTRL9ncEI5tV2xTg7qP7yCkkDG5OZjKh2pa8
         3sGaM5JNMYvEWNUSAwCJuxcEQut7h8gQr2Pw5YJWqkPqQfvkpE4FnoSmRDSNJVfhF5dW
         MmDtYV5A0I155qxVoc+Qj7kjLj/3uH4D8E4D8HxdMVUM47QdqnlM78zCNZRzFtQtBuBp
         iX3w==
X-Gm-Message-State: AO0yUKVhmBUL0xBnadGZf9DpOGIrRQ/XW+9Ze26ABnI+XlikCMgIRx94
        A3G2CwanxEnGSIPtr8K9ejJJuOyzCW71ybKc
X-Google-Smtp-Source: AK7set8vKo0zWX9ohUqQn+N7TVtgDAfvsoZTaWL85q1ATN6sNV1LGZA4tb1afQKLQtf/PKGrHbkfuw==
X-Received: by 2002:a50:f69d:0:b0:4aa:a4ea:cdc9 with SMTP id d29-20020a50f69d000000b004aaa4eacdc9mr8341562edn.16.1675680179388;
        Mon, 06 Feb 2023 02:42:59 -0800 (PST)
Received: from cloudflare.com (79.191.53.204.ipv4.supernova.orange.pl. [79.191.53.204])
        by smtp.gmail.com with ESMTPSA id ac5-20020a170907344500b0088f92a2639fsm5055762ejc.17.2023.02.06.02.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 02:42:58 -0800 (PST)
References: <20230201123634.284689-1-jakub@cloudflare.com>
 <d6682d52-25b3-a79f-c4db-6d720986b273@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alejandro Colomar <alx.manpages@gmail.com>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH] ip.7: Document IP_LOCAL_PORT_RANGE socket option
Date:   Mon, 06 Feb 2023 11:42:14 +0100
In-reply-to: <d6682d52-25b3-a79f-c4db-6d720986b273@gmail.com>
Message-ID: <87mt5rjcr2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 02:16 PM +01, Alejandro Colomar wrote:
> [[PGP Signed Part:Undecided]]
> Hi Jakub,
>
> On 2/1/23 13:36, Jakub Sitnicki wrote:
>> Linux commit 91d0b78c5177 ("inet: Add IP_LOCAL_PORT_RANGE socket option")
>> introduced a new socket option available for AF_INET and AF_INET6 sockets.
>> Option will be available starting from Linux 6.3. Document it.
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>> Submitting this man page update as the author of the feature.
>> We did a technical review of the man page text together with the code [1].
>
> The formatting LGTM.  Could you please resend when it arrives to Linus's tree?

Thanks for the review, Alex. Will do.

-Jakub
