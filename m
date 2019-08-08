Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E04D86772
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404172AbfHHQso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:48:44 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:43359 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHQso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 12:48:44 -0400
Received: by mail-wr1-f46.google.com with SMTP id p13so21017157wru.10
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 09:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ik0tB7a65fu1lS8UXFDknSwtrLbHMgx6PQIkEy3rTKY=;
        b=FnqvZLQabJkA9qdn+4b7jIJkELkRdLrWu9OikleSjLfPjI4+h72nQ8F62GkUqNej2S
         3J4XOMLut6YEeiDfARHTRTv5x38Chy1tgZmcRtsc8zsZPC+i/aAgR3kKjbv3qScD/ZwV
         0QdRtSYRwf1rXUehfpe7qi7AM7heEyTGBZ9M37hskZdoqxXLD1Yokgx5W2PeL4yn1uLZ
         38ugkg1yhevaBUpyEkK90iBVCQICeE3iDY09DHRlySVJGfMp3hRx9RiuroL5FuunXlyA
         ME8RfAZgXMbsXAu9Ep3V00j2h94JArs9ip+jtrLqBfpRkoCCVdQvtssWwR1cQdPJW62v
         3how==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ik0tB7a65fu1lS8UXFDknSwtrLbHMgx6PQIkEy3rTKY=;
        b=aWQoMHoo+UhqKdJL1xVQN3jJ7PiHBFDC/hwLIkG4oZU3d0kcOS2NkPcdB0CEiOPvRc
         /JduoMKKehfOTCOPO+abuNazRa7nDydQuOOdNApP7EE1r50qCufVXgJANdzfpV8MYPVA
         XEyvIcsECeo6+vc3RiMSfWc1AuA2gmQVFNhqRYdJlkwrsfzQL9C9Pm4BdzQLF/BTsZWv
         UTV5VW+34qXTvy60l2lmoCaWjOLBlYWAr9b7nF4U4UqwdKonzdrVOTsKyGyRRLznUmpH
         j6O8lfimwHbgQLFlDLwGf0v8AZdC1REIRzQY9M5OnsjOqxRe3fubM77rt5ZNJMdpqXoC
         /d+w==
X-Gm-Message-State: APjAAAU4vuaBvVUfhM1AP3EvQkhhHsLQ3XG4W2I00xew6hrIns8Ucd5S
        gzxzEuRA0u3GjyCPxhTkcjvhdGynBao=
X-Google-Smtp-Source: APXvYqy+90VgioYFif7mbHxlavdCERbSrLSI7embJ8fzxdiEO06uAB9Morfbo7VO44wZo9g6dQRzwA==
X-Received: by 2002:adf:8364:: with SMTP id 91mr18103794wrd.13.1565282920839;
        Thu, 08 Aug 2019 09:48:40 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id o20sm241944268wrh.8.2019.08.08.09.48.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 09:48:40 -0700 (PDT)
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190807022509.4214-1-danieltimlee@gmail.com>
 <20190807022509.4214-4-danieltimlee@gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [v3,3/4] tools: bpftool: add bash-completion for net
 attach/detach
Message-ID: <5cd88036-8682-8d26-b795-caf96e1e883f@netronome.com>
Date:   Thu, 8 Aug 2019 17:48:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807022509.4214-4-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-07 11:25 UTC+0900 ~ Daniel T. Lee <danieltimlee@gmail.com>
> This commit adds bash-completion for new "net attach/detach"
> subcommand for attaching XDP program on interface.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  tools/bpf/bpftool/bash-completion/bpftool | 64 +++++++++++++++++++----
>  1 file changed, 55 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index c8f42e1fcbc9..1d81cb09d478 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -201,6 +201,10 @@ _bpftool()
>              _bpftool_get_prog_tags
>              return 0
>              ;;
> +        dev)
> +            _sysfs_get_netdevs
> +            return 0
> +            ;;

Makes sense to have this for "dev", thanks! But it seems you missed one
place where it was used, for "bpftool feature probe" (We have "[[ $prev
== "dev" ]] && _sysfs_get_netdevs && return 0"). Could you also remove
that one please?

Other than this looks good, thanks:

Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
