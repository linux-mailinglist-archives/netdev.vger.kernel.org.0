Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75164E3EF1
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiCVNA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiCVNAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:00:25 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0EF5DA2F
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:58:57 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id yy13so36029123ejb.2
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=fdnG00+FVnrNPc7pRJZUf6p0lTeWtkmJlgm0eIX6kX4=;
        b=AjNPKZIAqwx1xa9dhSiLiycGummqAab3uazQK7DKrwe4jObs6/BzrY3gxWNhbARWYA
         hVNgYlQWf0qCGbhYxIsv5oba6QFc4dqbH4rVwMM63GJC+ZYcFQu8a9yfPLTJFtebEnvq
         sS7TBQzwsITHfW0WlkcFqkMk1QckKj0PPIq++Nyvh30ESPvmnbwBBUoOt7bFvweLvZdB
         w/lllBznyKU8j0PhZDsnxxdukqmUvbUT+TXMDDH4nTzZQSODMf8zRUFxktw8DUru0TN2
         5ePBJm2QDozZZ+PV1buKYCWqMUNMkO6ABcF5+0IpVF09tAgWda+ewU0kKFbTVxSEqsMo
         lT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fdnG00+FVnrNPc7pRJZUf6p0lTeWtkmJlgm0eIX6kX4=;
        b=a5R0rCwTHehR+SUdgEJBckEbZFEBKQk3fsxOnWYNpd+eg8SAIl1jWFbg4Fheie8pVk
         P0OQcOqElloqq4hF3cfBRW+IH8drEUKdsJ/WuXZ5aNqOc1AArk7O5sbrAQFV+PG198Dw
         TWEJiciTpottrsilHd9aHY5+2oDSy645h5Z3NbOMNwbhxvRZiaYWxyQpsSU0xP4k92sV
         Fa306FjpLI9ybqBBfuuh2EKXTZdApc+tZjYYarCaioQqQxcXk9ZDVKT+zhzBUJ/Zxqiw
         UiDNxKJNeReWwkpCeGgNFjBFSzO75XgxV/eOB+L7wO0OX8yhdh8A1XIkl9FKbn/Exmng
         RK9w==
X-Gm-Message-State: AOAM532360NjQZ383h9RYlPONW3TPRSRQZjQONh9NLxfg2146+k5VyIY
        k+qz8IbBWVMtpMphDPNACdkMBGMqaNiNorDt3L4=
X-Google-Smtp-Source: ABdhPJxJ5gfI3ASPs1ZQLPJ5mqeDxFjPhL/TbK+nPa5kjecR/ZD6LUe2SEjX0DqHf5k94THAgBevjCd50OdAmJ5sdEE=
X-Received: by 2002:a17:907:d27:b0:6db:d928:a976 with SMTP id
 gn39-20020a1709070d2700b006dbd928a976mr25969197ejc.24.1647953935879; Tue, 22
 Mar 2022 05:58:55 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 22 Mar 2022 12:58:46 +0000
Message-ID: <CAHpNFcNnW_gYDy4m-cVqta_hux0cW5O7hhOP=fDEN5Tbuxk=NA@mail.gmail.com>
Subject: Reference Kernel Security: https://science.n-helix.com/2019/06/kernel.html
To:     bandwidthalliance@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,PDS_OTHER_BAD_TLD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  https://science.n-helix.com/2019/06/kernel.html

Trace ID : Kernel & Bios HASH Reference
https://lkml.org/lkml/2022/3/22/446

Jumpless Security HASH
https://lkml.org/lkml/2022/3/22/440

SPE Decode & Encode
https://lkml.org/lkml/2022/3/22/415

*****

VM Virtual Call Frame : Security Aspect Leaf HASH Identifiers : Rupert S

Leaf HASH Identifiers in 16Bit/32Bit/64Bit : RS

With this example in mind 16Bit HASH Values & identifiers make sense.

16Bit HASH Reasoning Table: based upon Leaf HASH Identifiers in
16Bit/32Bit/64Bit

16Bit Leaf HASH, Compatible max RAM) : 4GB Large Page

16 Million HASH groups for identifiers with 128MB RAM per HASH Master group..

256 HASH master Table
256 HASH Per Group

16:32MB up to 4GB(16Bit Leaf HASH, Compatible max RAM) : RAM per group

16Bit Hash identifier tables load into 16KB of processor cache
Load, Save & Store can be done in a higher Bit depth; 32Bit for example
SiMD can operate in Half, Single & Double Float capacity

Micro work loads such as motion & video & 3D Tessellation

*

VM Virtual Call Frame : Security Aspect Leaf HASH Identifiers in
16Bit/32Bit/64Bit : RS

If the CPU Manager can call Compression & Cypher independently on TASK Call,
If the Processor Manager can call from Virtualisation functions for
each secure task group.

Security Aspect : With CPU Cache in the 8MB+ Region Leaf HASH
Identifiers can be stored:

Compressed if Processor has Compression such as BZip
Encrypted Compressed if Processor has Compression such as AES

In a Secure &+ Work Isolation Container : WIC or SWIC contained L2
(Compress Store Small Identifier List)

In a Secure &+ Work Isolation Container : WIC or SWIC contained L3
(larger identifier lists),

(c)Rupert S

Reference Kernel Security:

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.html

Leaf HASH Identifier Paths to clear logic:

Performance issues related to handheld would be solved with the use of:

FP16 packed pixel
FP16 background object maths
FP/Int8/4 Machine learning adaptive code...
Compute Shaders
Compression > DOT Image format

With these resources available, We can potentially do more!

https://science.n-helix.com/2019/06/vulkan-stack.html
https://science.n-helix.com/2022/03/fsr-focal-length.html
https://science.n-helix.com/2021/09/temporal-aliasing-image-shaping-polygon.html
https://science.n-helix.com/2022/03/simd-render.html

*
https://science.n-helix.com/2019/06/kernel.html

Trace ID : Kernel & Bios HASH Reference
https://lkml.org/lkml/2022/3/22/446

Jumpless Security HASH
https://lkml.org/lkml/2022/3/22/440

SPE Decode & Encode
https://lkml.org/lkml/2022/3/22/415
*

As you know in my studies i found that 16x AA rarely has a performance
hit on all verified hardware since RX200 3GB (and the RX560) & even
the RX5770 1GB.The NVidia 1080 can manage most of this & i optimised
Elite Dangerous for the 1080 & RX200 market.


A lot of the performance issues related to handheld would be solved
with the use of:

FP16 packed pixel
FP16 background object maths
FP/Int8/4 Machine learning adaptive code...
Compute Shaders
Compression > DOT Image format

With these resources available, We can potentially do more!

*

"Apex Legends : I get the feeling that the lower final precision on
the screen output is the result of a 4x Anti Aliasing layer and lower
Image compression settings,"

*

Elite Dangerous Reference
Videos:https://www.youtube.com/watch?v=JmMQPS_azJA&list=PL8DNvgnwiUU1cezx_Y9DraHjyqJxnrrN7

ML & Game performance improvement

Rupert S

The Handheld market performance ratings are :

Snapdragon (often used & is good)

High quality option based upon Notebook expectations

AMD Chipset
NVidia

My studies concluded that both NVidia and AMD have little to worry
about AA performance upto 16x and it makes almost no performance
advantage to use less in my performance tuning...

I am frequently in possession of older hardware; Like many users i
cannot always afford all the best gear,

However there are examples of things that make a bigger hit:

16x tessellation rarely causes a problem (RX200 3GB+)24 & 32 both
dynamically jiggle FPS around heavy asteroids & space stations in
frontier elite..

but looks amazing!

Multisampling is manageable at 2x on RX200 on elite dangerous

(a quite intense graphic space MMO)
4x MultiSampling does involve a 20% frame rate drop, Quality is
preferred but i went for 2x as it rarely causes issues.

Texture Image compression format optimisation is a priority NO.1 Priority..

You save a lot of space & heavy usage of DOT 1 > 5 compression
management is advised..
10Bit sampling is perfectly logical.

https://www.nintendolife.com/news/2021/03/video_check_out_this_side-by-side_comparison_of_apex_legends_running_on_switch_and_ps4_pro

https://www.youtube.com/watch?v=uGrPwt_KHRE

Elite Dangerous 64Bit PvP Arena DeathMatch 4Q 2xMultiSampling.mp4
(93.26 MB) https://mirrorace.org/m/6qr3y

Elite Dangerous 64 Sub.FM Rastafari PvP 2016-04-23 19-27-22-552.mp4
(89.27 MB) https://mirrorace.org/m/54waA

EliteDangerous - CQC PvP Arena - Bloody is the bath of kings -
2016-05-05 14-30-27-909.mp4 (277.04 MB) https://mirrorace.org/m/3IO7p

yes cloudflare apex_eoso.nx7v.icu apex_eu.nx7v.icu apex_wes.nx7v.icu
apex_eas.nx7v.icu

USA: pop: apex_sv1.nx7v.icu apex_sv2.nx7v.icu apex_sv3.nx7v.icu
