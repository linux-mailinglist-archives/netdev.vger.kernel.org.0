Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E267163894
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 01:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgBSAeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 19:34:03 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43791 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgBSAeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 19:34:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id dc19so26959093edb.10
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 16:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j4bAJPqeySV3vjYbXXGrP14oCwNm+8NskOFJK5hDTYI=;
        b=ihsNJRqh3I6+eiASJ40zOEJQlDJOTR991J7TxX2UuN3oVQeNjsE56pib55cXmeFxNR
         44ov/QNDmRsp/JGUiDeXvr2nOlf4SfsU6+KW0G/VLubs5Fx12PaBTTHqb6kJDoJgJK0S
         FdMKIgHfU9+joYck659IEXSMNGJsymTtZIOO/TtQh2SwKohWqVEBPcikavEOYpH6umOU
         wroFgAC/X0hso1Jv0PSf9WS3O5Bxa2yP1MVppQTV+gB8AxrZI/9HPDhyAtDRK0HaP686
         VQwLTn3+FscaoRjYYEOVLD/ASxp4jAj9BnTUbsn97HU32GXA1ci9SePg0ZfbyeVYNJzb
         352w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=j4bAJPqeySV3vjYbXXGrP14oCwNm+8NskOFJK5hDTYI=;
        b=FNsCVzZLPrDvjpuxijK6fyvHialcWOgh3TNg6cpmoPGzUuMDFx1kAwWX77R8fwcshn
         Mx+psbcGYMxa/XJJHLcamZ6TrgFkcxckmtvzRFWB4h1YC7Ioyja3XFkL2JA8ti5WVFDT
         3sO6es/wQ5V+JLfcsAjzwgWo7EAnwEwoT93oYr3p0dk+Nntbm4AxW62ASfeLMpgwkkyw
         1bbqrQcQgUuuksCRDICBExLmFw/0YOLle1FnUy6IUx6cdf1D6qByGGpBsTx0KkWyyC5y
         8FPQGfkdZGvkzaItCKIG6VjAorabl1c7rlIcs+cNou1WFGZOfgPe5bsXUHIn3768bU4u
         V7Pw==
X-Gm-Message-State: APjAAAXWSiwtqayYRPFTYSRacr2wE1PFofrbH6yb3cLlN0nOohfFzBbX
        3VIO7aseIq5ujAkJ59T85x8wH+0Y
X-Google-Smtp-Source: APXvYqzRe4IZM7s9vWBO1lNcMRaAj/EztLY5M20JayLo0JhVCex5M3FbLDHlVThvWNu7deUZ4Q1mtw==
X-Received: by 2002:a17:906:6a4a:: with SMTP id n10mr21319020ejs.375.1582072440466;
        Tue, 18 Feb 2020 16:34:00 -0800 (PST)
Received: from [10.67.49.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w12sm11795edq.94.2020.02.18.16.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 16:33:59 -0800 (PST)
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <e2b53d14-7258-0137-79bc-b0a21ccc7b8f@gmail.com>
 <20200219001737.GP25745@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <b5edd8c7-d201-ce85-c074-fcc5c82e84fd@gmail.com>
Date:   Tue, 18 Feb 2020 16:33:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219001737.GP25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 4:17 PM, Russell King - ARM Linux admin wrote:
> On Tue, Feb 18, 2020 at 04:00:08PM -0800, Florian Fainelli wrote:
>> On 2/18/20 3:45 AM, Russell King - ARM Linux admin wrote:
>>> Hi,
>>>
>>> This is a repost of the previously posted RFC back in December, which
>>> did not get fully reviewed.  I've dropped the RFC tag this time as no
>>> one really found anything too problematical in the RFC posting.
>>>
>>> I've been trying to configure DSA for VLANs and not having much success.
>>> The setup is quite simple:
>>>
>>> - The main network is untagged
>>> - The wifi network is a vlan tagged with id $VN running over the main
>>>   network.
>>>
>>> I have an Armada 388 Clearfog with a PCIe wifi card which I'm trying to
>>> setup to provide wifi access to the vlan $VN network, while the switch
>>> is also part of the main network.
>>
>> Why not just revert 2ea7a679ca2abd251c1ec03f20508619707e1749 ("net: dsa:
>> Don't add vlans when vlan filtering is disabled")? If a driver wants to
>> veto the programming of VLANs while it has ports enslaved to a bridge
>> that does not have VLAN filtering, it should have enough information to
>> not do that operation.
> 
> I do not have the knowledge to know whether reverting that commit
> would be appropriate; I do not know how the non-Marvell switches will
> behave with such a revert - what was the reason for the commit in
> the first place?
> 
> The commit says:
> 
>     This fixes at least one corner case. There are still issues in other
>     corners, such as when vlan_filtering is later enabled.
> 
> but it doesn't say what that corner case was.  So, presumably reverting
> it will cause a regression of whatever that corner case was...

Andrew, can you provide more details on what prompted you to do this in
the first place?
-- 
Florian
