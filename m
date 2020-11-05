Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70AE2A7D7B
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgKELsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKELsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 06:48:53 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8791AC0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 03:48:51 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id l2so855195qkf.0
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 03:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m+Zufvd54wO3VEEFDq424VjNE7m32M25R3h/w4VcU88=;
        b=iMVIvcfjTxQ8VtqTVMSln4OLsGDQ48LJ/xZ//Bw5KRzy2znbpPyx51u292jpFQ0R46
         SFzzqkhdifNThpgtBpFFhGKkWqaIe3+EDUJtpOnoWQPBYbhRCFViEbRRG/WaSMPZzxtq
         rAWTTzCrseedrt2k0D4COsrwdRlNTaPoKgLnCYIyW6kvARugJ3RKTVLJAzcOEaYLaAPQ
         AqzYLPUb66IohJl+/1KGZev0iOmtfC6vBz8ULJ+UOgBJi6vuTWbub79baanklK7RUZj/
         7NLJI9BUBAzHBRLXnX6cfX9zoXH5CjgLnNyXGbQTcachnbIEF1HG6B0t6vauzs0TngnU
         Eh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m+Zufvd54wO3VEEFDq424VjNE7m32M25R3h/w4VcU88=;
        b=lRxWVa74BemJj7bxMksZ/VcPdSEM+1LgBRmGaSwjGDkhzyjXv3507YREDpX8JUK8Jp
         xnz5xoJVkOGdUWFF1Yw3wSnRB85lxOEzPAjEasLbyVtpIXlfzwCr6ywHxW5WYV9+lsBg
         RMHKba1pijpBQEK1Lp1qt22fvQ9dXv++F1++EjZwt86ikIyNVbfe7pXlWDBNhZhDs/fa
         TZDXs7HGqVmlqCSOfpneYBUwBJfx6J8X4Kq3umpk/1NA5T9bO5apYsgUmKTMTw2ZDdvN
         llfGR/LqH8WjIwAxfUnt+T+qtSrTdmp2ki/ASL+MOMFBz8N+kO0ODMxKvpL2Etuvi2KY
         ZrBw==
X-Gm-Message-State: AOAM530ikF++3SdnROv+GwBPvU5Lr1e48qSoEKmLoA1E1Jjt4w0IBdZu
        zl/RBT3O4ODn0IRjjKuTkrV1QJHUcZTSoQ==
X-Google-Smtp-Source: ABdhPJz92RGDJmARIYWI2RWMNNun0cdnZqloth8A0C/Wp95rkj5XaPBF6cOXZQylUxXEVoa5k3hrTg==
X-Received: by 2002:a37:8903:: with SMTP id l3mr1504133qkd.219.1604576930793;
        Thu, 05 Nov 2020 03:48:50 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id l16sm662779qtr.21.2020.11.05.03.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 03:48:49 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: sched: implement action-specific terse
 dump
To:     Jakub Kicinski <kuba@kernel.org>, Vlad Buslov <vlad@buslov.dev>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <20201102201243.287486-1-vlad@buslov.dev>
 <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ba0251f7-e3d4-5197-3a09-8598418e10dc@mojatatu.com>
Date:   Thu, 5 Nov 2020 06:48:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-04 7:39 p.m., Jakub Kicinski wrote:
> On Mon,  2 Nov 2020 22:12:43 +0200 Vlad Buslov wrote:
>> Allow user to request action terse dump with new flag value
>> TCA_FLAG_TERSE_DUMP. Only output essential action info in terse dump (kind,
>> stats, index and cookie, if set by the user when creating the action). This
>> is different from filter terse dump where index is excluded (filter can be
>> identified by its own handle).
>>
>> Move tcf_action_dump_terse() function to the beginning of source file in
>> order to call it from tcf_dump_walker().
>>
>> Signed-off-by: Vlad Buslov <vlad@buslov.dev>
>> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> Jiri, Cong, can I get an ack?
> 
> The previous terse dump made sense because it fulfilled the need of
> an important user (OvS). 


The requirement is to save on how much data crosses between user
space and the kernel. If you are polling the kernel every second
for stats and you can shave say 32B per rule - it is not a big
deal if you have a few rules. If you have 1M rules thats 32MB/s
removed.
So how do you get the stats? You can poll the rules (which have actions
that embed the stats). That approach is taken by Ovs and some others.
Or you can poll the actions instead (approach we have taken to cut
further on data crossing). Polling the actions has also got a lot of
other features built in for this precise purpose (example time-of-use
filtering).
Terse is useful in both cases because it cuts the amount of data
further.

Hope that clarifies.

cheers,
jamal
