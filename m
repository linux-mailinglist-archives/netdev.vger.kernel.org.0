Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59EB314D2D0
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 23:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgA2WC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 17:02:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgA2WCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 17:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Fop62bTazPLo+WGNB+BfCgO9zchmyRpUfYX/ot3XXHk=; b=WEB96WDwGvjGlZ1G/woW/8P3L
        7eraE+Yqe8ItWLr3zttniO9D1gPV7Y5hdupA0mtJtuJ6QmjriI9pKK7ogBjzXJkkv8Rll+Kopg8Bk
        vnudFQN+wGCWsF2ptNGDPdxb2O3BM6RIoTBvvVAtPM36CNz6nnyAf46o3dOI7Y/zw2Y6auq1gFeIC
        ezIuDIKKUrcxVy3LOWtD3f895LvLYBQblxIT8Txgb+2qnmo9gGCyt1cWtmKRUE4TWrAYW424TIqEL
        g03kbDKjM/82JSW0ejGd8tXDFqeFN4gALcs6JuZ6DcueQ9hXtZFmAIzNai8SoU9/SBK7LTD+tvzmN
        rCKDtDEoA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwvQE-0006zY-Ja; Wed, 29 Jan 2020 22:02:55 +0000
Subject: Re: [PATCH] MAINTAINERS: mptcp@ mailing list is moderated
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.01.org, LKML <linux-kernel@vger.kernel.org>
References: <0d3e4e6f-5437-ae85-f1f5-89971ea3423f@infradead.org>
 <alpine.OSX.2.21.2001290857310.9282@cmossx-mobl1.amr.corp.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4112784b-a70b-8e4a-4110-9898e0626306@infradead.org>
Date:   Wed, 29 Jan 2020 14:02:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.21.2001290857310.9282@cmossx-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/20 9:09 AM, Mat Martineau wrote:
> 
> On Tue, 28 Jan 2020, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Note that mptcp@lists.01.org is moderated, like we note for
>> other mailing lists.
> 
> Hi Randy -
> 
> The mptcp@lists.01.org list is not moderated, but there's a server-wide default rule that holds messages with 10 or more recipients for any sender (list member or not). I've turned off those server-wide defaults for this list so it shouldn't be a problem in the future.

OK, thanks for the clarification & revert...

> Thank you for your report on the build errors.
> 
> 
> Mat
> 
> 
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
>> Cc: netdev@vger.kernel.org
>> Cc: mptcp@lists.01.org
>> ---
>> MAINTAINERS |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- mmotm-2020-0128-2005.orig/MAINTAINERS
>> +++ mmotm-2020-0128-2005/MAINTAINERS
>> @@ -11718,7 +11718,7 @@ NETWORKING [MPTCP]
>> M:    Mat Martineau <mathew.j.martineau@linux.intel.com>
>> M:    Matthieu Baerts <matthieu.baerts@tessares.net>
>> L:    netdev@vger.kernel.org
>> -L:    mptcp@lists.01.org
>> +L:    mptcp@lists.01.org (moderated for non-subscribers)
>> W:    https://github.com/multipath-tcp/mptcp_net-next/wiki
>> B:    https://github.com/multipath-tcp/mptcp_net-next/issues
>> S:    Maintained


-- 
~Randy

