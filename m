Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5885FC79F
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJLOnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJLOnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:43:12 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6145BCF1B0;
        Wed, 12 Oct 2022 07:43:10 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-132af5e5543so19673732fac.8;
        Wed, 12 Oct 2022 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=S/kw7ibov8fIqFFyDb5i661fIrEGGXdzEU8j/6GYfUs=;
        b=lwWt2VGDdW2eTzsFViTM80BfmTlpcYxahYdqdIEzTPCFnjbhfS67C43SVieQhcZyHl
         Mnmnix/GcB1/+OlLua7ENpb0gX/KLrkpyNkY3vDOuHKsEJVr3rU5Ud16K2l2sNxNG+cJ
         3Ac96efJ+6fmM4gVwAo7dDfRKuuxmX6DbEnAsd+ht/38HxkrBlnSIBuOSNfqNKcghANo
         /aSScVQLIxPLXwiOM6ggbNrG1FuvIZ6J8VUNzE5WYGQe35+2GE/oC4SJ8apd2KiRxZvc
         SVQhtFJuoYQ2v+CgBfdkF3ropNj5sDb/t3C+wL3QVAoDGg7TJCbQ19vbefSiSAVVNPLR
         7NJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S/kw7ibov8fIqFFyDb5i661fIrEGGXdzEU8j/6GYfUs=;
        b=wAaN6RQULX0f84jcdtrBCXocS4Kha84oGUa0hQjw78FicbPRBxzL8uPTMtOl42xICS
         oQLR1TBt+whIAnXAm/bn3wY+zx0shUp4iSRfC4GcDO+MI7wexoKCsxEdG9ZcO3Fo6TrE
         ZTZtUWLO/KFyMoxKrD4RYP3TJv7RVU93H0+7L4XVWdq91r6myHEsS/FTf7t/SoVTKVLj
         UEyXJssG4z6vSSFV2FRX6Mp7laRuo9t7c5k5fdcJ0ru0nc7QQPhWu5LfOzEG+/z5G4av
         b58Rh9iXUAbcgEILB4lYXo4ocXaw3bzml2OZRZq+pvjmclQYOeB0t3S6Y0+nikWsO6XE
         DC3w==
X-Gm-Message-State: ACrzQf1LN3UcwfR0jZh7DG4OdbuVLrr9K8N4C6SxhGZKt/ZhSl8hRIEV
        cYnB/nssq3RZLnc3zV0atWI=
X-Google-Smtp-Source: AMsMyM59p1FhlyyLz5RgpybriNa/vwkA2oVbi9wL7mFa8CtaGXqW6NtxzT6NMEE6l3kOASLhaT1Kjg==
X-Received: by 2002:a05:6870:178e:b0:126:7055:fc78 with SMTP id r14-20020a056870178e00b001267055fc78mr2784283oae.58.1665585789247;
        Wed, 12 Oct 2022 07:43:09 -0700 (PDT)
Received: from [192.168.1.128] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id u5-20020a056870d58500b0010c727a3c79sm1234714oao.26.2022.10.12.07.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 07:43:08 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <19d41aed-591d-ce01-c5fc-350fe40e9f8f@lwfinger.net>
Date:   Wed, 12 Oct 2022 09:43:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: rtlwifi: missing return value in
Content-Language: en-US
To:     "Colin King (gmail)" <colin.i.king@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <11ea25ad-0ad9-7d34-de3f-09ca7d9c4ee2@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <11ea25ad-0ad9-7d34-de3f-09ca7d9c4ee2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/22 08:10, Colin King (gmail) wrote:
> Hi,
> 
> Static analysis with cppcheck has found an issue with a function that returns an 
> int value but there is a code path that does not return a value causing 
> undefined behaviour:
> 
> Source: drivers/net/wireless/realtek/rtlwifi/usb.c function _rtl_rx_get_padding 
> - introduced by commit:
> 
> commit 354d0f3c40fb40193213e40f3177ff528798ca8d
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Wed Sep 25 12:57:47 2013 -0500
> 
>      rtlwifi: Fix smatch warnings in usb.c
> 
> The issue occurs when NET_IP_ALIGN is zero and when len >= sizeof(*hdr), then 
> the following return is *not* taken:
> 
>      /* make function no-op when possible */
>          if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
>                  return 0
> 
> and then execution reaches the end of the function where no return value is 
> returned because the #if NET_IP_ALIGN != 0 is false so the return padding hunk 
> of the code is not compiled in.

Colin,

The no-op code snippet you quote above returns zero if NET_IP_ALIGN is zero. In 
that case, the value of len is irrelevant. If NET_IP_ALIGN is not zero, then the 
function returns a value in every case.

I admit that the logic is overly convoluted and clearly it overwhelmed cppcheck, 
but as I see it, the problem is with the tool, not with the code.

Obviously, a patch such as shown below would let your tool come to the correct 
conclusion, but it is not wrong now.

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c 
b/drivers/net/wireless/realtek/rtlwifi/usb.c
index a8eebafb9a7e..7b7277b33a7e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -554,13 +554,11 @@ static unsigned int _rtl_rx_get_padding(struct 
ieee80211_hdr *hdr,
  {
  #if NET_IP_ALIGN != 0
         unsigned int padding = 0;
-#endif

         /* make function no-op when possible */
-       if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
+       if (len < sizeof(*hdr))
                 return 0;

-#if NET_IP_ALIGN != 0
         /* alignment calculation as in lbtf_rx() / carl9170_rx_copy_data() */
         /* TODO: deduplicate common code, define helper function instead? */

@@ -581,6 +579,8 @@ static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr 
*hdr,
                 padding ^= NET_IP_ALIGN;

         return padding;
+#else
+       return 0;
  #endif
  }

I happen to believe that fixing bugs in tools is more important than needlessly 
modifying the kernel so that the tool gets the right answer. I say that as 
someone that has been burned in the past by a faulty tool.

Larry


