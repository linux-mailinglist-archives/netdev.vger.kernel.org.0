Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD494B79F8
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbiBOVvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 16:51:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiBOVvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 16:51:23 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BC2D5F72;
        Tue, 15 Feb 2022 13:51:13 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m7so502396pjk.0;
        Tue, 15 Feb 2022 13:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mexl3os4BQqYiQV1Two8gyEZOIW76cOBbYjh80oXZRc=;
        b=XuFSQmRrVV5aRBEPyP3BEPRjdy/3JQIe2BH9WIOfwaBRne8yld3renrqxEmMJh+ElN
         vH1LuvUiyeSSIUfg2W//ST8J55qFhQIpj8nfzUVCjxjudsKcWDIE57FIepm0C+nSuupX
         Sk7ADm8lFFtdQr54NfN2GZWNhRP4JD9eWnu2B81UbaykpWelj6gFC00T9Nby2fjW1x6P
         yfdP8nvNXP1HstDUZ4vuQ6agbv38e2JApSEs6Ke/UwX0aKKn9lAUSCXUlX1sta3KSz4Q
         /yj05EqV+MOM5OCXL51GHne6DBtDWb6/LdIj8NQ9rm7FLV/HixV+41W3yHIgSICVXDsU
         lXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mexl3os4BQqYiQV1Two8gyEZOIW76cOBbYjh80oXZRc=;
        b=g9cU6rgy6MIUOu6UwbVjgUu4JQdjUJF4zDJDkVQKcgwRikvlhr/VXY02tcnX+RQwMQ
         DQD1Mc9YQR2MTtXtT2+gjvxCG8F46ZsFM+qauUwtZY5F++6HdhUuyqw3f6tfHCuEXg5V
         wQE6e2XYO4ElWl46B/PokDV5mqiIbtZOamAccDJbib47HnE6b+O0lNwxbsY0GHG57Z+Y
         lZw340kEji4pb2uuuuSFsPWYCM8tnNNPdI0P9OQkeKQiF570VLJEJIrujXT10W1hivcp
         FEMW+/L+BLjL6USSGffG15K6Ua9VajLJB1nHIRawzvzwbrg6Xl63t4O6kUTDACldnGZs
         OzLg==
X-Gm-Message-State: AOAM530LGeLh6Wh6WrggSmQvaRyRuRMnkqm3fIJ1NqdEMEM6DPnp5s2P
        LxkaSuvZcTvYSpKJOkcaja4=
X-Google-Smtp-Source: ABdhPJxQ/5GF4sBQCPRsKWvD0cB3cbEOz0QRM4q8OD13AysF+sxQaMhIkcxg5Bn3ML5+05shYbB8gQ==
X-Received: by 2002:a17:90b:3e85:: with SMTP id rj5mr946051pjb.65.1644961872676;
        Tue, 15 Feb 2022 13:51:12 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e4sm2230484pgr.35.2022.02.15.13.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 13:51:12 -0800 (PST)
Message-ID: <8cb46dd1-c2eb-869a-0af8-443d84a83b85@gmail.com>
Date:   Tue, 15 Feb 2022 13:51:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: 4 missing check bugs
Content-Language: en-US
To:     Jinmeng Zhou <jjjinmeng.zhou@gmail.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        shenwenbosmile@gmail.com
References: <CAA-qYXiUFi5atN8tGRdORbiGqWnbdquuAeKuwdpWSVFVO2FveA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <CAA-qYXiUFi5atN8tGRdORbiGqWnbdquuAeKuwdpWSVFVO2FveA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/15/22 04:37, Jinmeng Zhou wrote:
> Dear maintainers,
>
> Hi, our tool finds several missing check bugs on
> Linux kernel v4.18.5 using static analysis.
> We are looking forward to having more experts' eyes on this. Thank you!
>
> Before calling sk_alloc() with SOCK_RAW type,
> there should be a permission check, ns_capable(ns,CAP_NET_RAW).
> For example,


v4.18 is not a stable kernel.

No one is supposed to use v4.18.5, and expect others to fix bugs in it.


