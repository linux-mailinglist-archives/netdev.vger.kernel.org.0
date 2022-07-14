Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DD4574E78
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiGNM64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiGNM6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:58:54 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB25D1ADAF;
        Thu, 14 Jul 2022 05:58:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d10so1759933pfd.9;
        Thu, 14 Jul 2022 05:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a2nkN9l+/fF2fL+xTF7Ln71n6qkHaZWp85p/BTS2OiE=;
        b=E+fq1rDSFR/EJVpBLT10sLjCMULqsvwacBLqEqnBuBD6v7VmFsEzoo8PSssv84oWQN
         lwdNan2XVO9K6lhOlmS/F7HpU1eSdb8TEAHeTne+i7mnOiBOEtg8HXwXqo1bvCxA6LJQ
         AfplOkMDW1L0BYMn4wYhWl0kp/CN/R9NH8NfCg02EUnsdLSNb3vyopmuDNgyQeQPNvrH
         gq+QnYqyfIKMgfTXDMyF6t2tPkwUbVbohgYGYKx5LSBwJ81NyLKsNcLmDJP/p8yuHb7l
         gDEkj7hVUPdjzS0SdIYOADx1ML1DS0QDOl8SVUkm2H78eNhR+RI4PPhkRBNwSNKQQPW0
         tjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a2nkN9l+/fF2fL+xTF7Ln71n6qkHaZWp85p/BTS2OiE=;
        b=1pqxYNw0NzHPsTTovfWMyHEiAClLnaUUvoti4nLV3K2vP61MV58If6lfNCJi21bwbI
         O5G4A4uhHB+buk+6jabrwBHbbwBNC7dZzceYqthnCZIAqgA3DlU6ePVPwxL6rLyxyBDc
         rWMxx5TPPFSJbnjAxoIwDIBZ7It3PJvoUt2iMEeaeOkTtaG4pIO8d126wxsguOEDUnKd
         xrehGXDwBRgbbwkf0knE2z947hHbz5zzeEqtz3zX775h1FV15wRNO3ZIUkCX7i3T0Q9u
         och3GN8v5vqafQkZpIR49CkyvQ8Nmmn8RzIoHapEbCmVlv0VmP5QYk03QhNeHfKuKDYo
         Pe7g==
X-Gm-Message-State: AJIora9H8JiGzuveNIN+FK+5Ah71hSmzH1MkNzQHk5f6zu5Ib1Tv88Ne
        iNVS/of8wuiifb6K7jXuBXo=
X-Google-Smtp-Source: AGRyM1tlayBJTQ7cQPVSU45NNDmsAmBm9Qj5+P+ch52kxN2A9a/e85Vbah5TX9K3w2AQijnf7k9zAQ==
X-Received: by 2002:a65:4c0b:0:b0:415:d3a4:44d1 with SMTP id u11-20020a654c0b000000b00415d3a444d1mr7650725pgq.191.1657803533233;
        Thu, 14 Jul 2022 05:58:53 -0700 (PDT)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id x14-20020aa79ace000000b0052ad49292f0sm1575195pfp.48.2022.07.14.05.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 05:58:52 -0700 (PDT)
Message-ID: <4790ba0a-d09d-2f12-a1e0-eb807fb9ec34@gmail.com>
Date:   Thu, 14 Jul 2022 14:58:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] p54: add missing parentheses in p54_flush()
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Christian Lamparter <chunkeey@googlemail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
References: <20220714091741.90747-1-subkhankulov@ispras.ru>
 <7cebf20083d2464e5f1467a406cda583ae2750a0.camel@sipsolutions.net>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <7cebf20083d2464e5f1467a406cda583ae2750a0.camel@sipsolutions.net>
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

On 7/14/2022 11:45 AM, Johannes Berg wrote:
> On Thu, 2022-07-14 at 12:17 +0300, Rustam Subkhankulov wrote:
>> The assignment of the value to the variable total in the loop
>> condition must be enclosed in additional parentheses, since otherwise,
>> in accordance with the precedence of the operators, the conjunction
>> will be performed first, and only then the assignment.
>>
>> Due to this error, a warning later in the function after the loop may
>> not occur in the situation when it should.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
>> Fixes: d3466830c165 ("p54: move under intersil vendor directory")
>>
> 
> That fixes can't be right, it just moved the code.

commit 0d4171e2153b70957fe67867420a1a24d5e4cd82
Author: Christian Lamparter <chunkeey@googlemail.com>
Date:   Wed Feb 16 19:43:06 2011 +0100

     p54: implement flush callback

     Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>

