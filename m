Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157304F5E73
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiDFNAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiDFNAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:00:12 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465AA5B9542
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:25:58 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id bn33so2369565ljb.6
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 02:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C6QDCDUyjEGvBSzCnZBnMMd2TYRDDb79iUJmxGyEU9g=;
        b=foP8RN/cqAFvB8ZW6FsCcqYmzD7CLs174xyGAMJ9q1bkBilx6T9jjHcF8kWO7bEP/0
         C7JGrx5fBvB02Y4YCwrZLOKSLm0Mib1F3xvJNnxaltFORzUulNDQRpJGs6qbmc4ilDGY
         Qk1i/BFWroSndKkLmUJ6TXCFC4+LUbyaSNTPePWkXLyNWOy53IsEEqK4zfWxKp/mbs+G
         0sE9Ghm5/z6tD8t8BmwOVzJXXdTHEI2aUxARDuOoORmFxBYEt9gA0lZkDOLUQ89Sx0Nf
         NOgJvrUvL+/y56IjHQCxniRDNRwo3f78IxFi/4qTBZKRppKaFnK90IBtLshgix0mo9KF
         iqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C6QDCDUyjEGvBSzCnZBnMMd2TYRDDb79iUJmxGyEU9g=;
        b=xHOcxm9znkxBiSpD/i7Fr8+KWnWvg3nOmRBzizaRwjW198dM+6g41MNSGZOSPzn2lK
         Sp2CNTUFHg8mj4TxW67u9LRJL48/2y44GMpKN7B1HeYkYZwbXLN394fQJAvtFCvNffVC
         SGvXaP6TT2iNdEKn4Nz54M8FEKRfEDbVITxXL2CnfpOcwjCEVRRWT8cylckzFPwX799X
         i5cQThzObnGimxi1jTTCSgMdzBjT/oRlzquUBhjkFUCMkW55VNeg+UlxhCpCdCYYyOpj
         rZBN82+M/j4/iqkjyC5IZrnPNUihrqXVlu5wnX28gB1PocTlXNAdeCwBOQHup+oLCEC4
         5Ebg==
X-Gm-Message-State: AOAM533FGzR6f81X1dx+BBkBNutx0f4g75t2apyjY6QrtBtme8RLpw2d
        /9cAKpxhBLamn562NJxbB3FY6y2+pAxlEA==
X-Google-Smtp-Source: ABdhPJxUW9WGAx4APfbnAAb74hsg8mPYCCGCYdayAoNfuH39JV5yWQp7tpc0dZYo/x0zBT3NDa5E+Q==
X-Received: by 2002:a2e:bf22:0:b0:247:da0b:e091 with SMTP id c34-20020a2ebf22000000b00247da0be091mr4773402ljr.489.1649237088413;
        Wed, 06 Apr 2022 02:24:48 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id p41-20020a05651213a900b00443fac7d6ffsm1775273lfa.108.2022.04.06.02.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 02:24:47 -0700 (PDT)
Message-ID: <84412805-f095-3e39-9747-e800c862095d@gmail.com>
Date:   Wed, 6 Apr 2022 11:24:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220404104826.1902292-1-mattias.forsblad@gmail.com>
 <20220405180949.3dd204a1@kernel.org>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220405180949.3dd204a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-06 03:09, Jakub Kicinski wrote:
> On Mon,  4 Apr 2022 12:48:24 +0200 Mattias Forsblad wrote:
>> Limitations
>> If there is tc rules on a bridge and all the ports leave the bridge
>> and then joins the bridge again, the indirect framwork doesn't seem
>> to reoffload them at join. The tc rules need to be torn down and
>> re-added.
> 
> You should unregister your callback when last DSA port leaves and
> re-register when first joins. That way you'll get replay.
> 

So I've tried that and it partially works. I get the FLOW_BLOCK_BIND
callback but tcf_action_reoffload_cb() bails out here (tc_act_bind() == 1):

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/act_api.c?h=v5.18-rc1#n1819

B.c. that flag is set here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/sched/cls_api.c?h=v5.18-rc1#n3088

I cannot say I fully understand this logic. Can you perhaps advise?

> Also the code needs to check the matchall is highest prio.

Isn't sufficient with this check?

	else if (flow_offload_has_one_action(&cls->rule->action) &&
		 cls->rule->action.entries[0].id == FLOW_ACTION_DROP)
		err = dsa_slave_add_cls_matchall_drop(dev, cls, ingress);

If it only has one action is must be the highest priority or am I 
missing something?
