Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47040421874
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 22:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhJDUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 16:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhJDUgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 16:36:41 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96238C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 13:34:52 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h129so21894833iof.1
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 13:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c0hwqs6p7Ru2CkxdNWAgix4idc1xYEonvtNVJOMJao0=;
        b=ROnqbH3ApfRdwm045GfASwtFIN3fGzOP1qpYXoFJg5LT+LODJlJbWho8fNVopL+bCY
         ONCasCj5CZNAQ3EU7x+6O5rVy/UMzIsPhB/EATs1fmaoX/vvhX7OKkG0RNqiEsXTM5+m
         S60uDyWm51GQX8xSA14uOeK3U8W0tnxuHejic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c0hwqs6p7Ru2CkxdNWAgix4idc1xYEonvtNVJOMJao0=;
        b=m7Q1DJMlk4yYqnudm2GGZB22KP3rhby8CDrsiN0kBiprKfk9bualoiMjx13nOYsDIX
         X2Ebr0Ku5Mqpda7dM1F6ZvNLbpmkJ8ZUmjq/Jlq9/MWvP/BdsBQhEfN/6kllpksieUi2
         zeE12+IesIGKc25NvjZ/gO5mHLFlsBcKYCFaaRguT7TZrtB9raKkymmhGR35oCu/aG7H
         Hm7zr2YWAYURwwhz3ysOQE/uCBdf58dTUVCMlSeBLPtmkTBcjGiZc5N3MYnMbInU18uM
         Yu/PHkAW7nhAAt6+DbHwBwJUlVP4+9r3RM0+deaHwevJtYQGKFurv+8Ra7OUU4UfF22f
         rlxw==
X-Gm-Message-State: AOAM531xPENupTkEX5rbahpCyYVR7TMWu5sXmVQB+f9IlTmwMgfizBS1
        7YMw+/i7vufS9Em4x1yWvtmwNA==
X-Google-Smtp-Source: ABdhPJzhtmZYb3L3kzexCvpg44/FmdXYXLLWs3+jHNagrFBcW0HT9/ky8nw9XMC3cdz0pWwN+yWxEg==
X-Received: by 2002:a02:caac:: with SMTP id e12mr12873268jap.16.1633379691949;
        Mon, 04 Oct 2021 13:34:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l3sm9697379ilq.48.2021.10.04.13.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:34:51 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc1 review
To:     Eric Dumazet <edumazet@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
 <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
 <CANn89iKPvyS1FB2z9XFr4Y1i8XXc34CTdbSAakjMC=NVYvwzXw@mail.gmail.com>
 <576d46b9-644f-ece0-2cf0-8abbe8b85f4a@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <14314f54-57fa-fa89-ce4c-ce79116d3d80@linuxfoundation.org>
Date:   Mon, 4 Oct 2021 14:34:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <576d46b9-644f-ece0-2cf0-8abbe8b85f4a@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 1:49 PM, Shuah Khan wrote:
> On 10/4/21 11:44 AM, Eric Dumazet wrote:
>> On Mon, Oct 4, 2021 at 10:40 AM Naresh Kamboju
>> <naresh.kamboju@linaro.org> wrote:
>>>
>>> On Mon, 4 Oct 2021 at 18:32, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> This is the start of the stable review cycle for the 4.19.209 release.
>>>> There are 95 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.209-rc1.gz
>>>> or in the git tree and branch at:
>>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Regression found on arm, arm64, i386 and x86.
>>> following kernel crash reported on stable-rc linux-4.19.y.
>>>
>>
>> Stable teams should backport cred: allow get_cred() and put_cred() to
>> be given NULL.
>>
>> f06bc03339ad4c1baa964a5f0606247ac1c3c50b
>>
>> Or they should have tweaked my patch before backporting it.
>>
> Seeing the same problem on my test system as well.
> 
> Patch applied with fuzz. Didn't need any tweaks. Compiling now.
> Will let you know soon.
> 

With f06bc03339ad4c1baa964a5f0606247ac1c3c50b

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

-----------------------------------------------------------------------

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 1dc351d8548b..4b081e4911c8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -240,7 +240,7 @@ static inline struct cred *get_new_cred(struct cred *cred)
   * @cred: The credentials to reference
   *
   * Get a reference on the specified set of credentials.  The caller must
- * release the reference.
+ * release the reference.  If %NULL is passed, it is returned with no action.
   *
   * This is used to deal with a committed set of credentials.  Although the
   * pointer is const, this will temporarily discard the const and increment the
@@ -251,6 +251,8 @@ static inline struct cred *get_new_cred(struct cred *cred)
  static inline const struct cred *get_cred(const struct cred *cred)
  {
         struct cred *nonconst_cred = (struct cred *) cred;
+       if (!cred)
+               return cred;
         validate_creds(cred);
         nonconst_cred->non_rcu = 0;
         return get_new_cred(nonconst_cred);
@@ -261,7 +263,7 @@ static inline const struct cred *get_cred(const struct cred *cred)
   * @cred: The credentials to release
   *
   * Release a reference to a set of credentials, deleting them when the last ref
- * is released.
+ * is released.  If %NULL is passed, nothing is done.
   *
   * This takes a const pointer to a set of credentials because the credentials
   * on task_struct are attached by const pointers to prevent accidental
@@ -271,9 +273,11 @@ static inline void put_cred(const struct cred *_cred)
  {
         struct cred *cred = (struct cred *) _cred;
  
-       validate_creds(cred);
-       if (atomic_dec_and_test(&(cred)->usage))
-               __put_cred(cred);
+       if (cred) {
+               validate_creds(cred);
+               if (atomic_dec_and_test(&(cred)->usage))
+                       __put_cred(cred);
+       }
  }
  
  /**

-----------------------------------------------------------------------

thanks,
-- Shuah

