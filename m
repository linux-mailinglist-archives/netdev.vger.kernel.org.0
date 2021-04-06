Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7071D35505C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 11:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhDFJwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236968AbhDFJwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 05:52:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEABC06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 02:52:40 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id f12so7525398wro.0
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 02:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dDAgVC/hqtt+LwQPewm7KFVU3XcpgxXGnKxS4+oobrk=;
        b=olzixRXpceJdgJMyBaF/lN+j9XoGyMEVh6iUBezfv53VUTu5BzAWi5AO71nxx4IMPn
         UgxnQxpAhA0hgRvDYFvsM+GntYXc9EditdVSpufCrU/LrGnFmsRDZMHbh95jatNlJhZY
         fQ3oPuQ+njUofZ8WQhxAlLYliUwYBpGUwOJmmsp+S62G0bzj7UegDgMziky5mNtoykBw
         9auCT2kbN7hUbJXaxzRVXQaAo5UR6N8sJxORM+W4bVIvANEkTmbAr8U4ZhPgNXG+RbPm
         6ODeOdQcH3j4VSXYQO1lkt0VCHuMO19c/f+6BCsONH75UtXUNosDGy3SYuW3T07OS6gq
         GVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dDAgVC/hqtt+LwQPewm7KFVU3XcpgxXGnKxS4+oobrk=;
        b=SWmz22GIUIaTiFVkEenEUu2Ibx0aC9xegfByvJTKMdc8Gy9HuNyw8jKVs91qdDA85E
         sragWVq5Bo8EMhsf8pt++pVpYlw6Efq0EhwBN9M3nAL5Y54pTkEUg9VZVq4yKe19KoZs
         9UJgWUrt8l1fywTqyWLizufHR7AJjCIxXhFfoUBwjvuo6UziX8gvots/GZJNALkeqDSm
         t8mNH8yyt7dRnOw2tBq1u24IpFT3z/yKuKfJpMx1qXqzT/4LyRYULe364ZoHeh8pyDAM
         Il5QVE6thxy4fTM+hx4LSiD7Jm69j99QE0Sl0SitjN+tZgNEIYvWUqc9EdlYNst1R8gH
         HL4Q==
X-Gm-Message-State: AOAM5312ghLcTIKm7VYgEjDcdQNBDismRARzVVkSjD19tfZOTk5nq/zr
        vH9hAcxZzSGmVaCW3w62mrVVvA==
X-Google-Smtp-Source: ABdhPJwSsT1j+ARlUiWUw4vcoH8DgHukopL8Ti3FdGHR71I9nXozDjiWHqsPO1O4pYVreB/x/mTkXg==
X-Received: by 2002:a5d:4203:: with SMTP id n3mr33269955wrq.116.1617702758797;
        Tue, 06 Apr 2021 02:52:38 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y17sm1993784wmo.42.2021.04.06.02.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 02:52:38 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: Document dsa,tag-protocol property
In-Reply-To: <20210327181343.GA339863@robh.at.kernel.org>
References: <20210326105648.2492411-1-tobias@waldekranz.com> <20210326105648.2492411-4-tobias@waldekranz.com> <20210327181343.GA339863@robh.at.kernel.org>
Date:   Tue, 06 Apr 2021 11:52:37 +0200
Message-ID: <87blarloyi.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 12:13, Rob Herring <robh@kernel.org> wrote:
> On Fri, Mar 26, 2021 at 11:56:48AM +0100, Tobias Waldekranz wrote:
>> The 'dsa,tag-protocol' is used to force a switch tree to use a
>> particular tag protocol, typically because the Ethernet controller
>> that it is connected to is not compatible with the default one.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 7 +++++++
>>  1 file changed, 7 insertions(+)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> index 8a3494db4d8d..5dcfab049aa2 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
>> @@ -70,6 +70,13 @@ patternProperties:
>>                device is what the switch port is connected to
>>              $ref: /schemas/types.yaml#/definitions/phandle
>>  
>> +          dsa,tag-protocol:
>
> 'dsa' is not a vendor.

It is not. The property is intended to be consumed by the
vendor-independent driver. So should it be linux,tag-protocol? Just
tag-protocol?

>> +            description:
>> +              Instead of the default, the switch will use this tag protocol if
>> +              possible. Useful when a device supports multiple protcols and
>> +              the default is incompatible with the Ethernet device.
>> +            $ref: /schemas/types.yaml#/definitions/string
>
> You need to define the possible strings.

Alright.

Andrew, Vladimir: I will just list dsa and edsa for now. If it is needed
on other devices, people can add them to the list after they have tested
their drivers. Fair?

>> +
>>            phy-handle: true
>>  
>>            phy-mode: true
>> -- 
>> 2.25.1
>> 
