Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09342521CF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 22:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHYUSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 16:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYUSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 16:18:45 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522B8C061574;
        Tue, 25 Aug 2020 13:18:45 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id f24so10087472edw.10;
        Tue, 25 Aug 2020 13:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8k54/wE0SJdSYHFKB65kPT2GfYY/F68XNItC0ZawlMs=;
        b=Rv4w+BsVBU9bQLlMX5nPmcv/iby7Atp6ZZWB8ouG2LBYQCQO6yK3bsOCRaDyo0fD2u
         z9mvfWrDzWtn31JC7edW3JoTUVRsmcLVRWv0KqFtwGB54Mop9v5/IkA+0dSfl3zpVCqv
         ukYUDPpLX4NrCWY36fBvJ0Gk1IpgbeDkXLPldeQ1+F27Yp0oC1XCDd6v/zL/V82b+ByN
         MkZek+GZtchOBGt2lEkrS4ZdivRtPfSHCHtxJ1IMoI5oztjwEMMP3NlekvDiTfOmo2Y2
         sMxaHNw4h65nSS0f+uiyIHOrYK0rOmgoHrvd4AuFoc3lFFDUUKoFZBLjxJ95PsQWMpSa
         5XKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8k54/wE0SJdSYHFKB65kPT2GfYY/F68XNItC0ZawlMs=;
        b=U+tJMUqjnziRCeMyDZf0ZO7QLd2crpM88kmJdRwOUy+rH5kbc6MvRAgG6PZ08+N6+e
         buGU1gAQF7KhiyU3uOPWeffsztAIkREp05/B66X6PX9II+VWlcZbED2lll5DhQp4jNmj
         2BphTGwl0GdXLf4MU1VOBcgybokLtI/vrJZn64lLd0QgzAoJswYYy5pqIUuTrbB36IzW
         Xg5pgT743aobNw5EkFBlGeYTfUFF3+pxsfq7MUfZAC6qtFkXdqCeC0M691fMjv4pBnET
         G/k69WuT3Q8jq+brQu1soqQKYlyVWVj5Bv1ZOaipMtD6g1ja4Bg0rgkQwbgP+GCLQ44z
         XJyg==
X-Gm-Message-State: AOAM532OoNpwdtHSciEOcoxZ7iYO+2FSTROojb/MsleCsmcUDmrffcUx
        eTu4dujb500TL/ZCKeajGKyYghdcdfotHA==
X-Google-Smtp-Source: ABdhPJwjRBjRSuLtemmLEN8j2cEzr4ZD1/ajIblLZhbYqPBNqz/8YT4tY6U4+d4dS25qBeJ7gxnJHg==
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr10295040edy.377.1598386723973;
        Tue, 25 Aug 2020 13:18:43 -0700 (PDT)
Received: from [192.168.2.202] (pd9ea301b.dip0.t-ipconnect.de. [217.234.48.27])
        by smtp.gmail.com with ESMTPSA id dr21sm15574816ejc.112.2020.08.25.13.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 13:18:43 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
Subject: Re: [PATCH net] mwifiex: Increase AES key storage size to 256 bits
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kaloyan Nikolov <konik98@gmail.com>
References: <20200825153829.38043-1-luzmaximilian@gmail.com>
 <CA+ASDXPoxdMb4b5d0Ayv=JFACHcq7EXub14pJtJfcCV2di95Rg@mail.gmail.com>
Message-ID: <65b14706-321d-4025-f199-a89768815dfe@gmail.com>
Date:   Tue, 25 Aug 2020 22:18:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CA+ASDXPoxdMb4b5d0Ayv=JFACHcq7EXub14pJtJfcCV2di95Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/20 9:30 PM, Brian Norris wrote:
> Also, while technically the regressing commit (e18696786548 ("mwifiex:
> Prevent memory corruption handling keys")) was fixing a potential
> overflow, the encasing command structure (struct host_cmd_ds_command)
> is a union of a ton of other command layouts, and likely had plenty of
> padding at the end, which would at least explain why non-malicious
> scenarios weren't problematic pre-commit-e18696786548.

This is pretty much spot on, although as far as I can tell, the padding
comes from struct mwifiex_ie_type_key_param_set_v2. That contains a
key_params member, which is a union over all supported key types,
including other 256 bit types (like struct mwifiex_wapi_param).

I should also note that this fix also affects mwifiex_set_aes_key_v2(),
where sizeof(struct mwifiex_aes_param) is used to calculate the command
length of what looks like a command being sent to the chip. This should
probably be reviewed by someone with a bit more inside knowledge about
the driver, as this could potentially break something due to the commit
changing it from 16 to 32. I think, however, that this might actually
also fix a potential issue when setting 256 bit AES keys.

Regards,
Max
