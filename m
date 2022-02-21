Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2CD4BEC17
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiBUUv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:51:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiBUUv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:51:28 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C5B237F1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:51:04 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2d62593ad9bso151262167b3.8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 12:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bM8fGjR8QJyKYDyoytdMfHLyx5gVU8QKAKx7b66oysM=;
        b=mwtEYT4IcE71ApIhxLBYomRm66hmzEG4W3zX2bzHuijnAzeA6rwcRr/sJq6ZaYmggy
         oSkCo+6t62IuvqJ1oKcupaDm65FOudITPtQfBebrWCNnusewu9vZhiDiX2LtZjvGFF5G
         pS6amffxCzIRzX1031AH0CxcKNAGSdyw82sXryBPVe+Uj/d7BjXLyTX97Nfhd1ihTlGH
         jYXL8nsjZQSmk5LpEx+DIT5ObatcrjNYn4oGWbqXbHReGzb031zWY8fz11c03J7/MkUZ
         /YML3SnZ6VtW1UIQwMdGO4MQ92na+mUw43godeyhkQJfX7Mii1uH2NebZZWN0kx7I4pj
         PyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bM8fGjR8QJyKYDyoytdMfHLyx5gVU8QKAKx7b66oysM=;
        b=oc0JG5SZda7cwCS4W5/ANqfuYQMxsnbtA00D4c2eLLGUFWbP0uGiczibGF90lh39Nf
         dIFeF5X0q9vNFRshu9eBdOrPCHHXg1vg1qPixKU4+A8wphEXSghL0UwBx/f7SpldhN7F
         exHT3zKzzYDgD9QKE3pVNig4IwJW1awmmAOf7/ilPeHt3MrC5pRhClEl4BPK6KG2D9qP
         6HregF/xNG165pV+EmUTk7UA19kWgcHXX476MnTnAdK610eoBoqBycvI3QakjTV7hCsD
         fcUVRGTX0P6gFgd1QkagAwHTcM5pwIEX8EmCQ1Rk8NIS1ureeadODh80mt1A7vr20ddP
         899Q==
X-Gm-Message-State: AOAM5334Syiri+wtdL1k/KqaxGVqV15N0NZ090CoNzWCp7OZB1HcNkt2
        LOJxw0a1h7ctSncQAZQytV+uqdqn8Bsgs5/Ys02MPg==
X-Google-Smtp-Source: ABdhPJy2YhVkZ0HHy0/Wpbu/F4l87DANXsovnIyPNZA1s2AwiKwdkVtJCTNGVkJE2dxr2dsIJlXl2DdWHYkU+oN+xM4=
X-Received: by 2002:a81:21c3:0:b0:2d6:eff3:11bb with SMTP id
 h186-20020a8121c3000000b002d6eff311bbmr12632383ywh.129.1645476662995; Mon, 21
 Feb 2022 12:51:02 -0800 (PST)
MIME-Version: 1.0
References: <20220221084930.872957717@linuxfoundation.org>
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 02:20:51 +0530
Message-ID: <CA+G9fYtW1xOWQLC8YEuQxwnJBu7dvsc5B=0p5xYqKUzYcurB7g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/196] 5.15.25-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022 at 14:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.25 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.25-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
Regressions on arm64, arm and mips for following build errors /warnings.

arm and arm64 build log:
drivers/tee/optee/core.c: In function 'optee_probe':
drivers/tee/optee/core.c:726:20: warning: operation on 'rc' may be
undefined [-Wsequence-point]
  726 |                 rc =3D rc =3D PTR_ERR(ctx);
      |                 ~~~^~~~~~~~~~~~~~~~~~~


mips build log:
  - gcc-10-malta_defconfig
  - gcc-8-malta_defconfig
net/netfilter/xt_socket.c: In function 'socket_mt_destroy':
net/netfilter/xt_socket.c:224:3: error: implicit declaration of
function 'nf_defrag_ipv6_disable'; did you mean
'nf_defrag_ipv4_disable'? [-Werror=3Dimplicit-function-declaration]
   nf_defrag_ipv6_disable(par->net);
   ^~~~~~~~~~~~~~~~~~~~~~
   nf_defrag_ipv4_disable
cc1: some warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

- regressions
 - arm64
  - build
   - gcc-8-defconfig-warnings
   - gcc-9-defconfig-warnings
   - gcc-10-defconfig-warnings
   - gcc-11-defconfig-warnings
   - clang-nightly-defconfig-warnings
   - clang-13-defconfig-warnings
   - clang-12-defconfig-warnings
   - clang-11-defconfig-warnings
   - gcc-11-defconfig-fac1da4b-warnings
   - gcc-11-defconfig-5e73d44a-warnings
   - gcc-11-defconfig-389abf09-warnings
   - gcc-11-defconfig-eec653ad-warnings
   - clang-13-defconfig-5b09568e-warnings
   - gcc-11-defconfig-59041e85-warnings
   - gcc-11-defconfig-904271f2-warnings
   - gcc-11-defconfig-5b09568e-warnings
   - gcc-11-defconfig-1ee88247-warnings
   - gcc-11-defconfig-0eba0eda-warnings
   - clang-nightly-defconfig-5b09568e-warnings
   - gcc-11-defconfig-bcbd88e2-warnings
   - clang-12-defconfig-eb1b7d61-warnings
   - clang-14-defconfig-warnings
   - clang-14-defconfig-5b09568e-warnings  -

 - arm
  - build
   - gcc-8-imx_v6_v7_defconfig-warnings
   - gcc-9-imx_v6_v7_defconfig-warnings
   - gcc-10-imx_v6_v7_defconfig-warnings
   - gcc-11-imx_v6_v7_defconfig-warnings
   - clang-nightly-imx_v6_v7_defconfig-warnings
   - clang-13-imx_v6_v7_defconfig-warnings
   - clang-13-mini2440_defconfig-warnings
   - clang-13-omap1_defconfig-warnings
   - clang-12-footbridge_defconfig-warnings
   - clang-12-imx_v6_v7_defconfig-warnings
   - clang-11-footbridge_defconfig-warnings
   - clang-11-imx_v6_v7_defconfig-warnings
   - clang-14-imx_v6_v7_defconfig-warnings  -

 - mips
   - gcc-10-malta_defconfig
   - gcc-8-malta_defconfig

--
Linaro LKFT
https://lkft.linaro.org/
