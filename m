Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2B6B7F95
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 19:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390766AbfISREc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 13:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389542AbfISREc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 13:04:32 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D236220644;
        Thu, 19 Sep 2019 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568912671;
        bh=9McqeeEKIgFZ2ZuG6M5IYR2WrH93EYD26mVgUCa8/Tc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=0ycU1wvP2mrqf8GK5O4ONtZQDBtEcD+OFQJsLURtPM9tTVQyyv7/19v5DoGYVJVbA
         c+0GgB2uXtOOMAdHA00L3TGwZxO4kPRaeXctKSx3W+IScnfzLxbZe6T9n9dn0DB/yF
         Jqm3sVqz5aDOcvritlx2YajoAgWXtBKSWpLLv75s=
Subject: Re: [PATCH 2/4] seccomp: add two missing ptrace ifdefines
To:     Kees Cook <keescook@chromium.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Tyler Hicks <tyhicks@canonical.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        luto@amacapital.net, jannh@google.com, wad@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20190918084833.9369-1-christian.brauner@ubuntu.com>
 <20190918084833.9369-3-christian.brauner@ubuntu.com>
 <20190918091512.GA5088@elm> <201909181031.1EE73B4@keescook>
 <20190919104251.GA16834@altlinux.org> <201909190918.443D6BC7@keescook>
From:   shuah <shuah@kernel.org>
Message-ID: <21046d2a-dd80-1d9a-9560-ea3f21d41234@kernel.org>
Date:   Thu, 19 Sep 2019 11:04:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <201909190918.443D6BC7@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/19 10:55 AM, Kees Cook wrote:
> On Thu, Sep 19, 2019 at 01:42:51PM +0300, Dmitry V. Levin wrote:
>> On Wed, Sep 18, 2019 at 10:33:09AM -0700, Kees Cook wrote:
>>> This is actually fixed in -next already (and, yes, with the Fixes line
>>> Tyler has mentioned):
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git/commit/?h=next&id=69b2d3c5924273a0ae968d3818210fc57a1b9d07
>>
>> Excuse me, does it mean that you expect each selftest to be self-hosted?
>> I was (and still is) under impression that selftests should be built
>> with headers installed from the tree. Is it the case, or is it not?
> 
> As you know (but to give others some context) there is a long-standing
> bug in the selftest build environment that causes these problems (it
> isn't including the uAPI headers) which you'd proposed to be fixed
> recently[1]. Did that ever get sent as a "real" patch? I don't see it
> in Shuah's tree; can you send it to Shuah?
> 
> But even with that fixed, since the seccomp selftest has a history of
> being built stand-alone, I've continued to take these kinds of fixes.
> 
> -Kees
> 
> [1] https://lore.kernel.org/lkml/20190805094719.GA1693@altlinux.org/
> 

It has been sent to kselftest list yesterday. I will pull this in for
my next update.

thanks,
-- Shuah
