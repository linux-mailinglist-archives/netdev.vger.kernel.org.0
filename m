Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4554F282963
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 09:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgJDHSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 03:18:25 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8682 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDHSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 03:18:25 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f79770b0000>; Sun, 04 Oct 2020 00:17:31 -0700
Received: from [10.21.180.76] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 4 Oct
 2020 07:18:15 +0000
Subject: Re: [PATCH net-next 03/16] devlink: Add devlink reload limit option
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-4-git-send-email-moshe@mellanox.com>
 <20201003075100.GC3159@nanopsycho.orion>
 <20201003080436.40cd8eb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <62b6436c-5f12-8362-b10f-3b19f913e08a@nvidia.com>
Date:   Sun, 4 Oct 2020 10:18:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201003080436.40cd8eb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601795851; bh=ohvtIRryN1zqM/5y/NLdA3n4okfaM02PHrUQ5xzLOpA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=phne8JUY+Ba311sQJ194bnAHtbO7HikyzBYSwY16YfKlxoWCVrHITLzSmy8JVRES9
         QYw+0wiCJLOyp8YbNNVifEaWdFEsOXN/8dgY2Ui0gJwGAoMgaaBe3VolBmtsFMR4iB
         TQuapQBEZJSNdwchwPf8BMkGeVWeXvoGJHN8Bcz0d2ygNRqvLjMAXfjnFKAZpvyZnD
         1Yf0aLA/nmaJDmCSD9/tJMkAiRmh4dflTPWkFLLU+faPDzoFehBOUEl5cLK51EtVJc
         RJi77DXSWJHyX15G+FZnFIwQcM5oTleNWbCueJ0rbHzQ3DaDVJaT6mNxt4HfQlQHQL
         2fMrBEDAtFH5A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/3/2020 6:04 PM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Sat, 3 Oct 2020 09:51:00 +0200 Jiri Pirko wrote:
>>> enum devlink_attr {
>>>      /* don't change the order or add anything between, this is ABI! */
>>>      DEVLINK_ATTR_UNSPEC,
>>> @@ -507,6 +524,7 @@ enum devlink_attr {
>>>
>>>      DEVLINK_ATTR_RELOAD_ACTION,             /* u8 */
>>>      DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,  /* u64 */
>>> +    DEVLINK_ATTR_RELOAD_LIMIT,      /* u8 */
>> Hmm, why there could be specified only single "limit"? I believe this
>> should be a bitfield. Same for the internal api to the driver.
> Hm I was expecting limits to be ordered (in maths sense) but you're
> right perhaps that can't be always guaranteed.
>
> Also - Moshe please double check that there will not be any kdoc
> warnings here - I just learned that W=1 builds don't check headers
> but I'll fix up my bot by the time you post v2.


Didn't know this tool, but I will. Thanks.

