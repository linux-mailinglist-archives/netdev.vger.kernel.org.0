Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530CB471583
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhLKTFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLKTFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:05:45 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC578C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:05:44 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id m192so10776504qke.2
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YNVxd4m3NvT8jtZnbnRDzPJDqL5jaXQjloQr3iHbJvA=;
        b=hE6reIQyn9aIfqtHaYO648nhArCpR0KMXOy4587mXTYljpk3SaNLo9yRqxRNcwL39d
         KXnujOGYMSd7VInV8LAQsgwynv2xgGHo9UjThSX9EYXITr/251fBoFPF8HWwQYNXNuyk
         rNp7f+8clwDhNsPD50JFqlpx/Fsa5Jq4HGQcQfSt/6nASA/jdsZIKuhxUCpqHFmvu06a
         rII2ODvNDu0n4zZvWWZx2Eq/owoww0Th8T6/f08V2qOZ9P99byv/1MoSSPXD2w0tCpIo
         4wO754Z2kAS98Pm6ClWRndak3pC2l5IdSTeOuFJQYPxCShSj8Q3xc2Hsl+dqSauQWbTu
         +L/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YNVxd4m3NvT8jtZnbnRDzPJDqL5jaXQjloQr3iHbJvA=;
        b=XMNdPcza6LyBOZv92LCtQDd5sP6dsi8CNhgGd1iOyBI1cksj4r+lbzcNiYKpSb3UX2
         sTmAfp/cgqP6ggtQ6/GsOHIiMevteY9MCjUHSswsqmClVFid4qdAYIAXV1XbJhXZi0um
         DISLNwEmLRXi9Z+SfEipTSRrZB4rrYBlxAaioa/aKn93sqCCspQ1AWpuD4PlQH2nngpx
         iEDWsAff4EnkNhBUk1Doji+lIeSCJEk5N3hVIGMfw2rKQNwP6Ip/Z1mMphMDh/zC/ZVB
         S+R/jABTOBy9kTrz4dnExLuv60OYJ0IBLDIbHw1XHShpLp8lZEOBw8Ej/d/NBWycaao+
         GI0A==
X-Gm-Message-State: AOAM530/4eO1idM+PnWcpLtfCj1aktxqHvFZL0Sx+H4WspyHDGXmpaL3
        skvkIV1m22iodR+zt/LyacugeQ==
X-Google-Smtp-Source: ABdhPJzq1U9lrMhaAllaA8ecsiLXj7CJMyqXMsQ47YcTjTSIXuBlnVBD1Wklo9HVh+ejNnC/Vs4iVg==
X-Received: by 2002:a37:a087:: with SMTP id j129mr26557699qke.211.1639249544100;
        Sat, 11 Dec 2021 11:05:44 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id e13sm5123910qte.56.2021.12.11.11.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:05:43 -0800 (PST)
Message-ID: <a3ab2d5d-a4c3-7b4b-7da0-29f3d3fb33fa@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:05:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 01/12] flow_offload: fill flags to action
 structure
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
 <20211209092806.12336-2-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-2-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:27, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Fill flags to action structure to allow user control if
> the action should be offloaded to hardware or not.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
