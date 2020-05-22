Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74BE1DEB59
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbgEVPAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgEVPAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 11:00:49 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B0D2054F;
        Fri, 22 May 2020 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159648;
        bh=lgj9gREzZACWIMWDadE30OkMatrU+Z1FCFBhhJ5hTcU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lHtIED2X/j0HFUkgtIPVIU84CBQIHUHerSgUA91Kh+NCA0BralnQ3g2M9r4yoi5G/
         xgXAD5maXyotPYvv0vFH2Z1vb4ml3I0gs8Qh4fX39mFL7LsdHePjgoYqGvSCaeNXQk
         uCqU3FxMK69J4HfFHtxvshovdG7JdDvO9F7BJjOs=
Subject: Re: [PATCH] selftests:mptcp: fix empty optstring
To:     Li Zhijian <lizhijian@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Li Zhijian <zhijianx.li@intel.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20200402065216.23301-1-zhijianx.li@intel.com>
 <4bdd5672-eb24-2e49-e286-702510be0882@cn.fujitsu.com>
From:   shuah <shuah@kernel.org>
Message-ID: <3bd2171a-24e8-6e5a-5d16-10db2bcb27fe@kernel.org>
Date:   Fri, 22 May 2020 09:00:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4bdd5672-eb24-2e49-e286-702510be0882@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/20 10:47 PM, Li Zhijian wrote:
> ping
> 
> 
> On 4/2/20 2:52 PM, Li Zhijian wrote:
>> From: Li Zhijian <lizhijian@cn.fujitsu.com>
>>
>> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
>> ---
>>   tools/testing/selftests/net/mptcp/pm_netlink.sh | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh 
>> b/tools/testing/selftests/net/mptcp/pm_netlink.sh
>> index 9172746b6cf0..8c7998c64d9e 100755
>> --- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
>> +++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
>> @@ -8,8 +8,7 @@ usage() {
>>       echo "Usage: $0 [ -h ]"
>>   }
>> -
>> -while getopts "$optstring" option;do
>> +while getopts "h" option;do
>>       case "$option" in
>>       "h")
>>           usage $0
> 
> 
> 
> 

Li Zhijian,

You are missing netdev and net maintainer.
Adding netdev and Dave M.

net tests go through net tree and need review/Ack from Dave M.

Dave! Please review and let me know if you want me to take this through
kselftest tree.

thanks,
-- Shuah
