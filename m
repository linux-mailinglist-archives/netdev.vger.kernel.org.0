Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638FB285BF6
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgJGJkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:40:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38584 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgJGJkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:40:42 -0400
Received: from [192.168.0.114] (unknown [49.207.204.22])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5CDF520B4905;
        Wed,  7 Oct 2020 02:40:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5CDF520B4905
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1602063641;
        bh=LfDv92UxGb6CbQovQ0rM5jGGIzK/t5aaponJvOlw5hc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Ottpoj9aUawDQaD5ZdgwW0sEKKCbLuq1Nd9fnQlbee0nPfNHK97c36wzFFGoS6a6s
         K1ZKIYKYBoNcNOzvoUQI+fDCyv31F2KEFV6+7ZeEPGLHw2sK/1kdFig06k2Jl66T9n
         7vJ0A4JEGn0qDdFaXai1dZ9blgZ/6NP+3UVDGfNo=
Subject: Re: [RESEND net-next 1/8] net: dccp: convert tasklets to use new
 tasklet_setup() API
To:     Jakub Kicinski <kuba@kernel.org>, Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, gerrit@erg.abdn.ac.uk, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Romain Perier <romain.perier@gmail.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
 <20201006063201.294959-2-allen.lkml@gmail.com>
 <20201006074204.2bd6fd32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Allen Pais <apais@linux.microsoft.com>
Message-ID: <d5cca0db-ba98-ed5b-eeed-7838a0a06fa9@linux.microsoft.com>
Date:   Wed, 7 Oct 2020 15:10:27 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201006074204.2bd6fd32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> net/dccp/timer.c:223: warning: Function parameter or member 't' not described in 'dccp_write_xmitlet'
> net/dccp/timer.c:223: warning: Excess function parameter 'data' description in 'dccp_write_xmitlet'
> 
My bad. Will fix it.

Thanks.
