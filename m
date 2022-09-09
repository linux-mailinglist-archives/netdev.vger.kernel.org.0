Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2F65B3687
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 13:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiIILis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 07:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiIILie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 07:38:34 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D00C13D787
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 04:38:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k17so1172494wmr.2
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 04:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=HvNKBTw0L/lYKmZR35x7IEnP1bjDVpSzTqXAf0c4eyQ=;
        b=hmTnARBjoVStgQoPxT+j+rNvvQExGkJUi8pElnu3loRhAvKdMMUnJGmzWir30PUFdv
         qjpL2owE2PEG+kjT91XR1f47XCYDqVQuKNotrojQ64KoZuMEULKs1iE1G/yV6zV35RA2
         9sRfFk/1Igbk6vL1pxVzIcoXDho55Mhc6HEU6Sx2Vj1JJeDdUXOsaa59A2vo6HZj5vbq
         EczrmMLkIqcDxMpgpKyinY+pR/yjG7s+LMBO8fahuge8LD0DZERNkXqmULXwR3FMQoRr
         VBmsFut3XZwiySh18vSk6VGcSrohbjasBSS1+DJqwpRYOXnx6ACSiZfxo74k1EKLCJWW
         iyvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HvNKBTw0L/lYKmZR35x7IEnP1bjDVpSzTqXAf0c4eyQ=;
        b=pbLDfxuKNQH6NqGA+rE8WMKGEJGbivMs6padL5+Zt6Nq6COCuMteD0x5qUVNGEAn9K
         oMax717IsDHnfa5b2XwW8ONd3zosaw7mGBPEz65DwSeVHyP3+yFd0KmHBO4ULkHHHWHX
         cYYk80HscfFHpM2Ab5u6nsLXi7bnPtu1M5jYd6ODRJ71sNzh+Oy0bO3Y0nx9Tv4D8qkW
         jpEurKCEa8CRZa2NeM500iSyuHq6WRQoVvX1cTpb14vyAt737GE5eQDG8dk0HymiBOh1
         amBqSGhqu21BUXq1b7tObOplc2R/9/1UBjTOxUyy7veEY56hXojF3YEz5LmTJMWbrq/n
         QTcg==
X-Gm-Message-State: ACgBeo1lx2zmf6cKDIfTwjBNzzwWbMvyyN+NbnbVGSJC5ahzny86CoMs
        SdzqogWbyzh3GgaAFPBA2PEh6Q==
X-Google-Smtp-Source: AA6agR6ewvI4AXAvJtuQJzJV59HWk2gIoDBJ36WJdwkW12wvrg1/2LHRVT+8GbeMODjwSeXSCWlyLA==
X-Received: by 2002:a05:600c:1497:b0:3a5:f608:d765 with SMTP id c23-20020a05600c149700b003a5f608d765mr4946577wmh.19.1662723497872;
        Fri, 09 Sep 2022 04:38:17 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id j12-20020a05600c190c00b003b332a7bf15sm550688wmq.7.2022.09.09.04.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 04:38:17 -0700 (PDT)
Message-ID: <eedd6f65-0fb1-de2e-1a7d-702cf4e6e342@isovalent.com>
Date:   Fri, 9 Sep 2022 12:38:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [bpf-next v3 2/2] bpftool: Update doc (add auto_attach to prog
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
References: <1662704233-8805-1-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1662704233-8805-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2022 07:17, Wang Yufen wrote:
> Add auto_attach optional to prog load|loadall for supporting
> one-step load-attach-pin_link.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool-prog.rst | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index eb1b2a2..c640ad3 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -31,7 +31,8 @@ PROG COMMANDS
>  |	**bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | **opcodes** | **visual** | **linum**}]
>  |	**bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | **opcodes** | **linum**}]
>  |	**bpftool** **prog pin** *PROG* *FILE*
> -|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] \
> +|               [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]

Nit: Let's keep this on one line. Not necessary the best in the RST, but
I prefer to leave it to man to wrap the line on the generated page.

>  |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |	**bpftool** **prog tracelog**
> @@ -131,7 +132,7 @@ DESCRIPTION
>  		  contain a dot character ('.'), which is reserved for future
>  		  extensions of *bpffs*.
>  
> -	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
> +	**bpftool prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*] [**auto_attach**]
>  		  Load bpf program(s) from binary *OBJ* and pin as *PATH*.
>  		  **bpftool prog load** pins only the first program from the
>  		  *OBJ* as *PATH*. **bpftool prog loadall** pins all programs
> @@ -149,6 +150,8 @@ DESCRIPTION
>  		  given networking device (offload).
>  		  Optional **pinmaps** argument can be provided to pin all
>  		  maps under *MAP_DIR* directory.
> +		  If **auto_attach** is specified program will be attached
> +		  before pin.

I would like more precisions here, please. In particular, can you add
that 1) in that case, only the link (representing the program attached
to its hook) is pinned, not the program as such, so the path won't show
in "bpftool prog show -f" (I think), and 2) this only works when bpftool
(libbpf) is able to infer all necessary information from the object
file, in particular, it's not supported for all program types. Probably
worth adding an empty line before the description for auto_attach to
have it in a dedicated paragraph.

>  
>  		  Note: *PATH* must be located in *bpffs* mount. It must not
>  		  contain a dot character ('.'), which is reserved for future

Can you also update the bash completion, please? Just the following:


diff --git a/tools/bpf/bpftool/bash-completion/bpftool
b/tools/bpf/bpftool/bash-completion/bpftool
index dc1641e3670e..3f6f4f9c3e80 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -505,6 +505,7 @@ _bpftool()
                             _bpftool_once_attr 'type'
                             _bpftool_once_attr 'dev'
                             _bpftool_once_attr 'pinmaps'
+                            _bpftool_once_attr 'auto_attach'
                             return 0
                             ;;
                     esac

