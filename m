Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75DE1C5E3A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgEERAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729310AbgEERAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:00:52 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C34C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:00:52 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id t3so3063110qkg.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d20nDWhAZ8nK9XRx29AnSwojY3R78JsExl1JZqJ3/vU=;
        b=AsfEj20s8y3jNKJkmckkwTK4MaKWs1i0PXb1bJaF7tn3ltlMEolNW0mTHk1rXpP7nV
         DRSB43MuIMWMTkjh5PYg3XW+zD9DGwUm8m7weEk2A+SUodYV/EPbuO3/1vRZy302XsHn
         WKKuXn9OTq7BVECQ/TIB1aInM2xENFj+LnBb317EkA4lw37VjfpdwSCcSX9Zhw7WAXwp
         do9n9cqhi6d9o0/v1n/VCIFenweXLY9gNAdAOKb2j4R5Qrju7UOEgmVNsA5KaTUP5+x7
         CHOvLaN6OvlNHPaPDUerTPF9zA5KEbpiGOuhE+/gewXrXpfYaLEBL/QqSXUIiQXATx2U
         bnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d20nDWhAZ8nK9XRx29AnSwojY3R78JsExl1JZqJ3/vU=;
        b=O73jKjo0xi/zkBTHCBvn2YUsycVkYkftycI7AQQEE7jL9A5YeVrh4v7zTH+vrmwu5R
         JtK/Jx0kZwKIippKmueSstudpSvIc4ffvHL/ysKo03CuKi6LtjUgCeEm4swhqi/C7P7/
         aeOzzjfd579nMRL1ntuIFE/Lm8qA+sdOsJI88x70eXflAefbWrF9Z4x5bQpUaC++XL2l
         OQdY/KBGlMll8biCn6arDCQ5xhhKq/5WCH4E7l+BdDGU1Le1CQSb0txBOOe4RHWS1DkH
         K2F/QVLd97Ahalf8n6gsdKWLQCX8MzWRdJdqlCWywpIwCBw+FZPB0m0UUsJyhpgl7UPO
         afvw==
X-Gm-Message-State: AGi0PuYTSwJua5ADZExUz+CJ8QSDs9AwnrInuxlxuwEg42XAMBB0k6i8
        6Y70df/3rFY/nJKV059K+RGGCG0N
X-Google-Smtp-Source: APiQypKCExjnxVxNYDSPcq9ykYi9Mf7oXpkPf+TJznGRQwY9VVA5vX55fzTPf8Isd95DfOdqpxc/2A==
X-Received: by 2002:a05:620a:89d:: with SMTP id b29mr4597017qka.103.1588698050438;
        Tue, 05 May 2020 10:00:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id d23sm2228556qkj.26.2020.05.05.10.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:00:49 -0700 (PDT)
Subject: Re: [PATCH net 1/1] neigh: send protocol value in neighbor create
 notification
To:     Roman Mashak <mrv@mojatatu.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1588383258-11049-1-git-send-email-mrv@mojatatu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <073f9bbb-fece-68e8-dc39-fa3eeccb152e@gmail.com>
Date:   Tue, 5 May 2020 11:00:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588383258-11049-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/20 7:34 PM, Roman Mashak wrote:
> When a new neighbor entry has been added, event is generated but it does not
> include protocol, because its value is assigned after the event notification
> routine has run, so move protocol assignment code earlier.
> 
> Fixes: df9b0e30d44c ("neighbor: Add protocol attribute")
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---
>  net/core/neighbour.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 



Reviewed-by: David Ahern <dsahern@gmail.com>
