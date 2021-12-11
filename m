Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A54715D6
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhLKT5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhLKT5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:57:09 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D44C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:57:09 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id o17so11667777qtk.1
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RntXomUD8f35Dc8tlHukbWpQoAKjdG2bVgDcmeUJJP8=;
        b=a8NrxlAvBTUMpF/BucOpVB9bQnJsksMkXRTNWZaJuIFw273AqTa3g0RSOGZ4+jTTMn
         r2AS/daII5qZZ3vjqqS2o15NNh6pExls8/iHYzpT1DcccJKRB98uK5Yy1mkufKyUASg1
         a7hD0TeNcyNdOyaGAP/BtySVPpsN167KmBVlt9AerYNsWSwnQ7Jnlm2hNQol8u5lTAJ4
         jOgUVw/6hY5Oa3qIzahOCxYYYMuzgaRhqnz52AsQhvnPIifAsW7pHLzvOiwCoXivKgLd
         o0u9AxBaRvjI8qFaz2l+jMqI0Sjm+od657eDZBSxQDPHq2QLcA4pcUJyPCl8iIw0OUoC
         9iVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RntXomUD8f35Dc8tlHukbWpQoAKjdG2bVgDcmeUJJP8=;
        b=MekgBBiaLWudvMWrVMPaRrH3lAi95X3Hb48MmFNbtfZxeTtK2wbYusXMsLwohV6Dyf
         sA3UxDWSf1yTLYQHF5X3SaPuRZ/54Jx9YF6lZA3FyJj9fQ/VomQB4WegguGN8VCfPsiq
         UytoxXwRcEfG5C+PT6JvwFcocfdGSJlOyjEG/hpCsWuU/zsHODYW8Iab9jdNKgW1K3Rx
         WlZZLhtvkswJMoLXKO5wpN/7kMQ5Yigku9umD0vbloN2raFVTAUlKZ9+JlsgXNucUiEd
         lLfQ7V9SxDqX1EuSCr6ZeD25DOGb4vZ8VPL8vibscomJ/v9QxbU6i6IWn2oZEs35puWK
         S+bg==
X-Gm-Message-State: AOAM533pELAnYKZUuWY9uyO8L8PymsHTsdS4N52NY9EccxH2W4BbrE82
        52+ic9HsFshiynLi25QWAVd29A==
X-Google-Smtp-Source: ABdhPJy5vit3w2pBNUHtQQTKZkDahn3IK78Q25C11UHLCVfBXzGnZKWO8mcMsrsjSULDTbkjbPbveg==
X-Received: by 2002:a05:622a:608:: with SMTP id z8mr34647217qta.636.1639252628111;
        Sat, 11 Dec 2021 11:57:08 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id m9sm3436887qkn.59.2021.12.11.11.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:57:07 -0800 (PST)
Message-ID: <747730ac-8421-1f10-cac6-5c4518bb204b@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:57:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 12/12] selftests: tc-testing: add action
 offload selftest for action and filter
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-13-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-13-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:28, Simon Horman wrote:
> From: Baowen Zheng<baowen.zheng@corigine.com>
> 
> Add selftest cases in action police with skip_hw.
> Add selftest case to validate flags of filter and action.
> These tests depend on corresponding iproute2 command support.
> 
> Signed-off-by: Baowen Zheng<baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman<simon.horman@corigine.com>

Thanks for doing this. If you have cycles add one or two tests that
fail (example offload action then try to bind with match
that doesnt offload, etc).

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal
