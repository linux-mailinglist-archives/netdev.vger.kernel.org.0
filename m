Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7643A3E9378
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhHKOTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbhHKOTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 10:19:50 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6335DC061765;
        Wed, 11 Aug 2021 07:19:26 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o7-20020a05600c5107b0290257f956e02dso4565640wms.1;
        Wed, 11 Aug 2021 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AkaVV/B4zm1StBccEJF79FiDT5uYQrDcCQSV22VX30I=;
        b=VfQwWxYc0BAYDB88MDFCVEmvIdX9iQ1okd2lUzkvZAUKxLhodeWXj2o6islzuiy7lP
         0dfmE4G1gwNVraO8e2AAJ0jlW2KPNZ1onr3TNS7bRch+9x2O99UuJ3eUnC8ZiiQxXnvI
         q5exULF23j+tflRYFnePUjh4+mneigS/bIDmteVlI9B99QJlLjcCXU/cHCKiYBz4Yupt
         6KOwDSrN9slR2dpNY8kEjSuVZDrkHkVoZl0J6i+sBK5Ac32XWhHpdfh/LBXH2HbwBoXy
         ExqwbOrVdMV7dpQCqope71pFW7HI9uyb2lGncxySBVDLyLsgPdo1aTKaxmgqbfTCZ0Ie
         11bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AkaVV/B4zm1StBccEJF79FiDT5uYQrDcCQSV22VX30I=;
        b=LAjDeH+4/LfPW95U9L1n3maATVSQsbEqsI+Km05J+V1wI70uRseq7nC4nBWx+nbJCT
         1/ZK8n2x8RtK4GFWvMtuFLbw6/2I5vYGR9GMYQg1IEtI+GnYhj8E0ps1oPYnxc5EVYTp
         qUe+JCWlX/6fCngr71qX2ZmK7UbSdKDfHkupN9iyz/DdqtOe5PdwW6LdXkJmY2MjFSxC
         zgLILIbZ+ilW/SoRyfQ1PHDE+aK1TtiX5hcqzZI4LB/iRaBbm3QPaTHEHcgO1oRYYON6
         FJqwCQCuTn5VBCSqSaWUKxKaQUWbjxB5fCSyia0p65ubJsoZz4JrxV//pw4B8SH6Eldl
         ykMA==
X-Gm-Message-State: AOAM531kuUillw5KTNG346hkrdTvVQr634OXIRa8yxxzOObrUYoOg6up
        trUV1yPtTLpuNF2vhe078AY=
X-Google-Smtp-Source: ABdhPJythbVeqVlxRPbfuIJIg7664unWUee9J/dNSZXJFYo5PpsLdnPwGPhEvhKPMEuHjDkJ9LebLg==
X-Received: by 2002:a05:600c:4101:: with SMTP id j1mr27882935wmi.110.1628691564973;
        Wed, 11 Aug 2021 07:19:24 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.41.250])
        by smtp.gmail.com with ESMTPSA id y14sm15510450wrs.29.2021.08.11.07.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 07:19:24 -0700 (PDT)
Subject: Re: [PATCH -next] net/ipv4/tcp.c: remove superfluous header file in
 tcp.c
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew <Wilcoxwilly@infradead.org>
References: <20210811133305.14640-1-liumh1@shanghaitech.edu.cn>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6240ae70-3a50-2570-a115-c61ef09286a6@gmail.com>
Date:   Wed, 11 Aug 2021 16:19:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811133305.14640-1-liumh1@shanghaitech.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 3:33 PM, Mianhan Liu wrote:
> nr_free_buffer_pages could be exposed through mm.h instead of swap.h,
> and then tcp.c wouldn't need swap.h. Moreover, after preprocessing
> all the files that use nr_free_buffer_pages, it turns out that those files
> have already included mm.h.
> Thus, we can move nr_free_buffer_pages from swap.h to mm.h safely
> so as to reduce the obsolete includes.
> 
> Signed-off-by: MianHan Liu <liumh1@shanghaitech.edu.cn>

Not sure why tcp gets a special treatment.
Patch title does not match changelog at all.

You should submit a pure mm patch, then eventually one networking follow up.

# git grep -n linux/swap.h -- net
net/9p/trans_virtio.c:34:#include <linux/swap.h>
net/ipv4/sysctl_net_ipv4.c:18:#include <linux/swap.h>
net/ipv4/tcp.c:263:#include <linux/swap.h>
net/ipv4/udp.c:81:#include <linux/swap.h>
net/netfilter/ipvs/ip_vs_ctl.c:27:#include <linux/swap.h>
net/openvswitch/meter.c:15:#include <linux/swap.h>
net/sctp/protocol.c:36:#include <linux/swap.h>

