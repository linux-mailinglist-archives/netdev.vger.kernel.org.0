Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFE5C4094
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfJAS7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfJAS7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 14:59:39 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C524020B7C;
        Tue,  1 Oct 2019 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569956379;
        bh=w5e1NN947ltzsklCHEE38yaUZaBqgwUZghQ81esLHu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hDZqHxKi7dGO+mOkWsZvnY7Sbmf1iR43bCqb1jQvTjnObaOMXqWsubGzJk+pBR3PD
         7iW1sWCxhJuGABdiPb38piNg16UL5I9h/Cc6nt2h6QtB2HyrWrSFC76xLh3BPE6SGz
         kQjF0V0vW0R03JA+aL3mlOVA4Zsb5Y4lVSPCl9D8=
Date:   Tue, 1 Oct 2019 14:59:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Message-ID: <20191001185937.GA17454@sasha-vm>
References: <1569449034-29924-1-git-send-email-decui@microsoft.com>
 <DM6PR21MB1337194387A53DF549398F1ACA870@DM6PR21MB1337.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DM6PR21MB1337194387A53DF549398F1ACA870@DM6PR21MB1337.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 10:23:28PM +0000, Haiyang Zhang wrote:
>
>
>> -----Original Message-----
>> From: Dexuan Cui <decui@microsoft.com>
>> Sent: Wednesday, September 25, 2019 6:04 PM
>> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
>> <haiyangz@microsoft.com>; Stephen Hemminger
>> <sthemmin@microsoft.com>; sashal@kernel.org; davem@davemloft.net;
>> linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Michael Kelley <mikelley@microsoft.com>
>> Cc: Dexuan Cui <decui@microsoft.com>
>> Subject: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
>>
>> The existing netvsc_detach() and netvsc_attach() APIs make it easy to
>> implement the suspend/resume callbacks.
>>
>> Signed-off-by: Dexuan Cui <decui@microsoft.com>
>
>Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Queued up for hyperv-next, thanks!

--
Thanks,
Sasha
