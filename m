Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7A58567E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiG2Vcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiG2Vcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:32:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F408AEDD;
        Fri, 29 Jul 2022 14:32:39 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w17-20020a17090a8a1100b001f326c73df6so4779863pjn.3;
        Fri, 29 Jul 2022 14:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=xjH10rLqfqkr/3tCURQKF3STurdTTHn/fdTjGaWVXuo=;
        b=cInOSJkbeo+MRnO3/Jh2dtf/dUDVr10ZbHe8PwjnmKV2K54J6aDZ5FD5qxitqpX6SB
         Tta4sA/m7s5CI4rvQhbyD5Zj+sHlpW8kXgLAGFc5H8agXiBom01MBN5p1pi+IU3/sQhV
         VAQ3zLOBKtlUU5tGKs7hnco8FyBQ9t9LSQnYOUHJNKDgTbkRTVVrxL/GhC+LC44q/YVm
         3T4CkF2Dl5Ul5i87FTV0bsw/JG7IkiQL8Te16Qh3z5n+rv2D7r+ILNByJUrEGwyutyUi
         9HNiw/NEXnOGYvZEquUvDEAVIHvuafeWMQgSmr8IfRHK4p/Z9y8y984pfqIemZk4wlLd
         PTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=xjH10rLqfqkr/3tCURQKF3STurdTTHn/fdTjGaWVXuo=;
        b=G7Ea7UlONtrFJtHNeOQ9aQWWCVxZAmk+glgDRVsnUTL1mUkNsK/iO2dV39lrwumMtk
         VdxSVt4lQ3wgTd7WDacBiwd899gkJV1YdtyciQMaaNzqee4uRJzGz9KrIgnbSvyWQZIY
         zZeru32RxbL3T8gZWXnqGvGxpwWBP/VNzRXZAbXkHSfUi8zMFcnOgfIuT5d/CvyA9svq
         GXxfPCjPQcnkzgqomLek0nb/G/X05gn6tb2kLP7GqIwbAwSmD710QFB+YT8Vz0p0SdVX
         mUAlT1cZQea0xGrgdmn5/EAeeBtraiPud2ehMj5TysV90a6HQBJFaafXxmAmtfx0PUso
         lx4g==
X-Gm-Message-State: ACgBeo3k+fslRubR6AU9gz55ba6qrH7UuGJ6jL6dR7CPBIuulpGT08Xt
        lc+G6UL1KuNw02Y2X8OhK2E=
X-Google-Smtp-Source: AA6agR4lErwI/WTj49aG38zT0V7oK4P1emzQw8VIcZqAKNT1hzchXJd2VUMYeiwF8dsiOVuKYQO5Uw==
X-Received: by 2002:a17:903:230a:b0:16d:5b82:db2b with SMTP id d10-20020a170903230a00b0016d5b82db2bmr5752175plh.138.1659130358436;
        Fri, 29 Jul 2022 14:32:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a11-20020a1709027e4b00b0016cbb46806asm3995511pln.278.2022.07.29.14.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:32:38 -0700 (PDT)
Message-ID: <44a0f864-0768-e2f5-1a0b-4698a30959ff@gmail.com>
Date:   Fri, 29 Jul 2022 14:32:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 02/14] net: dsa: qca8k: make mib autocast
 feature optional
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:35, Christian Marangi wrote:
> Some switch may not support mib autocast feature and require the legacy
> way of reading the regs directly.
> Make the mib autocast feature optional and permit to declare support for
> it using match_data struct in a dedicated qca8k_info_ops struct.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
