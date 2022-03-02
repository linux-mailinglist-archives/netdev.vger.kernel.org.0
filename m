Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665A94C9DED
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbiCBGoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239068AbiCBGop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:44:45 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96BA70CEF
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:44:01 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id h126so1445354ybc.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 22:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xA54Dg6YOKNxGRpzFrHv89ue1P7bxRw6n+8ssbPupxQ=;
        b=TVtPeZqgVLUGUuIZ2XD0OBb6+n+CwoQ7OZnDO/i5IYb35GWzQpSK0T18BGlKtAa3PC
         d9tOQlEpZsFADgHbdsnUpZs8vnf+nlh274yZnN9T8WivtZqFSqpLt9sHEBAGKUrsPEfB
         Xs1P2YpD8oo5VllT/IBNvMCmgowulIZwVar5+PFuJKwXES2WKkZt2vk0biXX174+B33n
         pMhLJrFl+XPUXqWqYBKaKlKgIpP1tTCUKBumj8Xmh09GzH7ivYs79pSpxFWwr44eyHdC
         jnhBuYoO8sgMzXjOg31FCu/UDu3yg4MSw8urDUl9c0eQaqssSCmqKQXFNeJgp6mDpuKC
         hU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xA54Dg6YOKNxGRpzFrHv89ue1P7bxRw6n+8ssbPupxQ=;
        b=OdM5HKC1ppxr9EHxkmgFoXv2KvPPaeqkMmnDMz0NS0UjIr4Lpbkd+iqfAEtfkTR3E/
         mWfyHRoio2T6bimAwvYVqla205Q4uBsG7a8/UMQaxBGfT9FMCWuh3Jfq0w1bPxfD1etU
         4GYqweHxGrrHEJV9RUZTrE6LSt6/5X7WqSEcRnj2hfIzR6iSq2Xazd4+Wbju8uBlr/QB
         ZQReGX0RYE9sQvSqCn5hewjlhgYg61Crk9TJB389wCCx055otujcS8zo60R+/W4eJ0zf
         TbmCEgBrRN8QXudAb7GSrded9PlCYcQvLFz1W0DfKTmKA/E06TdGONkYFXG3J0B7Y+gJ
         YimQ==
X-Gm-Message-State: AOAM531XzVO4GAwSQ5WKla159fzhlE9Bg73OiQJts6DoDo7o6EuO5SbC
        rtc7qOGTgzXmiPuMVFZDZlEMAdtxQnm2/hNTIecgXQ==
X-Google-Smtp-Source: ABdhPJygqCh8bXOVmE1/4Sdam8IVhHnChATGgXXOD/t6ZD0DdfMuzII/fTX/m/OiAH2BuaKT/UpC9se9Dk+X37wJwJ0=
X-Received: by 2002:a25:4109:0:b0:628:7778:fb18 with SMTP id
 o9-20020a254109000000b006287778fb18mr6967618yba.412.1646203440687; Tue, 01
 Mar 2022 22:44:00 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Mar 2022 12:13:49 +0530
Message-ID: <CA+G9fYvUHjwU9sOMs+zNwuauGLqah3Ce_5VKtifZucOuXqw2qA@mail.gmail.com>
Subject: [next] warning: the frame size of 1120 bytes is larger than 1024
 bytes [-Wframe-larger-than=]
To:     open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     Nick Terrell <terrelln@fb.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        cai.huoqing@linux.dev, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following warnings noticed while building Linux next-20220301
for arm KASAN builds [1].

Build warnings:
lib/zstd/common/entropy_common.c: In function 'HUF_readStats':
lib/zstd/common/entropy_common.c:257:1: warning: the frame size of
1120 bytes is larger than 1024 bytes [-Wframe-larger-than=]
  257 | }
      | ^
net/ipv4/tcp.c: In function 'do_tcp_getsockopt.constprop':
net/ipv4/tcp.c:4272:1: warning: the frame size of 1152 bytes is larger
than 1024 bytes [-Wframe-larger-than=]
 4272 | }
      | ^
fs/select.c: In function 'do_sys_poll':
fs/select.c:1045:1: warning: the frame size of 1264 bytes is larger
than 1024 bytes [-Wframe-larger-than=]
 1045 | }
      | ^
drivers/usb/host/xhci.c: In function 'xhci_reserve_bandwidth':
drivers/usb/host/xhci.c:2877:1: warning: the frame size of 1056 bytes
is larger than 1024 bytes [-Wframe-larger-than=]
 2877 | }
      | ^
drivers/media/dvb-frontends/mxl5xx.c: In function 'config_ts':
drivers/media/dvb-frontends/mxl5xx.c:1566:1: warning: the frame size
of 1224 bytes is larger than 1024 bytes [-Wframe-larger-than=]
 1566 | }
      | ^


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Steps to reproduce:
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake

tuxmake --runtime podman --target-arch arm --toolchain gcc-10
--kconfig https://builds.tuxbuild.com/25mUEFdMf8eGt8sUkh7JnHahLIW/config


--
Linaro LKFT
https://lkft.linaro.org

[1] https://builds.tuxbuild.com/25mUEFdMf8eGt8sUkh7JnHahLIW/
