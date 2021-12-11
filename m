Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20280471587
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhLKTJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLKTJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:09:49 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1C6C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:09:48 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v22so11560817qtx.8
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/ppDedL2YlV0HbEbzcMiFEGFXKjmpIN+WyuTprvA4pQ=;
        b=ZOjxDeZ1n/Dg7qoSgrt5aVEkSW8tEohsjggfHiE4OLqtW286PP/2hELwQtJiWez0Ju
         u17wVDvxQgihBBpguZhmUla4/ZzfoCdqQpF5scMeX8DVrCNyacu5348Lna38cg4Ssc0k
         UbGcIm347qpP+0TPGWT27umgoVO8oubANorXgHaaOh9SsA+I/WM8qV1kCXCYtCwlMbhC
         C8mCYvIQGV7rreRdkmLNWeBxg0LAUmtp8hbX1gwfc8Vk9AhckS5QiI18iceXLCBKqK5a
         ir+ZXHrkzZlKX23PbEb5jObKa5BoVZ7znvHccL0nc1AdtebNeWo/xESxpHPw1tf7+Pw0
         schA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/ppDedL2YlV0HbEbzcMiFEGFXKjmpIN+WyuTprvA4pQ=;
        b=FT2Tp5dhW5AaXu1GVy4nwFve2OynN8UZK6KjXLs5affEkGK299ylA7akJq219Zcajp
         1LnWOpoWPTfS+kLifYTC9WI3LEdl9AJ4H4M1v49JQFXor2qcNnSpD3W6YlFJkVw4Q47F
         NaJ85eaxGhngbLg18uWOzheAfa7C2SUFabg4v2zieuVhz9diLT+eJXvjsXCS1lZLEGKO
         sX+J3zDraQpll6NLHgdskzIAHOtIx88mkcU0NYV6XcSOtz2o8TQokyl9igSO2xxGsjMC
         2mY4/8UH0KWrXp5sLxxzy3RFBwyzBkF2erjKwF8E+TXxd9RcLuej6lS1iTIIP4Zw2b94
         sXwg==
X-Gm-Message-State: AOAM531a5BoWbrm00n9gZhauUcGln2J6D+W/akIZm/8Wu1ittNAYH+3f
        587OcnR169AQZTpqINhOXnfZkA==
X-Google-Smtp-Source: ABdhPJzDUmhCst5e5SSEKsSernqpw/1fDAePNvEu7NFfTZT5FEbvMjMJJQ02M1X0YBD5KVoccIeNaA==
X-Received: by 2002:ac8:7d4e:: with SMTP id h14mr36217999qtb.35.1639249787531;
        Sat, 11 Dec 2021 11:09:47 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id x190sm3257645qkb.115.2021.12.11.11.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:09:47 -0800 (PST)
Message-ID: <ca81db9e-7d88-41ad-23d9-6ff8f03c86ba@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:09:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 03/12] flow_offload: add index to
 flow_action_entry structure
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
 <20211209092806.12336-4-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-4-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:27, Simon Horman wrote:

> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3961461d9c8b..f6970213497a 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -197,6 +197,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>   
>   struct flow_action_entry {
>   	enum flow_action_id		id;
> +	u32				index;
>   	enum flow_action_hw_stats	hw_stats;
>   	action_destr			destructor;
>   	void				*destructor_priv;


Because "index" is such a common noun - can you name this one
"hw_index" for grep-ability?

cheers,
jamal

