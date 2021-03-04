Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0C832DB5D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 21:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbhCDUsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 15:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhCDUsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 15:48:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB0DC64F78;
        Thu,  4 Mar 2021 20:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614890833;
        bh=fbItLtW0McjQ6cGOGdvkwgGtFHROSfMYY+UFxruVygw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQssWwEajlQ0NQ6yLH/zQF/vR0g8Aq6xV6z/yjciuQMwxLEznjkoNTUPOUin08pqr
         RkwDP9a928JPk8Y8lDrkLCoB+8paRFpHaabDHnRD1JBarrqDx0hFqV4kYAK52B57uY
         kF8A4fUaNUZo2mixUOQYkgFEHXB6Ahd8/46j0df8F7iByPix8+15V06xOGhlyzfhB5
         reT8WkbVlXOVD7XAwi5ncZ2OyeuH5JTynK7BhLCt08ijnOMKQm+kRaKD1gLPgzduKn
         TG4oh9jpjIIDSYlfrI+n1HBCGnqwbczFVvhrQd3tz+jAecRvPcJjSiMDQgsSZxngSR
         X3E+TXoL5N5Vg==
Date:   Thu, 4 Mar 2021 15:47:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 050/217] rsi: Fix TX EAPOL packet handling
 against iwlwifi AP
Message-ID: <YEFHULdbXVVxORn9@sashalap>
References: <20201223021626.2790791-1-sashal@kernel.org>
 <20201223021626.2790791-50-sashal@kernel.org>
 <68699f8a-2fcd-3b3d-f809-afa54790e9f9@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <68699f8a-2fcd-3b3d-f809-afa54790e9f9@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 08:25:49PM +0100, Marek Vasut wrote:
>On 12/23/20 3:13 AM, Sasha Levin wrote:
>
>Hello Sasha,
>
>>From: Marek Vasut <marex@denx.de>
>>
>>[ Upstream commit 65277100caa2f2c62b6f3c4648b90d6f0435f3bc ]
>>
>>In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in AP mode,
>>the association fails. The former is using wpa_supplicant during association,
>>the later is set up using hostapd:
>
>[...]
>
>Was this patch possibly missed from 5.10.y ?

I'm not sure what happened there, but I can queue it up.

>Also, while at it, I think it might make sense to pick the following 
>two patches as well, they dramatically reduce interrupt rate of the 
>RSI WiFi device, so it stops overloading lower-end devices:
>287431463e786 ("rsi: Move card interrupt handling to RX thread")

And this one too.

>abd131a19f6b8 ("rsi: Clean up loop in the interrupt handler")

But not this one, it looks like just a cleanup. Why is it needed?

-- 
Thanks,
Sasha
