Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91033471584
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbhLKTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhLKTHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:07:21 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4EBC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:07:21 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id f20so11574715qtb.4
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kL6OvDUixT3FQStawqmzdymym/cXmf80px80UtRjMTg=;
        b=EslY+M5m6xiOi19IZ9EgfZgLvMirOT2TXi86Y4HxkMfxoVCOhXMum0otrdyd7o60F+
         etNr8EcQQOFNTYNNSHUZOsaoiI4UE3zWTPxVM30UHuO3VyxxgQV0Bmi2lTiu0H6Rxxxa
         nN0rJb9YeJbzzCsLwjn417O5mxKIYJerV1ip4gRhXZ6InNgqv4hYEjLrf/1HhulA1qKN
         EdHuGN7q23QbazMkEuDVeHHC6rPY4sx3ZD+NscTsCF4fHbID+6/DmnGEaS03ew0YjNKr
         LW3Y9yaeeWPLHolYzUfyztERSUbA/OzfytdS3NDaZGwGso/VgwpR4xKLYBDsi0ew5eBH
         SNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kL6OvDUixT3FQStawqmzdymym/cXmf80px80UtRjMTg=;
        b=tsWGqTfd2zcvSiI9Vz+zt/RQHlsQPJiorTSTFxyi2ZnIgee8oj+HnoEBTytoTmJiA5
         MAe+Sg4wtsTloF3aj18KzFuIJuSHDsExdmQmF+/WOnowu1N2LNkjYyzdBi7SzMNP13eQ
         T1kDEeEsjrI/3uYlYDwFMezIGIBNc+qscy4tN1q2fXxVKyrsDWPHoclI84KziFoJAHK5
         0BrCt3a84vsHwixqo3CKjCDYQTuq3Ix/gX0o3JmMiAJRyvspI/CCZuq3iGGeGOx/YmiZ
         vIIRnbgzwYfwkF3OFq14pklFMhHAfeGgGR6H19HII2pdZb98CoqV0Wa3dGyRwXjQjin4
         z0GA==
X-Gm-Message-State: AOAM5323u7a8P6aazM4FOhT02G6CH/nmnw04PuABeb1ThtNVJhXL2VW5
        PBbR1pUpxVS2RAPKB1Fi8DMZLA==
X-Google-Smtp-Source: ABdhPJwLPQ94zGUy/WDrtUtP3tsyQi1D9uvYNlaTC5BdkYtdHaRyFyPkCpsvGIZm9RzWRbNMxaaWSw==
X-Received: by 2002:ac8:7f86:: with SMTP id z6mr35140370qtj.162.1639249640593;
        Sat, 11 Dec 2021 11:07:20 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id p10sm5164689qtw.97.2021.12.11.11.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:07:20 -0800 (PST)
Message-ID: <34dbc544-13e1-214d-58e0-04fb685fd36f@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:07:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 02/12] flow_offload: reject to offload tc
 actions in offload drivers
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
 <20211209092806.12336-3-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-3-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:27, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> A follow-up patch will allow users to offload tc actions independent of
> classifier in the software datapath.
> 
> In preparation for this, teach all drivers that support offload of the flow
> tables to reject such configuration as currently none of them support it.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>


Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
