Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC91365BED
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhDTPN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhDTPN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:13:57 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B3DC06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 08:13:24 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d200-20020a1c1dd10000b02901384767d4a5so4281200wmd.3
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 08:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EbMM3OPpmou+Fc7NwIqPRrcr+UVw0GdPTXKFHqUtgMk=;
        b=BzNYCn8Kk/jqSkNltTvofoIuuo71k1vWaLpQYoTXV9NtUVVy6V3eOarwcAuOQcjAlS
         6cQC4zB4DKYqy3ocTXUnGeOp7xftMKWpU8hK+Zxmu+BymG+5PbbvGVyga2wWe6tMScdr
         /nvDWH1DirHvu8y6ewKO/f/ju2m+HFMoR5GcwWXF25LEUg/AS3+qvst70Q2EFDkcAUTS
         6X5QdrVkv3pDgFDFFZv5m/hH133ZFMG9vnUqKmPEc9yAe6igbWo3G9soh6m9VC7jDYUv
         1Vnu4F40iCoIuBGsayHlTLMHGZG+adh26hR341At/30eumK2dnu61mRIGQz1+aglZlyn
         U6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EbMM3OPpmou+Fc7NwIqPRrcr+UVw0GdPTXKFHqUtgMk=;
        b=s6KYPTnCGeT25j13Ffd6PQo61mwtGwkskjA+rDH3utJtQgH3uHxq2+xoGfQTSH4ewR
         XFn9ycKCJJCM4t15KEKdLcbWlVj9gNB46bdoNg3llOSQMMRwYMXptGMf8axIzXJ+apLN
         ZfTdxz77frBV96cIfwzOj5JrPX3nsuBGAqOI+bwLqxyTg7LanPNex6c6DYd/3TjUHJSO
         zHl0FZZF4eZ3aFQqWpNdRlIf1N/zXN+9glSwHkbPV7iwLaooSWOPk9KLkogB22h7hdm6
         izumbV/Hzm91E1IVjp5xrTlDO1bf7MrD4V3GOpECh1zOKl9mM4ypEKnKJBiQWJ9RU2MP
         KCxQ==
X-Gm-Message-State: AOAM533ZjqdIYV5i1E3L/I78cc6JiTVTiZqD9+ShVN5i5O3VuQ25g0XE
        1wigEXvusGjWEYdQBP23KVc=
X-Google-Smtp-Source: ABdhPJxNLKWikGGGTI0QYliEeJLccOdKX1gYGXGGjWcLAPklx4wlYnotBrkBIjU07sf9MDuk1HNxGA==
X-Received: by 2002:a05:600c:2f9a:: with SMTP id t26mr4864811wmn.20.1618931602888;
        Tue, 20 Apr 2021 08:13:22 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id o17sm8588947wrg.80.2021.04.20.08.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 08:13:22 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/6] sfc: ef10: implement
 ethtool::get_fec_stats
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, habetsm.xilinx@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        ariela@nvidia.com
References: <20210415225318.2726095-1-kuba@kernel.org>
 <20210415225318.2726095-6-kuba@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bb02f3b8-8949-a2f0-3a56-5d17537f8bb6@gmail.com>
Date:   Tue, 20 Apr 2021 16:13:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210415225318.2726095-6-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/04/2021 23:53, Jakub Kicinski wrote:
> Report what appears to be the standard block counts:
>  - 30.5.1.1.17 aFECCorrectedBlocks
>  - 30.5.1.1.18 aFECUncorrectableBlocks
> 
> Don't report the per-lane symbol counts, if those really
> count symbols they are not what the standard calls for
> (even if symbols seem like the most useful thing to count.)
> 
> Fingers crossed that fec_corrected_errors is not in symbols.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

For the record: yes, fec_[un]corrected_errors are counts of
 FEC codewords, not symbols, so this patch is correct.

Whereas, the per-lane counts definitely are counting symbols.

-ed
