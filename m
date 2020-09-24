Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07685276A20
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgIXHLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:11:25 -0400
Received: from mickerik.phytec.de ([195.145.39.210]:55128 "EHLO
        mickerik.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgIXHLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=phytec.de; s=a1; c=relaxed/simple;
        q=dns/txt; i=@phytec.de; t=1600931474; x=1603523474;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OMthT7YUyFnK+E3+Gi8XWgeSHho8uppt/CoxlwcYZxA=;
        b=CYXmttNUWPi/coMUHaDLYOJfNlI2v9DmehSyge3T8euQVPHCMQW4w/dcoOR+Fcad
        uAyHtxQuIME+Npmv7D8g/GzdyK9QjbqQN6FIpFOSxpET5AY6LRW1TCxleGX9w88H
        FhdOaT84sDScJ5JxwPbG2lk4foU5cIstlH/yC6oeirw=;
X-AuditID: c39127d2-253ff70000001c25-ef-5f6c469251b7
Received: from idefix.phytec.de (Unknown_Domain [172.16.0.10])
        by mickerik.phytec.de (PHYTEC Mail Gateway) with SMTP id 00.80.07205.2964C6F5; Thu, 24 Sep 2020 09:11:14 +0200 (CEST)
Received: from [172.16.23.108] ([172.16.23.108])
          by idefix.phytec.de (IBM Domino Release 9.0.1FP7)
          with ESMTP id 2020092409111413-487872 ;
          Thu, 24 Sep 2020 09:11:14 +0200 
Subject: Re: [EXT] Re: [PATCH] net: fec: Keep device numbering consistent with
 datasheet
To:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "c.hemp@phytec.de" <C.Hemp@phytec.de>
References: <20200923142528.303730-1-s.riedmueller@phytec.de>
 <20200923.133147.842604978902817779.davem@davemloft.net>
 <AM8PR04MB73153F8A9E3A4DB0F7AA8003FF390@AM8PR04MB7315.eurprd04.prod.outlook.com>
From:   =?UTF-8?Q?Stefan_Riedm=c3=bcller?= <s.riedmueller@phytec.de>
Message-ID: <6a4e3e6e-4371-f0ad-4150-4fffc0739901@phytec.de>
Date:   Thu, 24 Sep 2020 09:11:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM8PR04MB73153F8A9E3A4DB0F7AA8003FF390@AM8PR04MB7315.eurprd04.prod.outlook.com>
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 24.09.2020 09:11:14,
        Serialize by Router on Idefix/Phytec(Release 9.0.1FP7|August  17, 2016) at
 24.09.2020 09:11:14,
        Serialize complete at 24.09.2020 09:11:14
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRoCBS3eSW068wb2rQhbn7x5itphzvoXF
        YuXzu+wWF7b1sVpsenyN1eLyrjlsFscWiDmwe2xZeZPJY9OqTjaPzUvqPXbu+MzksfHdDiaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDKOT9/BWnCNr+Jzv28D4wXuLkZODgkBE4kfD34wdjFycQgJ
        bGOUaPizkwnCOcMo0bpxBwtIlbBAlMTiE5OYQWwRgVSJlyvWgsWZBfqZJNb0qUM0nGaUmH37
        HTtIgk3ASWLx+Q42EJtXwEZiyvcnYDaLgKpEw8I/QIM4OEQFIiV27rCEKBGUODnzCdhMToFY
        iWldH8AukhBoZJJobd/ICHGqkMTpxWeZIRbLS2x/OwfKNpOYt/khlC0ucevJfKYJjEKzkMyd
        haRlFpKWWUhaFjCyrGIUys1Mzk4tyszWK8ioLElN1ktJ3cQIjJfDE9Uv7WDsm+NxiJGJg/EQ
        owQHs5II7w217Hgh3pTEyqrUovz4otKc1OJDjNIcLErivBt4S8KEBNITS1KzU1MLUotgskwc
        nFINjIvE7np8tbjgeOHIqYdahzm3zLV0KXdRdspY5jszyUY5rfjK5ocTahM8DmvP5uGd5/Xb
        bJuAb9jSvYYdhxNXBU5r2pJ5qu3DtmDhQIMv3/yPdy3/uWbxV4UOef7ll65dOvp+/2+dZ6WM
        PgauE4/vO5z1tliz78DmD+ylfKHmVzoCT/69nvb70kElluKMREMt5qLiRAC1AbhWhQIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, David and Andrew,

first of all, thanks for your review. I really appreciate it!

On 24.09.20 08:36, Andy Duan wrote:
> From: David Miller <davem@davemloft.net> Sent: Thursday, September 24, 2020 4:32 AM
>> From: Stefan Riedmueller <s.riedmueller@phytec.de>
>> Date: Wed, 23 Sep 2020 16:25:28 +0200
>>
>>> From: Christian Hemp <c.hemp@phytec.de>
>>>
>>> Make use of device tree alias for device enumeration to keep the
>>> device order consistent with the naming in the datasheet.
>>>
>>> Otherwise for the i.MX 6UL/ULL the ENET1 interface is enumerated as
>>> eth1 and ENET2 as eth0.
>>>
>>> Signed-off-by: Christian Hemp <c.hemp@phytec.de>
>>> Signed-off-by: Stefan Riedmueller <s.riedmueller@phytec.de>
>>
>> Device naming and ordering for networking devices was never, ever,
>> guaranteed.
>>
>> Use udev or similar.
>>
>>> @@ -3691,6 +3692,10 @@ fec_probe(struct platform_device *pdev)
>>>
>>>        ndev->max_mtu = PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN;
>>>
>>> +     eth_id = of_alias_get_id(pdev->dev.of_node, "ethernet");
>>> +     if (eth_id >= 0)
>>> +             sprintf(ndev->name, "eth%d", eth_id);
>>
>> You can't ever just write into ndev->name, what if another networking device is
>> already using that name?
>>
>> This change is incorrect on many levels.
> 
> David is correct.
> 
> For example, imx8DXL has ethernet0 is EQOS TSN, ethernet1 is FEC.
> EQOS TSN is andother driver and is registered early, the dev->name is eth0.
> So the patch will bring conflict in such case.

I was not aware of that conflict, but now that you mention it it makes total 
sense.

I wanted to make life a little easier for myself but underestimated the 
global context. I will try to find a solution with udev or something similar.

So please drop this patch and sorry for the noise.

Stefan

> 
> Andy
> 
