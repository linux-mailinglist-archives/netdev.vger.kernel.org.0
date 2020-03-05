Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C57817A5D7
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCEM6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:58:49 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35346 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCEM6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:58:49 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so5644806wmi.0
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=DYfkE0ncKgeiIEFcrfqOPuwYh3P/dXWNU13hXGL/1nY=;
        b=td74DyrH81gxnb6eV9aGEpFkClWOS9/E+DhX4rcZqxxw/u7t8bmRV2m0tnCtDXIDV4
         /O3OXSBn4Z4zRBeft/Fc/rMkp5jnrL0fAppkzdX3pQVeivMpfko0jiM3or+kS2KO6mh5
         rQOagr5n5erjIDwLKOUPCkljc1R562YO3a3qM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=DYfkE0ncKgeiIEFcrfqOPuwYh3P/dXWNU13hXGL/1nY=;
        b=aRIW+ja7ml9+qA6jEDbZjbacFzpIXsCxmkuCse4KFiTH7VkDyiGPD2stYMQuklrRy5
         OXE4dwVYu1GYw8DWUhL2e2smXDo4t/BDG/0+/CIgtR3wwZykgv0nAAcyBXy/cn186s0B
         7pgWkRhqGE/71deN1yYQ+DsRAe9WIJYmVOfWJnKj9nlKS89tYeQuhSXoUMM97szUScCL
         7AqGNuonv/vSI3l0MjfO/OT2beSw9kxZ5th6n30THHwQY6WJgNfBRpXlmd/ZXYJ7eJdn
         4Z8CE8JGpCtgPINlYOkTFIsFHVzdJ5U8gUDkaZFxB+TU4+0FtbitmTnjLWwRYr9jBeJT
         n4aA==
X-Gm-Message-State: ANhLgQ1W8WSXTHLjSlmcnd4c9pw6bAHX192W5v9/bdvvGs7x0hrcj0f6
        i/YwzA1KbT7acpHCntyDw0g1TA==
X-Google-Smtp-Source: ADFU+vt55nZ9BZ8YtU7c3+AI5KJ0LWKvjV0O6TS2oAfk+AP4ij4qmtEllGiuHScjABOTfyVX66gJyg==
X-Received: by 2002:a7b:c414:: with SMTP id k20mr9064848wmi.182.1583413126033;
        Thu, 05 Mar 2020 04:58:46 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id o5sm9674246wmb.8.2020.03.05.04.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:58:45 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-13-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 12/12] bpf, doc: update maintainers for L7 BPF
In-reply-to: <20200304101318.5225-13-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:58:44 +0100
Message-ID: <875zfjyn3v.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> Add Jakub and myself as maintainers for sockmap related code.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2fae56dca9f..0b570b3b46d1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9352,6 +9352,8 @@ F:	include/net/l3mdev.h
>  L7 BPF FRAMEWORK
>  M:	John Fastabend <john.fastabend@gmail.com>
>  M:	Daniel Borkmann <daniel@iogearbox.net>
> +M:	Jakub Sitnicki <jakub@cloudflare.com>
> +M:	Lorenz Bauer <lmb@cloudflare.com>
>  L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Maintained

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
