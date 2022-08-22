Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7959BD29
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiHVJxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiHVJxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:53:24 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63974264A;
        Mon, 22 Aug 2022 02:53:22 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.110.187])
        by gnuweeb.org (Postfix) with ESMTPSA id 8EB6F80927;
        Mon, 22 Aug 2022 09:53:17 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661162001;
        bh=iT3I6GSMz8GsVcIXKTF1Mno6cYZkSK5yv1x/6Z/kQY8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NVdYj1mRqrGDiox7JcRo9HD9RT1M17Hs/y7e9cUiP9h0/AyRhmSp3bXQo1cpar10q
         R/v8ux333PQ+1lX9vAQQPQaV8mXF6ZzfP4vhzwT7ACVmNtSf2bBwkvf2jueaaBN2EG
         Ab0enwRZJUF5RL6+nMVQ8+dkRiI+ZbccA8hhiOoi7YfIj3ngxOMX7gVDg9PGsvR6bS
         X+1yO+wiIEUFBehZ6QuhQy9WPCayxoqg96ge5nDsjSEaOoqIhN18J9Lt2MT9jt0udy
         IOr/jl0+odNMKqVyeydiWrvBtE097tPVWvUAJKXxOqY7TMDFpLvrw8UGUZ8+ynAl/R
         lS1xpn/FTB2QQ==
Message-ID: <c327e887-dcbf-5537-4fbf-69b30cf9ae36@gnuweeb.org>
Date:   Mon, 22 Aug 2022 16:53:10 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [LKP] Re: [vrf] 2ef23e860e:
 kernel-selftests.net.fcnal-test.sh.fail
Content-Language: en-US
To:     Yujie Liu <yujie.liu@intel.com>
Cc:     kernel test robot <lkp@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        stable@vger.kernel.org, lkp@lists.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
References: <20220822065003.GA33158@inn2.lkp.intel.com>
 <532c4311-ada3-05c7-bc63-b5cb2d32ca1a@intel.com>
 <c9451365-e582-3bb0-0180-462d0a4069ed@gnuweeb.org>
 <70e690da-df88-5d78-d25c-b01ce1f3f886@intel.com>
 <730e3e31-509b-23d4-3f35-cf787118b005@intel.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <730e3e31-509b-23d4-3f35-cf787118b005@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


+ Adding stable and netdev people to the participants.

Full story here:

    https://lore.gnuweeb.org/gwml/532c4311-ada3-05c7-bc63-b5cb2d32ca1a@intel.com

If you fix the issue, kindly add following tag
Reported-by: kernel test robot <yujie.liu@intel.com>

On 8/22/22 3:17 PM, Yujie Liu wrote:
> On 8/22/2022 16:09, Yujie Liu wrote:
>> On 8/22/2022 15:15, Ammar Faizi wrote:
>>> On 8/22/22 2:03 PM, kernel test robot wrote:
>>>> =========================================================================================
>>>> tbox_group/testcase/rootfs/kconfig/compiler/group/test/atomic_test/ucode:
>>>>    lkp-skl-d01/kernel-selftests/debian-12-x86_64-20220629.cgz/x86_64-rhel-8.3-kselftests/gcc-11/net/fcnal-test.sh/use_cases/0xf0
>>>>
>>>> commit:
>>>>    cae90bd22cffb ("net: bridge: vlan: fix error return code in __vlan_add()")
>>>>    2ef23e860e765 ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")
>>>>
>>>> cae90bd22cffb1e1 2ef23e860e765eb1dd287492206
>>>> ---------------- ---------------------------
>>>>         fail:runs  %reproduction    fail:runs
>>>>             |             |             |
>>>>             :6          100%           6:6     kernel-selftests.net.fcnal-test.sh.fail
>>>>
>>>>
>>>> FYI, we noticed that this is a backport commit of upstream 205704c618af0ab2366015d2281a3b0814d918a0
>>>> (merged by v5.10), so we also test this case on mainline, and this issue doesn't exist.
>>>
>>> Can you test the latest linux-5.4.y branch and see whether the issue
>>> exists on there?
>>>
>>> You can pull from:
>>>
>>>    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-5.4.y
>>>
>>> The HEAD commit is:
>>>
>>>     de0cd3ea700d1e8ed76705d02e33b524cbb84cf3 ("Linux 5.4.210")
>>>
>>
>> The issue doesn't exist on latest head of linux-5.4.y branch
> 
> Sorry, I made a mistake, the issue still exists on linux-5.4-y head.

Thanks for testing, unfortunately, I am not the committer nor author of
the offending commit. This should have been reported to the netdev list.

I have added them to the CC list. Can you resend the reproducer and
detailed test output with them CC'ed?

>>
>> =========================================================================================
>> atomic_test/compiler/group/kconfig/rootfs/tbox_group/test/testcase/ucode:
>>    use_cases/gcc-11/net/x86_64-rhel-8.3-kselftests/debian-12-x86_64-20220629.cgz/lkp-skl-d01/fcnal-test.sh/kernel-selftests/0xf0
>>
>> commit:
>>    2ef23e860e765 ("vrf: packets with lladdr src needs dst at input with orig_iif when needs strict")
>>    cae90bd22cffb ("net: bridge: vlan: fix error return code in __vlan_add()")
>>    de0cd3ea700d1 ("Linux 5.4.210")
>>
>> 2ef23e860e765eb1 cae90bd22cffb1e19a83a794ad5                    v5.4.210
>> ---------------- --------------------------- ---------------------------
>>         fail:runs  %reproduction    fail:runs  %reproduction    fail:runs
>>             |             |             |             |             |
>>             :6          100%           6:6            0%            :2     kernel-selftests.net.fcnal-test.sh.pass
> 
> for this stat, only cae90bd22cffb can pass the test, while 2ef23e860e765 and v5.4.210
> all failed.

FYI, I found a backported commit with a Fixes tag contains
205704c618af (commit upstream):

    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=e245ea3b524069e1a264bb50190dceedd59c36fb

But the 5.4.y HEAD that already includes that commit still fails
based on your report. Let's wait for netdev people' response on
this. As the mainline doesn't have this issue, maybe something
need to get backported?

Summary:

These commits only live in 5.4.x stable branch (backport from upstream):

(notice the "Upstream commit")

# Known good commit:

     commit cae90bd22cffb1e19a83a794ad5f57dafb3e76ad
     Author:     Zhang Changzhong <zhangchangzhong@huawei.com>
     AuthorDate: Fri Dec 4 16:48:56 2020 +0800
     Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
     CommitDate: Mon Dec 21 13:27:03 2020 +0100

     net: bridge: vlan: fix error return code in __vlan_add()
     
     [ Upstream commit ee4f52a8de2c6f78b01f10b4c330867d88c1653a ]
     ...

# The next commit after that one fails (first bad commit):

     commit 2ef23e860e765eb1dd287492206d833f04eae9df
     Author:     Stephen Suryaputra <ssuryaextr@gmail.com>
     AuthorDate: Thu Dec 3 22:06:04 2020 -0500
     Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
     CommitDate: Mon Dec 21 13:27:03 2020 +0100

     vrf: packets with lladdr src needs dst at input with orig_iif when needs strict
     
     [ Upstream commit 205704c618af0ab2366015d2281a3b0814d918a0 ]
     ...

# The HEAD of linux-5.4.x still fails:

     commit de0cd3ea700d1e8ed76705d02e33b524cbb84cf3
     Author:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
     AuthorDate: Thu Aug 11 12:57:53 2022 +0200
     Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
     CommitDate: Thu Aug 11 12:57:53 2022 +0200

     Linux 5.4.210
     ...

netdev folks, any comment on this?

-- 
Ammar Faizi
