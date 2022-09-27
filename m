Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AC5EC091
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 13:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiI0LII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 07:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiI0LHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 07:07:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A76C4C601;
        Tue, 27 Sep 2022 04:05:37 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4McGrJ1gmxzHtcW;
        Tue, 27 Sep 2022 19:00:48 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 19:05:34 +0800
Message-ID: <f34e0c32-34b5-bca5-b71a-5d588caf1c2f@huawei.com>
Date:   Tue, 27 Sep 2022 19:05:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v6 2/3] bpftool: Update doc (add autoattach to prog
 load)
To:     Daniel Borkmann <daniel@iogearbox.net>, <quentin@isovalent.com>,
        <ast@kernel.org>, <andrii@kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <nathan@kernel.org>, <ndesaulniers@google.com>,
        <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
References: <1664014430-5286-1-git-send-email-wangyufen@huawei.com>
 <1664014430-5286-2-git-send-email-wangyufen@huawei.com>
 <2b001fcb-4340-e1ba-4b84-a69c670cf09a@iogearbox.net>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <2b001fcb-4340-e1ba-4b84-a69c670cf09a@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/27 0:20, Daniel Borkmann 写道:
> On 9/24/22 12:13 PM, Wang Yufen wrote:
>> Add autoattach optional to prog load|loadall for supporting
>> one-step load-attach-pin_link.
>>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   tools/bpf/bpftool/Documentation/bpftool-prog.rst | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst 
>> b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
>> index eb1b2a254eb1..2d9f27a0120f 100644
>> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
>> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
>> @@ -31,7 +31,7 @@ PROG COMMANDS
>>   |    **bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | 
>> **opcodes** | **visual** | **linum**}]
>>   |    **bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | 
>> **opcodes** | **linum**}]
>>   |    **bpftool** **prog pin** *PROG* *FILE*
>> -|    **bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* 
>> [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] 
>> [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
>> +|    **bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* 
>> [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] 
>> [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**autoattach**]
>>   |    **bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>>   |    **bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>>   |    **bpftool** **prog tracelog**
>> @@ -131,7 +131,7 @@ DESCRIPTION
>>             contain a dot character ('.'), which is reserved for future
>>             extensions of *bpffs*.
>>   -    **bpftool prog { load | loadall }** *OBJ* *PATH* [**type** 
>> *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** 
>> *NAME*] [**pinmaps** *MAP_DIR*]
>> +    **bpftool prog { load | loadall }** *OBJ* *PATH* [**type** 
>> *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** 
>> *NAME*] [**pinmaps** *MAP_DIR*] [**autoattach**]
>>             Load bpf program(s) from binary *OBJ* and pin as *PATH*.
>>             **bpftool prog load** pins only the first program from the
>>             *OBJ* as *PATH*. **bpftool prog loadall** pins all programs
>> @@ -150,6 +150,15 @@ DESCRIPTION
>>             Optional **pinmaps** argument can be provided to pin all
>>             maps under *MAP_DIR* directory.
>>   +          If **autoattach** is specified program will be attached
>> +          before pin. In that case, only the link (representing the
>> +          program attached to its hook) is pinned, not the program as
>> +          such, so the path won't show in "**bpftool prog show -f**",
>> +          only show in "**bpftool link show -f**". Also, this only 
>> works
>> +          when bpftool (libbpf) is able to infer all necessary 
>> information
>> +          from the objectfile, in particular, it's not supported for 
>> all
>> +          program types.
>
> Related to Quentin's comment, the documentation should also describe 
> clear semantics
> on what happens in failure case. I presume the use case you have in 
> mind is to use
> this facility for scripts e.g. to run/load some tests objs? Thus would 
> be good to describe
> to users what they need to do/clean up when things only partially 
> succeed etc..


Thanks for your comment.
add in v7, please check.

>
>>             Note: *PATH* must be located in *bpffs* mount. It must not
>>             contain a dot character ('.'), which is reserved for future
>>             extensions of *bpffs*.
>>
>
>
