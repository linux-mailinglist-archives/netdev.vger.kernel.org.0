Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34FE5BE9C1
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiITPMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiITPMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:12:30 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7065418E16
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:12:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r7so4857370wrm.2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Edc5vm8+HRg8OvueT4HffnM8lhoUQsfY1q2oyUaLegM=;
        b=O0ko2PMRP4hSqwQ+T2uyZeknljuCg085maL0c/OFwwKxfUIgM23Tp/gpv9VSx0Sueh
         yhAwQ/pigKIYkkyYhQbPHlE3Ew6cvxQpCa5dDhu2+mjrRRPNf1SH8Km06aWjC6aydtE3
         l9Y4ygxtXGRxk3EMUQ4ge6qV/KOKaILoUikseuM4EEWMn/38LQ3bQAMbn9Ro/vDz/EnI
         oA5CPjQyNx+lwPwJsO+yOAE69qofPcxWjr1bxd6nlJHV8RsK0cTd3Z4HfbC0ucGVRKef
         RMMJ3yZlrNOK5IkjsZyaLD4rS/cEvI9dg6F8yX6zjaB4gxwLfaa9LXGRb/ffzkM0FjiX
         pvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Edc5vm8+HRg8OvueT4HffnM8lhoUQsfY1q2oyUaLegM=;
        b=7GJSfgXtfIzJf5p6uL6cnlvO0QWbplBp/Cf2cwCHA3w2e/LiwkyjixHXjCSwQ6ClO/
         lmsuaA8tNzdJOiBjaaShTneWRBD+DUMQ04mk0fugam6HL66GcJVI5vp1mLiyBzPlYnZr
         mNLBHhfM/mzc8I5jc9sQCuMwMNQNGWiGPCOsaYPV9vwXOOmSzeFgAx1XFL1TOMfXey/W
         q9T0vMC+tkfJLn7dhx2qvT2jo/mo4ESeIkjRvjmjGLD2RlCdJ5HvUJ4IhyE54mwoRach
         YhYySN/9s1cVsyCMf1XbCtiISXaQjxFcG+9TEOArN24N3vczOH2tXOisficrJ9ruDOJE
         xn+g==
X-Gm-Message-State: ACrzQf0ci54GS2umsnGWYteAtpbZdN/NNW6ytgB4Lb/6E7mPw+K5AVdW
        K3AwA/1me2AjSq4NPEb4ZBdzfw==
X-Google-Smtp-Source: AMsMyM4u7M8Oa3I0tiFWjywE/WPatGo9t8jr+6HvqPcpjnCsdmlW3DJa0sFe70cyd5vWJDPhvhUEkQ==
X-Received: by 2002:a5d:67ca:0:b0:228:7ad5:768f with SMTP id n10-20020a5d67ca000000b002287ad5768fmr14282120wrw.163.1663686746950;
        Tue, 20 Sep 2022 08:12:26 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id v10-20020a5d590a000000b002206203ed3dsm34079wrd.29.2022.09.20.08.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 08:12:26 -0700 (PDT)
Message-ID: <6bed1b34-3e92-2deb-94b5-9c194c6c7e6c@isovalent.com>
Date:   Tue, 20 Sep 2022 16:12:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [bpf-next v4 2/3] bpftool: Update doc (add auto_attach to prog
 load)
Content-Language: en-GB
To:     Wang Yufen <wangyufen@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1663037687-26006-1-git-send-email-wangyufen@huawei.com>
 <1663037687-26006-2-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1663037687-26006-2-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue Sep 13 2022 03:54:46 GMT+0100 (British Summer Time) ~ Wang Yufen
<wangyufen@huawei.com>
> Add auto_attach optional to prog load|loadall for supporting
> one-step load-attach-pin_link.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool-prog.rst | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index eb1b2a2..463f895 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -31,7 +31,7 @@ PROG COMMANDS
>  |	**bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | **opcodes** | **visual** | **linum**}]
>  |	**bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | **opcodes** | **linum**}]
>  |	**bpftool** **prog pin** *PROG* *FILE*
> -|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>  |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |	**bpftool** **prog tracelog**
> @@ -131,7 +131,7 @@ DESCRIPTION
>  		  contain a dot character ('.'), which is reserved for future
>  		  extensions of *bpffs*.
>  
> -	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>  		  Load bpf program(s) from binary *OBJ* and pin as *PATH*.
>  		  **bpftool prog load** pins only the first program from the
>  		  *OBJ* as *PATH*. **bpftool prog loadall** pins all programs
> @@ -150,6 +150,14 @@ DESCRIPTION
>  		  Optional **pinmaps** argument can be provided to pin all
>  		  maps under *MAP_DIR* directory.
>  
> +		  If **auto_attach** is specified program will be attached
> +		  before pin. 1)in that case, only the link (representing the program

"1)in" -> "In"

> +		  attached to its hook) is pinned, not the program as such, so the
> +		  path won't show in "bpftool prog show -f", only show in

Let's use markup instead of quotes around the commands please, **bpftool
prog show -f** and **bpftool link show -f** (below).

> +		  "bpftool link show -f", and 2)this only works when bpftool (libbpf)

", and 2)this..." -> ". Also, this..."

> +		  is able to infer all necessary information from the object file,
> +		  in particular, it's not supported for all program types.
> +
>  		  Note: *PATH* must be located in *bpffs* mount. It must not
>  		  contain a dot character ('.'), which is reserved for future
>  		  extensions of *bpffs*.

Apart from the formatting nits above, looks good, thank you.
