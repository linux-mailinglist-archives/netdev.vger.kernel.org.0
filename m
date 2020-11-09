Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289182AB158
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 07:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgKIGi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 01:38:57 -0500
Received: from linux.microsoft.com ([13.77.154.182]:39940 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgKIGi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 01:38:56 -0500
Received: from [192.168.0.114] (unknown [49.207.198.216])
        by linux.microsoft.com (Postfix) with ESMTPSA id EE5ED20B4905;
        Sun,  8 Nov 2020 22:38:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EE5ED20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1604903936;
        bh=rkU5naMeL4Jg46DuvhBR5CjwpfV9t1M3Rsm/XSDELtk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Pw2BSwIh/4jRlxd4++3SCx2z2aKXO2jgIJU5HW4AOEvs+K1IX5u8+ffxzUQN3VPgs
         IQEdVH/BL7CyIrFYSlNmUfuXMOx5fJKpxIsFKFBj4zHXaPz0JgxaOOMcavMQcqdXZ/
         2Wxpz7+gjj6qas8XBPysndGSyUo1G8WP6JvP4Q0Y=
Subject: Re: [net-next v4 0/8]net: convert tasklets to use new tasklet_setup
 API
To:     Jakub Kicinski <kuba@kernel.org>, Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, gerrit@erg.abdn.ac.uk, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
References: <20201103091823.586717-1-allen.lkml@gmail.com>
 <20201107104752.2113e27a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <f0364296-6255-a0fc-900f-11b8c431d89c@linux.microsoft.com>
Date:   Mon, 9 Nov 2020 12:08:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201107104752.2113e27a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
>> introduced a new tasklet initialization API. This series converts
>> all the net/* drivers to use the new tasklet_setup() API
>>
>> The following series is based on net-next (9faebeb2d)
> 
> Hi Aleen! I applied everything but the RDS patch to net-next.
> Could you resend the RDS one separately and CC linux-rdma,
> so we can coordinate who takes it?

  Sure, Will have it re-sent. Thanks.
