Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836D93BA6E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfFJRJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:09:23 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45691 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbfFJRJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:09:23 -0400
Received: by mail-pl1-f194.google.com with SMTP id bi6so3509319plb.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6PLYJgZLyOghu/Zj4EjjyzNoDg+PnIVANK7gMeQCPyA=;
        b=aO3Ks8FVi0vpvPXBTPdFpE95lMfdgRlZYI/qdF0gBKoIFy11U52iT3m9MsvAqFKqTm
         WzMC+89OR1FtBwvnAIS5tppIUlR6bgmqdaG/RdiwF2BPcbPlB0YNAo87XKmsriv56sMD
         Cfg36bCAX77y7SV+ylk0sr8rizwqiJU3+Po9FWKPXDGEEBWgEduK6Nz3kJbtNrNNDmFP
         AGhh5yQ8U2wUM/1VzIS1+1qR6KWyjwwRHQYbBlD5l+G7vwrbZW1H6R9rSOvxYxMUudin
         4LVair+fvLFCs+EfVIf8SZ9y5o1eRjr4ArxL7dBT8hYzVGuXFCyrqzw/c2yyJPY21nlL
         hrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6PLYJgZLyOghu/Zj4EjjyzNoDg+PnIVANK7gMeQCPyA=;
        b=k9MusauXwje1I7QuM57XOPKw3eZloDzJUIwc01gVpZE0bOzZyX1IMSdZ/C0FV1KUCC
         Ty+asZp6Ka11ldr0MaoI+VuqsTa6QjH7aaLNo6HNmydSB1xvS19ke3xxxlN2A4MccX23
         nabMRhmhRcjzg2ISqi5HabJXnOO0csZhP/aQR4tP+iHNBTeSUZsLZRWVsrHhPzU36/bg
         408QuTArtFxPwXyECR+cwXoQqcBL6eP27mV6OjNMo/8hudg+6XBOAPMXgPy7rKD3ptOc
         WHBNUxg4PcBEbLcw0OvMgW+0wQ1iSPHDE55wt3tFNoC5mmHbOdMhwnGna4JqMl4G0azA
         Q5GA==
X-Gm-Message-State: APjAAAX/vH8aFih1RMkodkrPcekTp0Cx5HvToh5K/P1uthE4USAlECnZ
        E1FnEC354QI7LX2KA7ZnWZs=
X-Google-Smtp-Source: APXvYqwbkpGfoTqIiCXnrr/ewJhdRxZMVKFbW5nFyg2c+iGPg0V6sLN/9Yk4e+eyJFHh6XEB5dCVTw==
X-Received: by 2002:a17:902:a60d:: with SMTP id u13mr2703719plq.144.1560186563058;
        Mon, 10 Jun 2019 10:09:23 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k22sm10845836pfk.178.2019.06.10.10.09.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 10:09:22 -0700 (PDT)
Subject: Re: [patch net-next v3 3/3] devlink: implement flash status
 monitoring
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org, f.fainelli@gmail.com
References: <20190604134044.2613-1-jiri@resnulli.us>
 <20190604134450.2839-3-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
Date:   Mon, 10 Jun 2019 11:09:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190604134450.2839-3-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/19 7:44 AM, Jiri Pirko wrote:
> diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
> index 1804463b2321..1021ee8d064c 100644
> --- a/man/man8/devlink-dev.8
> +++ b/man/man8/devlink-dev.8
> @@ -244,6 +244,17 @@ Sets the parameter internal_error_reset of specified devlink device to true.
>  devlink dev reload pci/0000:01:00.0
>  .RS 4
>  Performs hot reload of specified devlink device.
> +.RE
> +.PP
> +devlink dev flash pci/0000:01:00.0 file firmware.bin
> +.RS 4
> +Flashes the specified devlink device with provided firmware file name. If the driver supports it, user gets updates about the flash status. For example:
> +.br
> +Preparing to flash
> +.br
> +Flashing 100%
> +.br
> +Flashing done
>  
>  .SH SEE ALSO
>  .BR devlink (8),

something is missing here from a user perspective at least:

root@mlx-2700-05:~# ./devlink dev
pci/0000:03:00.0

root@mlx-2700-05:~# ./devlink dev flash pci/0000:03:00.0 file
/lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
devlink answers: No such file or directory

root@mlx-2700-05:~# ls -l
/lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
-rw-r--r-- 1 cumulus 1001 994184 May 14 22:44
/lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2


Why the 'no such file' response when the file exists?
