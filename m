Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9955B5B2BC2
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIIBkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIIBka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:40:30 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FC883FA;
        Thu,  8 Sep 2022 18:40:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 78so191178pgb.13;
        Thu, 08 Sep 2022 18:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=opMHbhzPWlzvUgAliFnJJB8yW1hajJahD6Wqj7mMbYk=;
        b=Sn7iMixibbOE9yShth3gvVIUPI7UDKY8s0dY1SUuYERNVmaNK4pam9mtQVru2ljfZ9
         wyaXJnaz+85JZXLuViTO/L4kJ4a89qAgJ2mg3mb95lTRVIbKxbw6Vobs310AGlkULNn3
         2weWbQB93QiqbSduQDNGtnQkC3vk8r8ihXRZAkvSWsIfPeJgCD7WxvfLjdEFs2S7MMo2
         F8YJJKxzZvUOXvkuSX9zqNYf2XQSB07UE3TAVeB3hC8LjvKMAEhHJU+4cQ5n6VnBu/2v
         jQohsYQSF8I6q8y49bHijSrHx7zC0h8h38rZ704TChD5Ykby1ye3YiJpYW9ZxHQ8F6Rw
         yxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=opMHbhzPWlzvUgAliFnJJB8yW1hajJahD6Wqj7mMbYk=;
        b=WEhNPhZj3SoCkVF5RhQVIPfJZdPWaRwkQJCZogSoS33jbWfjyWV1TpC6UouEc8lyuM
         hijCB74yiqY4uOZbi+nfqLBOxdqhOkl9vrfoqzgA6NbQL8vpaRMQod+CMTp0thrJGL1t
         93lGIQ0wJUwov+uSPZnqBWSEazeLrJeI7ZLkYLm16TsYOqmD7/o8pgMTwsaPy9XklDiH
         S2zJuVi3QQ7TMGVJWK0MD/dVO3I29Mod/edWui+MxLbC8cB/OdcnsfJjFYMz4cqaeG7k
         Uwq/5if3jHXSE2YxbuQ+q2tjuN923hcS7axlgitWfwF0aKImnU755VIYcSUEU+A2W+re
         xDLw==
X-Gm-Message-State: ACgBeo2J/pGSW9D0cYZzLR7xV/f1sNmwBJPzCLefUJMfw6EcDYCnYcVu
        UAmO6AVyBQ5kAGYCuk7C15tYXB51fC0TNw==
X-Google-Smtp-Source: AA6agR7Lb3R1nPNK7ief5X8jNpBPQ+MWDSH4uIIm1mvcJUyvI8lzhYnBzIC6Oi6NPjXF3cyOlop4ng==
X-Received: by 2002:a63:d114:0:b0:429:f039:ccfc with SMTP id k20-20020a63d114000000b00429f039ccfcmr10311537pgg.95.1662687623767;
        Thu, 08 Sep 2022 18:40:23 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-47.three.co.id. [116.206.28.47])
        by smtp.gmail.com with ESMTPSA id y66-20020a636445000000b00421841943dfsm135078pgb.12.2022.09.08.18.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 18:40:23 -0700 (PDT)
Message-ID: <d9c17e2a-48f4-e7fd-7cbb-c47e7cffcd72@gmail.com>
Date:   Fri, 9 Sep 2022 08:40:17 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [net-next v4 1/6] net: Documentation on QUIC kernel Tx crypto.
Content-Language: en-US
To:     Adel Abouchaev <adel.abushaev@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220909001238.3965798-1-adel.abushaev@gmail.com>
 <20220909001238.3965798-2-adel.abushaev@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220909001238.3965798-2-adel.abushaev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/9/22 07:12, Adel Abouchaev wrote:
> Add documentation for kernel QUIC code.
> 

LGTM, thanks.

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
