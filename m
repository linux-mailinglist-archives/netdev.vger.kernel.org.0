Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43A93E0959
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240866AbhHDU1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239787AbhHDU1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 16:27:30 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE217C0613D5;
        Wed,  4 Aug 2021 13:27:16 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id x9so2048505ljj.2;
        Wed, 04 Aug 2021 13:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sFhwGgihGIFf7rMl6r2eM9E8ktjo6vC3SBJMNxxgU0I=;
        b=WS6vaQgA5hRwemrisu+Jyfpdp6O5QxbS0k+zcSD6oFVFpt191xhOJdX3/X/fXlrD4M
         I1XGyghZMd2bk5f6Hg3WztQce7FHKF/I1IT1CcHy8dQBJUqUrBSGDWtmtdqWdYYn/IOV
         I5lv6el+ZPbScmMXeqA1T/u3Lp/BdRlMW4RdfkXMsD9+vkvG2GluScmNL1scrMb92O5l
         5gFDEamnT0ngmPM1JZUVf5V7vNBKof9SzkTVFl6iGzuq/6YEdi1zFq+a+NM++vB9i4WQ
         bkxW3FkNgb2i4RrE6SBtLcaGUGbBLX5/drAQcS6nVrwejPOYTjCT9OM7H2yMKttbU3YQ
         tkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sFhwGgihGIFf7rMl6r2eM9E8ktjo6vC3SBJMNxxgU0I=;
        b=KPKK7BmaD1ZU3VpPT/zNLiywA/TiDx6Ig5d3XIfmPtSGBSa59zgPBiMngbS5PuenYp
         ukdIHL1pawjmlZPz0fieBcgzgZJ51oMi0i3qBUwTh3ZOzRSAlWOEUxwoJShS6hPdhvAk
         jL1uteg6E/Et2sAFq1tQVoSggkrMu1LVw+efchCSNezU160p2eZwxE1dhsui/BUSLzhr
         3HLqvX39B+cJxS9u5YGWQk+D0ep9+lGvxzcLfA3AyphpM+NoFs44xXt+2MVrjjlQygor
         9wZzN8cXFJLeKkFYS1LNq38VPv5vjaeIIJN/oV2mpKh22uNmoMrLCGJa7VfPOBeWSuR+
         pHqw==
X-Gm-Message-State: AOAM533rqRKzpMcDCnU5GAT5CmAJq1Y3M4dz/U2LxPzguhMyojhcPaTR
        O1rri5VInbFtklJve+CEjdI=
X-Google-Smtp-Source: ABdhPJwQ8DZqQyhO5JF/PIgGbW+wxBaYE4dPFufzWBTXuc2AOw7pO0kWsYB+w3flAjSdpLOY8Ko0dw==
X-Received: by 2002:a2e:2f05:: with SMTP id v5mr774129ljv.66.1628108835193;
        Wed, 04 Aug 2021 13:27:15 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.77.221])
        by smtp.gmail.com with ESMTPSA id o1sm293755lfl.67.2021.08.04.13.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 13:27:14 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <e740c0ee-dcf0-caf5-e80e-9588605a30b3@gmail.com>
 <OS0PR01MB592289FDA9AA20E5B033451E86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <5a53ce65-5d6c-f7f2-861e-314869d2477d@gmail.com>
Message-ID: <6e4971cb-3567-6f1d-11d6-467c0ba88f27@gmail.com>
Date:   Wed, 4 Aug 2021 23:27:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5a53ce65-5d6c-f7f2-861e-314869d2477d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/21 10:27 PM, Sergei Shtylyov wrote:

>>> Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to
>>> driver data
>>>
>>> On 8/2/21 1:26 PM, Biju Das wrote:
>>>
>>>> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC
>>>> are similar to the R-Car Ethernet AVB IP. With a few changes in the
>>>> driver we can support both IPs.
>>>>
>>>> Currently a runtime decision based on the chip type is used to
>>>> distinguish the HW differences between the SoC families.
>>>>
>>>> The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2
>>>> and RZ/G2L it is 2. For cases like this it is better to select the
>>>> number of TX descriptors by using a structure with a value, rather
>>>> than a runtime decision based on the chip type.
>>>>
>>>> This patch adds the num_tx_desc variable to struct ravb_hw_info and
>>>> also replaces the driver data chip type with struct ravb_hw_info by
>>>> moving chip type to it.
>>>>
>>>> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>>>> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>>>> ---
>>>> v2:
>>>>  * Incorporated Andrew and Sergei's review comments for making it
>>> smaller patch
>>>>    and provided detailed description.
>>>> ---
>>>>  drivers/net/ethernet/renesas/ravb.h      |  7 +++++
>>>>  drivers/net/ethernet/renesas/ravb_main.c | 38
>>>> +++++++++++++++---------
>>>>  2 files changed, 31 insertions(+), 14 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/renesas/ravb.h
>>>> b/drivers/net/ethernet/renesas/ravb.h
>>>> index 80e62ca2e3d3..cfb972c05b34 100644
>>>> --- a/drivers/net/ethernet/renesas/ravb.h
>>>> +++ b/drivers/net/ethernet/renesas/ravb.h
>>>> @@ -988,6 +988,11 @@ enum ravb_chip_id {
>>>>  	RCAR_GEN3,
>>>>  };
>>>>
>>>> +struct ravb_hw_info {
>>>> +	enum ravb_chip_id chip_id;
>>>> +	int num_tx_desc;
> 
>    How about leaving that field in the *struct* ravb_private? And adding the following instead:
> 
> 	unsigned unaligned_tx: 1;

   Or aligned_tx, so that gen2 has it set, and gen3 has it cleared.

> 
>>>    I think this is rather the driver's choice, than the h/w feature...
>>> Perhaps a rename would help with that? :-)
>>
>> It is consistent with current naming convention used by the driver. NUM_TX_DESC macro is replaced by num_tx_desc and  the below run time decision based on chip type for H/W configuration for Gen2/Gen3 is replaced by info->num_tx_desc.
>>
>> priv->num_tx_desc = chip_id == RCAR_GEN2 ? NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;
> 
>    .. and then:
> 
> 	priv->num_tx_desc =  info->unaligned_tx ? NUM_TX_DESC_GEN2 : NUM_TX_DESC_GEN3;

   Sorry, mixed the values, should have been:

	priv->num_tx_desc =  info->unaligned_tx ? NUM_TX_DESC_GEN3 : NUM_TX_DESC_GEN2;

>> Please let me know, if I am missing anything,
>>
>> Previously there is a suggestion to change the generic struct ravb_driver_data (which holds driver differences and HW features) with struct ravb_hw_info.
> 
>     Well, my plan was to place all the hardware features supported into the *struct* ravb_hw_info and leave all
> the driver's software data in the *struct* ravb_private.

   ... just like *struct* sh_eth_cpu_data and sh_eth_private in the sh_eth driver.

>> Regards,
>> Biju

MBR, Sergei
