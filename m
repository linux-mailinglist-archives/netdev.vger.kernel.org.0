Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842CC2160A5
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGFUxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:53:31 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5E3C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:53:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so42655125wrj.13
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eve4O4C8UTzN0RISNCluFtUbow9NOyYSnxvO0Vr8WBw=;
        b=YitR/ngeRskKjw2+3QdpYyilSxeObGM+0oBk5QeLyjQd94DNJ06f5OjCds/hvgCFY8
         V5csSW++4rWqISPpvhl14rYvlLaP/N+19lYK2XJ//ag2cAeTHHjanw3Ry4HHkX6Sud/l
         h75D2Uv4lJ/gNmwzIzARPoLElBVzES895rQ13aqpGMEddBQpaaq8JngGysuq0FB1w/LN
         x/qWKJzCV+FJ9cvuMPJjlik3gay1928hx9eJB+MTGNhrT7Pgfa+YvpSKLqeSyhmRlHbF
         F3G54w7pjBt7ggyYFBSeujIab9U4XwDYVl590gaz203QGxxgXQmfe93UAZ64rc1+0goi
         ZWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eve4O4C8UTzN0RISNCluFtUbow9NOyYSnxvO0Vr8WBw=;
        b=nOdeI8rC1GZQG6S3tq7fGBlef52WlXFz7SQxkBpRLWlHakjET+u4jDqVItM7uMVS+m
         s9LTu0ZwNl2VzB9L6t7Y8OU4dO9xJliiZF7mfExB6r326OR3rvJ85nTtsqQBZ5wfaQCW
         VCvBdpy3jegHd9UXbrLmsdV9/LZBYE+Hf1EFpCueLxJ+HIf5yR834zq4xTCqyyzS6Yzf
         iwPiPZwqi5FPirB8odgEKDgMvuZ9WpZjQfil53O5mdmNAB3coKiesBmRKT4Vh9q24FB5
         xME+C/a5wdL0t2JwXNdPs5Zu0d3efRqEmQhGbOy+YPhicDGzvCRC96WQyqe9HRQPZ2yj
         i6dw==
X-Gm-Message-State: AOAM530XfHpJ5Encn7Dev0+ifm3AZ8MBsCL5/8U7Rh4vM40MvlUDDlcd
        6E0XgVqY/O4w6/TXkJ+RJOY=
X-Google-Smtp-Source: ABdhPJx9linQxZrjGzXhfHqqAtOamOAKmu8qXLZyh/QKFBleJT9L8m4UX3mMgrEqrJBOrYAKdOHFHw==
X-Received: by 2002:a5d:4002:: with SMTP id n2mr53659112wrp.255.1594068810281;
        Mon, 06 Jul 2020 13:53:30 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id g144sm1112200wme.2.2020.07.06.13.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 13:53:29 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 0/6] PHYLINK integration improvements for
 Felix DSA driver
To:     David Miller <davem@davemloft.net>, linux@armlinux.org.uk
Cc:     olteanv@gmail.com, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com
References: <20200706084503.GU1551@shell.armlinux.org.uk>
 <20200706.125454.557093783656648876.davem@davemloft.net>
 <20200706203924.GV1551@shell.armlinux.org.uk>
 <20200706.134611.1669469964883291908.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc1115e0-e603-d742-125a-30f42ff97016@gmail.com>
Date:   Mon, 6 Jul 2020 13:53:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706.134611.1669469964883291908.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2020 1:46 PM, David Miller wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Mon, 6 Jul 2020 21:39:24 +0100
> 
>> On Mon, Jul 06, 2020 at 12:54:54PM -0700, David Miller wrote:
>>> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
>>> Date: Mon, 6 Jul 2020 09:45:04 +0100
>>>
>>>> v3 was posted yesterday...
>>>
>>> My tree is immutable, so you know what that means :-)
>>
>> I was wondering whether there was a reason why you merged v2 when v3 had
>> already been posted.
> 
> I simply missed it, so relative fixups need to be sent to me.

The changes were more about the commit message than the code itself...
so I am not sure how this can be fixed without a fixup! or squash!
commit which you probably would not do since it would amount to
rewriting history.
-- 
Florian
