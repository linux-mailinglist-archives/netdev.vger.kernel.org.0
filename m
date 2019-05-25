Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C773A2A446
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 13:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfEYLzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 07:55:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35556 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfEYLzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 07:55:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so12419831wrv.2
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 04:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CsIarrO2L5WOB1SMV5+alsBx9LCjTDuPLbeAGtbhW7Q=;
        b=D5FdVLiwCcZS1Lkl0Mb15BfbPGqf9qivdqrKsWL5OYV7Y1qWfmFFZWPoqqa6i+IyAK
         z8/x3qEgA4fSQsL0AEOawi674itLRS9VS+IemoOs7Wpj+6K1Bk7yIC5mMpsUvwCKy8F0
         3ow5byTCGiukQ9EQfReM7VW8jVK67BOpoE+vRPSkhteGn+HhrLhNsEpuVQVFlC3MlCi5
         wmOO6X4m8Ppj0/wlnCP5xrtVyPRYKEfXQp0pik1ObmrwFjyhNjJHhpB0JRESTseMMoQ0
         +MlQ9p5l/D7MPlI1vBFbD/DXjOIoSNkP91k2xsglyqyoL0KaXIzbwQdpLv9dJ7ByDfOr
         JJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CsIarrO2L5WOB1SMV5+alsBx9LCjTDuPLbeAGtbhW7Q=;
        b=mW0n9XRgNu+MxntQ/3oE9RKPbvbiVL8Tmn8TwkrT2EnwUqG7K2pXcDe+HuEog5e46o
         co5eX4d9wQI7X7wrputrFHjg3PNXsGKwkcOVupL1PU7PzuWMfVNgiOeV1t3PbKvgGRwg
         4h8fVVUZBpHA8qxvpwsWj4n2i2xDDUonOKBtre2VUQMAETL10aqCzdTtVKMmFDLaBmeq
         96YwuMdMpblmSICGql+WhhQgsrpKqy5qu2WsA7HQLWCj7CxdDBCU/AxR0O09W5N4KWqH
         QZpCLM4WQ4B7/FJVLT+QMJ/juUtnqClbg77BQpaqZGx3WJW5OxOi2Mi1Oqslnk/11YsZ
         Trew==
X-Gm-Message-State: APjAAAXgmDVpXGd7xV9HqsZBNmYZaJxNspLFjEfaM5gC59FylgatZ45x
        2MvSVflJt0T2dxG5IXV92zZo2A==
X-Google-Smtp-Source: APXvYqwkHNvD4zZ7FtIyBqKk4F+kYfrYOK5TZYZ09Nr2NSSmHgsLgAhSCW4q/8whTVypntU59myCpg==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr59322659wrj.182.1558785317332;
        Sat, 25 May 2019 04:55:17 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.20])
        by smtp.gmail.com with ESMTPSA id x1sm7977487wrp.35.2019.05.25.04.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 04:55:16 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpftool: auto-complete BTF IDs for btf dump
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        ast@fb.com, daniel@iogearbox.net
References: <20190525053809.1207929-1-andriin@fb.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <3543ed02-97f5-8d55-58d7-29f66220bacc@netronome.com>
Date:   Sat, 25 May 2019 12:55:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190525053809.1207929-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-24 22:38 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Auto-complete BTF IDs for `btf dump id` sub-command. List of possible BTF
> IDs is scavenged from loaded BPF programs that have associated BTFs, as
> there is currently no API in libbpf to fetch list of all BTFs in the
> system.
> 
> Suggested-by: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/bash-completion/bpftool | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 75c01eafd3a1..9fbc33e93689 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -71,6 +71,13 @@ _bpftool_get_prog_tags()
>          command sed -n 's/.*"tag": "\(.*\)",$/\1/p' )" -- "$cur" ) )
>  }
>  
> +_bpftool_get_btf_ids()
> +{
> +    COMPREPLY+=( $( compgen -W "$( bpftool -jp prog 2>&1 | \
> +        command sed -n 's/.*"btf_id": \(.*\),\?$/\1/p' | \
> +        command sort -nu )" -- "$cur" ) )
> +}

Thanks! It works well. It looks like the "sort -nu" is not required,
however? Bash completion on my system seems to run the equivalent of
"sort -u" on the results anyway, ignoring the ordering you made just
before. As I understand this is what completion always does, unless we
pass "-o nosort" to "complete".

E.g. I get the same following output:

	1     1234  191   222   25

When completing with this function:

	_bpftool()
	{
		COMPREPLY+=( $( compgen -W "$( \
			command echo '1 1 1 191 1234 25 222')"))
	}
	complete -F _bpftool bpftool

or with that one:

	_bpftool()
	{
		COMPREPLY+=( $( compgen -W "$( \
			command echo '1 1 1 191 1234 25 222' | \
			command sort -nu )" ) )
	}
	complete -F _bpftool bpftool

Could you double check you have the same thing on your setup, please? If
so we can just remove the "sort -nu".

Quentin
