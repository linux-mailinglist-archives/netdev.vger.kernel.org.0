Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFA84715B2
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhLKTbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhLKTbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:31:07 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D34C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:31:06 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id t83so10782986qke.8
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R8QSh5R9SDX/TxQhbWdccYQu1CGot6aRuF1eUPN3RLI=;
        b=IwuyKNHaUkcYNQ8JvUiE5LojdXq3Ir4VTExar5zpI1+GgeNaQyz2Ch84NowQQVUilN
         MfhE1kPIvPlHVbb9v+GYqZ+hHz454T+BDqeU7ypLqeGtcZbetj90QSCOy4eDVUR0+6dd
         nR2nnVxegO4gul+EzDWJo3gza6d0uWbG8LwOgSm1TusPvv9yn6AuGe+KAx4iRE3dEL/m
         XjxJ4yxtoYaXtgtRprZwCIbCG+RGk4Zs+1YT+gK18UXROfmjoaNohbtfaFPF41NbViGx
         Rv+JPyeUPisAwSvmbR8xrGgRAfAg8VonZIAucKxeBWjSswcIk+BX2uY5vi8qD5+A+XGy
         SzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R8QSh5R9SDX/TxQhbWdccYQu1CGot6aRuF1eUPN3RLI=;
        b=M+05xEgz+VkYhgoP/Nvq6CYPAl9FWzsqtRFdMsJ2Prhax6PJOPXECEuM1vSXxyL9sh
         ze/U0zQptBcAIPv39rbEIWm7QqkWap/aauk3NAvG1K0ozBn/f2U+RpziFJ32IDz+dc36
         l/GAks0Ky8tcH8XRhzix0MLquxsg6O00UKsWltiXISG4gtunQpe/hKkZG0wzRxOSmsN8
         H0SuHMtS6ezNujgv4pgWj6wZuG9ix9nc0EGanNw0Rsrzs9L5qxnYgH5ffVbPGnhm8blH
         h2gyaMZCVk4tBkZ3S7mYWEux0qIJ8wcx++R8sKEUJosl/vJemkvnHmbjWDeaJZGA9UZy
         hoJQ==
X-Gm-Message-State: AOAM531ptDwxDohagzTEahTlINvjvLVfZt2z/0YUbNifGXQwGZMEDiw0
        jU4KKP+y2yp6kkZJVWUuL6zgRGtjbqWnvQ==
X-Google-Smtp-Source: ABdhPJz2awZ7976vu23ewTxnI1uPS+g+zOaXw47YSqxvlPXbwJ5wRcHvHySKhkOxAeO/QEEMpy+G9g==
X-Received: by 2002:a37:a90a:: with SMTP id s10mr25846464qke.124.1639251066103;
        Sat, 11 Dec 2021 11:31:06 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id w2sm5098713qta.11.2021.12.11.11.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:31:05 -0800 (PST)
Message-ID: <44f072d1-331e-a09d-eaba-420f07e89ce3@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:31:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 05/12] flow_offload: add ops to tc_action_ops
 for flow action setup
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
 <20211209092806.12336-6-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-6-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:27, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Add a new ops to tc_action_ops for flow action setup.
> 
> Refactor function tc_setup_flow_action to use this new ops.
> 
> We make this change to facilitate to add standalone action module.
> 
> We will also use this ops to offload action independent of filter
> in following patch.


Please name these functions with "offload" instead of "flow".
It improves readability because those functions exist for the
purpose of offload.
So i would say:
s/XX_setup_flow_action/XX_setup_offload_action/g
i.e
flow_act_setup becomes offload_act_setup
and things like tcf_gate_flow_act_setup become
tcf_gate_offload_act_setup

Again from a naming convention that tc_setup_flow_action
should be tc_setup_offload_act() really..
Maybe an additional patch for that?

<Rant>
Really - this whole naming of things in flow_offload.{c,h}
is very misleading and simplistic. I know it is not your doing.
The term flow is very much related to exact matches. A better
name would have been "match" (then you dont care if it is
exact, prefix, range, ternary, etc). Note:
In this case you can offload actions independent of matches
so a binding to a match may not even exist.

cheers,
jamal
