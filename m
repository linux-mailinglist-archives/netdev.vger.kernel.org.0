Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED82D3A96
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 06:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgLIFdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 00:33:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4494 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgLIFdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 00:33:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd0616c0000>; Tue, 08 Dec 2020 21:32:28 -0800
Received: from [10.26.73.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Dec
 2020 05:32:18 +0000
Subject: Re: [PATCH iproute2-net v2 1/3] devlink: Add devlink reload action
 and limit options
To:     David Ahern <dsahern@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
References: <1607319322-20970-1-git-send-email-moshe@mellanox.com>
 <1607319322-20970-2-git-send-email-moshe@mellanox.com>
 <7bb89ef8-78bf-1264-6921-1d9f15ec2b12@gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <c85af9c6-3532-fd57-9183-e26791469664@nvidia.com>
Date:   Wed, 9 Dec 2020 07:32:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <7bb89ef8-78bf-1264-6921-1d9f15ec2b12@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607491948; bh=UCB49qVvmRCkwupA2zKQXHIRHr7PlXg4tRgP/q9uMQk=;
        h=Subject:To:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=elPuaPzoQqh/IISoiMp/L8zTW9+JCvlOj9GEj2r4hhj1rhp/W2JmDhRpCVffM/JZI
         Su9M/BwzCKaLzqI8zi3sLSC32GFL/A8frodfd2pqct1sRhuc/j9L48HZ+P2L3MPa3l
         rJhX+4pRTAKq8KCfDJ/YkFGfs6167bhYg0Kpk879J5hiBKz9kUyoeUmGAJTOeMkkUj
         tJcvzfCbQLM+TqF90Q2MEItK1cKHo4Bw5uT35B71UOZ2FH7bP2ww1xiXyl0Cm1+Oc6
         oBcL2Z+xvEzIxIW4qG/j7JsyvkJcKuPCqzXcfuMCyCksNdBGj8c1szjpuxQJIWZK8U
         mI1joCbt9vHaQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/9/2020 4:46 AM, David Ahern wrote:
> On 12/6/20 10:35 PM, Moshe Shemesh wrote:
>> +			print_string(PRINT_ANY, NULL, "%s", reload_action_name(action));
> That line should be:
> 			print_string(PRINT_ANY, NULL, "%s",
> 				     reload_action_name(action));
>
> to fit preferred column widths. By print strings in my previous comment,
> I meant don't wrap quoted text.
>
> Fixed and applied.
OK, thanks.
