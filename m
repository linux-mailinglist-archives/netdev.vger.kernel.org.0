Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478D7136381
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgAIW5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:57:41 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33173 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgAIW5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 17:57:41 -0500
Received: by mail-pj1-f65.google.com with SMTP id u63so1264337pjb.0
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 14:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=KdzaHl3Hi7MGefUdDHblJJGsJtsdyJXyQd1TFyhu15I=;
        b=4UweHJ1NKB1Sdjex6yDmf9jCl/J4lMktoI0lRyqU4IVT79KzcSoUC5k9oVeyT+YUtB
         obGFeGsmvo6lTa7e/k09TP76jP3Levv+VuRnBKEdc8kB8IkWJj3LSeRzH8inJHfPqOdO
         o/1qEhxoAHa7ZpajXvGhw9WjYUvycJElpRY9g/Sp8Hzxod92PfeHEaL03QsHGno1J1Tz
         Gt04DNjzaTtDnZAH730QQy/7Zh6KqfTrz/gxqYHgqJm+4QUxA+LIPPCOF6gmIUN0Gahm
         YUh06ls28HaSvoQtp7HSnD4ApBI34nwCULf9ADc3/LgI3Ha0n3Mm3ojG/9iNMChTwrFh
         mRuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KdzaHl3Hi7MGefUdDHblJJGsJtsdyJXyQd1TFyhu15I=;
        b=n3kCc4tKYHHanJigYAbQtLOf1o8OxFpnpQKMEbLIrH/7S0+Cuo3KJv72etUEGeznvy
         XgFpkrBxDfvPrCS8kXgaY/aTr+8G3KJuDJ7OAlbUl+qpygM7ObIzIbDoiIAPiE9QfEvZ
         pdB5ZeXIFE4kSjZVUTBC2XuyjUBRruQiAIUECaYslQ9pXbGYheyuQ2aaj73jUaz8aGOz
         ccNuBGPzzww6mWU2WyegndoUzMVqGwF3OpM1LXxKUocoeTn7J93n+2dE1zHdl6u0QqCH
         aha1oN9kuYQOgeZDhr5HnS17RYl2XHuSURmHJ1wOC97xS45vCZVHaOVfa8KO9nYIMYX7
         o8sA==
X-Gm-Message-State: APjAAAUSYnuiNKaH3i2ELs/DJU6384DhLmtyWFca+fa4ELVv+Twc1gLd
        BLxyhU8tr4CXdRhICaAINcht0SFRCo4=
X-Google-Smtp-Source: APXvYqz4tsoJF1HEhRDKWa4BGeeK8FjhcQFZ8wGodb9JishJ3KrvQNb3OnWjJTexKPS67NnK33GoaQ==
X-Received: by 2002:a17:90b:1110:: with SMTP id gi16mr578605pjb.110.1578610660101;
        Thu, 09 Jan 2020 14:57:40 -0800 (PST)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id u1sm70726pfn.133.2020.01.09.14.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 14:57:39 -0800 (PST)
Subject: Re: [PATCH 13/17] devlink: add documentation for ionic device driver
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
 <20200109224625.1470433-14-jacob.e.keller@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <954167d7-9e79-5828-b689-47da7f3d49a3@pensando.io>
Date:   Thu, 9 Jan 2020 14:57:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200109224625.1470433-14-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/20 2:46 PM, Jacob Keller wrote:
> The IONIC device driver allocates a devlink and reports versions. Add
> documentation for this driver.
>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Shannon Nelson <snelson@pensando.io>
> ---
>   Documentation/networking/devlink/index.rst |  1 +
>   Documentation/networking/devlink/ionic.rst | 29 ++++++++++++++++++++++
Seems like a reasonable start - thanks!

Acked-by: Shannon Nelson <snelson@pensandi.io>

>   2 files changed, 30 insertions(+)
>   create mode 100644 Documentation/networking/devlink/ionic.rst
>
> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
> index 3d351beedb0a..ce0ee563d83a 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -30,6 +30,7 @@ parameters, info versions, and other features it supports.
>      :maxdepth: 1
>   
>      bnxt
> +   ionic
>      mlx4
>      mlx5
>      mlxsw
> diff --git a/Documentation/networking/devlink/ionic.rst b/Documentation/networking/devlink/ionic.rst
> new file mode 100644
> index 000000000000..48da9c92d584
> --- /dev/null
> +++ b/Documentation/networking/devlink/ionic.rst
> @@ -0,0 +1,29 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=====================
> +ionic devlink support
> +=====================
> +
> +This document describes the devlink features implemented by the ``ionic``
> +device driver.
> +
> +Info versions
> +=============
> +
> +The ``ionic`` driver reports the following versions
> +
> +.. list-table:: devlink info versions implemented
> +   :widths: 5 5 90
> +
> +   * - Name
> +     - Type
> +     - Description
> +   * - ``fw``
> +     - running
> +     - Version of firmware running on the device
> +   * - ``asic.id``
> +     - fixed
> +     - The ASIC type for this device
> +   * - ``asic.rev``
> +     - fixed
> +     - The revision of the ASIC for this device

