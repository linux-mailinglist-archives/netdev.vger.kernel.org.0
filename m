Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF712C5540
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389980AbgKZN1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:27:20 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:43941 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389558AbgKZN1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 08:27:19 -0500
Received: from [192.168.0.4] (ip5f5af1e2.dynamic.kabel-deutschland.de [95.90.241.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A287F20647855;
        Thu, 26 Nov 2020 14:27:16 +0100 (CET)
Subject: Re: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug firmware
 is missing
To:     Wolfram Sang <wsa@kernel.org>, linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200625165210.14904-1-wsa@kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <b500e3f5-6ac7-a96e-bcb9-6fd30f3c5fe0@molgen.mpg.de>
Date:   Thu, 26 Nov 2020 14:27:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20200625165210.14904-1-wsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Sorry, I did not know where and how to import the thread, and only got 
the first message from Patchwork.]


Dear Linux folks,


Am 25.06.20 um 18:52 schrieb Wolfram Sang:
> Missing this firmware is not fatal, my wifi card still works. Even more,
> I couldn't find any documentation what it is or where to get it. So, I
> don't think the users should be notified if it is missing. If you browse
> the net, you see the message is present is in quite some logs. Better
> remove it.
> 
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> ---
> 
> This is only build tested because I wanted to get your opinions first. I
> couldn't find any explanation about yoyo, so I am entering unknown
> territory here.

[…]

Despite commit 3f4600de8c93 (iwlwifi: yoyo: don't print failure if debug 
firmware is missing) being in Linux since version 5.9-rc1, I am still 
seeing this with Debian’s Linux 5.9.9.


Kind regards,

Paul
