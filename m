Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B98D90A44
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfHPV2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 17:28:43 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:36076 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbfHPV2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 17:28:42 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 396C765936;
        Fri, 16 Aug 2019 14:28:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 396C765936
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1565990922;
        bh=Ed09baKTwKNkTf5ewjvCt6ywTtqZO1AhFTpVRjClhYo=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=SumZZtLRvtJycIAQ6UEcaSuAsBq5FZqZc9H9BI35bNPOS71vELxdaV4NgGZxX9fE/
         L00PaZDcYoBq86LQ8X9rQRGjuOfZ37QFWu6VfL2qn5obhJIt6Y2dglh8peMq9xzspx
         v94r5svW2kqmjaT6kRmOFu6Ep9LraSl3mAtvnqJw=
Subject: Re: IPv6 addr and route is gone after adding port to vrf (5.2.0+)
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <c55619f8-c565-d611-0261-c64fa7590274@candelatech.com>
 <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <ca625841-6de8-addb-9b85-8da90715868c@candelatech.com>
Date:   Fri, 16 Aug 2019 14:28:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <2a53ff58-9d5d-ac22-dd23-b4225682c944@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 12:15 PM, David Ahern wrote:
> On 8/16/19 1:13 PM, Ben Greear wrote:
>> I have a problem with a VETH port when setting up a somewhat complicated
>> VRF setup. I am loosing the global IPv6 addr, and also the route,
>> apparently
>> when I add the veth device to a vrf.  From my script's output:
> 
> Either enslave the device before adding the address or enable the
> retention of addresses:
> 
> sysctl -q -w net.ipv6.conf.all.keep_addr_on_down=1
> 

Thanks, I added it to the vrf first just in case some other logic was
expecting the routes to go away on network down.

That part now seems to be working.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

