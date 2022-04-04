Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B88A4F1B05
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379370AbiDDVTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379221AbiDDQrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:47:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C535DFF;
        Mon,  4 Apr 2022 09:45:14 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dr20so21081794ejc.6;
        Mon, 04 Apr 2022 09:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WYOOnPbn2RmEaHen3xtS2MJr0dYPX1i1sJyDMjOr0AU=;
        b=QMcDsPvIRuHi/WpJFJSoj5Z10CCm1Oo4x4A560Z5jTXDssFzvPFge568Rzbldy/2MQ
         S4nGAfN+tf8CRXW7HcSYn0wzdxLIQB9xjNqQWtnYw2e/Rbq1rCgklrfKYoDp/pX/CBl+
         BNw8Uz5EyE3p8DLCmGJ5Hi2Y+Jx/4X8JsRSrUcwdEsUkyx924f5ryrDaebgr/HfxG13U
         aDuTXOVLkR8Vg3PmOVfUtomcPwUCRhSgg3ZckjS56UXycmGS0Xz0/K0WbbykW9ZTRzer
         C0rm3kJEdSLJaEh6elf9JHT15ndrGpxJnLukoJ8LJPYYQ+dtQ4oQE5+3t0SBAPNfApT0
         XCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WYOOnPbn2RmEaHen3xtS2MJr0dYPX1i1sJyDMjOr0AU=;
        b=XcsgZZoG7z4zLByPE6nIjqiBOnPSIUoS/7Nj2ie/+XTOaSy3oQ1oK20HKFf4DykuBu
         vMkglmnAF6o0GiBVMnczhPkV4K4hhyPOjTdr+hih3CqWxDaaQRThoVLdf/OFOMk3mATL
         /+aaVpG6p/Akvc01dVbs9a2XaN6uEX5WBLE3ZnVLECa+lfKgNl9GsuZaeCsl0QM6CJnv
         zL7CUprgMhq3IMcPn+CTM/A++7pzYCz2edY6RQd3uorFZ4NR0RyutZ2FmAJhm4K8XB66
         jBX5dOh/NFvehLfh2lhUJN2VSxboQWV+rXULKxM1Sws+0MDSIuByXtYf0Ud+42yjJUkt
         aj6w==
X-Gm-Message-State: AOAM531XnR3HNa3BNjgxeEJZrilEEQ0Yuc8WyD/NRV+2Tt19fUAzivKM
        tkcweIkPPffcKS1PpnztY3Q=
X-Google-Smtp-Source: ABdhPJyZ1hv37A/0H7OrNN/66SRFU5MG2iN3PNyU2k0zTQ2HJwYjX+VdJpPd1V52Z/uY0Mx4q+lnPA==
X-Received: by 2002:a17:906:cf99:b0:6e7:9ff0:38d9 with SMTP id um25-20020a170906cf9900b006e79ff038d9mr992994ejb.646.1649090712908;
        Mon, 04 Apr 2022 09:45:12 -0700 (PDT)
Received: from [192.168.0.253] (ip5f5abb55.dynamic.kabel-deutschland.de. [95.90.187.85])
        by smtp.gmail.com with ESMTPSA id yy18-20020a170906dc1200b006d6e5c75029sm4555841ejb.187.2022.04.04.09.45.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 09:45:12 -0700 (PDT)
Message-ID: <1bd30dce-4046-721b-2207-32ace83af441@gmail.com>
Date:   Mon, 4 Apr 2022 18:45:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ath11k: do not return random value
Content-Language: en-US
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     kvalo@kernel.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220404105324.13810-1-straube.linux@gmail.com>
 <CA+HBbNHEK=CbyeeyPG=s=D2xofdSbk8Lxx5R9nij_cp6t7ybDA@mail.gmail.com>
From:   Michael Straube <straube.linux@gmail.com>
In-Reply-To: <CA+HBbNHEK=CbyeeyPG=s=D2xofdSbk8Lxx5R9nij_cp6t7ybDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/22 18:35, Robert Marko wrote:
> On Mon, Apr 4, 2022 at 12:54 PM Michael Straube <straube.linux@gmail.com> wrote:
>>
>> Function ath11k_qmi_assign_target_mem_chunk() returns a random value
>> if of_parse_phandle() fails because the return variable ret is not
>> initialized before calling of_parse_phandle(). Return -EINVAL to avoid
>> possibly returning 0, which would be wrong here.
>>
>> Issue found by smatch.
>>
>> Signed-off-by: Michael Straube <straube.linux@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
>> index 65d3c6ba35ae..81b2304b1fde 100644
>> --- a/drivers/net/wireless/ath/ath11k/qmi.c
>> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
>> @@ -1932,7 +1932,7 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
>>                          if (!hremote_node) {
>>                                  ath11k_dbg(ab, ATH11K_DBG_QMI,
>>                                             "qmi fail to get hremote_node\n");
>> -                               return ret;
>> +                               return -EINVAL;
>>                          }
>>
>>                          ret = of_address_to_resource(hremote_node, 0, &res);
>> --
>> 2.35.1
> 
> Hi Michael,
> This is already solved in ath-next and 5.18-rc1:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ath/ath11k/qmi.c?h=v5.18-rc1&id=c9b41832dc080fa59bad597de94865b3ea2d5bab
> 

Hi Robert,

Ah ok, then I worked with the wrong tree (wireless-drivers-next).
Sorry for the noise.

regards,
Michael


