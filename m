Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FCF2EBA89
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 08:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbhAFHe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 02:34:56 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:46357 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbhAFHez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 02:34:55 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kx3Jb-000Abi-8Q; Wed, 06 Jan 2021 08:33:07 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kx3Ja-000AbP-KA; Wed, 06 Jan 2021 08:33:06 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id B03F8240041;
        Wed,  6 Jan 2021 08:33:05 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 2B578240040;
        Wed,  6 Jan 2021 08:33:05 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id A498C20046;
        Wed,  6 Jan 2021 08:33:04 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 Jan 2021 08:33:04 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.4 075/130] net/lapb: fix t1 timer handling for
 LAPB_STATE_0
Organization: TDT AG
In-Reply-To: <CAJht_EOXf4Z3G-rq92hb_YvJEsHtDy15FE7WuthqDQsPY039QQ@mail.gmail.com>
References: <20201223021813.2791612-75-sashal@kernel.org>
 <20201223170124.5963-1-xie.he.0141@gmail.com>
 <CAJht_EOXf4Z3G-rq92hb_YvJEsHtDy15FE7WuthqDQsPY039QQ@mail.gmail.com>
Message-ID: <70be903f2be49e243b5a28cf565c07a8@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1609918387-0001A85E-4872F59B/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-24 10:49, Xie He wrote:
> On Wed, Dec 23, 2020 at 9:01 AM Xie He <xie.he.0141@gmail.com> wrote:
>> 
>> I don't think this patch is suitable for stable branches. This patch 
>> is
>> part of a patch series that changes the lapb module from "establishing 
>> the
>> L2 connection only when needed by L3", to "establishing the L2 
>> connection
>> automatically whenever we are able to". This is a behavioral change. 
>> It
>> should be seen as a new feature. It is not a bug fix.
> 
> Applying this patch without other patches in the same series will also
> introduce problems, because this patch relies on part of the changes
> in the subsequent patch in the same series to be correct.
> 
> Hi Martin,
> 
> It's better that we avoid using words like "fix" in non-bug-fix
> patches, and make every patch work on its own without subsequent
> patches. Otherwise we'll make people confused.

Yes, you are right.
