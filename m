Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D7A3EDF29
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhHPVQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhHPVQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:16:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2EFC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 14:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=IahjxOjONTR/ookqE8d4dqz7vyXyxyY75ZAKcOKZ4/g=; b=KrjdBp9hPKqCjKkdf9QIyA/8DC
        A2/8vnyPlskyGmX2CMA5jNYlCfD69t4++k6bzppK2tVLwxmgOu1yqBfTxz5/CcgHMw3ZSF9vxfivu
        5HCH6pGvltU+InrsBIWe6tOrLTP+v6b5mHGcjYqw3/50W2qBbcln7KPKOMBFpiEJAZrZVkmRQuoDh
        tGFQJXbEkgZdPuDfCL5I/MMFeLQ5iAZzvZDwafnvMaWpR51RiOl70CFlltljWmjoFD5jX6mtksTHD
        /kKJf004en4WzF9gjjg7tUWCYUYkVPCaRB1M5G1v2UbdHQsYrQNdjPMgyo+Q70cIbesSKu+Fub2hm
        2HgzeXaA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFjxY-000JHD-5s; Mon, 16 Aug 2021 21:15:52 +0000
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
References: <20210813203026.27687-1-rdunlap@infradead.org>
 <20210816210914.qkyd4em4rw3thbyg@bsd-mbp.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <16acf1ad-d626-b3a3-1cad-3fa6c61c8a22@infradead.org>
Date:   Mon, 16 Aug 2021 14:15:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210816210914.qkyd4em4rw3thbyg@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/21 2:09 PM, Jonathan Lemon wrote:
> On Fri, Aug 13, 2021 at 01:30:26PM -0700, Randy Dunlap wrote:
>> There is no 8250 serial on S390. See commit 1598e38c0770.
> 
> There's a 8250 serial device on the PCI card.   Its been
> ages since I've worked on the architecture, but does S390
> even support PCI?

Yes, it does.

>> Is this driver useful even without 8250 serial?
> 
> The FB timecard has an FPGA that will internally parse the
> GNSS strings and correct the clock, so the PTP clock will
> work even without the serial devices.
> 
> However, there are userspace tools which want to read the
> GNSS signal (for holdolver and leap second indication),
> which is why they are exposed.

So what do you recommend here?

thanks.
-- 
~Randy

