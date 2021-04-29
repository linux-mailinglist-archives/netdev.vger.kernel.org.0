Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C4D36ECBC
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 16:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhD2Ou3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 10:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240747AbhD2Ou2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 10:50:28 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF8FC06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 07:49:41 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f15-20020a05600c4e8fb029013f5599b8a9so9491764wmq.1
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 07:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vf/4RFWT0jjFBhBsGq2YtUf3ZoV1qc5jW+Bh/WyGB0w=;
        b=cYDnnbpcCvqASAl8qN3wgPuSkl40wXiHwDg53H+H9Ye5g8JC3AHNKPz8x07dhFPkcr
         3c/MUbEZAHciVmWuxXWX39/MVgBCddmNHiQX70II1dVsy/alAMVQw878e70GBtZHAIvj
         xXFRMIJKmdAm6V9q1xsyMWweYuJlcj5atqr3FO0Z5Mp2VnDRn6+m7c0ClfFWvAup221y
         AvMKhmDGacgEy6n79/xJtW94DUKGUgirzbHlHEFtgYC6QShz8vyBx150H4mlS+1Nw+ts
         p4n3W7ynosMim+hPr/8Gh6I9OXqYvt+YIJhAVule+TnZJDIS/Nx7I+0ERY27QsP2SMqT
         ShXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vf/4RFWT0jjFBhBsGq2YtUf3ZoV1qc5jW+Bh/WyGB0w=;
        b=fUH31a1T3HL4cuFBgvzPRezuWPEcSeGi4rvgJ0YscvrDv9QEKGiMagh9XOxb4BJElD
         3nkMIl5Y33xv4peXdPwi1yzxg85W0Fr5TtBIp9uCSY1XZXpIPhCybCYM428DA9bhBQYE
         K1j/ramJV730R5EFVr+fbCijGSLSZkY8rQ3jftCJvRowuQgvbSxsezZlyEQYfeS/T+eS
         nnj4nbVtRrHtqv5/gibYlxuE+kkWHlm4jt1AGepHqF+WgCWNwPgsC3BueMZ74jZz+pdE
         Dm76/cBQIAamk9lq9sKgVkHo0INERrM0Z7sEIHxze6Avzig7uy3NdwT8tPLk2mGcBLBT
         GNjg==
X-Gm-Message-State: AOAM533JNOKQvxgYaoixbysPCL+8mvxSo3WE7zpu6YKJBWMvr1tegNJo
        svyKFjW7k+h5iAhOcUEb6MA=
X-Google-Smtp-Source: ABdhPJwnIdtbvlLNG5VcHwf8jYODpuP5i+R/CTuU+zMUHccANLP8ufmpn4LhoCbjs2Lt5LTBBXuaCg==
X-Received: by 2002:a1c:2c0a:: with SMTP id s10mr10762926wms.158.1619707780129;
        Thu, 29 Apr 2021 07:49:40 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id c15sm5375024wrr.3.2021.04.29.07.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 07:49:39 -0700 (PDT)
Subject: Re: ethtool features: tx-udp_tnl-csum-segmentation and
 tx-udp_tnl-segmentation
To:     Aya Levin <ayal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Maria Pasechnik <mariap@nvidia.com>
References: <c4cd5df8-2a16-6c31-8a13-4d36b51ba13b@nvidia.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <77f09431-d80f-e9d0-7e08-3ab7bf4680d8@gmail.com>
Date:   Thu, 29 Apr 2021 15:49:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <c4cd5df8-2a16-6c31-8a13-4d36b51ba13b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2021 10:16, Aya Levin wrote:
> I see a strange behavior when toggling feature flags:
> (1) tx-udp_tnl-csum-segmentation
> (2) tx-udp_tnl-segmentation
...
> What is the role of each feature flag?
IIRC, tx-udp_tnl-segmentation controls whether to do TSO on packets that don't
 have an outer checksum to offload, whereas tx-udp_tnl-csum-segmentation controls
 the same for packets that _do_ need outer checksum offload.  The difference
 being whether gso_type is SKB_GSO_UDP_TUNNEL or SKB_GSO_UDP_TUNNEL_CSUM.

To a first approximation there's one feature flag for each SKB_GSO_* bit, and if
 an skb's gso_type requires a feature that's not enabled on the device, the core
 will segment that skb in software before handing it to the driver.

Documentation/networking/segmentation-offloads.rst may also be useful to read if
 you haven't already.

(And note that the kernel's favourite way for hardware to behave is to instead
 provide GSO_PARTIAL offload / tx-gso-partial, rather than doing protocol-
 ossified offloads for specific kinds of tunnels.)

-ed
