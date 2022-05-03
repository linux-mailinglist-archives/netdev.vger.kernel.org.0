Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF5518A7F
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 18:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbiECQ4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 12:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiECQ4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 12:56:10 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833A42C10C;
        Tue,  3 May 2022 09:52:34 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-ed9ac77cbbso7165942fac.1;
        Tue, 03 May 2022 09:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bWkQqeErx5MXuFYoagP2ysKJM8eb7JrDblYR45Dz8Bg=;
        b=VGCJPeUfA+EZJnX6lHLhS4jh1pSuMvHLFLlKfnjUdD8VCe5Ic8sgBwXDuLDmj9A/+m
         X8hiODHRpqGv3vNTo/cv46jzSWgPyz4re1OGXadZIh+p+wBJ/g8yJnosSiTUvp2/578T
         OKS4MwDua23ujsZj8Oaml1nUTra3n7+lxvKMVphsFrBdatUo8mbGH5XAsuDahwtt55HY
         dTsKVFjVzzFcpekkjBRJ2qOu3TGTHbVxPQkaltjL2kkHdFUlzkeokVtsA2CCN6ovQmaU
         KCwMGcO7jzRZnsOyaD5chbIKrdj7RJ+XWWWIEHLy7eit8/52rNzaV3xxf4eFpXGrSH7b
         r9Fg==
X-Gm-Message-State: AOAM531igVUDhjBzsvl5xugyMuPy/ETrzKt0cj+Cushf8Q5LlGxsT7dh
        OLfnQwJyB+6Vswk/tkVbVA==
X-Google-Smtp-Source: ABdhPJweQhiPc2aks3JjKmQerHyDZiP2Figm9BHZLfa154VJ/Sv6faf2F3g3gkldQCZLkAww3JxmPw==
X-Received: by 2002:a05:6870:538d:b0:de:aa91:898e with SMTP id h13-20020a056870538d00b000deaa91898emr2066155oan.54.1651596753800;
        Tue, 03 May 2022 09:52:33 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s35-20020a05680820a300b003260f1e8361sm1657401oiw.54.2022.05.03.09.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 09:52:33 -0700 (PDT)
Received: (nullmailer pid 3862072 invoked by uid 1000);
        Tue, 03 May 2022 16:52:32 -0000
Date:   Tue, 3 May 2022 11:52:32 -0500
From:   Rob Herring <robh@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Biju Das <biju.das@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL
 support
Message-ID: <YnFd0CnF1yDltPoV@robh.at.kernel.org>
References: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
 <YnAlVQr1A6UU0tB3@robh.at.kernel.org>
 <20220502185929.hgjuitw4mnu4ye3c@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502185929.hgjuitw4mnu4ye3c@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 08:59:29PM +0200, Marc Kleine-Budde wrote:
> On 02.05.2022 13:39:17, Rob Herring wrote:
> > On Sat, 23 Apr 2022 14:07:43 +0100, Biju Das wrote:
> > > Add CANFD binding documentation for Renesas R9A07G043 (RZ/G2UL) SoC.
> > > 
> > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > >  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > 
> > Applied, thanks!
> 
> That just got into net-next/master as
> | 35a78bf20033 dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL support

Okay, dropped.

Rob
