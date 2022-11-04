Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC159619ED6
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiKDRfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiKDRfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:35:01 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D453C11A17;
        Fri,  4 Nov 2022 10:35:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id cl5so8003569wrb.9;
        Fri, 04 Nov 2022 10:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dhf/O0SjVjpw6jRetWE0L82sj+G4OHwcso0XGOJf/IA=;
        b=ctUnnpcc0DIJ2sF5zmWvSVuVW0yW9Z20ZzmdVRkEZWNy9gsUVppLEEmvFgKdpghvC8
         ACXVUVUAdvqoD+dykPqxyWA4jtaDwgBDMPnc87PFwrrmgMJX/IPK0QpP0xd26PolAynP
         8xBUTVmTt2mC9DKhCOwfg8A5N1OvN0Ht6Wqzk6CGg9wavl9mjkFKdh9RZxb2yrttKFHr
         O6N1Zw4mf8aU+QQ9/0oHPTNUMXJSYLXo1e8wOcwQ3pvxQMA3Z8Qkb6ASyLZbpx8a7bTr
         0hezgy2oMUYGE+eZq9iSE+WzPiesemgPobI5i0jIpvS3hxv1AB48IlRNsVR7BMamSIoA
         hZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dhf/O0SjVjpw6jRetWE0L82sj+G4OHwcso0XGOJf/IA=;
        b=NxlSHuuA+jSY4gNP0UWkXcnoL2HPgeXo8mmI+2yth8EChpMIknYy5eprrYyJIuCIbE
         bTrwD+CaDsdh9HX2v5iRKBkl+GSPIKOH+f9QTwwzUeztVqPcn3omCxcr17j71xQUCjVf
         +oop55chFbtEmIm5GZJd8gFqxtNu+7SBUeRbl6qe1PjDCBOdCCt45L8Sd0aFzaoRkRbj
         nY/wYFFpcw5zlI+m/GFsWYo0OprEWWgKmtG33Jf+Jqt8S5LpbGLOg8oq3pvuj28vwvtE
         35JkjMYS+vX8p5yMteQwy3h6OwZOwmBhVRKZW5j/hoEUlljWxRLp18rwBDVBN/YXCuBb
         qBvg==
X-Gm-Message-State: ACrzQf1pkM3pZo7sAVjonJdRGyB4detKZf0IT0iB9iDx9syRwSMdMGAb
        uCbd74bPcIuaPF+P7cyuMj4=
X-Google-Smtp-Source: AMsMyM6IS2dFBZT3a63/g3DEE40WExK5lgkSeBqOlyin0201hKegeOHfUqud7p8A3zQTZN3U1x1QCA==
X-Received: by 2002:a05:6000:1888:b0:236:8b32:cb47 with SMTP id a8-20020a056000188800b002368b32cb47mr22338907wri.601.1667583299339;
        Fri, 04 Nov 2022 10:34:59 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id p25-20020a05600c1d9900b003cf77e6091bsm3453839wms.11.2022.11.04.10.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 10:34:58 -0700 (PDT)
Message-ID: <9fba3825-fd11-acab-fca7-87fdc17cca5b@gmail.com>
Date:   Fri, 4 Nov 2022 17:34:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] iwlegacy: remove redundant variable len
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104135036.225628-1-colin.i.king@gmail.com>
 <874jvevd4q.fsf@kernel.org>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <874jvevd4q.fsf@kernel.org>
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

On 04/11/2022 17:32, Kalle Valo wrote:
> Colin Ian King <colin.i.king@gmail.com> writes:
> 
>> Variable len is being assigned and modified but it is never
>> used. The variable is redundant and can be removed.
>>
>> Cleans up clang scan build warning:
>> warning: variable 'len' set but not used [-Wunused-but-set-variable]
>>
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> 
> For future wireless patches please add "wifi: " to the subject. I can
> edit the subject during commit so no need to resend.
> 
OK, will try to remember to do that. Thanks for handling the $SUBJECT

Colin
