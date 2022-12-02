Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 895B76404B9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiLBKds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiLBKdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:33:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6D8C4CFC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 02:33:36 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r26so5875633edc.10
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 02:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/e58gZBtEpImuaapH5z3ZZXyBnJ+7CtdRYYz6q6IemE=;
        b=FBEXuKdH6DfRsx/hPmSsGMAoEqRA85szN/9ar3oRgmjZKJSW0qhSTMipDJfm2YOWoQ
         aWCWj3YaFHriFVFVuqIBHBXtPSRJz901i+Ix+WOHoKB1VeZHk0CAHkNfH9Smf9l9Rrvo
         IM7L/PfDnCGhkeVRsZpsK5387PYAMfyEO9yXca3u/33VOejA35Y3GUqR26S+Fq+2fXAs
         7prhT/G8V2D2zcr13/2W37SvVVSd/K4e//HKKA00PKCpBfAe/bn3D9M/KjmGI+m+j4uk
         sMW66RUtnuKD1kEyUEwzuxEJ6wQ1LSgsuwNLLnkK8vqBclsIMWz3KBejJw9PelhZCz0P
         Oexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/e58gZBtEpImuaapH5z3ZZXyBnJ+7CtdRYYz6q6IemE=;
        b=aCrkW3WRVMtsODVPFE02vLqkfhCRPxHTnLEGf3TeykJ6kthlK8xtKqiD0wwSFrfY5D
         lpkOCriETo4n1k2BXqU7xWEkQbHeCY3YLdgAEfIUI3G56PO4YsYAGD4GdJRI+217zAT4
         m1pa2tMmaVv0+r+7oxBD6ia3y3KtqhUuICFBUsErJubXP3QljDppmjekPdOLgQP0+6jX
         cu82IvEnyJOd1h4n4der0k1YWp6TMcQDN9wCF1jDAIlMhzlZFDivMfw7saqa+RbYSS0i
         CCt9eMTSV3Kwq9V+LrempelYmNSc5xF4HT7CphF3v42lBTwNiJLJVFV3fLOOgJgnrx/+
         43uA==
X-Gm-Message-State: ANoB5pnfFXvK4Zd7rj9uQUA6PSOlIGDC4XOWkyRZ/AK973Fqh7dJMsb9
        ef0LHyQfI9fhL1fYOzgi73FG7Q==
X-Google-Smtp-Source: AA0mqf62g7tL05/yrH9Nmc/hP4lJkxbx6iU2/cPHDSx5Oqj8j6hZK8YiIPj5dHAh++pcOEG7PBPo0w==
X-Received: by 2002:a05:6402:528d:b0:468:dc9:ec08 with SMTP id en13-20020a056402528d00b004680dc9ec08mr49095306edb.17.1669977214833;
        Fri, 02 Dec 2022 02:33:34 -0800 (PST)
Received: from [10.44.2.26] (84-199-106-91.ifiber.telenet-ops.be. [84.199.106.91])
        by smtp.gmail.com with ESMTPSA id q18-20020a1709066b1200b007bf988ce9f7sm2876728ejr.38.2022.12.02.02.33.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 02:33:34 -0800 (PST)
Message-ID: <fc48c2e1-1df2-c636-bfa4-621148790133@tessares.net>
Date:   Fri, 2 Dec 2022 11:33:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 00/11] mptcp: PM listener events + selftests
 cleanup
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
 <20221201200953.2944415e@kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20221201200953.2944415e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 02/12/2022 05:09, Jakub Kicinski wrote:
> On Wed, 30 Nov 2022 15:06:22 +0100 Matthieu Baerts wrote:
>> Thanks to the patch 6/11, the MPTCP path manager now sends Netlink events when
>> MPTCP listening sockets are created and closed. The reason why it is needed is
>> explained in the linked ticket [1]:
>>
>>   MPTCP for Linux, when not using the in-kernel PM, depends on the userspace PM
>>   to create extra listening sockets before announcing addresses and ports. Let's
>>   call these "PM listeners".
>>
>>   With the existing MPTCP netlink events, a userspace PM can create PM listeners
>>   at startup time, or in response to an incoming connection. Creating sockets in
>>   response to connections is not optimal: ADD_ADDRs can't be sent until the
>>   sockets are created and listen()ed, and if all connections are closed then it
>>   may not be clear to the userspace PM daemon that PM listener sockets should be
>>   cleaned up.
>>
>>   Hence this feature request: to add MPTCP netlink events for listening socket
>>   close & create, so PM listening sockets can be managed based on application
>>   activity.
>>
>>   [1] https://github.com/multipath-tcp/mptcp_net-next/issues/313
>>
>> Selftests for these new Netlink events have been added in patches 9,11/11.
>>
>> The remaining patches introduce different cleanups and small improvements in
>> MPTCP selftests to ease the maintenance and the addition of new tests.
> 
> Also could you warp you cover letters at 72 characters?
> I need to reflow them before I can read them :(

Oops, my bad, I'm sorry for that! Thank you for having reported the issue!

I didn't notice I didn't set the limit to 72 chars for the
"gitsendemail" file type like I did for "gitcommit" in my current vim
config. Done now, next cover-letter should be properly formatted! :)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
