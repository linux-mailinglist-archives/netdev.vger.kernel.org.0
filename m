Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64B3200AEB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgFSOHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:07:35 -0400
Received: from tk2.ibw.com.ni ([190.106.60.158]:53912 "EHLO tk2.ibw.com.ni"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730051AbgFSOHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 10:07:34 -0400
Received: from tk2.ibw.com.ni (localhost [127.0.0.1])
        by tk2.ibw.com.ni (Proxmox) with ESMTP id BF1E620E93
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 08:07:32 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 japi.ibw.com.ni 6178A1424BE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibw.com.ni;
        s=B01EB49E-4102-11E9-ABBB-FDA7C1AECE99; t=1592575647;
        bh=Mi/x5CQSDTLlu5za76uyRjx0zh9FZ/wZiq9NZq6r0L8=;
        h=From:To:Message-ID:Date:MIME-Version;
        b=SZPpVivwNljVD6G7j8FXSGS4VsPd8UzM9jDdYpDq/5TsxMsutQvCx9O5M7qMQr6w3
         dVIRVvLjD214EH5/WgL2MU0HXdIvMGk72TNeMYMnjCfhmIQ9NKV/YNnNhPhx2zJgUN
         /kQK824gQdfHoXJDo4hKqgYznyo0KdPaHmaqBqFKUpV0LuUh5Y/+HdCpJZoxoGYBUW
         VHQI063HpprYxukCeFiHrpHTnBQIJo8sUsS0AGOdNq9tq2hXVS5HAxmQi32YmH0Q57
         Gn3KNxt6mI6vrfnyBVV205+xdWCOifhcDNtmq5BCm7zyCGtCw7u8O1oq0yd6VUJYez
         twIw96w1jOUOA==
Subject: Re: RATE not being printed on tc -s class show dev XXXX
From:   "Roberto J. Blandino Cisneros" <roberto.blandino@ibw.com.ni>
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <d33998c7-f529-e1d1-31a5-626aa8dd44da@ibw.com.ni>
 <CAM_iQpWa6KmiWv72YmB3ufR8Rw9RD9=PwLMamjOS6fSCM+zXbA@mail.gmail.com>
 <d746708a-f000-a6f7-d0d5-ab5905d080da@ibw.com.ni>
Message-ID: <60d5a5e7-854b-1fe3-b433-4a59b5e74866@ibw.com.ni>
Date:   Fri, 19 Jun 2020 08:07:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d746708a-f000-a6f7-d0d5-ab5905d080da@ibw.com.ni>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-NI
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


El 19/6/20 a las 07:56, Roberto J. Blandino Cisneros escribi=C3=B3:
>
> El 18/6/20 a las 19:30, Cong Wang escribi=C3=B3:
>>
>> You either need to enable /sys/module/sch_htb/parameters/htb_rate_est
>> or specify a rate estimator when you create your HTB class.
> Does it need to be set on the "root handle"?

echo "1" > /sys/module/sch_htb/parameters/htb_rate_est

Did the trick. Thanks.

I look in google and nothing came up as "No rating being printed on tc=20
-s class show"

Now with the parameter you gave me i look it in google and i was not=20
going to find it in the way i was looking for this inconvenient. If i=20
were able to guess that it is a "HTB scheduler" it would another pattern=20
of search and i would be able to find it easy.

Thanks. It is solve!


>>
>> Thanks.
>>
>
>

