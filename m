Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3905037F9
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiDPTkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiDPTkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:40:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916DB30553;
        Sat, 16 Apr 2022 12:37:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so14253610pjn.3;
        Sat, 16 Apr 2022 12:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bBrIvj2RbZjYdFWgGo9Q0KH8nivE4RSBLo6+AjhmX8c=;
        b=lEOMeVgS1UMAn/xAIx5tnzWJc4+4PBnVnbIGYnQgj/K7x1Xjyp0bC5S4rQX/eJ5XJ+
         Uvn4OHwJ93BV1qqJQ8Lz8Dh5SMvYbToBLlkhbRBgK8+8NJHX95bahxE8bIyrfhPfTOmB
         zyHMM6yt3Pc4IVFjxuzz0Zus9NOynBqBsxuzSkzBUVJ8d2KcICxb5bsLxJfdh9ArULCH
         DBWP0uXEP/didfNU/U9Mf6Cl0qPKeQnU6ukgCF3Xqk388QOUUIf8BLF1eyJLxPeXVZDA
         4n4v4zJ7TEb5faKVZN/sBliY0tZGS+DMd9VhpsfLOYIHRRZbOy2e1qKh5A00PUzLphHZ
         kKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bBrIvj2RbZjYdFWgGo9Q0KH8nivE4RSBLo6+AjhmX8c=;
        b=s37A6bTX4dBEQ0FZiicd0+IljQgxS+ce3AgtPK7fJI63V4IZ4rovss6NQN3osMwfJd
         ocETMti5v+xKsh6fkzlhR+LSUEBAxZbcOCbMrC1939KUKoaFbgeUbHSOuIHtiAj4fR1z
         s9iRNZzfg89YKpiKJQrf6dz7h5h1ytGVqfb/YgqHgygAK3+E7+PcuuwGmXaYv91j4Nrn
         xWSxEB+vHsuzLuHP+QKciYHWXMP1mpf3s17LYY9oRqcNngQhvljiOWx5uZrD2VYZq05e
         5lXFOXA/OK88MqRYClsnf4Dft84Fzaz1DepxIYbyKgkwz/R610Iq8tWXmO71xJ/wbH73
         oIYg==
X-Gm-Message-State: AOAM530MZf1YgR6JLmL4JdNRz5voj2atSfsXe/CZJ5pl7sCquaa9QqMo
        0cMtnhryAD/bRptvV+T9z0Y=
X-Google-Smtp-Source: ABdhPJytoSNnjDeE+7hBXKTSMpgdN3zwp9Rbobt1H/fmiDJUw3gNnLwtvKzHRCcSY93HciTZejk2EQ==
X-Received: by 2002:a17:902:8c96:b0:158:9135:98d3 with SMTP id t22-20020a1709028c9600b00158913598d3mr4509598plo.171.1650137869043;
        Sat, 16 Apr 2022 12:37:49 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u10-20020a63b54a000000b00380ea901cd2sm8056884pgo.6.2022.04.16.12.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:37:48 -0700 (PDT)
Message-ID: <bec03048-d15a-d934-ab88-0f6a5cb2ab0f@gmail.com>
Date:   Sat, 16 Apr 2022 12:37:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 07/18] net: dsa: Replace usage of found with
 dedicated list iterator variable
Content-Language: en-US
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
 <20220415122947.2754662-8-jakobkoschel@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415122947.2754662-8-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 5:29 AM, Jakob Koschel wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> This removes the need to use a found variable and simply checking if
> the variable was set, can determine if the break/goto was hit.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
