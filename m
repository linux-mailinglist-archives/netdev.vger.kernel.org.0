Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA5299379
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1787406AbgJZRM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:12:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41398 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1787390AbgJZRM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 13:12:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id b69so9042097qkg.8
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 10:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tr/tHSNQP2fV94sMZ6KdpFbjVi2JwLl8zPoIG2ibueM=;
        b=x4pdZBV8YJX6mAQF/6QML7Ogk//9/PCyGUdQS3QAyOfZyZeIMFOeZNs7goMwHwB6l3
         JKmj2mrQcgiJ592lYXJ5kKM7I1EGzg2Ari7UbbsYFK16VPDWZ3WUDN+jqwq9wKVRWf5m
         UO0ngBS8xfEGg5+9xZa/0N0wWBdpLfvyKYmYdsuqCstVr3XQyAGmQtFFG4kUkuV5Rzy/
         kQ51/YU8z/E5PtesvA4S68TnPHorWodfsmSbqGjrKDM+k7ZEBZuqDdPDCVdkWu/ySbaP
         DSzJrblZ6dTf8nsL2OQZrO+ChWjLrv8ywWZ804Y3Xvj4pQI9bYWUOIngOYp04moiEdYc
         97BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tr/tHSNQP2fV94sMZ6KdpFbjVi2JwLl8zPoIG2ibueM=;
        b=HXAqQgGDDULvpM9WiIEg3+36ezXUBoMIkLInvZJ0/Z0iqr9/X1dkgK9nZ7f+dCOI89
         JdE7hhp0S3SfJbNqGRoK/XEhYE35RsJMa1weA1jdOqwF9WE+qSiBkrzUmlkfgs+jHFWX
         igby9g3Lb6z6hhtbf15TL7vyjXLZhOkouSLplTJTtLN49+OQTz7C3OrzAfNsd/WBwI17
         RuvwZhIjcAFuGvG+wQ+0ZKMdk2GNX4t6jk6aRIQttZK7OZAVeKHkBKKO4cOEwjE3w1yK
         cDTTpmyODKdxiw2ZsJ+YxJT4bgxNPml1OoA1LSdBUTQCyUBs/9Ihsv0czxLRI7MewUtL
         Iadg==
X-Gm-Message-State: AOAM532syIgkKxpff++02h4h/ljx+Vu2RBiy5Q9CqIy542t+rlDSfUqe
        a5RjUJYR6WfEFVBWm858DNRt7zm6dn9Eqg==
X-Google-Smtp-Source: ABdhPJxqtnAx+GvAF7njZPvDBkloVkmubCd2zpL2qxgcofAZtZUm9dwR/vjj+v0hey+G16hxfCyFWw==
X-Received: by 2002:a37:480e:: with SMTP id v14mr1710525qka.414.1603732377227;
        Mon, 26 Oct 2020 10:12:57 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id f1sm809095qto.18.2020.10.26.10.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 10:12:56 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
 <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
 <ygnh8sc03s9u.fsf@nvidia.com>
 <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
 <ygnh4kml9kh3.fsf@nvidia.com>
 <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
 <ygnh7drdz0nf.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <370dd8e0-315b-04a5-c137-3b4f3cbd02a0@mojatatu.com>
Date:   Mon, 26 Oct 2020 13:12:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ygnh7drdz0nf.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-26 7:28 a.m., Vlad Buslov wrote:
> 
> On Sat 24 Oct 2020 at 20:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

[..]
>>>
>>> Yes, that makes sense. I guess introducing something like 'tc action -br
>>> ls ..' mode implemented by means of existing terse flag + new 'also
>>> output action index' flag would achieve that goal.
>>>
>>
>> Right. There should be no interest in the cookie here at all. Maybe
>> it could be optional with a flag indication.
>> Have time to cook a patch? I'll taste/test it.
> 
> Patch to make cookie in filter terse dump optional? That would break
> existing terse dump users that rely on it (OVS).

Meant patch for 'tc action -br ls'

Which by default would not include the cookie.

cheers,
jamal

