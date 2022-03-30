Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAD54EB8C7
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242287AbiC3DcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiC3DcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:32:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C633056D;
        Tue, 29 Mar 2022 20:30:19 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id c2so16472873pga.10;
        Tue, 29 Mar 2022 20:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/OSEDj2Lps5srjK5rm2F0bLYUw3yM+SKZwzZ6R571II=;
        b=QLlZJxjP/P38Gy8D+Su0YX1iPIF4N6s/NQnmNT4yzFM96+M+OToItlhhc21kqNt68E
         ENBYrKxvbXHmXfh/RuG/e8seIMT7R/vO23I1kvphELSr1ssac5DKdDo16KQkJVv70A7d
         LPVWlzof1LafIxwKtt02CQEjZ4PlvpP+V/LO7trLvjYahXwyUblhB86zzfz5QSkSz/CE
         I/icXGx+MN8AfoPE9aV+sE6WNTTjwNgwZdv71v4CH34b41pFAmMR5nkanRcpJMB8PPn2
         /q4d/oD5zwlR5cTTKOCw7S2rFHSu5glaqiVpLEFqcc0qtA4+o8IdIP8EUY3sMstO9nc6
         faAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/OSEDj2Lps5srjK5rm2F0bLYUw3yM+SKZwzZ6R571II=;
        b=oo5ja8SRtSlAb8NDOSKM6cLpBeKwXRa7dVgmCrOVpSkkghCCtZz6Uxrljwe6ZF70lo
         5kojHH0oLY0LZHgZpFYmGSPFcKvy4pgkn0L9eZXw89odkV7gVyBTlzhRQYcUz6OyROR2
         IysciTZrH/xAwFU0qUqQ7abguWOW0x3rvuRn9LHpIe1UUcbkxSJsFFQO1ZbF65RCf8g9
         jFVB6hU32+WXBUYyOD1xW8kCeJbBhd/2+hMDj0yaBajMblNU6+7sHwnPUkFiCXDUzkdp
         nOL+StC++g5MV8YuWUHGE17YN1sKkdYS85qzo4v/TOveVxJJPgzwiPGSpbDK1yLcXtD1
         Q60w==
X-Gm-Message-State: AOAM531VlKDaAsuJvmC3znT5diTlOCM8VTOVUii+C5fCnhNOoFQ3ip03
        zxm/Jg/+y7ComswYp44rMtE=
X-Google-Smtp-Source: ABdhPJz1j9h0wW1YX4H5nDH7pozghSGaG45lpxrpdyS0PAggZMtKm1b/HqehOe5cHS4G0ftyMP3ieg==
X-Received: by 2002:aa7:86c6:0:b0:4fa:46d:6005 with SMTP id h6-20020aa786c6000000b004fa046d6005mr31372665pfo.86.1648611019047;
        Tue, 29 Mar 2022 20:30:19 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id mi18-20020a17090b4b5200b001c9a9b60489sm4463269pjb.7.2022.03.29.20.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:30:18 -0700 (PDT)
Message-ID: <496dce70-d739-7338-5f82-49fdc862b775@gmail.com>
Date:   Tue, 29 Mar 2022 20:30:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 02/14] docs: netdev: minor reword
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-3-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-3-kuba@kernel.org>
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



On 3/28/2022 10:08 PM, Jakub Kicinski wrote:
> that -> those
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
