Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDC92CB791
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 09:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbgLBIpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 03:45:05 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7416 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgLBIpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 03:45:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc753e90000>; Wed, 02 Dec 2020 00:44:25 -0800
Received: from [10.26.73.44] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Dec
 2020 08:44:11 +0000
Subject: Re: [PATCH iproute2-net 0/3] devlink: Add devlink reload action limit
 and stats
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Netdev <netdev@vger.kernel.org>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
 <CAACQVJr_cYUUO=Nys=MeOLUno4sXy0a1PTwUk59hzjJZQz3j+w@mail.gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <8ef56162-d720-b7e0-081b-df7bf970c88a@nvidia.com>
Date:   Wed, 2 Dec 2020 10:44:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAACQVJr_cYUUO=Nys=MeOLUno4sXy0a1PTwUk59hzjJZQz3j+w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606898665; bh=R0hkf3cbWepz7KDOtSLMkAlRjHJQqU3s1ERti9VgDyk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=ekAxzEhzfMdxSKhvRxaRbY3zmj8Gl/cl4CKn73j8aSjZ5pvXOUfhNbZfLt05FdzOR
         1PPeRx+2qJP+p1kr+V5K8m4BqOersEymGd8J3b1FZLDEwC9DFVmFX0sIVo1XrYN9rw
         fe+JXwI0GwTU2eqvf9dfs6p0+wvptGfOO7RKyXT7AtIdJAiu28wkxowQ1FxB9osA+i
         XgZHOHZwLyCLy0T3DZZ1+FXu3tfZ4VE3EN4LjkhqvPcV+PbXSWXQ4fXO7TNPvNzehg
         /mCimDlsBKEeQ58SDrJs2A4n0G7D7BDJOdhdGKcYRD/jgpGSFYDhj9Oh99zqbEs8Tk
         HupxgqzoXFNnw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/1/2020 1:25 PM, Vasundhara Volam wrote:
> On Thu, Nov 26, 2020 at 4:46 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>> Introduce new options on devlink reload API to enable the user to select
>> the reload action required and constrains limits on these actions that he
>> may want to ensure.
>>
>> Add reload stats to show the history per reload action per limit.
>>
>> Patch 1 adds the new API reload action and reload limit options to
>>          devlink reload command.
>> Patch 2 adds pr_out_dev() helper function and modify monitor function to
>>          use it.
>> Patch 3 adds reload stats and remote reload stats to devlink dev show.
>>
>>
>> Moshe Shemesh (3):
>>    devlink: Add devlink reload action and limit options
>>    devlink: Add pr_out_dev() helper function
>>    devlink: Add reload stats to dev show
>>
>>   devlink/devlink.c            | 260 +++++++++++++++++++++++++++++++++--
>>   include/uapi/linux/devlink.h |   2 +
>>   2 files changed, 249 insertions(+), 13 deletions(-)
> I see man pages are not updated accordingly in this series. Will it be
> updated in the follow-up patch?
Right, I will update man page. Thanks.
>> --
>> 2.18.2
>>
