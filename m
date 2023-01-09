Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEB7662554
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbjAIMS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbjAIMSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:18:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CE51AD9C;
        Mon,  9 Jan 2023 04:18:40 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NrCXN4MnNz6HJRn;
        Mon,  9 Jan 2023 20:13:40 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 9 Jan 2023 12:18:36 +0000
Message-ID: <8eed91ae-3a2e-4367-f68b-76c2f5125828@huawei.com>
Date:   Mon, 9 Jan 2023 15:18:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: ru
To:     Dan Carpenter <error27@gmail.com>
CC:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-sparse@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <gnoack3000@gmail.com>, <linux-security-module@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <artem.kuzin@huawei.com>, Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <9a6ea6ac-525d-e058-5867-0794a99b19a3@huawei.com>
 <47fedda8-a13c-b62f-251f-b62508964bb0@digikod.net>
 <4aa29433-e7f9-f225-5bdf-c80638c936e8@huawei.com> <Y7vXSAGHf08p2Zbm@kadam>
 <af0d7337-3a92-5eca-7d7c-cc09d5713589@huawei.com> <Y7vqdgvxQVNvu6AY@kadam>
 <0dab9d74-6a41-9cf3-58fb-9fbb265efdd0@huawei.com> <Y7wAITZ/Ae/SwH9m@kadam>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <Y7wAITZ/Ae/SwH9m@kadam>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


1/9/2023 2:53 PM, Dan Carpenter пишет:
> On Mon, Jan 09, 2023 at 02:39:36PM +0300, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 1/9/2023 1:20 PM, Dan Carpenter пишет:
>> > On Mon, Jan 09, 2023 at 12:26:52PM +0300, Konstantin Meskhidze (A) wrote:
>> > > 
>> > > 
>> > > 1/9/2023 11:58 AM, Dan Carpenter пишет:
>> > > > These warnings seem like something I have seen before.  Maybe it was an
>> > > > issue with _Generic() support?
>> > > > > Are you really sure you're running the latest git version of
>> > > Sparse?
>> > > > > I tested this patch with the latest version of Sparse on my
>> > > system and
>> > > > it worked fine.
>> > > 
>> > >  Hi Dan,
>> > > 
>> > >  git is on the master branch now - hash ce1a6720 (dated 27 June 2022)
>> > > 
>> > >  Is this correct version?
>> > 
>> > Yes, that's correct.  What is your .config?
>> 
>>   What parameters do I need to check in .config?
> 
> I don't know.  I was hoping you could just email me the whole thing
> and/or the results from make security/landlock/ruleset.i.  That way
> we could see what line was making Sparse complain.

   here is the whole error message:

   make C=2 security/landlock/
   CHECK   scripts/mod/empty.c
   CALL    scripts/checksyscalls.sh
   DESCEND objtool
   DESCEND bpf/resolve_btfids
   CHECK   security/landlock/setup.c
./include/asm-generic/rwonce.h:67:16: error: typename in expression
./include/asm-generic/rwonce.h:67:16: error: Expected ) in function call
./include/asm-generic/rwonce.h:67:16: error: got :
./include/linux/list.h:292:16: error: typename in expression
./include/linux/list.h:292:16: error: Expected ) in function call
./include/linux/list.h:292:16: error: got :
./include/linux/list.h:328:34: error: typename in expression
./include/linux/list.h:328:34: error: Expected ) in function call
./include/linux/list.h:328:34: error: got :
./include/linux/list.h:329:53: error: typename in expression
./include/linux/list.h:329:53: error: Expected ) in function call
./include/linux/list.h:329:53: error: got :
./include/linux/list.h:867:17: error: typename in expression
./include/linux/list.h:867:17: error: Expected ) in function call
./include/linux/list.h:867:17: error: got :
./include/linux/list.h:876:17: error: typename in expression
./include/linux/list.h:876:17: error: Expected ) in function call
./include/linux/list.h:876:17: error: got :
./arch/x86/include/asm/atomic.h:29:16: error: typename in expression
./arch/x86/include/asm/atomic.h:29:16: error: Expected ) in function call
./arch/x86/include/asm/atomic.h:29:16: error: got :
./arch/x86/include/asm/atomic64_64.h:22:16: error: typename in expression
./arch/x86/include/asm/atomic64_64.h:22:16: error: Expected ) in 
function call
./arch/x86/include/asm/atomic64_64.h:22:16: error: got :
./include/linux/atomic/atomic-arch-fallback.h:227:23: error: typename in 
expression
./include/linux/atomic/atomic-arch-fallback.h:227:23: error: Expected ) 
in function call
./include/linux/atomic/atomic-arch-fallback.h:227:23: error: got :
./include/linux/atomic/atomic-arch-fallback.h:1348:23: error: typename 
in expression
./include/linux/atomic/atomic-arch-fallback.h:1348:23: error: Expected ) 
in function call
./include/linux/atomic/atomic-arch-fallback.h:1348:23: error: got :
./include/linux/jump_label.h:286:9: error: Expected ; at end of statement
./include/linux/jump_label.h:286:9: error: got __flags
./include/linux/jump_label.h:302:9: error: Expected ; at end of statement
./include/linux/jump_label.h:302:9: error: got __flags
./include/linux/jump_label.h:319:9: error: Expected ; at end of statement
./include/linux/jump_label.h:319:9: error: got __flags
./include/linux/jump_label.h:322:17: error: Expected ; at end of statement
./include/linux/jump_label.h:322:17: error: got __flags
./include/linux/jump_label.h:330:9: error: Expected ; at end of statement
./include/linux/jump_label.h:330:9: error: got __flags
./include/linux/jump_label.h:333:17: error: Expected ; at end of statement
./include/linux/jump_label.h:333:17: error: got __flags
./include/asm-generic/bitops/generic-non-atomic.h:140:23: error: 
typename in expression
./include/asm-generic/bitops/generic-non-atomic.h:140:23: error: 
Expected ) in function call
./include/asm-generic/bitops/generic-non-atomic.h:140:23: error: got :
./include/linux/bitmap.h:268:17: error: Expected ; at end of statement
./include/linux/bitmap.h:268:17: error: got __flags
./include/linux/thread_info.h:127:16: error: typename in expression
./include/linux/thread_info.h:127:16: error: Expected ) in function call
./include/linux/thread_info.h:127:16: error: got :
./include/linux/thread_info.h:233:13: error: Expected ; at end of statement
./include/linux/thread_info.h:233:13: error: got __flags
./include/linux/llist.h:191:16: error: typename in expression
./include/linux/llist.h:191:16: error: Expected ) in function call
./include/linux/llist.h:191:16: error: got :
./include/linux/rcupdate.h:1073:31: error: typename in expression
./include/linux/rcupdate.h:1073:31: error: Expected ) in function call
./include/linux/rcupdate.h:1073:31: error: got :
./include/linux/rcupdate.h:1077:9: error: Expected ; at end of statement
./include/linux/rcupdate.h:1077:9: error: got __flags
./include/linux/key.h:453:16: error: typename in expression
./include/linux/key.h:453:16: error: Expected ) in function call
./include/linux/key.h:453:16: error: got :
./include/linux/list_bl.h:74:33: error: typename in expression
./include/linux/list_bl.h:74:33: error: Expected ) in function call
./include/linux/list_bl.h:74:33: error: got :
./include/linux/rculist_bl.h:24:33: error: typename in expression
./include/linux/rculist_bl.h:24:33: error: Expected ) in function call
./include/linux/rculist_bl.h:24:33: error: got :
./include/linux/seqlock.h:259:16: error: typename in expression
./include/linux/seqlock.h:259:16: error: Expected ) in function call
./include/linux/seqlock.h:259:16: error: got :
./include/linux/seqlock.h:274:1: error: typename in expression
./include/linux/seqlock.h:274:1: error: Expected ) in function call
./include/linux/seqlock.h:274:1: error: got :
./include/linux/seqlock.h:274:1: error: typename in expression
./include/linux/seqlock.h:274:1: error: Expected ) in function call
./include/linux/seqlock.h:274:1: error: got :
./include/linux/seqlock.h:275:1: error: typename in expression
./include/linux/seqlock.h:275:1: error: Expected ) in function call
./include/linux/seqlock.h:275:1: error: got :
./include/linux/seqlock.h:275:1: error: typename in expression
./include/linux/seqlock.h:275:1: error: Expected ) in function call
./include/linux/seqlock.h:275:1: error: got :
./include/linux/seqlock.h:276:1: error: typename in expression
./include/linux/seqlock.h:276:1: error: Expected ) in function call
./include/linux/seqlock.h:276:1: error: got :
./include/linux/seqlock.h:276:1: error: typename in expression
./include/linux/seqlock.h:276:1: error: Expected ) in function call
./include/linux/seqlock.h:276:1: error: got :
./include/linux/seqlock.h:277:1: error: typename in expression
./include/linux/seqlock.h:277:1: error: Expected ) in function call
./include/linux/seqlock.h:277:1: error: got :
./include/linux/seqlock.h:277:1: error: typename in expression
./include/linux/seqlock.h:277:1: error: Expected ) in function call
./include/linux/seqlock.h:277:1: error: got :
./include/linux/seqlock.h:429:16: error: typename in expression
./include/linux/seqlock.h:429:16: error: Expected ) in function call
./include/linux/seqlock.h:429:16: error: got :
./include/linux/seqlock.h:682:16: error: typename in expression
./include/linux/seqlock.h:682:16: error: Expected ) in function call
./include/linux/seqlock.h:682:16: error: too many errors
Segmentation fault (core dumped)
make[3]: *** [scripts/Makefile.build:251: security/landlock/setup.o] 
Error 139
make[2]: *** [scripts/Makefile.build:502: security/landlock] Error 2
make[1]: *** [scripts/Makefile.build:502: security] Error 2
make: *** [Makefile:1994: .] Error 2

Please tell me if you need some more info.

regards,
Konstantin

> 
> regards,
> dan carpenter
> 
> .
