Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC6623DDD
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 18:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389925AbfETQxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 12:53:24 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32819 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389148AbfETQxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 12:53:24 -0400
Received: by mail-pf1-f196.google.com with SMTP id z28so7534564pfk.0
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 09:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=c20f3Uy5AB/Gpwno1cTjtsaMqlmM2s5OZcsDjKv33Gg=;
        b=x6exvqB1OaLuoM/xTiWeSQdbIEXNbyjWXnZRBmL+g2ZZMe3hd+o7640/p7qsiaTP5w
         YeRJt7aoK8jBv2DKS7z0F9Sx6bYhOMvuTSqpXojvsPXjT1ZZFb+ujclCy7ljg653sEB1
         AmJeuNL6lUkF8vcSARDLqFL8iDbu/xiLz0mYarz0FK9VmjhUgL1bBne7TZAJ9McuIl+3
         vZiJMo+riMWztQ8K6fvfhmjfFUtio+9UH/T86P5BfsCJxcHSZ/K+AOCYyiYu5oUHRws8
         jPw4cOty4/yPUpmBKG5PA/ApMGHqVKRwqdC86vHbVWHACmYSmrSvuahUUR4KuNxipXGS
         Dvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=c20f3Uy5AB/Gpwno1cTjtsaMqlmM2s5OZcsDjKv33Gg=;
        b=R9Szs5EFjnmW85nbapkyX7EVEjPTQuBOrPGPF8vXIK80bMNZ2m9wsm+P20pEcG9STn
         cGTZu9pa2NEyY94vjrArpBKMxk4vDvsvnxE30e5GGlR3i+2udLsZMSamtEMVZz+ujAUS
         OqrwpEd73cqABcBLVigvsy42Ahra/necCm7n4eTrWF466iVYAIpm8GefGVEzyJUf5sbt
         qvXW2T5h6e9/qyr99oF8739lzbAjbnKvQtQndjq0p3S1aATWMxFkhC8oUeIzUHm6Wi+B
         MbroIWtmHFW+C6HGTFMK8WioQddpnLIGTVcPCeYqFLQFFwYnx8sW6Js3sf8SUh8OYOlD
         d+OQ==
X-Gm-Message-State: APjAAAUuSpoeZSLaHAqgkIN6+L5vywkkrHVQ22hxBUT8IFOnLv0rB/mo
        YilyXrgzBjVpy/E/85FGCpxIhA==
X-Google-Smtp-Source: APXvYqwNXBSATkDA+MTsDrIhuYp39xzy7Plfkd7vDczjkfCUq8ddFXOENvNKA9O8rggfnMmevZUPww==
X-Received: by 2002:a62:575b:: with SMTP id l88mr80907008pfb.143.1558371203496;
        Mon, 20 May 2019 09:53:23 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id k13sm14575196pgr.90.2019.05.20.09.53.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 09:53:22 -0700 (PDT)
Date:   Mon, 20 May 2019 09:53:22 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 2/5] libbpf: add missing typedef
Message-ID: <20190520165322.GH10244@mini-arch>
References: <20190518004639.20648-1-mcroce@redhat.com>
 <20190518004639.20648-2-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190518004639.20648-2-mcroce@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/18, Matteo Croce wrote:
> Sync tools/include/linux/types.h with the UAPI one to fix this build error:
> 
> make -C samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=samples/bpf/../../ O=
>   HOSTCC  samples/bpf/sock_example
> In file included from samples/bpf/sock_example.c:27:
> /usr/include/linux/ip.h:102:2: error: unknown type name ‘__sum16’
>   102 |  __sum16 check;
>       |  ^~~~~~~
> make[2]: *** [scripts/Makefile.host:92: samples/bpf/sock_example] Error 1
> make[1]: *** [Makefile:1763: samples/bpf/] Error 2
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  tools/include/linux/types.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
> index 154eb4e3ca7c..5266dbfee945 100644
> --- a/tools/include/linux/types.h
> +++ b/tools/include/linux/types.h
> @@ -58,6 +58,9 @@ typedef __u32 __bitwise __be32;
>  typedef __u64 __bitwise __le64;
>  typedef __u64 __bitwise __be64;
>  
> +typedef __u16 __bitwise __sum16;
> +typedef __u32 __bitwise __wsum;
If you do that, you should probably remove 'typedef __u16 __sum16;'
from test_progs.h:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/tree/tools/testing/selftests/bpf/test_progs.h#n13

> +
>  typedef struct {
>  	int counter;
>  } atomic_t;
> -- 
> 2.21.0
> 
