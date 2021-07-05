Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE1D3BBB65
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhGEKoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhGEKoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 06:44:21 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5779BC061574
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 03:41:44 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id d12so17910423pgd.9
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 03:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GmOPP2p87nq+KxCaiyuBJMqpdbYri7ZGEetUfwA2B80=;
        b=B7+XJKjTPWJzHxz3vxDPS7g3t/1N3s8eYG2Fg+S4XoIMq7lpdMSbeSH++UVRmVkYU3
         r3RUS9tBAoDxW4EsgmqsXOuiWXUvE6ry0cV2RSB2TT3v0Yv2xiqbrW4rECn5y/JB8m6m
         1wke7mNYmUtCm3ucZiLsH/xO8adyzeBAvSYwbw3+29GEZlVKowHgvqP77lQ48O9QZoEk
         OqJ2GlswyvWq/uKDBk2rC4X7liU9QZWDSqBgNmubonJoV8Q9f9mmtLNdLH69G1GJqUiK
         AcZN7sVAyQdTYikeP3tq1kpIQrqTRrW0YDqfe+PA+Dceaopwtba69a+S9RYV8/TxlcA5
         UG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GmOPP2p87nq+KxCaiyuBJMqpdbYri7ZGEetUfwA2B80=;
        b=pYOSwFS7OKk0y6sHYkCjJghv4Q1eq1yy2KwhU1wrs6U3FxSD9MsV9uUHGYBezv6ZJF
         5e+TXhcPHS84eYVFLtd2KIcOF7LBAwPOFPgTcC1Uxg5ARZv44+TiXBErY6rZaGMo4cyW
         NNK57QBT6/ygt2vWfjVSKUnO4qEZsZ/rAWBknkLiGCynwDmXJy5rvKYrw+1Z2Q4x2ky2
         7CHPdSZM1yS5f5WZJVuN1+cZ018u0KEaiIGyXS3koDgvZXvhzZAY/w++zLECzDaNpeQT
         4wiRy4nqnE4vbJ55QmbvrawSwfD98LAh6hOF2vUi9wUA7OQz0rOqGO/b2e+GShbxgCiU
         ZNmg==
X-Gm-Message-State: AOAM532F7u+XmtjWx1gCOultfG8pofmkDh4XXgwFUdE4Q8N1sezuClTd
        3Cjp/mae39BFPQZ04hNWnVA=
X-Google-Smtp-Source: ABdhPJzr+2fQoDDPfgIYaTcI4nYCMoOpMYAGAi6RDSVgebUPTY65K6WvqMRX7ZnhVR1u5KUwkfo98Q==
X-Received: by 2002:aa7:9710:0:b029:314:1980:a33e with SMTP id a16-20020aa797100000b02903141980a33emr14588496pfg.53.1625481703836;
        Mon, 05 Jul 2021 03:41:43 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y3sm14416611pga.72.2021.07.05.03.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 03:41:43 -0700 (PDT)
Date:   Mon, 5 Jul 2021 18:41:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
Message-ID: <YOLh4U4JM7lcursX@fedora>
References: <20210607064408.1668142-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607064408.1668142-1-roid@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 09:44:08AM +0300, Roi Dayan wrote:
> Change to use the print wrappers instead of fprintf().
> 
> This is example output of the options part before this commit:
> 
>         "options": {
>             "handle": 1,
>             "in_hw": true,
>             "actions": [ {
>                     "order": 1 police 0x2 ,
>                     "control_action": {
>                         "type": "drop"
>                     },
>                     "control_action": {
>                         "type": "continue"
>                     }overhead 0b linklayer unspec
>         ref 1 bind 1
> ,
>                     "used_hw_stats": [ "delayed" ]
>                 } ]
>         }
> 
> This is the output of the same dump with this commit:
> 
>         "options": {
>             "handle": 1,
>             "in_hw": true,
>             "actions": [ {
>                     "order": 1,
>                     "kind": "police",
>                     "index": 2,
>                     "control_action": {
>                         "type": "drop"
>                     },
>                     "control_action": {
>                         "type": "continue"
>                     },
>                     "overhead": 0,
>                     "linklayer": "unspec",
>                     "ref": 1,
>                     "bind": 1,
>                     "used_hw_stats": [ "delayed" ]
>                 } ]
>         }
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> ---

[...]
> 
> @@ -300,13 +301,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>  	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>  		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>  
> -	fprintf(f, " police 0x%x ", p->index);
> +	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);

Hi everyone,

This update break all policy checking in kernel tc selftest actions/police.json.
As the new output would like 

total acts 1

        action order 0: police   index 1 rate 1Kbit burst 10Kb mtu 2Kb action reclassify overhead 0 ref 1 bind 0


And the current test checks like

	"matchPattern": "action order [0-9]*:  police 0x1 rate 1Kbit burst 10Kb"

I plan to update the kselftest to mach the new output. But I have a question.
Why need we add a "\t" before index output? Is it needed or could be removed?

Thanks
Hangbin
