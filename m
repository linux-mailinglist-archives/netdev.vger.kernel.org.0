Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5354D6113C2
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJ1N5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJ1N5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:57:46 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF6A1D52F8;
        Fri, 28 Oct 2022 06:57:45 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f23so4916004plr.6;
        Fri, 28 Oct 2022 06:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pURq2ZAIigLcDR9TJTtusCVtDsz7Ut0rfG8GHdRJiLY=;
        b=HOgEVO+N1Zf1fQolQQp13J5kNAlNn8KlHrL0Sg5RBszVJCST6gOzhLjEA1+izYlRo0
         wKLRzpzzb3OVrRcCE2as6vKT3PzVSgpdYdxiRJ7KNfZbB5obteL03PnlBB8YaxZ5x0le
         ARJEhl1HFQb4677BmbF40X6pHBAHjcvpZgb2D0VTCX3uxTlJ2zLIIkJSwK9JDINnx33K
         NE6d7/2o9zRNVdvM8mfo/gdwUG4lMayDxZ5/OcI/dKOu5MUgVyhy9ziGHqCWuy1X5nzB
         svIxyAdmMuk3v3rl24T9lIR/NtCgvNXJ+wWuKin3nFQNSsYTHtq835J+IxRFqlS4lJXq
         gDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pURq2ZAIigLcDR9TJTtusCVtDsz7Ut0rfG8GHdRJiLY=;
        b=YbHS7watV1dJGJ/Eub8+D+QgZTF52/vNjNWnJVHTZoQntkEYhEJn4fjCDoFp2axBsp
         Ri1i+kUBaqk70cQfhGjhnTCp2Cpisuxyi+QLt6GH/+VPrweH+aKaRN4AadcgXUyVQffv
         68Bz8YcvPQ36eIH3o8gb/uV5iqelVZi13ZbxczMFYpmnssCWMgLdTfyfKLKKoo+H7NFc
         lMNX6WzWiQNUJ58BA5VgNHusBNe3Wn1b2IP/EyNf7kqVisEBLdUj+Ep4SSsw5Cc6qglE
         5nghFetoEWHKhKbBacsoyMwItpQ/1LjBtSSrEAeiXLj2kM2+nfA+ct7fIskBsCqbQbHA
         X0SQ==
X-Gm-Message-State: ACrzQf1dYXE1Xy37a2pdsHBYWvJBHO6sZxLF5gw5MiI/frFH0EGpojSh
        mBDtWTeuoCwlqALn+hnx7S8=
X-Google-Smtp-Source: AMsMyM4TmHqsO8JBZiWG9JydskJ3G+0iWR4RBrx4gAFd8i7wP2pvDVtrfXUd4cIl1xJm5O4PcntkPg==
X-Received: by 2002:a17:902:e84e:b0:186:b699:d4ab with SMTP id t14-20020a170902e84e00b00186b699d4abmr23303128plg.116.1666965465198;
        Fri, 28 Oct 2022 06:57:45 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id n3-20020a635c43000000b0045935b12e97sm2734731pgm.36.2022.10.28.06.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:57:44 -0700 (PDT)
Message-ID: <18fe94a5-23f3-aa59-ddf3-d9f0cd370182@gmail.com>
Date:   Fri, 28 Oct 2022 20:57:38 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 12/15] drivers: net: slip: remove SLIP_MAGIC
Content-Language: en-US
To:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jakub_Kici=c5=84ski?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Huang Pei <huangpei@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <f5f9036f2a488886fe5a424d8143e8f2f3fdcf3f.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <f5f9036f2a488886fe5a424d8143e8f2f3fdcf3f.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/22 05:43, наб wrote:
> We have largely moved away from this approach,
> and we have better debugging instrumentation nowadays: kill it
> 
> Additionally, all SLIP_MAGIC checks just early-exit instead
> of noting the bug, so they're detrimental, if anything
> 

Same reply as [1].

[1]: https://lore.kernel.org/linux-doc/9386b19f-dd99-3601-9e87-3056100dfe53@gmail.com/

-- 
An old man doll... just what I always wanted! - Clara

