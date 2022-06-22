Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2715549C9
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348395AbiFVKXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 06:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353870AbiFVKXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 06:23:40 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2405C17E07;
        Wed, 22 Jun 2022 03:23:38 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m1so14949641wrb.2;
        Wed, 22 Jun 2022 03:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=qEPAGOxMSdk4gLCQ3Q2YT2MQlAarZo3S0qU7nlqQDf0=;
        b=iukmiRMeggvZDo2T+uBsLZwNu7y4Cv0CuVYFQugMYYNcMTCo6eO7wxmfUngtI5qxa2
         L3ljjtkIY5EZ0IFp0dd3M0DOso/yd8AAP7ic8zcOPnIeKvos0S2FNl6ai1D56JMVoruL
         dFB7JBMJAKaKFN3e7pwoRdEiOcrXb4SP7Jyd9N76L8oO1yhwsrF6zd61ge2nL81JTRez
         OIfSQxUbk5GrOF2hmjE4gTxF+oIJW4CDtubNht7FVpaDr5+bruRwBl3fvmhxebug2XPN
         IrTTtofFsclXLCCa2I9eV7nH5laDTd6bX/TbxefJc8dJjsNl/N5RAGfTuzdnV52xgzfj
         d94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qEPAGOxMSdk4gLCQ3Q2YT2MQlAarZo3S0qU7nlqQDf0=;
        b=7YkOV16uJBMIp3k3yu1RFnSARkvwQNfIZCX74WHLVXlUf0PUsbjsousFZw7griiVJU
         xGVnghbwZTcnJYRn4ItiORMF8P9zeBbOrclxiwSffJ0SMZzr1KrC111/bjGwOdcUDjbR
         g7m6bqqAfkZDtRigKl/SjLEZE/tSSw9qWgvS7haWSaZePZ+zpq7MgQy3qWhEUqURu6xL
         X/Ia1pfnCNbgc9xsnnsBFaQ+rG3OelZWIXzP4P+Vt/YqrJF69pHCR2ZldUBTykwLqGY/
         EEq0ISL85uUn101ksZj6grKayeMpnq7SLIokWsNvQzzcSVtFqoUM4WN43O/43Cfj0hiR
         nVcQ==
X-Gm-Message-State: AJIora+4D4C6eSr0USu9fFFqUtcoIlcp1nBaNNQiHm17XWc1agK1yZCG
        9uqkLf/Oymvk/H8IMs3hAa4=
X-Google-Smtp-Source: AGRyM1tP/HV5yFKgu/BaBt9sY7h56n9ysa8JINltQolzb2rgEIZZg37kIcvxX37CGw35EvC2jBFT1A==
X-Received: by 2002:adf:f446:0:b0:21b:821f:a916 with SMTP id f6-20020adff446000000b0021b821fa916mr2486592wrp.11.1655893416626;
        Wed, 22 Jun 2022 03:23:36 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id bp17-20020a5d5a91000000b0021b9870049dsm4526213wrb.82.2022.06.22.03.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 03:23:36 -0700 (PDT)
Date:   Wed, 22 Jun 2022 11:23:34 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: mainline build failure due to 281d0c962752 ("fortify: Add Clang
 support")
Message-ID: <YrLtpixBqWDmZT/V@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I have recently (since yesterday) started building the mainline kernel
with clang-14 and I am seeing a build failure with allmodconfig.

In file included from drivers/net/ethernet/huawei/hinic/hinic_devlink.c:15:
In file included from ./include/linux/netlink.h:7:
In file included from ./include/linux/skbuff.h:15:
In file included from ./include/linux/time.h:60:
In file included from ./include/linux/time32.h:13:
In file included from ./include/linux/timex.h:67:
In file included from ./arch/x86/include/asm/timex.h:5:
In file included from ./arch/x86/include/asm/processor.h:22:
In file included from ./arch/x86/include/asm/msr.h:11:
In file included from ./arch/x86/include/asm/cpumask.h:5:
In file included from ./include/linux/cpumask.h:12:
In file included from ./include/linux/bitmap.h:11:
In file included from ./include/linux/string.h:253:
./include/linux/fortify-string.h:344:4: error: call to __write_overflow_field declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
                        __write_overflow_field(p_size_field, size);

After a bisect it pointed to 281d0c962752 ("fortify: Add Clang support").
Since it was introduced in v5.18, not sure if its already reported before.


--
Regards
Sudip
