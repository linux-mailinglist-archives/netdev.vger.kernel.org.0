Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DBF5BF75F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiIUHPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiIUHPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:15:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3733B976;
        Wed, 21 Sep 2022 00:15:05 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MXV1r50cKz14RVq;
        Wed, 21 Sep 2022 15:10:56 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 15:15:02 +0800
Message-ID: <d937796a-48da-50b1-52ce-23aa3d022bf2@huawei.com>
Date:   Wed, 21 Sep 2022 15:15:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v4 2/3] bpftool: Update doc (add auto_attach to prog
 load)
To:     Quentin Monnet <quentin@isovalent.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
References: <1663037687-26006-1-git-send-email-wangyufen@huawei.com>
 <1663037687-26006-2-git-send-email-wangyufen@huawei.com>
 <6bed1b34-3e92-2deb-94b5-9c194c6c7e6c@isovalent.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <6bed1b34-3e92-2deb-94b5-9c194c6c7e6c@isovalent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/20 23:12, Quentin Monnet 写道:
> Tue Sep 13 2022 03:54:46 GMT+0100 (British Summer Time) ~ Wang Yufen
> <wangyufen@huawei.com>
>> Add auto_attach optional to prog load|loadall for supporting
>> one-step load-attach-pin_link.
>>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   tools/bpf/bpftool/Documentation/bpftool-prog.rst | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
>> index eb1b2a2..463f895 100644
>> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
>> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
>> @@ -31,7 +31,7 @@ PROG COMMANDS
>>   |	**bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | **opcodes** | **visual** | **linum**}]
>>   |	**bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | **opcodes** | **linum**}]
>>   |	**bpftool** **prog pin** *PROG* *FILE*
>> -|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
>> +|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>>   |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>>   |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>>   |	**bpftool** **prog tracelog**
>> @@ -131,7 +131,7 @@ DESCRIPTION
>>   		  contain a dot character ('.'), which is reserved for future
>>   		  extensions of *bpffs*.
>>   
>> -	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
>> +	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>>   		  Load bpf program(s) from binary *OBJ* and pin as *PATH*.
>>   		  **bpftool prog load** pins only the first program from the
>>   		  *OBJ* as *PATH*. **bpftool prog loadall** pins all programs
>> @@ -150,6 +150,14 @@ DESCRIPTION
>>   		  Optional **pinmaps** argument can be provided to pin all
>>   		  maps under *MAP_DIR* directory.
>>   
>> +		  If **auto_attach** is specified program will be attached
>> +		  before pin. 1)in that case, only the link (representing the program
> "1)in" -> "In"
>
>> +		  attached to its hook) is pinned, not the program as such, so the
>> +		  path won't show in "bpftool prog show -f", only show in
> Let's use markup instead of quotes around the commands please, **bpftool
> prog show -f** and **bpftool link show -f** (below).
>
>> +		  "bpftool link show -f", and 2)this only works when bpftool (libbpf)
> ", and 2)this..." -> ". Also, this..."
>
>> +		  is able to infer all necessary information from the object file,
>> +		  in particular, it's not supported for all program types.
>> +
>>   		  Note: *PATH* must be located in *bpffs* mount. It must not
>>   		  contain a dot character ('.'), which is reserved for future
>>   		  extensions of *bpffs*.
> Apart from the formatting nits above, looks good, thank you.
Thanks， will send v5
