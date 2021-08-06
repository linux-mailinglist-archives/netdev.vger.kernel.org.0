Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B702F3E2856
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbhHFKNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:13:36 -0400
Received: from amphora3.sui-inter.net ([80.74.147.35]:51798 "EHLO
        amphora3.sui-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244980AbhHFKN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:13:27 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2021 06:13:25 EDT
Received: from [IPV6:2a02:168:6182:1:7643:c4ac:7a96:f4a3] (localhost [127.0.0.1]) by amphora3.sui-inter.net (Postfix) with ESMTPSA id 1068DB042353;
        Fri,  6 Aug 2021 12:03:19 +0200 (CEST)
Authentication-Results: amphora.sui-inter.net;
        spf=pass (sender IP is 2a02:168:6182:1:7643:c4ac:7a96:f4a3) smtp.mailfrom=rs@hqv.ch smtp.helo=[IPV6:2a02:168:6182:1:7643:c4ac:7a96:f4a3]
Received-SPF: pass (amphora.sui-inter.net: connection is authenticated)
Message-ID: <26f85a9f-552d-8420-0010-f5cda70d3a00@hqv.ch>
Date:   Fri, 6 Aug 2021 12:03:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0
Subject: Re: [PATCH v2] rtl8xxxu: Fix the handling of TX A-MPDU aggregation
Content-Language: en-US
To:     chris.chiu@canonical.com
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jes.sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
References: <20210804151325.86600-1-chris.chiu@canonical.com>
From:   Reto Schneider <rs@hqv.ch>
In-Reply-To: <20210804151325.86600-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Chris,

On 8/4/21 17:13, chris.chiu@canonical.com wrote:
> The TX A-MPDU aggregation is not handled in the driver since the
> ieee80211_start_tx_ba_session has never been started properly.
> Start and stop the TX BA session by tracking the TX aggregation
> status of each TID. Fix the ampdu_action and the tx descriptor
> accordingly with the given TID.

I'd like to test this but I am not sure what to look for (before and 
after applying the patch).

What should I look for when looking at the (sniffed) Wireshark traces?

Kind regards,
Reto
