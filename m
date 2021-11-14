Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6438A44F852
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 15:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKNOGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 09:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234744AbhKNOGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 09:06:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2078B60F41;
        Sun, 14 Nov 2021 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636898623;
        bh=bOul5+22/AWDACxPNeQOEV1OMaX2gJdZS9NMj/IB9mg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wkdb7d0s4ZRD7gQVxxq53h3lL+aBbriAPa/hRkXvJWlzjhf2IJ6xSoKZp7ii9C6BC
         UxM0PlZ+/hFYHc0tf9jcug/h8lQCHy9ef8AvSq4WXRvhMEzZfqXw7ONNNlv8OiZqUp
         quSbB9e1Nh+norJSW5oJ+xMo24AAmv9S4j4nVbjLftgNj1n1pNRdPN3CwXGq/bnZuw
         UqWe1IkPSPIeKtcPho7eifClxZ1KkO5s9Ag6C+wxyPCd6zStyj6rWwcGTQvXr7P75I
         q93tQgh+qn/TSypHUTXX9KGUtNY5FJv+ZSET51dKNe/OhYh+uuzg3HK4qVOA7gY9kt
         7xCk7YiYdypUg==
Date:   Sun, 14 Nov 2021 09:03:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 10/39] mwifiex: Run SET_BSS_MODE when
 changing from P2P to STATION vif-type
Message-ID: <YZEXPmTF2NKLOQ9Y@sashalap>
References: <20211109010649.1191041-1-sashal@kernel.org>
 <20211109010649.1191041-10-sashal@kernel.org>
 <CA+ASDXPwH9esHZFVy4bD+D+NtfvU6qJ_sJH+JxMmj3APkdCWiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+ASDXPwH9esHZFVy4bD+D+NtfvU6qJ_sJH+JxMmj3APkdCWiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 10:06:19AM -0800, Brian Norris wrote:
>On Mon, Nov 8, 2021 at 5:18 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Jonas Dreﬂler <verdre@v0yd.nl>
>>
>> [ Upstream commit c2e9666cdffd347460a2b17988db4cfaf2a68fb9 ]
>...
>> This does not fix any particular bug and just "looked right", so there's
>> a small chance it might be a regression.
>
>I won't insist on rejecting this one, but especially given this
>sentence, this doesn't really pass the smell test for -stable
>candidates. It's stuff like this that pushes me a bit toward the camp
>of those who despise the ML-based selection methods here, even though
>it occasionally (or even often) may produce some good.

I have hundreds of examples of patches that claim they are just an
improvement but fix a serious bug :)

-- 
Thanks,
Sasha
