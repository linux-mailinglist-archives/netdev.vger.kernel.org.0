Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310AA3BE680
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 12:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhGGKsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 06:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhGGKsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 06:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF60360FF0;
        Wed,  7 Jul 2021 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625654734;
        bh=3D/5zjSCzpHDTDTXUpdP6UzY3JY64bboQX+7H4xyk8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVlUte8yb2BNRR3yXPmjBhGvOJWr4h1jf+bwVoQVSrkWeTZi2GW+0oipjtsz4qkND
         lW/eUai7RYA49P8Evpfibsl/tv5livmuLjhDvmQMSMB9OBvxFy3cqBVSmyictzOk3M
         /JVwaKJPYbKjuSJMoFmqzF/KU0QdbWJdOMV+nJ14S75QT//OLyXbUJp8lPXNTswcK7
         UjVuRmLvQD9iCugXuUe38TpRSQxkhenBi12DKd9UIj3YFIcDxHMw56JYS9HCRyZrIO
         1Yl3HHSnVPnrq/a9pydTxd+HJ1711kD6eOlFOU4M3jt/vffbfG9Cw1s9wZXdpHkcNL
         BaOf/XqOxAg+Q==
Date:   Wed, 7 Jul 2021 06:45:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 113/137] wireless: wext-spy: Fix
 out-of-bounds warning
Message-ID: <YOWFzFBGGqiYWsI6@sashalap>
References: <20210706112203.2062605-1-sashal@kernel.org>
 <20210706112203.2062605-113-sashal@kernel.org>
 <5da1f4fbdac533be3b753e54b43e2058ba270bc8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5da1f4fbdac533be3b753e54b43e2058ba270bc8.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 04:08:09PM +0200, Johannes Berg wrote:
>On Tue, 2021-07-06 at 07:21 -0400, Sasha Levin wrote:
>> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
>>
>> [ Upstream commit e93bdd78406da9ed01554c51e38b2a02c8ef8025 ]
>>
>> Fix the following out-of-bounds warning:
>>
>> net/wireless/wext-spy.c:178:2: warning: 'memcpy' offset [25, 28] from the object at 'threshold' is out of the bounds of referenced subobject 'low' with type 'struct iw_quality' at offset 20 [-Warray-bounds]
>
>For the record: while this clearly isn't harmful, there's almost
>basically no chance that the stable kernel will ever compile warning-
>free with -Warray-bounds, so there's not much point in backporting this
>patch.

While the warning is a non-issue, it wasn't clear if it fixes a real bug
or just silences the warning which is why I took it in.

-- 
Thanks,
Sasha
