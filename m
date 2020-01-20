Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32188143185
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 19:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgATSfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 13:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgATSfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 13:35:17 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61B922525;
        Mon, 20 Jan 2020 18:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579545317;
        bh=ZdGhSuiplX9eWNsHF3QojzXW5HfBHpo2ssWTxuY2BRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lxfdcIco5UepDW1gDOhOnXyV6cvXeH5psCDd1xArCcROxFPQXsUuLp6mrrSsEAExz
         QJZ3NtTJihVTGYidHpmh029WB8YnWGA4J5lGn2Tk6TLMnvGp2Cbsxii8qNsCClLdIo
         W8RvAu2rtbtcttB2J7Wo2vXoIwmWyl0vLPvNhsyU=
Date:   Mon, 20 Jan 2020 13:35:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "Hans-Christian Egtvedt (hegtvedt)" <hegtvedt@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Regression in macvlan driver in stable release 4.4.209
Message-ID: <20200120183515.GA1706@sasha-vm>
References: <01accb3f-bb52-906f-d164-c49f2dc170bc@cisco.com>
 <20200120095714.GA3421303@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200120095714.GA3421303@splinter>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 11:57:14AM +0200, Ido Schimmel wrote:
>On Mon, Jan 20, 2020 at 09:17:35AM +0000, Hans-Christian Egtvedt (hegtvedt) wrote:
>> Hello,
>>
>> I am seeing a regression in the macvlan kernel driver after Linux stable
>> release 4.4.209, bisecting identifies commit
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.4.y&id=8d28d7e88851b1081b05dc269a27df1c8a903f3e
>
>Noticed it too last week (on net-next), but Eric already fixed it:
>https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1712b2fff8c682d145c7889d2290696647d82dab
>
>I assume the patch will find its way to 4.4.y soon now that it is in
>mainline.

David, any objection if I grab this patch directly to fix the regression
in the next stable kernel release?

-- 
Thanks,
Sasha
