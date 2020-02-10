Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C093A157CEE
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgBJN7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:59:47 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:58666 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbgBJN7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:59:47 -0500
Received: from [109.168.11.45] (port=48250 helo=[192.168.101.73])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <luca@lucaceresoli.net>)
        id 1j19bE-005RAO-LZ; Mon, 10 Feb 2020 14:59:44 +0100
Subject: Re: [PATCH v2] iwlwifi: fix config variable name in comment
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200130080622.1927-1-luca@lucaceresoli.net>
 <877e19cojc.fsf@kamboji.qca.qualcomm.com>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <53ce7e7d-630c-b807-9210-547455087736@lucaceresoli.net>
Date:   Mon, 10 Feb 2020 14:59:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <877e19cojc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On 30/01/20 09:54, Kalle Valo wrote:
> Luca Ceresoli <luca@lucaceresoli.net> writes:
> 
>> The correct variable name was replaced here by mistake.
>>
>> Fixes: ab27926d9e4a ("iwlwifi: fix devices with PCI Device ID 0x34F0
>> and 11ac RF modules")
> 
> The Fixes tag should be all in one line. But TBH I'm not sure if it
> makes sense to add that to a patch which has no functional changes like
> this one.

Ok, I agree this is a gray area. Just sent v3 without the Fixes tag.

Thanks,
-- 
Luca
