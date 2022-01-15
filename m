Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B3848F681
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 12:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiAOLMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 06:12:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45966 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiAOLMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 06:12:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A85CCE24A0;
        Sat, 15 Jan 2022 11:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA85C36AE5;
        Sat, 15 Jan 2022 11:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642245119;
        bh=jNFGzrPIobZj5wF79igvxvVFmouOIeEfIO7F0ckDzkg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=h/L4Iav/wMcmrsPa0lJ6MqsYHCSbKP0Gv/f9Xq7iVb72BT3pUcUDqYw/i2wYM8diQ
         YixaDehTMbf8cwOThCvnDb5deXdPWpcip+m0CFfMXa9aGx2nawjGKzYLdQ+TA4ncLN
         /uu9HXK1hnKinn0bZyTos0WC+fXRyoTNs5NwobNDRpXL1bRpg6dvVQiHh5ZBz79pZ4
         kRhF5rWX0mvQIGHAlfs7JLeIrcGMEgNjmA+ECgDGbZqeGa0weP9I+yFoMVGeX12kb8
         t+5CpqourRKxKbqR1j9pH1hlffVlkxDzpWHg9/3WOBwpSIr62gHClxSCJOtOxLrRZh
         4wOknAmx8A21A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH wireless] MAINTAINERS: add common wireless and wireless-next trees
In-Reply-To: <20220115081809.64c9fec5@canb.auug.org.au> (Stephen Rothwell's
        message of "Sat, 15 Jan 2022 08:18:09 +1100")
References: <20220114133415.8008-1-kvalo@kernel.org>
        <20220115081809.64c9fec5@canb.auug.org.au>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Sat, 15 Jan 2022 13:11:54 +0200
Message-ID: <87o84ds16t.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Kalle,
>
> On Fri, 14 Jan 2022 15:34:15 +0200 Kalle Valo <kvalo@kernel.org> wrote:
>>
>> For easier maintenance we have decided to create common wireless and
>> wireless-next trees for all wireless patches. Old mac80211 and wireless-drivers
>> trees will not be used anymore.
>> 
>> While at it, add a wiki link to wireless drivers section and a patchwork link
>> to 802.11, mac80211 and rfkill sections.
>> 
>> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Kalle Valo <kvalo@kernel.org>
>> ---
>> 
>> Stephen, please use these new trees in linux-next from now on.
>
> Done from today.  I have set you and Johannes as contacts along with
> the linux-wireless mailing list.  Also, I assume you meant to mention
> that I should use the branches called "main".

Yes, please use main branches. We decided to try the new naming scheme.
Thanks Stephen.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
