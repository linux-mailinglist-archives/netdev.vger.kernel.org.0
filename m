Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6F4CDC68
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbiCDS2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiCDS2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:28:33 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C8C3CFCB;
        Fri,  4 Mar 2022 10:27:45 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id c1so8185687pgk.11;
        Fri, 04 Mar 2022 10:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LvmSyZzQRNQUyJ7FXCcgvACVEOlbwc9YXOG/YfEoPhw=;
        b=Hu9tZzR5nCi4uuzWy81rRifFKV2i9HgCOYyfxLgDcuzuNXdD1VQXFfEXNKX3hPmXXF
         /LJwdbdz2EFPUQ43SUNF9Q8UWFZBOpSaeD3vgF1xeaARbu+9zZYmGL+2JY1rtF1z56Vm
         C2VnGMTPRyw79o8dUiGznT+61ofSHsvknrG3c82BG3XgCC6sTGlhFoGMdWP8v1Ce1PqQ
         boVjQHiALhFN5ovv2F4hPSbmZi59bdxhdXM2FS1/wUbinbhbPk6a6CZoJyS8Ca/uWXwC
         3oC9ybxScv2N1TBoXYJ0hTsFmiXF2+68jUxfwoawg5kTD0knN1Ft71tYiyq+Df3nvUV9
         /W0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LvmSyZzQRNQUyJ7FXCcgvACVEOlbwc9YXOG/YfEoPhw=;
        b=ZcLDDn7qAURBJOMHpuLf38b/RbG5mQQ/nzMfUjUiTfevoDuj9TbBidP0FlAfCEkLU9
         Qb2iBpEN5nFrX5hJ4ns/nLuK41qymdhJsbYZUczh8b0HfRzjy8gWS3YKSzwZmDmxo2KK
         VlKYWttI8PWBHYrj7+oW+AEnoGnXnrnFQmJ2wNzYWx8tvyaVqXV606IJ7laYfkrJvFY7
         SrzpXnQm18jn93kpG91b4g9YPzppBtBPKvKs3sp0BPfl1cgKaHBjThEj9O7jdj0eyOJb
         jBy8gQYt7XuueFBgUQWWwsQ8hp4/QZ89HjSfpfDKG+gNYTPtg55caVX4IOR9NVY5eGxI
         zNyA==
X-Gm-Message-State: AOAM531TzKceifqJ2JSjSeaaBSg4ws+LlS/ZI54tWz5TZ10ik6BKWyle
        n+4xdi92WpLEmw3uhvZtMtA=
X-Google-Smtp-Source: ABdhPJwCodtZ81e4pL09u62nr29Kwx+gEEvUelA/rFJJFZJ57L810c0ESXgqCNqLtdX9dgBWdP/a2A==
X-Received: by 2002:a63:cd58:0:b0:364:bca8:55a with SMTP id a24-20020a63cd58000000b00364bca8055amr35584768pgj.56.1646418464814;
        Fri, 04 Mar 2022 10:27:44 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm6746079pfi.93.2022.03.04.10.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 10:27:43 -0800 (PST)
Message-ID: <9cde59df-3148-8d28-6751-da955a8116fd@gmail.com>
Date:   Fri, 4 Mar 2022 10:27:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v5 1/3] dt-bindings: net: dsa: add rtl8_4 and
 rtl8_4t tag formats
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        devicetree@vger.kernel.org
References: <20220303015235.18907-1-luizluca@gmail.com>
 <20220303015235.18907-2-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220303015235.18907-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/2022 5:52 PM, Luiz Angelo Daros de Luca wrote:
> Realtek rtl8365mb DSA driver can use these two tag formats.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
