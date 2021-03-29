Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B618934CF82
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhC2L5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhC2L4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:56:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A86C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:56:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so8394366wml.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VyG3P5A5WzCKv5rZKiJCGMIEBBTSLULK3qInnid9K/M=;
        b=HSfe/KPnrYvrGrSzfVcayo8/2C3bNBL6LbAePPw7MbokyLEACWdkRvAypFwViSo4lg
         mox0EJXOkClOJavPVBjNjyAkJdlN3kdIFcEHE6XOGo7rbthYI3tKMH2cSGTvrinuFnzN
         Rh/rickQLLccKvB2Tywl8eFPJlkYVgXadQJBfHqOK4GPO4J1HgTTU1+scOwRXdN6WHo2
         QvkO643dAoZxF43yzbJJKloO0exkbDkAkjwYMGAPccnDK7J6URWrukfzV9DmNR7LCGbg
         SWozAKthar/+xdTqyVWXBrqlWvKJmKtjs3iPJ2GzjAxxhz+pBjKPoMWEUQiTawHV+RJ6
         Havw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VyG3P5A5WzCKv5rZKiJCGMIEBBTSLULK3qInnid9K/M=;
        b=EDLey/Pkn2vq9QjE2SrQdjZjgtG2d4tTad5/J8As55E0u4e5swcR6WCnLzaUspSMgu
         2t1quL5FLKaScmWZReMhMmiU+eTvG8qA/T4Z3fvZqD/iLnX8DebtNn44RWdM5Mu3VVBP
         wNHHyZJRP5PgoZTvaDihPTTxYpH5n2Z6Ai7ptMCIS/GrwXrlONFZGg2SPITd14SaryiY
         s6O0XpORYEpaSnXF/PPSNXH9TvUhDTU5V9Ym4FsyiXW6+nwYWfC4DIkBS0E99vKO3dyy
         Oo8rv6PqWvEsmAx/hQcsB1JqHir4hRt99mAX3Vzh+b3Fy/qEzeLEdfCq/CJI07P8oY1V
         80DA==
X-Gm-Message-State: AOAM533kU7zcm292fZ61UmFh8EqQ1XG49zj4plTzUJMvushYqD4qYdkM
        2QmsDAj5AAeN3RsN3m6lWT8=
X-Google-Smtp-Source: ABdhPJxXaRAmDqQn+hiWWDaDunCFokjvV2U5FalJAwNUtQnnBZug3Hxn0qDriLGn+M1n1JeNo7xy+A==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr24668243wmj.26.1617018992653;
        Mon, 29 Mar 2021 04:56:32 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id q9sm29457661wrp.79.2021.03.29.04.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 04:56:32 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] ethtool: clarify the ethtool FEC interface
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        damian.dybek@intel.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com
References: <20210325011200.145818-1-kuba@kernel.org>
 <20210325011200.145818-7-kuba@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <435d5a68-95bf-81b6-2d29-75d2888e62cd@gmail.com>
Date:   Mon, 29 Mar 2021 12:56:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210325011200.145818-7-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/03/2021 01:12, Jakub Kicinski wrote:
> Drivers should reject mixing %ETHTOOL_FEC_AUTO_BIT with other
> + * FEC modes, because it's unclear whether in this case other modes constrain
> + * AUTO or are independent choices.

Does this mean you want me to spin a patch to sfc to reject this?
Currently for us e.g. AUTO|RS means use RS if the cable and link partner
 both support it, otherwise let firmware choose (presumably between BASER
 and OFF) based on cable/module & link partner caps and/or parallel detect.
We took this approach because our requirements writers believed that
 customers would have a need for this setting; they called it "prefer FEC",
 and I think the idea was to use FEC if possible (even on cables where the
 IEEE-recommended default is no FEC, such as CA-25G-N 3m DAC) but allow
 fallback to no FEC if e.g. link partner doesn't advertise FEC in AN.
Similarly, AUTO|BASER ("prefer BASE-R FEC") might be desired by a user who
 wants to use BASE-R if possible to minimise latency, but fall back to RS
 FEC if the cable or link partner insists on it (eg CA-25G-L 5m DAC).
Whether we were right and all this is actually useful, I couldn't say.

-ed
