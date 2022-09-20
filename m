Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC75BE9C9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiITPNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiITPM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:12:59 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4493ED7A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:12:55 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id e18so2168408wmq.3
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vvnaISRyDO+wyF/zyk6fq41j/OaXjIWzqbLONv3536s=;
        b=fsTHogJl2vm0IGtQVzBEIlBvrN6arirK7KE9uUIUIdD6XO3LoHVFspMWJnMYobEZ19
         Tnr01VwqhlyLxilXd+cGXfjZEH0W7tq4wSM6uMOY/BGHNqlz0OBgn+w4r0oW8tH/tT+h
         b5xdW+IvasH4FdhqnPLbqRfQSSon7EoEmRkVt23gWu2A51wzPCBCuqmSct0T3gOZvRmj
         6dTZYuSlcbD5ZnCPzD0un7fSx4UMiNv241APtXLWqXgmrN4KpoQ3kD8cRk7oUVRa0VUO
         c+hpt1nMUt4svsYp6EPIXTARQdwObZrIVByp7HclH7wUptqVNnxFp/BObzY4R6PCyb1F
         VNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vvnaISRyDO+wyF/zyk6fq41j/OaXjIWzqbLONv3536s=;
        b=d+exYtZaDsuG9RayoHjbnJotvqmMbq0tw+Bbg56ghD2ra6yY5a7VvTU/SEkFU6n+oj
         eLdrhAR0yPY9TIEMyLM8Dj3xkg65qqTOB3yla7l6Kt6Kmi9lRm2/4kvd97LT9YdyBjb2
         E+12nobX3CCuqmEBfvFzi3d+8efLAk1gaKT6VIu0tkazTqiSE9wR5ohHAYj3s4i3book
         avwYSYkvsyALuyf6TiB4UUJ0TPFvmPZ7FcedA4FOEnSFRTb5H1SVxUlNIy5tA0loCiDA
         UnUQ2y5W7grgKeUkVCEan7XILxGVzKY8hklWwMy3z1lRBnOAA/rthVZ2I4gKumKmXN1S
         jLgA==
X-Gm-Message-State: ACrzQf3g9ir4Od1KMNFWPLhz9KB+m6Aus400SrQ23aatWoeeg38LmQ4q
        ytRP8RmHhVRs5kecDX/E/xq80A==
X-Google-Smtp-Source: AMsMyM4udr1W3bHW44bQQIPh2gcs1ur29uywFTAjmVPsve4+Yljn0LIt7TSumHS1ZcgmvCCXEU2gvg==
X-Received: by 2002:a7b:c34b:0:b0:3a6:8516:a729 with SMTP id l11-20020a7bc34b000000b003a68516a729mr2888644wmj.83.1663686773575;
        Tue, 20 Sep 2022 08:12:53 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id ba5-20020a0560001c0500b00228d183f9c2sm282541wrb.89.2022.09.20.08.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 08:12:53 -0700 (PDT)
Message-ID: <af301902-1e54-13cc-0a4c-3d724f1cb835@isovalent.com>
Date:   Tue, 20 Sep 2022 16:12:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [bpf-next v4 3/3] bpftool: Update the bash completion(add
 auto_attach to prog load)
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
 <1663037687-26006-3-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1663037687-26006-3-git-send-email-wangyufen@huawei.com>
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

Tue Sep 13 2022 03:54:47 GMT+0100 (British Summer Time) ~ Wang Yufen
<wangyufen@huawei.com>
> Add auto_attach optional to prog load|loadall for supporting
> one-step load-attach-pin_link.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/bpf/bpftool/bash-completion/bpftool | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index dc1641e..3f6f4f9 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -505,6 +505,7 @@ _bpftool()
>                              _bpftool_once_attr 'type'
>                              _bpftool_once_attr 'dev'
>                              _bpftool_once_attr 'pinmaps'
> +                            _bpftool_once_attr 'auto_attach'
>                              return 0
>                              ;;
>                      esac

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks
