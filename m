Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590B6597B6B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242712AbiHRCSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240595AbiHRCSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:18:45 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845C242AFD;
        Wed, 17 Aug 2022 19:18:43 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 130so283305pfv.13;
        Wed, 17 Aug 2022 19:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=L6wchhCs7RCHw4m9lweaJN6ZBZNWWOIcKvLVnf0uZZQ=;
        b=kx0bPU3AP5HeVClj7yO8QgXJTHh0Z9BBQgnP9ZlHDuxC/kCsQgLyHMg13F90mIBYTj
         29e0VizSXDrGzNn001fvQFge7GfG928eE1NJgQQqxic+al+MBbT2ceojGMxz27cgqgc2
         qUhf6OTFiuHLhGKDdXQ5U0wf9hdl8V6yrjR6l2QyWWu8InHDaTU1JTW6PovECxYslqfe
         fbkdCUXPw5Mz5h8/T+ub9qDA+DxlbBOZUgFQ3XllRytFDJ/NzsR37D4hb82OVWkS7Ub+
         rrkydQniB1tFQqgD6N/dCO5dmaJFIwwq8SpxNdH9JRDWcuIGCPCOHKWwu5Okte57+2V8
         XUvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=L6wchhCs7RCHw4m9lweaJN6ZBZNWWOIcKvLVnf0uZZQ=;
        b=hzXtFolYhnje8yl0jf1LpMN8hDDREMIOy0c7AN30p9WhM75XQoHUhW8sTw4B09ZaNh
         hWAui9NLKsO0dckjihAyUUGJuyc431Tjbkf+3sxFQCjkgPcBsPsCA8A0KiK3ct/vfCsa
         Q6VRpIXAodRtaCaiaUTkYV/i55MqyYr/I9IW9ofupxkK3mZDzFx0a6Z4KWr9ZS/OaRn+
         54KguwrbMqK7KhaEljzsh18H5YTYMPATBC9nLoMiJ9ZofxtRRyfOG/ax/mMrb1Tu8a6o
         1yFf5wBYL1A03vcnLdgF19xkSryXQlRWB3irVtBq4kcybXxXKunr71UQ5mYGyPpOjATM
         H3bg==
X-Gm-Message-State: ACgBeo3jQqMUWK4llm089L6pXx1Opl5UtSpIWltxdvawhQ+EaqnWNkVb
        3Cj8B9Ob1xZ90omnSzhQ4U4=
X-Google-Smtp-Source: AA6agR6JzHBmHZYIC9VrcFSpi51ulwPagGgumM1lFX7TT5WyG5nl9+BwkMlCmzuiZullyHOpcJy7cQ==
X-Received: by 2002:a63:1624:0:b0:41a:9dea:1c80 with SMTP id w36-20020a631624000000b0041a9dea1c80mr849410pgl.400.1660789122972;
        Wed, 17 Aug 2022 19:18:42 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-61.three.co.id. [116.206.12.61])
        by smtp.gmail.com with ESMTPSA id v1-20020a622f01000000b0052d98fbf8f3sm224240pfv.56.2022.08.17.19.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 19:18:42 -0700 (PDT)
Message-ID: <c26cdb19-2e9c-adfd-7890-67fb08e3d2ff@gmail.com>
Date:   Thu, 18 Aug 2022 09:18:35 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net-next v2 0/6] net: support QUIC crypto
Content-Language: en-US
To:     Adel Abouchaev <adel.abushaev@gmail.com>, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220817200940.1656747-1-adel.abushaev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 03:09, Adel Abouchaev wrote:
> QUIC requires end to end encryption of the data. The application usually
> prepares the data in clear text, encrypts and calls send() which implies
> multiple copies of the data before the packets hit the networking stack.
> Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
> pressure by reducing the number of copies.
> 
> The scope of kernel support is limited to the symmetric cryptography,
> leaving the handshake to the user space library. For QUIC in particular,
> the application packets that require symmetric cryptography are the 1RTT
> packets with short headers. Kernel will encrypt the application packets
> on transmission and decrypt on receive. This series implements Tx only,
> because in QUIC server applications Tx outweighs Rx by orders of
> magnitude.
> 
> Supporting the combination of QUIC and GSO requires the application to
> correctly place the data and the kernel to correctly slice it. The
> encryption process appends an arbitrary number of bytes (tag) to the end
> of the message to authenticate it. The GSO value should include this
> overhead, the offload would then subtract the tag size to parse the
> input on Tx before chunking and encrypting it.
> 
> With the kernel cryptography, the buffer copy operation is conjoined
> with the encryption operation. The memory bandwidth is reduced by 5-8%.
> When devices supporting QUIC encryption in hardware come to the market,
> we will be able to free further 7% of CPU utilization which is used
> today for crypto operations.
> 
> Adel Abouchaev (6):
>   Documentation on QUIC kernel Tx crypto.
>   Define QUIC specific constants, control and data plane structures
>   Add UDP ULP operations, initialization and handling prototype
>     functions.
>   Implement QUIC offload functions
>   Add flow counters and Tx processing error counter
>   Add self tests for ULP operations, flow setup and crypto tests
> 
>  Documentation/networking/index.rst     |    1 +
>  Documentation/networking/quic.rst      |  185 ++++
>  include/net/inet_sock.h                |    2 +
>  include/net/netns/mib.h                |    3 +
>  include/net/quic.h                     |   63 ++
>  include/net/snmp.h                     |    6 +
>  include/net/udp.h                      |   33 +
>  include/uapi/linux/quic.h              |   60 +
>  include/uapi/linux/snmp.h              |    9 +
>  include/uapi/linux/udp.h               |    4 +
>  net/Kconfig                            |    1 +
>  net/Makefile                           |    1 +
>  net/ipv4/Makefile                      |    3 +-
>  net/ipv4/udp.c                         |   15 +
>  net/ipv4/udp_ulp.c                     |  192 ++++
>  net/quic/Kconfig                       |   16 +
>  net/quic/Makefile                      |    8 +
>  net/quic/quic_main.c                   | 1417 ++++++++++++++++++++++++
>  net/quic/quic_proc.c                   |   45 +
>  tools/testing/selftests/net/.gitignore |    4 +-
>  tools/testing/selftests/net/Makefile   |    3 +-
>  tools/testing/selftests/net/quic.c     | 1153 +++++++++++++++++++
>  tools/testing/selftests/net/quic.sh    |   46 +
>  23 files changed, 3267 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/networking/quic.rst
>  create mode 100644 include/net/quic.h
>  create mode 100644 include/uapi/linux/quic.h
>  create mode 100644 net/ipv4/udp_ulp.c
>  create mode 100644 net/quic/Kconfig
>  create mode 100644 net/quic/Makefile
>  create mode 100644 net/quic/quic_main.c
>  create mode 100644 net/quic/quic_proc.c
>  create mode 100644 tools/testing/selftests/net/quic.c
>  create mode 100755 tools/testing/selftests/net/quic.sh
> 
> 
> base-commit: fd78d07c7c35de260eb89f1be4a1e7487b8092ad

Applied, but based on f86d1fbbe78588 ("Merge tag 'net-next-6.0' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next") instead,
since this series fails to apply on the specified base-commit tag.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
