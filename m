Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546BF3C156D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 16:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGHOss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 10:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbhGHOss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 10:48:48 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434F1C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 07:46:05 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so6113027otl.0
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 07:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gydcggy83Y+XYIYL62WYQRY6KVdLVFniRJtIx2ZyVH4=;
        b=ikkmBCKrRVQJOlS3B9KgNDoPD49caYdm/PpaghzeBTrkjUMa+Gr4J+ao2YZN0J1bJ0
         A1mQQT3DBDrQsyQqnniTo/lX718hju8E1Bzi/BaPZi5xyRun7vGR0cgPFKkzGGP59xSd
         yXzVUu9oHp476W66Lq3mnaRg5m9OVaGd3pG+93AVOiPDlg83gVKlD61/BNzONmNW/+Jr
         jSQMw2TMFhoUd1dndCHUnd+FLFLlkbMT4O6r89pRItmjK8a8O6ulLJhY5uO3pLnJ4PD7
         m/VDUmZrhAgQNargWX3QxtIJw1y596YtFvEUxxg76n7VoKfS1bKNWvpjHQSdNs9P97fP
         Y/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gydcggy83Y+XYIYL62WYQRY6KVdLVFniRJtIx2ZyVH4=;
        b=mps+OyORo4+Pgu8Dp+jO6aQRAAQTCASOnBEFNhQPzgOGmqBb66lRitB1RuM+I5Ti87
         /WpNoRr4o+BEJj+doDIKcPROO8C5XdDljmnMHB/sTfJUARY0ucq3yeGbXZv6k9tYbmDF
         HAKkApYnCi8qBOYlNCEz5v89tcy9+cXoQhAcxH6Nufrw8sjVYW3mzHf0LB3GnBUsLgAN
         cGwGE3b8UvVlfiZ6mQSq4IiSm1XAXrJCE69twpu9vGEnybMrXzTR8BEuYz6OEDDyjn1p
         XYVdSC9M/jsY2mKTAJhc4uRLkNwy2LQh8TJlWhD91431/HQ9Hkqxpy7BUYqX9atPcyn3
         UPoA==
X-Gm-Message-State: AOAM532TK0wLxeYxWqVI3q4XPdqrv4ltrTbfGpdoD/jHM+w7CRNYrOao
        aBO91PvOOe7j8w677ZAA0f0=
X-Google-Smtp-Source: ABdhPJwc5ATejKFSakHe7OdiXSzP/jgjHIy4lAxgIsp8ugUtQRQWFTp2iEV2r2kC0FDAZEx7s08Luw==
X-Received: by 2002:a9d:77c6:: with SMTP id w6mr863929otl.123.1625755564717;
        Thu, 08 Jul 2021 07:46:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id u22sm559021oie.26.2021.07.08.07.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 07:46:04 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     Roi Dayan <roid@nvidia.com>, Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora> <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ba39e6d0-c21f-428a-01b1-b923442ef73c@gmail.com>
Date:   Thu, 8 Jul 2021 08:46:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 12:57 AM, Roi Dayan wrote:
> 
> 
> On 2021-07-07 9:53 AM, Hangbin Liu wrote:
>> On Tue, Jul 06, 2021 at 10:27:34AM +0200, Davide Caratti wrote:
>>> my 2 cents:
>>>
>>> what about using PRINT_FP / PRINT_JSON, so we fix the JSON output
>>> only to show "index", and
>>> preserve the human-readable printout iproute and kselftests? besides
>>> avoiding failures because
>>> of mismatching kselftests / iproute, this would preserve
>>> functionality of scripts that
>>> configure / dump the "police" action. WDYT?
>>
>> +1
>>
> 
> 
> why not fix the kselftest to look for the correct output?

That is but 1 user. The general rule is that you do not change the
output like you did.
