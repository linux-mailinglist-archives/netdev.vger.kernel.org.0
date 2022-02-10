Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E34B1963
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345615AbiBJXV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:21:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345604AbiBJXVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:21:55 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBA25F59
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:21:55 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id bt13so20067933ybb.2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oho4kHg5TtY+NZGrMmgq2oNnvWnJbxZawxp34xcMT7Q=;
        b=clov2gzoIlc79y8hpdLd82HJmwA09KLVNdSCCKySSICYtCBiKefZXWypdPpEQxeMEE
         IVvNdooFX5Wif0q47VPEvGuihqEa7vFI7bqLn/g8ypBZqvuKia+hVHLDxtOS8i7exyRV
         B5iFayZ4W3H82MWZwjj8tJP4gP1Z2tTpvpdshzzaGMLhzE6Es+oCIpL6zfmFfwzcv/el
         Vy8VxnDt4f6ZxN2DfoevDTv3+rUuUge/F1OFbahegoqvZKK8mtX8kd8KyP+ArU4I66I0
         mhvlBXY577BIvdO8BgZ/B+1v2tMfVgvcvp4mXkhu/nvA3v80USFSxNeCwAMAWe0gZ2tL
         rMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oho4kHg5TtY+NZGrMmgq2oNnvWnJbxZawxp34xcMT7Q=;
        b=VY60eAPs5x0OGmmNsJlfOcS4iw3sETkzpWjemgpqkH6xVqEjY1sqQOOx1VJs/Qfkxj
         p9g8bHwh6pniaXDig1x9K0gbYkP0ULRs6qFq5n5Rai3sJFKHtn37/wQevATj8bj/68aG
         HsixBgwLU4C76kT67/j9YoRWHswuVL9b8WFP4mH60u/1yWUPgZ4ZafoCbbSG8Moymjz7
         NoijUiyE201Jj9QZJPjRXbiNJnZmdZAcoUoaBWl9t+AFPQjAwDFe3NWGusL8otMiOSJP
         vGz7Yu5Ley9X/vqFCCWwipS/iUieQSHG4eoWamdRkku1Vfgp9zeP5Zte5zMexcTPtwj5
         oYfA==
X-Gm-Message-State: AOAM533o/Lg1iVnX9FCcMbLJ4H0/K6Yp5FPgPZUp5OSYMCoNma+dvk7o
        UJ+0vvNYqbfsampv+noZWMuvltOZvmIfwUP8TLvANw==
X-Google-Smtp-Source: ABdhPJwnpcLIK0W556IGC9rovS3MIh+e8sYvhOzt9h63gGzrTGzuKCJXqXNvbAUnj3Kt/XDqX/FOHli9nQeo8hjRJ2E=
X-Received: by 2002:a81:9f12:: with SMTP id s18mr10054526ywn.448.1644535315101;
 Thu, 10 Feb 2022 15:21:55 -0800 (PST)
MIME-Version: 1.0
References: <20220208051552.13368-1-luizluca@gmail.com>
In-Reply-To: <20220208051552.13368-1-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 11 Feb 2022 00:21:43 +0100
Message-ID: <CACRpkdYZ1cMUn_aiMmbgHLZ41K4uMh48m1LQB5ComU_+sA=O1g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 6:16 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> RTL8367RB-VB was not mentioned in the compatible table, nor in the
> Kconfig help text.
>
> The driver still detects the variant by itself and ignores which
> compatible string was used to select it. So, any compatible string will
> work for any compatible model.
>
> Reported-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
