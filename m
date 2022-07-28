Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C939584880
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 01:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiG1XAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiG1XAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 19:00:10 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871211C2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 16:00:06 -0700 (PDT)
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26SN03HV026620;
        Fri, 29 Jul 2022 08:00:03 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Fri, 29 Jul 2022 08:00:03 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26SN02EQ026614
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 29 Jul 2022 08:00:03 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ea010779-7296-006e-1212-63a18a1ba633@I-love.SAKURA.ne.jp>
Date:   Fri, 29 Jul 2022 08:00:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
 <165814567948.32602.9899358496438464723.kvalo@kernel.org>
 <9487e319-7ab4-995a-ddfd-67c4c701680c@I-love.SAKURA.ne.jp>
 <87o7xcq6qt.fsf@kernel.org>
 <df9efa23-e729-d1d0-b66f-248d7ae67c60@candelatech.com>
 <20220726143807.68f46fb3@kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20220726143807.68f46fb3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/07/27 6:38, Jakub Kicinski wrote:
> On Tue, 26 Jul 2022 08:05:12 -0700 Ben Greear wrote:
>>>> Since this patch fixes a regression introduced in 5.19-rc7, can this patch go to 5.19-final ?
>>>>
>>>> syzbot is failing to test linux.git for 12 days due to this regression.
>>>> syzbot will fail to bisect new bugs found in the upcoming merge window
>>>> if unable to test v5.19 due to this regression.  
>>>
>>> I took this to wireless-next as I didn't think there's enough time to
>>> get this to v5.19 (and I only heard Linus' -rc8 plans after the fact).
>>> So this will be in v5.20-rc1 and I recommend pushing this to a v5.19
>>> stable release.  
>>
>> Would it be worth reverting the patch that broke things until the first stable 5.19.x
>> tree then?  Seems lame to ship an official kernel with a known bug like this.
> 
> I cherry-picked the fix across the trees after talking to Kalle and
> DaveM. Let's see how that goes...

This patch successfully arrived at linux.git, in time for 5.19-final.

Thank you.
