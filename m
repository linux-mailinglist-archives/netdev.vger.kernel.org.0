Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497584715CB
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhLKTsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhLKTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:48:17 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638BDC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:48:17 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id o17so11655753qtk.1
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bNSMBWz4LZtkAiFVYfrbqbrlav5tps5HaVrFWX7Z3nw=;
        b=PSpMFRSLdXGDcSNwsaae9xSgnW2i0A/cV0bX80naFgPdhKi3Bs9ItFElj2oQzCaa15
         IZixuQ4qtimEvkwXFwfA2Im0MeBvqcOupCIVYclOeL7pYQnFEIkorA5J7wmuC3rPd5xV
         1DhzIVBdcatr9OYqrjHEaLX2F2uHWvT7DCQVTw6II7+Y0yBH2BpEbaV5aFUtCXgNFyFb
         rsLp12b+z6nF5WQ/JcURVEIaacZPGLcS3YYmJbAXPSzkKBXiakdZigBd8bkChLD+tK60
         6PeXiRP3BncQOOWMw6IkjcfcgStdI1dGRQ38gzp7OHqRgvXqeyRwfr5JMbvvsS24dwkN
         xnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bNSMBWz4LZtkAiFVYfrbqbrlav5tps5HaVrFWX7Z3nw=;
        b=EKFMgkDylZdwx/lrAIJ/i/lbdPN7Nfi/K3KSTcyVBh3TxfUhclrR1vLHP9otJlV6cX
         zCvbT7HdSHo7yMYeUmB4sbT9x7czkT3q+9wkim9/GBwEroxtoNg584UJpu5ULkb3ncty
         s1F7NW9p6Oj6KsqbhrHNLsjD0hDGBmTtlILBNuuVVvYhOmeP+rBSeV3W5XP7zNk45gDQ
         GIJKV1ynq/VlHKMt01LJTDmTud6/7BrEzND0J/MZEZ+RadU2PhLQysR5I+Emhx9Qb0Dv
         mWWNyLjWC+7iJAAfy7imjVrH+2rXRwMllKr2SKvewL8dWxNaod5ghAcClSrxKt9ZWXnW
         uLKg==
X-Gm-Message-State: AOAM533s/eg2UyB71JJ0pU6w63vbC8XT7sgHkJEKPQhiuIobeFNBkLo5
        vtEy1ArztyYjAWMEouklog/FfQ==
X-Google-Smtp-Source: ABdhPJwcUNAlWBHNd0Dmq0VPZMSXXJ/13BehbM83qfG710QWRVDtm9f+KnXy2Ow0oAkkPfXcCzVdNw==
X-Received: by 2002:ac8:7f09:: with SMTP id f9mr34831559qtk.163.1639252096628;
        Sat, 11 Dec 2021 11:48:16 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id t11sm3464057qkm.96.2021.12.11.11.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:48:16 -0800 (PST)
Message-ID: <dbe7c1a7-9f2b-51e0-52d7-b2061bd639c9@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:48:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 07/12] flow_offload: add skip_hw and skip_sw
 to control if offload the action
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
 <20211209092806.12336-8-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-8-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:28, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> We add skip_hw and skip_sw for user to control if offload the action
> to hardware.
> 
> We also add in_hw_count for user to indicate if the action is offloaded
> to any hardware.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
