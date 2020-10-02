Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AA528161D
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgJBPIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:08:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9913 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:08:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7742650002>; Fri, 02 Oct 2020 08:08:21 -0700
Received: from [10.21.180.145] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Oct
 2020 15:08:24 +0000
Subject: Re: [PATCH net-next 15/16] net/mlx5: Add support for devlink reload
 limit no reset
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-16-git-send-email-moshe@mellanox.com>
 <20201001145200.2ba769b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <c84c80b6-8a2d-b605-c447-fdea16a8dd85@nvidia.com>
Date:   Fri, 2 Oct 2020 18:08:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201001145200.2ba769b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601651301; bh=HoU+iv3+B0WFImV8HuQyeOM8ZisK/4jMaOHGl0MMApA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=OWcg2MEVQGN2jvf8LxFf0XG2JzgByILttkt2Ra6tCOvgjtZuFNGs3UYYQDgHjTdj7
         SjpzgjlZB2kEbk7MzpBgAcs14MTFQIMuE8r3XUwk874uCYkLdB3jiSDiuV5EDToQK6
         nb3h52/E3PxKKLGHPRputh9Oy6DWxcExY8yb44xBP0xFRHk8fdr1Ne0jQdt5o+B7IA
         l49riNEXaKV6Xr9vlng2V0uhb/2QbGg5wEqA3X0qTmxB8267rGMDksyhnCPgW0YcIv
         /iBZS21tN/6ykzGqlQ/5n2lNS9jVcfAjrCUILut6bhDNnXx1hyR1uHmKWeRYAZ03rq
         xdFllY2MmbYJw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/2/2020 12:52 AM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu,  1 Oct 2020 16:59:18 +0300 Moshe Shemesh wrote:
>> +     err = mlx5_fw_reset_set_live_patch(dev);
>> +     if (err)
>> +             return err;
>> +
>> +     return 0;
> nit return mlx...


Right, will fix. Thanks.

