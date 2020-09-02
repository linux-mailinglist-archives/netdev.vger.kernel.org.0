Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D9725B3DF
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgIBSkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:40:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728190AbgIBSkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599072014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0uPPhC3zXrQ09ZOMV6+TGvbzv6S3EaGNYNTJu5Zubg=;
        b=H7Kb5QWT7c1O4TMb991usAw+mZ23EgcADO9HJZ2YHdDt8ofmi4ZprvoaQa0hvOn0pQ2FOy
        3nuMK3UHZeeDwgPzGSD/RJlVrrOEr+Z4L9OY24MpIsctqMnICYTzrEEz0ebPpb6y9M+10N
        ivwUQqXdLaCV5J3stNATo6AkjWpWri8=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-hFVBJwwjNSqGzLFwhAYCdA-1; Wed, 02 Sep 2020 14:40:13 -0400
X-MC-Unique: hFVBJwwjNSqGzLFwhAYCdA-1
Received: by mail-il1-f198.google.com with SMTP id k8so394439ili.21
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 11:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=j0uPPhC3zXrQ09ZOMV6+TGvbzv6S3EaGNYNTJu5Zubg=;
        b=i1zLTodyOpINZeB8+3yDiEB4PwHm9O/PtHKFhaa1mWt62W4UmM8ix+TqWk0YJ7TH+k
         bAVg/zIYwBkt2gnO7/THQEDp9odgCMs/QBrLFCf9XZuz+mHqrJvbTNMmkeZLPTyhq7jv
         AQFQa0y6t94sKLPK1yeK6ZzS0Gc0+sA3gj3oMkEZeupxaNrjFh6G8+DM3YtPhqpruiso
         pkiCfqY3yvZrzAwdCIsj+YJYhdu/pUiEFaRILjjx77Z6JfREueEHHdWuPzA/bE2F8Krd
         7RtxRYZHP8M+NYUTR28o+k5DX74HhK5bM9507VDZKYCfbDhsXCDAcdOjOiwttoFqFGJa
         tyjQ==
X-Gm-Message-State: AOAM530+Gnt1Gx8gmId/tpweL78NchgPlDKe7ACoy+63LQW4K6Wr1TKo
        I+r4McIpabzu2V9m04ZBZJ7FzfaEiXSJajWfluF9OU4h0J9bX8nI4ABbxNbaBEe99m8dtLenvSQ
        lyZxsKvLQOG2DWLvB
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr4629244ioh.186.1599072012699;
        Wed, 02 Sep 2020 11:40:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZtLCzpJ4UK29gX+Y0AYBy64NrsA5WDVyrB09mtmKEQIp2UsYMvd2RPnoUL0lxE9o89yAuGQ==
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr4629228ioh.186.1599072012548;
        Wed, 02 Sep 2020 11:40:12 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id o1sm191736ils.1.2020.09.02.11.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 11:40:12 -0700 (PDT)
Subject: Re: [PATCH v2] net: openvswitch: pass NULL for unused parameters
To:     David Miller <davem@davemloft.net>
Cc:     pshelar@ovn.org, kuba@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
References: <20200830212630.32241-1-trix@redhat.com>
 <20200901.131111.186993526997490086.davem@davemloft.net>
From:   Tom Rix <trix@redhat.com>
Message-ID: <7b82468b-bc67-df62-1816-1f510888fc39@redhat.com>
Date:   Wed, 2 Sep 2020 11:40:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901.131111.186993526997490086.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/1/20 1:11 PM, David Miller wrote:
> From: trix@redhat.com
> Date: Sun, 30 Aug 2020 14:26:30 -0700
>
>> Passing unused parameters is a waste.
> Poorly predicted branches are an even bigger waste.
>
> I'm not a big fan of this change and others have asked for performance
> analysis to be performed.
>
> So I'm not applying this as-is, sorry.

no worries.

I think these functions need a larger working over so the stats collecting are not in the core functions.

Thanks for giving it a look,

Tom

>
> It's also not great to see that CLANG can't make use of the caller's
> __always_unused directive to guide these warnings.

