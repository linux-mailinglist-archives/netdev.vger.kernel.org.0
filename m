Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD32F2521C4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 22:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHYURS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 16:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYURP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 16:17:15 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05999C061574;
        Tue, 25 Aug 2020 13:17:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l23so12368632edv.11;
        Tue, 25 Aug 2020 13:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=81t2aDI5v1x3cz6lfle+1PiUyFahp9ZjxTfV8FCX8Xo=;
        b=IZvJ/ufQek750GeWPxk9BxabiDFeqIOQLeTijcyIhHyqigJDxAvuLEvssHqG0ByYzd
         5RgULxsKaJVJ/ImRbHQoZ0UFLH/eHB+6QDVs9zdYHOdZ/ifdWTqet4IRO/hirzYDWmc8
         QYM/voORlmaRa+9Y6b3zrNyVjezPqsZhWnlV94NsZVQZQCUy+GwJgJoU8B34nUaTX19c
         5vRRdzc4eVIKv3TpU3AHGvc/SPWcLEu2oTxbjF/IXCE+Hd+O51/5Mebf1b8QraGMBCdX
         xjOjs8dPxfFV5tu7xI1ApTxRqfNc8wv2eEiCSGkD7rQriK712jxAgx+hXIo5og/QWnbT
         m5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=81t2aDI5v1x3cz6lfle+1PiUyFahp9ZjxTfV8FCX8Xo=;
        b=NoocFbsS/FtqVu9xQPx5Zy0j6B6BzkzKZNDiRNZ1UdwtPUzwQliSqERWv926Aw4e00
         lb6kCeHdOv7WU3xKtAy4MoQMzD1MmCDp485aiWxTj2B4vsDUyE8BCUERciZb6Z9530mw
         UePGeeJU/D/ZlEAtCBR/y2tbhoP0XtXVgYnMVs7EHykUHi6M1hDjJFK+ov5cd1gOv/UZ
         BGaetOKV9PvElhPp4z9IAjG76swQcFzaGWDqcWpjxI2WZ4zRoIQ0AncZ9MMo1/PZj/HI
         rPMrSOjl6yDS2VQbYJcQ2iS+QZLbu6U5Mas44r32rGRHF2H6Q8b13MQWd4WOyibe8XD2
         bsxw==
X-Gm-Message-State: AOAM533PenUw8vrYB1aJuiKz3dvcrneRHHd7nQNW70+IJaV47ZNJWSG6
        kRl95b5E574i2VLRHzxzXyU=
X-Google-Smtp-Source: ABdhPJzDMdTD0z69cJdwS/8jhUmd/UCBW5lo2GAsKIaEs4WrroEXT6CUJTbOoG5ZIVbA0v2Ssh5/Dw==
X-Received: by 2002:a50:8709:: with SMTP id i9mr12236951edb.141.1598386632599;
        Tue, 25 Aug 2020 13:17:12 -0700 (PDT)
Received: from [192.168.2.202] (pd9ea301b.dip0.t-ipconnect.de. [217.234.48.27])
        by smtp.gmail.com with ESMTPSA id sd17sm14506440ejb.93.2020.08.25.13.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 13:17:11 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
Subject: Re: [PATCH net] mwifiex: Increase AES key storage size to 256 bits
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaloyan Nikolov <konik98@gmail.com>,
        Brian Norris <briannorris@chromium.org>
References: <20200825153829.38043-1-luzmaximilian@gmail.com>
 <20200825185151.GV5493@kadam>
Message-ID: <54a785f9-d49e-354b-1430-8a854b4d36c5@gmail.com>
Date:   Tue, 25 Aug 2020 22:17:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825185151.GV5493@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/20 8:51 PM, Dan Carpenter wrote:
> I sort of feel like the code was broken before I added the bounds
> checking but it's also okay if the Fixes tag points to my change as
> well just to make backporting easier.

I'd argue the same. Any critical out-of-bounds access was just never
discovered (at least for 256 bit keys) due to the struct containing the
key being a union member, as Brian observed.

> Another question would be if it would be better to move the bounds
> check after the "if (key_v2->key_param_set.key_type != KEY_TYPE_ID_AES)"
> check?  Do we care if the length is invalid on the other paths?

Given that I have pretty much no knowledge of the driver, I
unfortunately can't answer this. But I agree that this should be looked
at. I think this has the potential to work now (as long as the maximum
key size is 256 bit) but break in the future if the maximum key size
ever gets larger and the check excludes some key types that would be
valid in this context (if there are even any?).

Regards,
Max
