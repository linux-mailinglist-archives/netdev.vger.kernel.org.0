Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D3A4715D3
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhLKTzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhLKTzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:55:03 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8338DC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:55:02 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id p4so10815438qkm.7
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZXMkW2CmNNs4DKHzZfFR0+/a0MB4PGTkR59q56D/WRA=;
        b=b4s2xWgxfMsRyZJV/MAMb0Kgi1VZgsOHYowdxmcwml8nltDIyoWmtM6dEkT4060vPN
         S83EL/NlSWcUJSAyYthPde/zmDqOiUaZ5Av4ik2a/g9Uono+KsveZ//eyo4nsn771kkz
         i0WnkIqpdbfD3Kccx6eJH0xX0Kki8QruUxqP2QqnsnnWOUokYugAsOkll72S67zT7Ekh
         gWf/oZUbtO+oRaH/3Q5Kyqk4qUzlRFwjjzvWb6RxmgZPkbyTL2HGFHv7LM6219JaPLU1
         mbipoBwCzijB/QA4/g637sPiVcKSTnbz8hqEzCwSIVtHSN8jvvfiIDrsXaCscbcWHRDv
         hwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZXMkW2CmNNs4DKHzZfFR0+/a0MB4PGTkR59q56D/WRA=;
        b=jc3BRnp01Qcs1WBcpkKDB00hS/bXiFlW9qvn22i7Ac07P0n1eVjaB0/Dai+LGqcG71
         6/DbCbRtIfQu5ihivFgbFggV3t11PXlJAcvWQW9qfsmKfUZsWnoJEP8R9avyBnnZ0ICH
         /kNYUtiU/QtExxzjeO0SsJs+C0f1AXwMoZQCtJ7Ft9jQHBcNFXVBH5qP1CwiiKRIAFto
         v3uM12a7s9QliqtqQrwZbV9yRh83sn5oPJa7WEseLwpfQaXUzYsmGowuxkVPHuRwpbNe
         j1y9iTX0GQsqpzVykHdiJRmaxuHJdv8EQjoHVzR7lE3D/topBqMJy6rp9QwSD5AIgfu1
         kZZw==
X-Gm-Message-State: AOAM530fw+H+Hez2eu9Eo+NTVXGwl5YtMQcMegxv4WyBwKw/HxXe5V9U
        OtfamARHY4WWmSlqJGqRcwvvWw==
X-Google-Smtp-Source: ABdhPJxibJ03pLXSk2soWm1PB3RFpdDxUpPSzR2isAaw2cvqIZsA1jTF+azSLbKdA3J7AMf7B2vGOw==
X-Received: by 2002:a05:620a:2153:: with SMTP id m19mr27931190qkm.77.1639252501775;
        Sat, 11 Dec 2021 11:55:01 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id b6sm4936474qtk.91.2021.12.11.11.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:55:01 -0800 (PST)
Message-ID: <6a0a2e61-d122-f833-82ee-ce09250c9aca@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:55:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 11/12] flow_offload: validate flags of filter
 and actions
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
 <20211209092806.12336-12-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-12-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:28, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Add process to validate flags of filter and actions when adding
> a tc filter.
> 
> We need to prevent adding filter with flags conflicts with its actions.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
