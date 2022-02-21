Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8493A4BEC45
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbiBUVPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:15:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbiBUVPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:15:39 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF6B23BF0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:15:12 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id j2so37103357ybu.0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uFeSUMQXvI58Rc5ptIDkWKszPED1nBAKaDSflKyhul4=;
        b=RZzEj0T6lR2oZmD5sYJSaQ09IIO8ejkvKQAG9qZzjgkjCIH9iWqDgiv+dWWWGPIiYW
         686aLRQ6B4JKAqKr+FWZxUROgLNcq3AWKzOWY4A8nzyP31hDxzY5Ho7Fawb+USO6W/X8
         Fp85k64JrvF8FiKClxEzE2QYxcYFMEl8vuck2D2eTz8RSlX3i4G4HPDKNC1fu1sUW3di
         aw8VEKHIUEb3H+z8a+hqPWT58k790b/43E07DCjt11lJkgxmOb3E0PGGEewkFAvji1nZ
         ZHbMTTBZPWvacQG41hoiJ45mBOQ9SJD8mBDM2QZfF/rp0l7ryMiwqrYuOCXsJfJH4+Mb
         Mf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uFeSUMQXvI58Rc5ptIDkWKszPED1nBAKaDSflKyhul4=;
        b=q8j05lEUCH22qcTk9MXZ9/vCjYCbzSl9hnqvM7yWzAOnXqNQ4JT7ttfAeMeVxV1g+j
         y0bRNkKklPaDYDCSLJpPp7tsuU0uqTX5RikisVkOmLEVCNLDYbeROQtgFp16MFwBGHdl
         2c/m1NqCUATxToAUfESgYHKZEM/RoVL3eN2cwR4ep0I8FD5VvRN68QyGaE2jKbeFc1mm
         umQbiX4nzkMMdnr6NnrhaTdt9rnahGTgoMJK2QKt4V+l3uDXKWFda07g1s30XhE7d3V+
         GnHnoq3NXqSRk4XK4t/iRvz/hwxCA9p/noOXZaLjXdEyYOjX05Udj+96CsgqHX74DlZJ
         jhNw==
X-Gm-Message-State: AOAM532Kcj31Y0JvaD+BwBC6d8PoSlw73ywu+SX8FoX+o77skfLdlV1E
        2n0KobggLD2rS23ozJkQg12p563tXIVeDBtTQcU8uw==
X-Google-Smtp-Source: ABdhPJzi5i7MHEsd7FI5A+sSoNSiFoNL2xxPH4uFsyOtnvsQbIQX0VSEbJlqGDAm9gwGzWnn0YPBkySUqRu7Zbm9OsQ=
X-Received: by 2002:a25:c304:0:b0:623:e017:8e15 with SMTP id
 t4-20020a25c304000000b00623e0178e15mr20592189ybf.592.1645478111630; Mon, 21
 Feb 2022 13:15:11 -0800 (PST)
MIME-Version: 1.0
References: <20220221084934.836145070@linuxfoundation.org>
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Feb 2022 02:44:59 +0530
Message-ID: <CA+G9fYsELVHqtz6KV8UWvOHJY=F3YD-DQ7_hoauhHUtrV7GHKQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
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

On Mon, 21 Feb 2022 at 14:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.16.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Regressions on mips for following build errors /warnings.

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

Build links,
  - https://builds.tuxbuild.com/25PhCYlLyigpYcPp4pVZrKxXo4C/

--
Linaro LKFT
https://lkft.linaro.org
