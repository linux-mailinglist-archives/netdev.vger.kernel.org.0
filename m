Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8BA6218EA
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiKHP71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiKHP70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:59:26 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EBA58BE5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:59:26 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id bp12so6361812ilb.9
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 07:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LxEsUdZzBjG4pFuPmvDLmV2oYPornyiErbUh+7geeO8=;
        b=B1V6S1/ZNlUgxwNpL6x/jMAVV72GGIvH9YK3t+W6qYZ6LZtBDvm/GkfgT0EedNWkBU
         4k5stRg6d/UeU9CSiRtQipAF9cVgUEHzXRS9f9PjMPzP7Yrbl/nlVDtBcp4B7pUfI78K
         VjDYKQ9rAInRKa6AcJHzVyaq5nxsG3PMwmnSkMGSctAGZ3lQ6YJqRXn7djBrjhlE1LvA
         ZmLjv5ozKLuo3x4/sKDDnuJjN3wbJuwzQRoRyCO5/Y1cWaKGAQCF3oB2n28uisA/79Kn
         14Er3M1Wvo9A6c3Lrgr0jzG4n4JRY7P2gtEI9ePvYDnCO/udjwejwDa7knfEU6nJqfYZ
         kCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LxEsUdZzBjG4pFuPmvDLmV2oYPornyiErbUh+7geeO8=;
        b=R9HhhemOPWH8oEHehHu5zBFu8x/z/86Q5JXCz07Wz5ClNO3SwdzZEACw5ks8XhY72q
         c7R7WTkgaUQUoyitQyum3aM4Pp8HlQ5Ev++M71t9KLJILfnaOCTj1v/mU0mfqq4SU9Ce
         ssyYdhAnkMLLmht71+Ly7ZXJxzSf9EA0TYv8wlDhZbWqdiBGlywDXFuNh01KuyHxIDQJ
         RoTrdH1hG4nkFuNFDrz6YL0Qcabx8JZm5MntvPb/TOUoqul6wP2Ql5fVF8Qm55z9RXUs
         4I4gfrXFoleIOUK3cBZ0SFZTUlDizHDyjvh8HvAmnTPHiiiTjiQ4hSkg2WVKUyVLxTCX
         a2Ng==
X-Gm-Message-State: ACrzQf1lnAewPm0bCy6P6OXAc07ojFdAYbu73isxau73mcek1QFTQN+L
        v00I6rxLRGVJo2366ULEgR67VY/HDoa+rA==
X-Google-Smtp-Source: AMsMyM6EL7E1wjrnq6GSwUGCT888D8/4TS1h0y0gP6a/KSqMRXJHJrILvcUxD2bWZwYv1YvbfbVloQ==
X-Received: by 2002:a92:de41:0:b0:300:ec01:ee4a with SMTP id e1-20020a92de41000000b00300ec01ee4amr620422ilr.74.1667923165524;
        Tue, 08 Nov 2022 07:59:25 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:a10c:23e5:6dc3:8e07? ([2601:282:800:dc80:a10c:23e5:6dc3:8e07])
        by smtp.googlemail.com with ESMTPSA id h15-20020a056602154f00b006bc48537658sm4543034iow.0.2022.11.08.07.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 07:59:24 -0800 (PST)
Message-ID: <f7e9ba65-bed3-540b-a2d9-879f7205f0c7@gmail.com>
Date:   Tue, 8 Nov 2022 08:59:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [patch iproute2-next 1/3] devlink: query ifname for devlink port
 instead of map lookup
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, moshe@nvidia.com
References: <20221104102327.770260-1-jiri@resnulli.us>
 <20221104102327.770260-2-jiri@resnulli.us>
 <6903f920-dd02-9df0-628a-23d581c4aac6@gmail.com>
 <Y2kqLYEle5oDxfts@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <Y2kqLYEle5oDxfts@nanopsycho>
Content-Type: text/plain; charset=UTF-8
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

On 11/7/22 8:54 AM, Jiri Pirko wrote:
> Mon, Nov 07, 2022 at 04:16:42PM CET, dsahern@gmail.com wrote:
>> On 11/4/22 4:23 AM, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@nvidia.com>
>>>
>>> ifname map is created once during init. However, ifnames can easily
>>> change during the devlink process runtime (e. g. devlink mon).
>>
>> why not update the cache on name changes? Doing a query on print has
> 
> We would have to listen on RTNetlink for the changes, as devlink does
> not send such events on netdev ifname change.
> 
> 
>> extra overhead. And, if you insist a per-print query is needed, why
>> leave ifname_map_list? what value does it serve if you query each time?
> 
> Correct.

"Correct" is not a response to a series of questions.

You followed up that 1 word response with a 2 patch set that has the
same title as patch 3 in this set. Please elaborate.

