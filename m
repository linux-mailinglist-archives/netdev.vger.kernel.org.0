Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68910578EB5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiGSAIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiGSAIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:08:06 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578EC32470;
        Mon, 18 Jul 2022 17:08:05 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so12063205pgs.3;
        Mon, 18 Jul 2022 17:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LwIsnm/+Me2/DxvmPehaf4zs3e/ctRtUpPnAE3AHXDI=;
        b=IMinIYRXGi+bDsypwABgV4qLgYiI+bqzQItKC8xyCt91QuWV1bJ2U2c7YA+SPV7cU9
         d+ImCkt/UOMsPMT8YoaQPDwbWjfRdXEwqqlDPFsSCavDldhm87C+REoBCMr2y/R6akQW
         iXy7caPzKsoBeubNcew+COhhTeTzrTiHcYlWL44FccuvTeLATewGRN0ucnXuC8S3ToqS
         h8vK0Fws8LermjH+ShtQLQj1fBOYEKD0z9ejmUy1ces+fGgCTQPzS1kUG3dq6+01wEUU
         HGQrTdObp+KdB9CI2AINyP/RHHe9I26INIfj6nnCNNyzbE0vk3NY6Rndt4dHBFOJoprV
         T+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LwIsnm/+Me2/DxvmPehaf4zs3e/ctRtUpPnAE3AHXDI=;
        b=oMObmRq/uJaGI87Cnd8cHNiq8bZJacbxXzqmZJvHqmfLFyMrtGpAGHXKQzLZkfOO+m
         6EHEJ1EFUVOPoighCsABED3f9S/pX3DsVDwvt1cr7qV+eLRrmst7Dv42zfMQC0ADlBhO
         MLZJdrFbS/D+yJM0wSzz/HAeuLiTo3tkv2pXFjX69IQPc6On8ZOtFawXUt2hQCE8jxsR
         SwpQppX6nzK3isUjaGcxZ5J1drMKKBaPlvS7nZRG3jtp/BlThRHhRatlRN6s+ClkOqeu
         vrYi8kOqnio5QJ5qEA+60YLLn/vam2PRtiuduPKQYuDy68mJo8byLTA4Gcz8fJ6r4kpc
         SJMA==
X-Gm-Message-State: AJIora+HQi9Q08CvDCKSEXjwdpRgb8Hcb24XefarB/vREwI8BC0vOOwB
        KKnf6pMTgb563RjJAZavfWg=
X-Google-Smtp-Source: AGRyM1uYUYJUzNJAeBzrAEXt8oNrLG1qqftqzkKoeaKRDUAcStwl2o1ljbtBRddmBCHHNlHO9LT9+A==
X-Received: by 2002:a63:1047:0:b0:40d:7553:d897 with SMTP id 7-20020a631047000000b0040d7553d897mr26034484pgq.485.1658189284703;
        Mon, 18 Jul 2022 17:08:04 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s187-20020a625ec4000000b0051e7b6e8b12sm10210922pfb.11.2022.07.18.17.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 17:08:04 -0700 (PDT)
Message-ID: <e7ba27b8-47af-fa91-8b66-9406f3018d76@gmail.com>
Date:   Mon, 18 Jul 2022 17:08:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net: dsa: microchip: fix the missing
 ksz8_r_mib_cnt
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
References: <20220718061803.4939-1-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220718061803.4939-1-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 7/17/2022 11:18 PM, Arun Ramadoss wrote:
> During the refactoring for the ksz8_dev_ops from ksz8795.c to
> ksz_common.c, the ksz8_r_mib_cnt has been missed. So this patch adds the
> missing one.
> 
> Fixes: 6ec23aaaac43 ("net: dsa: microchip: move ksz_dev_ops to ksz_common.c")
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
