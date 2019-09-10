Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45817AE8AB
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfIJKw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfIJKw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 06:52:26 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97F920692;
        Tue, 10 Sep 2019 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568112746;
        bh=BEBUTIR1fNzkMOmIVHGpGroWQ3Ro/ae17Ts/8rK1HBw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zscLtYO3qbbTaKtDfXG+uZDsNg/AYmEmDLzFUtq2aFSkxArTo0FQQR/C6p64ik5p+
         SnLW5dh9exLXhhPHhgyYJ1aSEjvIWxkgyOJsayVXTD62UYJldtq+a1gMmnz5+UAgiL
         c+Y/YImhlw0leIxAMWB7eDw0lWYXnexIGUT6MnWo=
Date:   Tue, 10 Sep 2019 06:52:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>,
        netdev@vger.kernel.org, Jan Stancek <jstancek@redhat.com>,
        Xiumei Mu <xmu@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190910105223.GG2012@sasha-vm>
References: <cki.77A5953448.UY7ROQ6BKT@redhat.com>
 <20190910081956.GG22496@dhcp-12-139.nay.redhat.com>
 <20190910085810.GA3593@kroah.com>
 <20190910093021.GK22496@dhcp-12-139.nay.redhat.com>
 <20190910094025.GM22496@dhcp-12-139.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190910094025.GM22496@dhcp-12-139.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 05:40:25PM +0800, Hangbin Liu wrote:
>On Tue, Sep 10, 2019 at 05:30:21PM +0800, Hangbin Liu wrote:
>> Xiumei Mu also forwarded me a mail. It looks Sasha has fixed something.
>> But I don't know the details.
>
>Oh, I checked that thread. It's the same issue. So Sasha should has fixed it. I
>just wonder the commit id now.

That was fixed by upstream commit
b00df840fb4004b7087940ac5f68801562d0d2de.

--
Thanks,
Sasha
