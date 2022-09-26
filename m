Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5808F5EADBB
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiIZRMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiIZRLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:11:38 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE5063F03;
        Mon, 26 Sep 2022 09:20:55 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ocqqT-0003m5-43; Mon, 26 Sep 2022 18:20:37 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ocqqS-0002Aw-J8; Mon, 26 Sep 2022 18:20:36 +0200
Subject: Re: [bpf-next v6 2/3] bpftool: Update doc (add autoattach to prog
 load)
To:     Wang Yufen <wangyufen@huawei.com>, quentin@isovalent.com,
        ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1664014430-5286-1-git-send-email-wangyufen@huawei.com>
 <1664014430-5286-2-git-send-email-wangyufen@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2b001fcb-4340-e1ba-4b84-a69c670cf09a@iogearbox.net>
Date:   Mon, 26 Sep 2022 18:20:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1664014430-5286-2-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26670/Mon Sep 26 10:00:52 2022)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/22 12:13 PM, Wang Yufen wrote:
> Add autoattach optional to prog load|loadall for supporting
> one-step load-attach-pin_link.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>   tools/bpf/bpftool/Documentation/bpftool-prog.rst | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index eb1b2a254eb1..2d9f27a0120f 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -31,7 +31,7 @@ PROG COMMANDS
>   |	**bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | **opcodes** | **visual** | **linum**}]
>   |	**bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | **opcodes** | **linum**}]
>   |	**bpftool** **prog pin** *PROG* *FILE*
> -|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**autoattach**]
>   |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>   |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>   |	**bpftool** **prog tracelog**
> @@ -131,7 +131,7 @@ DESCRIPTION
>   		  contain a dot character ('.'), which is reserved for future
>   		  extensions of *bpffs*.
>   
> -	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**autoattach**]
>   		  Load bpf program(s) from binary *OBJ* and pin as *PATH*.
>   		  **bpftool prog load** pins only the first program from the
>   		  *OBJ* as *PATH*. **bpftool prog loadall** pins all programs
> @@ -150,6 +150,15 @@ DESCRIPTION
>   		  Optional **pinmaps** argument can be provided to pin all
>   		  maps under *MAP_DIR* directory.
>   
> +		  If **autoattach** is specified program will be attached
> +		  before pin. In that case, only the link (representing the
> +		  program attached to its hook) is pinned, not the program as
> +		  such, so the path won't show in "**bpftool prog show -f**",
> +		  only show in "**bpftool link show -f**". Also, this only works
> +		  when bpftool (libbpf) is able to infer all necessary information
> +		  from the objectfile, in particular, it's not supported for all
> +		  program types.

Related to Quentin's comment, the documentation should also describe clear semantics
on what happens in failure case. I presume the use case you have in mind is to use
this facility for scripts e.g. to run/load some tests objs? Thus would be good to describe
to users what they need to do/clean up when things only partially succeed etc..

>   		  Note: *PATH* must be located in *bpffs* mount. It must not
>   		  contain a dot character ('.'), which is reserved for future
>   		  extensions of *bpffs*.
> 

