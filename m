Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E12D4F89F2
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiDGUje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiDGUjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:39:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA1F4302FF
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 13:31:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j20-20020a17090ae61400b001ca9553d073so7501559pjy.5
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 13:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=m/E6BArpwqDrANlRq3WMScGEXTZifKpjR7gStWpTChc=;
        b=GzTu/RvIgNKxm9G5a6dcnwE5Rr3m90BfJP2NGpLv8xbQOkMVzrCTY6SLmt4hYy9w8Y
         xa7I7ov7oXz9I0MT8OaFY3k7n8tRUllAJk0CWlzdo+2oGfl1cs+fIgEVdK0GrsSS31om
         0YJqU+7wM7AfIGWCpeMhW4cNIdg8lH3U3sIMcQpKfYL5jdsoKE6iRXb5MLE1rJo96CzF
         vQ3Nj+amHxron2UZ+8jifsum8kyY4UJEkhcaW0Eit65ZZ5ieLE82AmyF5is32UzM+gOP
         clXOr5QsaVmyDh72N8k683mHssI4CbLSTKsxOe2zpc6YC/bT/dkTUNaV0ndshGucgekH
         Qk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m/E6BArpwqDrANlRq3WMScGEXTZifKpjR7gStWpTChc=;
        b=Xwptu7Erhak3n3TsqCze29ci4cT53SgE7rWw8UjBi2yGhqNDDH+kwTUOxvrkxrdfo5
         DSTbSF7wfkvgRtPM2BcXro5cljcgHFGlsKfK8cxkbGznWGptTpxieW0+8M1JNNMab/RF
         QilHAEA9JraLdk7UG3P59rdBx9vyDSK2a1QHCMMyj+OXRxGbS3EGHRARX3oMhb0P4UNL
         +lySDsjI4hdRJCVvL9gltHSH/j5RbiN5jVbtpc+xhw6QnhovmAMzOc0wIhteDN0rk5EA
         olwjbc72X+Nvj7TtAkVmqyCQxG5SLvBZIwMCWGYmQC2kYNFyruk58VbZqOH/4t4HuvY6
         vxNA==
X-Gm-Message-State: AOAM531vRbxLdvSVZtV4TdGZ/9nooxkgJORfIlAE+C8SqxZDTDaCgJk6
        KZi2KeJCYbPSPyAWjkQRJy0=
X-Google-Smtp-Source: ABdhPJy+cVqON6L7grJNpxn37HGaT55po8STNTErN+cFIzfNMknOvxVWel1qNRajtaZiqc9RkzVTGA==
X-Received: by 2002:a17:902:d88a:b0:156:1609:1e62 with SMTP id b10-20020a170902d88a00b0015616091e62mr15686707plz.143.1649363502004;
        Thu, 07 Apr 2022 13:31:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:d901:ea4d:3e0b:f62e? ([2620:15c:2c1:200:d901:ea4d:3e0b:f62e])
        by smtp.gmail.com with ESMTPSA id k9-20020a635a49000000b0039cc5dc237fsm2833994pgm.8.2022.04.07.13.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 13:31:41 -0700 (PDT)
Message-ID: <1c29e93f-5bfa-fcd1-eaa8-49983db8d3bb@gmail.com>
Date:   Thu, 7 Apr 2022 13:31:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: =?UTF-8?Q?Re=3a_TCP_stack_gets_into_state_of_continually_advertisin?=
 =?UTF-8?B?ZyDigJxzaWxseSB3aW5kb3figJ0gc2l6ZSBvZiAx?=
Content-Language: en-US
To:     Erin MacNeil <emacneil@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BY3PR05MB8002A408749086AA839466C2D0E69@BY3PR05MB8002.namprd05.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <BY3PR05MB8002A408749086AA839466C2D0E69@BY3PR05MB8002.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/22 10:57, Erin MacNeil wrote:
> In-Reply-To: <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05.prod.outlook.com>
>
>> On 4/6/22 10:40, Eric Dumazet wrote:
>>> On 4/6/22 07:19, Erin MacNeil wrote:
>>> This issue has been observed with the  4.8.28 kernel, I am wondering if it may be a known issue with an available fix?
>>>
> ...
>
>>> At frame 4671, some 63 seconds after the connection has been established, device A advertises a window size of 1, and the connection never recovers from this; a window size of 1 is continually advertised. The issue seems to be triggered by device B sending a TCP window probe conveying a single byte of data (the next byte in its send window) in frame 4668; when this is ACKed by device A, device A also re-advertises its receive window as 9060. The next packet from device B, frame 4670, conveys 9060 bytes of data, the first byte of which is the same byte that it sent in frame 4668 which device A has already ACKed, but which device B may not yet have seen.
>>>
>>> On device A, the TCP socket was configured with setsockopt() SO_RCVBUF & SO_SNDBUF values of 16k.
> ...
>
>> Presumably 16k buffers while MTU is 9000 is not correct.
>>
>> Kernel has some logic to ensure a minimal value, based on standard MTU
>> sizes.
>>
>>
>> Have you tried not using setsockopt() SO_RCVBUF & SO_SNDBUF ?
> Yes, a temporary workaround for the issue is to increase the value of SO_SNDBUF which reduces the likelihood of device A’s receive window dropping to 0, and hence device B sending problematic TCP window probes.
>

Not sure how 'temporary' it is.

For ABI reason, and the fact that setsockopt() can be performed 
_before_  the connect() or accept() is done, thus before knowing MTU 
size, we can not after the MTU is known increase buffers, as it might

break some applications expecting getsockopt() to return a stable value 
(if a prior setsockopt() has set a value)

If we chose to increase minimal limits, I think some users might complain.



