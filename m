Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04C2267B38
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 17:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgILPYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 11:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgILPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 11:23:58 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA2CC061573;
        Sat, 12 Sep 2020 08:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=SJAWfCenVwOSZWigKxYOq4zYrha5a4ifD+F7e6/X6sc=; b=wWVXm98MBFo/c8XICF6D8TxQjk
        OchGUiwnsoEutWgjDS9dkBJRMhaR5h03Yqns9vwDljochlttS5481IWk800TaO1reAXlY9FO28RRk
        waiBRqsOtUyNjkKkjHR8S/8f6prtq6DsH7m00075JPXyfXEGnVxHNUY1yUyW1GmkCE5ZzmCrz5dUA
        b4oqDEO9Miu3ntMZeRbBjbUIDsb6qbguzpj6OS9FZoKfA+rUMcBtpvd7cl+o/J7jVCJoW4Epdr/zQ
        WdOdFlkXg7/7dQBXGkBndvalMKq8bdXslyXdmHtZaHgJBOKYP3ZurX3yVdldk4kf2qUI48MIXS6nS
        Otv8FobA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kH7NW-0004dT-Bl; Sat, 12 Sep 2020 15:23:50 +0000
Subject: Re: [PATCH v2 08/14] habanalabs/gaudi: add a new IOCTL for NIC
 control operations
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Omer Shpigelman <oshpigelman@habana.ai>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
 <20200912144106.11799-9-oded.gabbay@gmail.com>
 <59a861d7-86e5-d806-a195-fd229d27ffb4@infradead.org>
 <CAFCwf12kfQJk5XwcX7qRRC-oLfXAUr+DSdBv0X9RcEDpyxJirA@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a551afc1-65f3-dfcc-6ce1-9ce575d4cf1f@infradead.org>
Date:   Sat, 12 Sep 2020 08:23:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAFCwf12kfQJk5XwcX7qRRC-oLfXAUr+DSdBv0X9RcEDpyxJirA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/20 8:19 AM, Oded Gabbay wrote:
> On Sat, Sep 12, 2020 at 6:07 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> Hi,
>>
>> On 9/12/20 7:41 AM, Oded Gabbay wrote:
>>> +#define HL_IOCTL_NIC _IOWR('H', 0x07, struct hl_nic_args)
>>
>>
>> ioctl numbers ('H') should be documented in
>> Documentation/userspace-api/ioctl/ioctl-number.rst
>>
>> Sorry if I missed seeing that. (I scanned quickly.)
>>
>> thanks.
>>
>> --
>> ~Randy
>>
> 
> Hi Randy,
> It is already documented for some time now:
> 
> 'H'   00-0F  uapi/misc/habanalabs.h                                  conflict!
> 
> I think you commented on this a few releases ago and I added it then :)

Oops.  Sorry I missed that.

thanks.
-- 
~Randy

