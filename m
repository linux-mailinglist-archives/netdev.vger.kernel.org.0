Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F85B2E7F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 08:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIIGID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 02:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiIIGIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 02:08:00 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C333F9FBC;
        Thu,  8 Sep 2022 23:07:59 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MP57j3Zw2znV9L;
        Fri,  9 Sep 2022 14:05:21 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 14:07:56 +0800
Message-ID: <216ca3d8-cc7e-8bd8-1c39-cab701e33f21@huawei.com>
Date:   Fri, 9 Sep 2022 14:07:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [-next v2 2/2] bpftool: Update doc (add auto_attach to prog load)
From:   wangyufen <wangyufen@huawei.com>
To:     <quentin@isovalent.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
References: <1662702807-591-1-git-send-email-wangyufen@huawei.com>
 <1662702807-591-2-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1662702807-591-2-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore, will resend with 'bpf-next'

在 2022/9/9 13:53, Wang Yufen 写道:
> Add auto_attach optional to prog load|loadall for supporting
> one-step load-attach-pin_link.
>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>   tools/bpf/bpftool/Documentation/bpftool-prog.rst | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index eb1b2a2..c640ad3 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -31,7 +31,8 @@ PROG COMMANDS
>   |	**bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | **opcodes** | **visual** | **linum**}]
>   |	**bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | **opcodes** | **linum**}]
>   |	**bpftool** **prog pin** *PROG* *FILE*
> -|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] \
> +|               [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>   |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>   |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>   |	**bpftool** **prog tracelog**
> @@ -131,7 +132,7 @@ DESCRIPTION
>   		  contain a dot character ('.'), which is reserved for future
>   		  extensions of *bpffs*.
>   
> -	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>   		  Load bpf program(s) from binary *OBJ* and pin as *PATH*.
>   		  **bpftool prog load** pins only the first program from the
>   		  *OBJ* as *PATH*. **bpftool prog loadall** pins all programs
> @@ -149,6 +150,8 @@ DESCRIPTION
>   		  given networking device (offload).
>   		  Optional **pinmaps** argument can be provided to pin all
>   		  maps under *MAP_DIR* directory.
> +		  If **auto_attach** is specified program will be attached
> +		  before pin.
>   
>   		  Note: *PATH* must be located in *bpffs* mount. It must not
>   		  contain a dot character ('.'), which is reserved for future
