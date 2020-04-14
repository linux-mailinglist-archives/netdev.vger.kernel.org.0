Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68291A8177
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440316AbgDNPJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440299AbgDNPIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 11:08:43 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5765A2076D;
        Tue, 14 Apr 2020 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586876921;
        bh=GLM7ITcjNGNqxFgguUrT1MtQmHq3TEbDWtKuGuJeo2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UT9cWIzX59N5Dp/DAqfP+XZ9ucR8iFlnC1CvLDdSIp4fp9+3b+M5kKrb6OHu58a5k
         ro20mPG3qeWc17ZkLZSq/fWkig8Y4RDmXLz7OPlVA2FwvSoddrfngn9nqbuD7N3I64
         kfzwhd3jFwNLAUP6jq+NApr8mJRJnV98nhzlKozg=
Date:   Tue, 14 Apr 2020 11:08:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set
 back-ends to report partial overlaps on insertion
Message-ID: <20200414150840.GD1068@sasha-vm>
References: <20200407000058.16423-1-sashal@kernel.org>
 <20200407000058.16423-27-sashal@kernel.org>
 <20200407021848.626df832@redhat.com>
 <20200413163900.GO27528@sasha-vm>
 <20200413223858.17b0f487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200413223858.17b0f487@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 10:38:58PM +0200, Stefano Brivio wrote:
>On Mon, 13 Apr 2020 12:39:00 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> On Tue, Apr 07, 2020 at 02:18:48AM +0200, Stefano Brivio wrote:
>>
>> >I'm used to not Cc: stable on networking patches (Dave's net.git),
>> >but I guess I should instead if they go through nf.git (Pablo's tree),
>> >right?
>>
>> Yup, this confusion has caused for quite a few netfilter fixes to not
>> land in -stable. If it goes through Pablo's tree (and unless he intructs
>> otherwise), you should Cc stable.
>
>Hah, thanks for clarifying.
>
>What do you think I should do specifically with 72239f2795fa
>("netfilter: nft_set_rbtree: Drop spurious condition for overlap detection
>on insertion")?
>
>I haven't Cc'ed stable on that one. Can I expect AUTOSEL to pick it up
>anyway?

I'll make sure it gets queued up when it hits Linus's tree :)

-- 
Thanks,
Sasha
