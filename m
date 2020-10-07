Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA881285DAF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgJGK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:57:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48594 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728259AbgJGK5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:57:25 -0400
Received: from [192.168.0.114] (unknown [49.207.204.22])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6F91F20B4905;
        Wed,  7 Oct 2020 03:57:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6F91F20B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602068244;
        bh=eV2zFGYNPModu6l1UU9BKFwPXNHsnOorsX1M/tMgFF0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ViWknCNRbQCHtOP4tK3Miyu+PcW64GZKbOH1JFHHXMzhPg/Hv2i4SLOh+78V9TbdD
         TzNbDXdV/XK1mMj+X8BhZYsz7EboI4GkwAzQ785VvPLzfhsgsY5oJENBIeJlJI3v1L
         1Ji3QGoew4LvisUob1MpV5YlVZ5J3Wl/tLPz2jLU=
Subject: Re: [net-next v2 3/8] net: mac80211: convert tasklets to use new
 tasklet_setup() API
To:     Johannes Berg <johannes@sipsolutions.net>,
        Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Romain Perier <romain.perier@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
 <20201007101219.356499-4-allen.lkml@gmail.com>
 <33ee6ec537894a614bcb8fa5ee3e5bf3128f4809.camel@sipsolutions.net>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <a7b7175a-37e8-9735-719f-68f12ee8d15e@linux.microsoft.com>
Date:   Wed, 7 Oct 2020 16:27:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <33ee6ec537894a614bcb8fa5ee3e5bf3128f4809.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/10/20 4:25 pm, Johannes Berg wrote:
> On Wed, 2020-10-07 at 15:42 +0530, Allen Pais wrote:
>> From: Allen Pais <apais@linux.microsoft.com>
>>
>> In preparation for unconditionally passing the
>> struct tasklet_struct pointer to all tasklet
>> callbacks, switch to using the new tasklet_setup()
>> and from_tasklet() to pass the tasklet pointer explicitly.
>>
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> I'm going to assume for now that the whole series goes through the net-
> next tree, holler if not.

Yes. Thank you.


