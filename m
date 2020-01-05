Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EB81308D8
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 16:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgAEPmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 10:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgAEPmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 10:42:22 -0500
Received: from localhost (unknown [73.61.17.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CC92077B;
        Sun,  5 Jan 2020 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578238941;
        bh=kqa7E7pY27pjTz+f6e0ccECN9J2A3cYu1FhYrBZerzc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ns+keplO9pEXxkWOQaPUzgi19poKeoyq3kSgJGOe0ITWRgN6k/+44J1jWsi0f76O5
         siUTlW8OWdS2yQq3mSEaq0UspmFfiGoldNXHFdB2IXJtbh+Q3liaZpASWS85Ly8iMa
         gwCTlf2xt5CW5I1TNQR00zSu4Okksn14H0b36GoM=
Date:   Sun, 5 Jan 2020 10:42:18 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Anders Kaseorg <andersk@mit.edu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 056/187] Revert "iwlwifi: assign directly to
 iwl_trans->cfg in QuZ detection"
Message-ID: <20200105154218.GP16372@sasha-vm>
References: <20191227174055.4923-1-sashal@kernel.org>
 <20191227174055.4923-56-sashal@kernel.org>
 <5dbea7a0-5c66-abe4-b1ef-bbfceccbb9bb@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5dbea7a0-5c66-abe4-b1ef-bbfceccbb9bb@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 29, 2019 at 09:48:53PM -0800, Anders Kaseorg wrote:
>On 12/27/19 9:38 AM, Sasha Levin wrote:
>> From: Anders Kaseorg <andersk@mit.edu>
>>
>> [ Upstream commit db5cce1afc8d2475d2c1c37c2a8267dd0e151526 ]
>>
>> This reverts commit 968dcfb4905245dc64d65312c0d17692fa087b99.
>>
>> Both that commit and commit 809805a820c6445f7a701ded24fdc6bbc841d1e4
>> attempted to fix the same bug (dead assignments to the local variable
>> cfg), but they did so in incompatible ways. When they were both merged,
>> independently of each other, the combination actually caused the bug to
>> reappear, leading to a firmware crash on boot for some cards.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=205719
>>
>> Signed-off-by: Anders Kaseorg <andersk@mit.edu>
>> Acked-by: Luca Coelho <luciano.coelho@intel.com>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This commit’s child 0df36b90c47d93295b7e393da2d961b2f3b6cde4 (part of
>the same bug 205719) is now enqueued for v5.4, but this one doesn’t seem
>to have made it yet, perhaps because I forgot to Cc: stable@ in the
>commit message.  Can someone make sure this goes to v5.4 as well?  Luca
>previously nominated it for v5.4 here:
>
>https://patchwork.kernel.org/patch/11269985/#23032785

Great to hear from you again Anders!

Yes, AUTOSEL runs on a slower cycle than patches tagged for stable.
Anyway, I've queued this patch up for the next release.

-- 
Thanks,
Sasha
