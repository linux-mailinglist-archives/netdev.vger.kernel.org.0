Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4F979AE3
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388539AbfG2VQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:16:38 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:35744 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387595AbfG2VQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:16:38 -0400
Received: by mail-pf1-f174.google.com with SMTP id u14so28670394pfn.2
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=E0efd4PV3Uj6GcfE9yL7gXeJE0Hngyl9mCBuy9/pXuU=;
        b=Njv6/2Xn4sV3PPt9NKLCzrMhrZN9HHpMeq5Zyn9bsrf3Tl5/U0ZsnrALz14wLWy+Kz
         Pe1pvPb+sCsZThy2+4M78L4nlCgVQb6t0vCHQxc1lELd53KKvqgOvZGP6PXIPiY0TvTF
         /d8uxwGtf8qRDWaM1a60KUwMGRap/fL7HS1PttAW4c76KBJylOx+t+P3w9Dl2amLP512
         nPKs9vYVT7Btgg44w+4h240pWnzKp38C6xUe6ij3knatDY9ZomsGUdGzvEgi6ouUkVJr
         1SHolPHU+5ARvDR4aASfRz6cKKGB0q21QLGaIFqHYfOm2tltHFT/0usdl/I2QLmnnjcu
         hxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E0efd4PV3Uj6GcfE9yL7gXeJE0Hngyl9mCBuy9/pXuU=;
        b=Kah35iadH+JpYa84RoYqxsQe78ZoDgG9E1NXxSM1qEffJh2l4n6pvXMjXfpC1GO1Ci
         PvV4jYd3PnEQNAkirHFksUfJqmYArVk9Fajoj7ymJMMBlp/gaEtSKpNVXwiron+7/6QW
         iGH90rhahkKV12GINWbtI2yPccsrc4sB7s/F63y2PdbOVto1aConS5arVank7N70+vJc
         tEJ3hMoALbXmLd1NXl59fW11r1ihF5Rg7DVxUc8TmRG4DDoeSiq3gszE56lYuSqsKD+r
         LotbCCkjt3wDXLVUQhPZEZH9VTC1wv3EDliWbmw9bRoCjz9OBnKBRSE3sjljYNHyV2qm
         dhLw==
X-Gm-Message-State: APjAAAXxXxJLU7fBKGfo97yAqV7ua5WpML9/Z2QqjkErcaopCVjLQ0b/
        5V2HeMi30H0CHqwTrqr3lqfQJ6X570w=
X-Google-Smtp-Source: APXvYqzIdOF5o2nb3ni96udcVBjOZlTC+J34mFqNx69zWx/P04xt5/IxnVubBIcnlRB3RhFIDL2EJA==
X-Received: by 2002:a65:5144:: with SMTP id g4mr53606846pgq.202.1564434997476;
        Mon, 29 Jul 2019 14:16:37 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k22sm65900042pfk.157.2019.07.29.14.16.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 14:16:36 -0700 (PDT)
Subject: Re: ip route JSON format is unparseable for "unreachable" routes
To:     Michael Ziegler <ich@michaelziegler.name>, netdev@vger.kernel.org
References: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fa98618d-8053-a944-f83b-a1260540bb45@gmail.com>
Date:   Mon, 29 Jul 2019 15:16:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/19 5:09 AM, Michael Ziegler wrote:
> Hi,
> 
> I created a couple "unreachable" routes on one of my systems, like such:
> 
>> ip route add unreachable 10.0.0.0/8     metric 255
>> ip route add unreachable 192.168.0.0/16 metric 255
> 
> Unfortunately this results in unparseable JSON output from "ip":
> 
>> # ip -j route show  | jq .
>> parse error: Objects must consist of key:value pairs at line 1, column 84
> 
> The offending JSON objects are these:
> 
>> {"unreachable","dst":"10.0.0.0/8","metric":255,"flags":[]}
>> {"unreachable","dst":"192.168.0.0/16","metric":255,"flags":[]}
> "unreachable" cannot appear on its own here, it needs to be some kind of
> field.
> 
> The manpage says to report here, thus I do :) I've searched the
> archives, but I wasn't able to find any existing bug reports about this.
> I'm running version
> 

actually that was fixed by:

073661773872 ip route: print route type in JSON output
