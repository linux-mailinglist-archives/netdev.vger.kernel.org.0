Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72F1A8211
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407333AbgDNPRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407290AbgDNPQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 11:16:48 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFB320768;
        Tue, 14 Apr 2020 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586877406;
        bh=Wa+qi2HBtbHbWYPnlD8RTn32LkOHAV3tmDpVnkMjakc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=emyUmr8na6VFJUPLNhRR3Dj6AeHqvcYx6yYPT746QFcZxfdZ3wLRHfjiCUcYbwBof
         olj5yXea3GtoJQb7k6rsKItCtYbIantaO8IuNDsR/3LR89Bpllo1e2lSA9UNyYmUTu
         +l7dDBjilttQt8kFpvjbefklJJtKJZTBDolkdQlk=
Date:   Tue, 14 Apr 2020 11:16:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200414151645.GE1068@sasha-vm>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 05:38:32PM +0300, Or Gerlitz wrote:
>On Tue, Apr 14, 2020 at 2:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Tue, Apr 14, 2020 at 01:22:59PM +0300, Or Gerlitz wrote:
>> > IMHO - I think it should be the other way around, you should get approval
>> > from sub-system maintainers to put their code in charge into auto-selection,
>> > unless there's kernel summit decision that says otherwise, is this documented
>> > anywhere?
>>
>> No, we can't get make this a "only take if I agree" as there are _many_
>> subsystem maintainers who today never mark anything for stable trees, as
>> they just can't be bothered.  And that's fine, stable trees should not
>> take up any extra maintainer time if they do not want to do so.  So it's
>> simpler to do an opt-out when asked for.
>
>OK, but I must say I am worried from the comment made here:
>
>"I'm not sure what a fixes tag has to do with inclusion in a stable tree"
>
>This patch
>
>(A) was pushed to -next and not -rc kernel

Fixes can (and should) come in during a merge window as well. They are
not put on hold until the -rc releases.

>(B) doesn't have fixes tag

In the 4.19 stable tree there are 3962 commits explicitly tagged for
stable, only 2382 of them have a fixes tag. 

>(C) the change log state clearly that what's being "fixed"
>can't be reproduced on any earlier kernel [..] "only possible
>to reproduce with next commit in this series"
>
>but it was selected for -stable -- at least if the fixes tag was used
>as gating criteria, this wrong stable inclusion could have been eliminated

Are you suggesting that a commit without a fixes tag is never a fix?

-- 
Thanks,
Sasha
