Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664882DB3C3
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 19:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbgLOSac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 13:30:32 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:49342 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731330AbgLOSaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 13:30:24 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2020 13:30:24 EST
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id E2A4A13C2B0;
        Tue, 15 Dec 2020 10:23:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E2A4A13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608056615;
        bh=Rz9XVqzoDiWY4qxrJfScJDMVgdjjFU7rO5iNL7mHVFE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=OxBC8b8E2ZapsnoHI686TBDWUQyyippu8dpvVVT38aCwUDQctQerrE9M8k8SvwOk/
         0BOz0fkSABRn9x3dYL+Udq8pzMdeJPOQrJTlJN4Xxn7EagWl3KGXMDhjENo36zxXeY
         D8pI+00hF8hwAbJ5Vv1QjNLIHxLfst5LDyocMOXY=
Subject: Re: [PATCH 0/3] mac80211: Trigger disconnect for STA during recovery
To:     Youghandhar Chintala <youghand@codeaurora.org>,
        johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
References: <20201215172113.5038-1-youghand@codeaurora.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <18dfa52b-5edd-f737-49c9-f532c1c10ba2@candelatech.com>
Date:   Tue, 15 Dec 2020 10:23:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201215172113.5038-1-youghand@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/20 9:21 AM, Youghandhar Chintala wrote:
> From: Rakesh Pillai <pillair@codeaurora.org>
> 
> Currently in case of target hardware restart ,we just reconfig and
> re-enable the security keys and enable the network queues to start
> data traffic back from where it was interrupted.

Are there any known mac80211 radios/drivers that *can* support seamless restarts?

If not, then just could always enable this feature in mac80211?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
