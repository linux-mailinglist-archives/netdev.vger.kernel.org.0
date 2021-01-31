Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B6E309EAF
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbhAaUKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 15:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbhAaTqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 14:46:11 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9C4C06178A
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 09:30:41 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id t25so3856685otc.5
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 09:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tp+pc8lXF0gzJvnko9LdWmTWPQxh1bB2ujPmPN1J5V4=;
        b=IN+8GlC/545AWpPmZ9gSYZ0UYU46b9rg9EyoanxBat8LelwwJ8LXS620AclGlvMnNr
         aEcVioJe3ZFNzljmp8IqFskUx9GFC3h2Bf+KJmdmIDK0DElVI8Fd0nt7kq50UclVoOw5
         eP7wgWDIFPKT6SSMnb5n6uhfCs5LG5Zk23lkEIx3QSA6hqGVvtkuhJxf56x5TyO8c9Z8
         EH1wT8fAdta2bgBjgUO6rLfds1pOqt6hJ/U99z98RappFgwV2yYFy8zs/9w2Xr3yrghn
         XKmDYmjYu0xsJFjIjWTW+6/lkdtWdMxGUxF8KfkSZKXhEnXKcpXWXG/bu5AUYgY8pppN
         WA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tp+pc8lXF0gzJvnko9LdWmTWPQxh1bB2ujPmPN1J5V4=;
        b=a5CkRLtjBfcCl6mptiDhrlhs8fPP7Hbty2PSOJuYXWB2StA4CksZDuxS27AvxoEIqQ
         fgTCDWpXROetw0/7m0ytMFDk3BhvK9cWme7S4+jURXTQfY0GiSWtmQNc13VY5XIGEDSa
         if9hzlF01BazH2GENKKgLxYwoabNTuE3S7LuDxVHd0Crw7VAMsp5UqdAjlYkM33M0UBq
         XVKz+KuC2O1tQ+L3aL/EFTZzEpR/JISi0hs1YggycFMOe2uby7tmFB0Aj3MSscLXUGkW
         tXc7fpcm91/VqmZqmofFKFyrmTHKlvrmX1UbhprEpwEn0IjXAtz5Y8ZT2HK56XzPSoJ9
         oukQ==
X-Gm-Message-State: AOAM532zthn95XTuY9R2aftiWZFaqheRGOdVMGoo9RMC1zsqZl4TEFn4
        iK/iu8hfIatMenRXX0hr4fE=
X-Google-Smtp-Source: ABdhPJw6KwREIBfK3FckPJtTq1AvqjpFblZiK3AHminNmcNYN+bRH1UWRKpy5BPzk1ATqJaZT08bxg==
X-Received: by 2002:a9d:ee7:: with SMTP id 94mr8470485otj.342.1612114240794;
        Sun, 31 Jan 2021 09:30:40 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id y66sm3888463oia.20.2021.01.31.09.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 09:30:40 -0800 (PST)
Subject: Re: [PATCH iproute2-next 5/5] devlink: Support set of port function
 state
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
 <20210129165608.134965-6-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c197fd9c-c6a8-0ad1-1dce-c439d891354c@gmail.com>
Date:   Sun, 31 Jan 2021 10:30:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129165608.134965-6-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/21 9:56 AM, Parav Pandit wrote:
> @@ -1420,6 +1423,22 @@ static int port_flavour_parse(const char *flavour, uint16_t *value)
>  	}
>  }
>  
> +static int port_function_state_parse(const char *statestr, uint8_t *state)
> +{
> +	if (!statestr)
> +		return -EINVAL;
> +
> +	if (strcmp(statestr, "inactive") == 0) {
> +		*state = DEVLINK_PORT_FN_STATE_INACTIVE;
> +		return 0;
> +	} else if (strcmp(statestr, "active") == 0) {
> +		*state = DEVLINK_PORT_FN_STATE_ACTIVE;
> +		return 0;
> +	} else {
> +		return -EINVAL;
> +	}
> +}
> +

if another state gets added this too should be table driven - string to
type here and the inverse in the previous patch.

>  struct dl_args_metadata {
>  	uint64_t o_flag;
>  	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];



> @@ -3897,7 +3934,6 @@ static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
>  
>  		print_string(PRINT_ANY, "opstate", " opstate %s", port_function_opstate(state));
>  	}
> -
>  	if (!dl->json_output)
>  		__pr_out_indent_dec();
>  	pr_out_object_end(dl);

Removing the newline intentional?




