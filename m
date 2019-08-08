Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE82786773
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404176AbfHHQsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:48:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51891 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHQsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 12:48:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so3074663wma.1
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7DbNTpBDyR0gJrQAZtE2rEQTa/g7wOQaWTWKLdoXwv8=;
        b=uLkpu2p6TyGLi4/GawsdqQa0qpCRfPNp8CzZ5CxfWneKgRpupnTI2JIBNMcmPCzxW1
         ND0Hm9D59EznxBXsxOJNWSdxVKaUhZyuP+/mYxjVxSjQeF8zcPE4SI+rr2BQrykGrHCz
         ipF4Gf3IycaeTfjy/ifWUsGxLt7kN/1GPez4UXyOZEjcIunpV7tUI2EcLfbC7NV9ewn7
         WI/QUjJPC70O3yB5XtbaEUkPxKN07SmrqYIZhVhM7NJrCmw5AkwDLBMbm0mM8cqyzO0v
         SYmCemdslVxFYVk6u//yhsdTujQLUrDGlWuirjbDpHb9M6RyX7dlbFv67kh0uzSontHM
         d24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7DbNTpBDyR0gJrQAZtE2rEQTa/g7wOQaWTWKLdoXwv8=;
        b=oV1r/5Xzdsi30fYgp9Suc5UVcvdd9QGSRYwndaaja+YD2SnqXdMsuE4mX0RHWS6WOm
         sMqiDB1EU57TS3iDTqjXlRMoUKHFCCBJ03Pg3cHtwT5BO5d7PCePWe0dpAWIDUTSlcol
         1Z8Tn9Oue7yHRucR86u+RdhMVmBVF+iXrM6zlFNV7lGDFwSc+CnM2HEoA3owNP2jgvf3
         lJUU4W3Ye+7OjPGdG3aLnh2hbmqz7/vGub+HjVtfivIdHw8j9+TxwknU2PfND45r33oW
         pmpiDVx0XBWq8WU0g8K/sYx9Yfwc8wocjqt9TSnmbu+37OjyZj65vtYlso80/OQlI3HH
         Lnsg==
X-Gm-Message-State: APjAAAVoOZxxSHpjmt8GgVKcylutPqZNUDfiR/Ch3YGAS0FQLU9D46VV
        sxLibhoL0RBktjucTCqNyktEy8CVpL0=
X-Google-Smtp-Source: APXvYqzVq9QEEvYkuNe+WrAXuUyigzvlSdxR7TNQr/Gr9+ihme1HMd7mozXDxN8Q9lOqIjd9mvNLEQ==
X-Received: by 2002:a1c:6145:: with SMTP id v66mr3933303wmb.42.1565282926940;
        Thu, 08 Aug 2019 09:48:46 -0700 (PDT)
Received: from [172.20.1.254] ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g2sm3339433wmh.0.2019.08.08.09.48.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 09:48:46 -0700 (PDT)
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190807022509.4214-1-danieltimlee@gmail.com>
 <20190807022509.4214-5-danieltimlee@gmail.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quentin.monnet@netronome.com; prefer-encrypt=mutual; keydata=
 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
 RHhSHGnKaQ6MfrTge5Q0h5A=
Subject: Re: [v3,4/4] tools: bpftool: add documentation for net attach/detach
Message-ID: <1cc16243-ad5a-87f3-7727-31a58599bf04@netronome.com>
Date:   Thu, 8 Aug 2019 17:48:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807022509.4214-5-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-08-07 11:25 UTC+0900 ~ Daniel T. Lee <danieltimlee@gmail.com>
> Since, new sub-command 'net attach/detach' has been added for
> attaching XDP program on interface,
> this commit documents usage and sample output of `net attach/detach`.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  .../bpf/bpftool/Documentation/bpftool-net.rst | 51 +++++++++++++++++--
>  1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> index d8e5237a2085..4ad1a380e186 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
> @@ -15,17 +15,22 @@ SYNOPSIS
>  	*OPTIONS* := { [{ **-j** | **--json** }] [{ **-p** | **--pretty** }] }
>  
>  	*COMMANDS* :=
> -	{ **show** | **list** } [ **dev** name ] | **help**
> +	{ **show** | **list** | **attach** | **detach** | **help** }
>  
>  NET COMMANDS
>  ============
>  
> -|	**bpftool** **net { show | list } [ dev name ]**
> +|	**bpftool** **net { show | list }** [ **dev** *name* ]
> +|	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *name* [ **overwrite** ]
> +|	**bpftool** **net detach** *ATTACH_TYPE* **dev** *name*

Nit: Could we have "name" in capital letters (everywhere in the file),
to make this file consistent with the formatting used for
bpftool-prog.rst and bpftool-map.rst?

>  |	**bpftool** **net help**
> +|
> +|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
> +|	*ATTACH_TYPE* := { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** }
>  
>  DESCRIPTION
>  ===========
> -	**bpftool net { show | list } [ dev name ]**
> +	**bpftool net { show | list }** [ **dev** *name* ]
>                    List bpf program attachments in the kernel networking subsystem.
>  
>                    Currently, only device driver xdp attachments and tc filter
> @@ -47,6 +52,18 @@ DESCRIPTION
>                    all bpf programs attached to non clsact qdiscs, and finally all
>                    bpf programs attached to root and clsact qdisc.
>  
> +	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *name* [ **overwrite** ]
> +                  Attach bpf program *PROG* to network interface *name* with
> +                  type specified by *ATTACH_TYPE*. Previously attached bpf program
> +                  can be replaced by the command used with **overwrite** option.
> +                  Currently, *ATTACH_TYPE* only contains XDP programs.

Other nit: "ATTACH_TYPE only contains XDP programs" sounds odd to me.
Could we maybe phrase this something like: "Currently, only XDP-related
modes are supported for ATTACH_TYPE"?

Also, could you please provide a brief description of the different
attach types? In particular, explaining what "xdp" alone stands for
might be useful.

Thanks,
Quentin

> +
> +	**bpftool** **net detach** *ATTACH_TYPE* **dev** *name*
> +                  Detach bpf program attached to network interface *name* with
> +                  type specified by *ATTACH_TYPE*. To detach bpf program, same
> +                  *ATTACH_TYPE* previously used for attach must be specified.
> +                  Currently, *ATTACH_TYPE* only contains XDP programs.
