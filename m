Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D23965AD7E
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 07:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjABGhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 01:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjABGhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 01:37:22 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC083262A
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 22:37:18 -0800 (PST)
Received: from fsav117.sakura.ne.jp (fsav117.sakura.ne.jp [27.133.134.244])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 3026atiG003480;
        Mon, 2 Jan 2023 15:36:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav117.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp);
 Mon, 02 Jan 2023 15:36:55 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp)
Received: from [192.168.1.20] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 3026asf1003477
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 Jan 2023 15:36:54 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c9b1c98e-e39c-331e-e22b-69b1e0a59af8@I-love.SAKURA.ne.jp>
Date:   Mon, 2 Jan 2023 15:36:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [syzbot] net build error (6)
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        syzbot <syzbot+4ca3ba1e3ae6ff5ae0f8@syzkaller.appspotmail.com>
References: <0000000000000ad94305f116ba53@google.com>
 <Y7A8r4Yo07BnDxYv@debian.me>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Y7A8r4Yo07BnDxYv@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/31 22:44, Bagas Sanjaya wrote:
> On Fri, Dec 30, 2022 at 06:46:36PM -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    d3805695fe1e net: ethernet: marvell: octeontx2: Fix uninit..
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14f43b54480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ca07260bb631fb4
>> dashboard link: https://syzkaller.appspot.com/bug?extid=4ca3ba1e3ae6ff5ae0f8
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+4ca3ba1e3ae6ff5ae0f8@syzkaller.appspotmail.com
>>
>> failed to run ["make" "-j" "64" "ARCH=x86_64" "bzImage"]: exit status 2
>>
> 
> I think the actual build warnings/errors should be listed here instead
> of only dumping exit status and then having to click the log output.
> 

There is an report which only says "Killed". Possibly terminated by OOM-killer?
Try "dmesg -c > /dev/null" before build and "dmesg" when build failed?
And/or retry build with verbose output?

  LD      vmlinux.o
Killed
make[1]: *** [scripts/Makefile.vmlinux_o:61: vmlinux.o] Error 137
make[1]: *** Deleting file 'vmlinux.o'
make: *** [Makefile:1245: vmlinux_o] Error 2

