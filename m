Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F29E61C4
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 10:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJ0JNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 05:13:47 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:39396 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfJ0JNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 05:13:47 -0400
Received: by mail-il1-f194.google.com with SMTP id i12so5433435ils.6
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 02:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BO8iIsuAZmVv1pdT1tQHttwB1r15uFdDULMfkhPpj+g=;
        b=Ga6UHJ9gc4fZQYvLeOjaooGmYh4URfyEXldUdTwojDB++vmqPWVpaKUCAckeJM4uWC
         Kfn1icN3kuswQOWi+jLuD5s3kPSEE2NWDPeAasO+D5tzgI4lP8b2ZILXXQ2yQoV1b+/W
         XyrPJO2Evyjbq/6D6C4SBBPss9Myj6uSDbE6boqoiwrIkaCmParsGWebimwduR12/ziL
         jhJMWjEBlcV06XhXw43TfU2aYbGKV8nWH7Gfklp/l0oCtNb9RPYBiLNY61KDKEzGmvyC
         8FKB1DrPYmInmpLb+3LN4KqzKztLJPVXS0VwYolnWofbyDqpjg3gpv5bD8cIVujZJN7R
         HacA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BO8iIsuAZmVv1pdT1tQHttwB1r15uFdDULMfkhPpj+g=;
        b=TLxqeMzt+unjFxIbulci7katqQ7mYjKYAWITDkbCNLA5ppvPZ96TLx6SYSjqAHq9WJ
         lxmGDaE9j0POAXHOtSLTg5uft6SF91UKYyxQM1RoYSowRmevMHT7LkQ5VQlwd8eNvoJd
         EBGoHs/L4OGtyC53h+fEXiPg7nqroYQD71swlkVTGpq+7vnD7rXlAnX9ClGhmCajGaDP
         LYCfc7gxNWARetV4UXUfWOc6r60cTRw3SlemYwPYCzxzW0nytg/wu16cN2LLDpxJzAIK
         lFiE0E8MxQHg5QIYLgO6s/UV0tAHzqV6v3N3MixC0lH2n0q8sN4pT5EMXgIarX+x/7sR
         hklQ==
X-Gm-Message-State: APjAAAUP6EbxxBurFtX5JcLFl/1Mwv/+ylpJGqY4ODyos5TYQP+5g448
        VZVEKFOFDAyR+TSoz3CbZqjLdQ==
X-Google-Smtp-Source: APXvYqzra1HegFYgtXhIYdN6gJ+6GPVHyQ8A+z5gSr5HYOXekt0i2SgfwhXjfmuNHivf1TtMBJyrAw==
X-Received: by 2002:a92:40d9:: with SMTP id d86mr14235281ill.303.1572167626680;
        Sun, 27 Oct 2019 02:13:46 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id g68sm1011732ilh.88.2019.10.27.02.13.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 02:13:45 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Roman Mashak <mrv@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbftv7wuciu.fsf@mellanox.com>
 <fab8fd1a-319c-0e9a-935d-a26c535acc47@mojatatu.com>
 <48a75bf9-d496-b265-bdb7-025dd2e5f9f9@mojatatu.com>
 <vbfsgngua3p.fsf@mellanox.com>
 <7488b589-4e34-d94e-e8e1-aa8ab773891e@mojatatu.com>
 <43d4c598-88eb-27b3-a4bd-c777143acf89@mojatatu.com>
 <vbfpniku7pr.fsf@mellanox.com>
 <07a6ceec-3a87-44cb-f92d-6a6d9d9bef81@mojatatu.com>
 <vbfmudou5qp.fsf@mellanox.com>
 <894e7d98-83b0-2eaf-000e-0df379e2d1f4@mojatatu.com>
 <d2ec62c3-afab-8a55-9329-555fc3ff23f0@mojatatu.com>
 <710bf705-6a58-c158-4fdc-9158dfa34ed3@mojatatu.com>
 <fcd34a45-13ac-18d2-b01a-b0e51663f95d@mojatatu.com>
 <vbflft7u9hy.fsf@mellanox.com>
 <517f26b9-89cc-df14-c903-e750c96d5713@mojatatu.com>
 <85eeyzk185.fsf@mojatatu.com>
 <2e0f829f-0059-a5c6-08dc-a4a717187e1a@mojatatu.com>
 <vbfk18rtq52.fsf@mellanox.com>
 <7c1efa70-bf63-a803-0321-610a963dcd9c@mojatatu.com>
 <vbfimoatwrk.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <18797298-12ab-547a-f206-dab1bdecccdf@mojatatu.com>
Date:   Sun, 27 Oct 2019 05:13:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfimoatwrk.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-27 4:31 a.m., Vlad Buslov wrote:

> 
> No, I meant that we don't need to change iproute2 to always send new
> TCA_ACT_ROOT_FLAGS. They can be set conditionally (only when user set
> the flag) or only when creating filters with actions attached (cls API).
> Such approach wouldn't introduce any additional overhead to netlink
> packets when batch creating actions.
> 
iproute2 will only send conditionally.
parse_actions() in iproute2 will only set this field if the user
explicitly set it on the command line for that action - either when
an action is  specified as standalone(or in a batch) or when bound
to a filter should make no difference. No?

The overhead i was talking about was worst case scenario.

cheers,
jamal
