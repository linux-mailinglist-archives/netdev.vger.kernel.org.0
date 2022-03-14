Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB904D887C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242082AbiCNPuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiCNPuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:50:02 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9866AE0CB
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:48:51 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id s25so27912345lfs.10
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=e9566eTgfgXWmgUeIx+yHGN7mWBBZcZfrgoY/7dO93E=;
        b=UZN4O8f0hMBlj5iHoKRUbwbQkXFrZY1y4uKcFVayUB/Rses4NGGTvl+0nXXWNyeibL
         yVps3W314XQah3EKsQ8dxt43Lp6W+1US3zTrchNemK3qpNYuQ0lIhUF01jchAbk0BuXV
         oRpLaatqRDpBGcdZWZXiLMrb+8wv5FuR5J2paogq097vIXbtbIZbm7G5GlDarhNyOpIm
         dQbq27Fw4tRDR1lOF0v/z7UAuX28+YaWtizKcvdKHQLmeucW810twl511jWVGAnIl+NW
         81gIBXpg65BNAMdRU5e79IRdZ1rQxcQJ5G7DpByW3AWpNbFUe+KAEnmP0+z6Njom5EDA
         avgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=e9566eTgfgXWmgUeIx+yHGN7mWBBZcZfrgoY/7dO93E=;
        b=bsD3ZXwPlNOd9j9lK33YcgQZvGxA+JVfMP/Lcrrj96n/nQ7Wzz+UPSKxt22s9ozG35
         LzoHL0rZ4IfbUm5bcpLVP9k4NQElQ5mD+bCWYoqN8XkJ9RwHxGU86RH/F70OJY4amz1S
         YRSBfzrcy7HJylvYc6H9Yh4sUcLTXT/6y2AigUCxLwL/j+EcyR6hUzpradnRa8VYDrQl
         EDbWwkwOTnC5b9udoZDJg1wVcTEZE6Ovz1xxzn8M9+Em/Wx10pMeYoyyxEyt/SrwYfI+
         r/RxUfO5uwQX0lRDJsIKDSvzFRvHt1+etBPn6d2Sw8DX2+iUfc9X8Pb1vbpl0dRb6o5q
         lmhg==
X-Gm-Message-State: AOAM5301FxksChfM0HQt7N4cznB4ZsD9uDRRPeuw/YrRNWj2L5POWXS4
        BsWxrALHEw65LtHra4ZYTTxuhQ==
X-Google-Smtp-Source: ABdhPJxJfqLB0IXY4R25x+2N8FZryvRsFr7ZQjUdO0Pe0dPpEZJ3r0KMa6ZYepQH3fvmUsUFFG+uzA==
X-Received: by 2002:a05:6512:3e29:b0:447:9cad:6a46 with SMTP id i41-20020a0565123e2900b004479cad6a46mr9910118lfv.188.1647272928330;
        Mon, 14 Mar 2022 08:48:48 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id x33-20020a0565123fa100b00443d3cffd89sm3316086lfa.210.2022.03.14.08.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 08:48:47 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marek =?utf-8?Q?Beh=C3=BAn?= <kabel@kernel.org>,
        Jan =?utf-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
In-Reply-To: <20220314153410.31744-1-kabel@kernel.org>
References: <20220314153410.31744-1-kabel@kernel.org>
Date:   Mon, 14 Mar 2022 16:48:47 +0100
Message-ID: <87tuc0lelc.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 16:34, Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> Fix a data structure breaking / NULL-pointer dereference in
> dsa_switch_bridge_leave().
>
> When a DSA port leaves a bridge, dsa_switch_bridge_leave() is called by
> notifier for every DSA switch that contains ports that are in the
> bridge.
>
> But the part of the code that unsets vlan_filtering expects that the ds
> argument refers to the same switch that contains the leaving port.
>
> This leads to various problems, including a NULL pointer dereference,
> which was observed on Turris MOX with 2 switches (one with 8 user ports
> and another with 4 user ports).
>
> Thus we need to move the vlan_filtering change code to the non-crosschip
> branch.
>
> Fixes: d371b7c92d190 ("net: dsa: Unset vlan_filtering when ports leave th=
e bridge")
> Reported-by: Jan B=C4=9Bt=C3=ADk <hagrid@svine.us>
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> ---

Hi Marek,

I ran into the same issue a while back and fixed it (or at least thought
I did) in 108dc8741c20. Has that been applied to your tree? Maybe I
missed some tag that caused it to not be back-ported?
