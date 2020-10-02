Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591BB2815F0
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgJBPB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:01:29 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9651 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:01:29 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7740610000>; Fri, 02 Oct 2020 07:59:45 -0700
Received: from [10.21.180.145] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 2 Oct
 2020 15:01:19 +0000
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-4-git-send-email-moshe@mellanox.com>
 <20201001141425.68f7eeb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <71a190af-6b00-2b2e-a356-8e9f241894f6@nvidia.com>
Date:   Fri, 2 Oct 2020 18:01:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201001141425.68f7eeb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601650785; bh=09Lfdng1n7Q4TTakBKhVCcqKyqUENsEv04FUoxMlFn8=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=JEk2Lb90N9nzP5ZWoo0BQ+kKbCwslxXFAr0UGrDrhQqhE6a7V0EOEzDxqE8uyiVZB
         51n5Ufyt4ADtkaZr2CPSXUkp+ZlW7TJB2DYfliZnpAp3WJ3MiNszAXmPsWqBGb7kAN
         2lbMYeGkS6gZA5WpHa+GuHWrAjZBCrCY9g8W8Kh2C54DGMkSofigNAcMkft2M9lBoT
         dwWsSRkaXUt6tIlPGS4B9cMaFYOWy+OKo7+Diq+Fzmfk8jp22ERH+oTavxbwcIqL4R
         m5V9Hgn+GHfpv7y91iiLHP2GIlyUre8suQIsygvvVmIA6YcTpdySGVnKBO7lEhyCcO
         I+zrAQVZ9EWyg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/2/2020 12:14 AM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu,  1 Oct 2020 16:59:06 +0300 Moshe Shemesh wrote:
>> @@ -3032,6 +3064,7 @@ devlink_nl_reload_actions_performed_snd(struct devlink *devlink,
>>
>>   static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>   {
>> +     enum devlink_reload_limit limit;
>>        struct devlink *devlink = info->user_ptr[0];
>>        enum devlink_reload_action action;
>>        unsigned long actions_performed;
> reverse xmas tree
missed that, thanks.
