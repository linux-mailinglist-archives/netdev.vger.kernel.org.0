Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457491F89AB
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgFNQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 12:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgFNQoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 12:44:37 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84480C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 09:44:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l26so12330660wme.3
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 09:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cnfA+Ca8alagE7SjXLsCzgVKESJUQbT921kheJPS/j0=;
        b=Keoa4KibcpYIGeVuQ0tiI+EQtQFXGqLn7kc3DYyHMDIS92Wics0oKGx3SEf4dInq+H
         msqYh/qdDc9BGWicLnWXPTJd+bKEudf5VUv9L+X9rBGzejMGcOYCwZ3J4jNPV3xrgq6/
         m77X+1hD+rbFDq9Y4heU7WK7XuZZ32XfpMMDi37rhTV0pL2dtyVJGbYjHBxZNPzGTBo+
         URtm7iUwVl3V4PZNzAfyT3grWUBu7lKi3F6q6RhcCo7d4i1xa9Va5XiC44AArH1tjxZg
         FK8HX5fU5Vj5E8FcVI5nzL0bdWSOwEB0XYt8pqgJFN0sKnn0Gsn6Th4LqFit4hETJ9VX
         J/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cnfA+Ca8alagE7SjXLsCzgVKESJUQbT921kheJPS/j0=;
        b=WHJl4Eh7gKoGt73FIg76gQO359ckTBSvKiO0DtOU6KjiE/9fDIQQHFgbpI/PPWw1GC
         v54Wf+yyQpq4znLM4cTDFOyFv/vFUNginb9n8qUxWuMrz43mnaW2jb0h3m+vBo4IB1FE
         gzLL2wyZs2LsLt1jwVFd53ZQ0X48f9k125mtPqOIAGJbsRSNAC065nFWfmrH+RlpcGbc
         M4B+HwEENMp4YpvXPLyiEViO+AwtudIm8b475TvOtuizXS/UCUsr4Sy58i6nsmOl8wCh
         jK1OucW2INsMnYKsVmNhIqd+9JBe22prvpieLZIFnMEYRhoKZK1LBvacnRKdGpNZYnVD
         xzyQ==
X-Gm-Message-State: AOAM5307EI/gtnzynzMlWh5GfpYZ3qu8Q933UQBWoKGlBv/abzrcnool
        mGDaIhgsx97QH3scct3yahobqzI+
X-Google-Smtp-Source: ABdhPJzgVK26N/5H5rspmTvTILRifoGQX9+U0/RCLat87Ka0inQ8LM7X4KAJ5h2/vxmAER3/ZWGoWw==
X-Received: by 2002:a1c:dfd7:: with SMTP id w206mr8849730wmg.130.1592153075892;
        Sun, 14 Jun 2020 09:44:35 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v7sm20622674wro.76.2020.06.14.09.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 09:44:35 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
 <0353ce74-ffc6-4d40-bf0f-d2a7ad640b30@gmail.com>
 <20200610200526.GB19869@lunn.ch>
 <2994dba7-c038-5702-a5ec-e11d5741a1e5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e9e6994d-50da-da4a-5992-872c5aa1fafb@gmail.com>
Date:   Sun, 14 Jun 2020 09:44:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2994dba7-c038-5702-a5ec-e11d5741a1e5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/2020 9:14 AM, Heiner Kallweit wrote:
> On 10.06.2020 22:05, Andrew Lunn wrote:
>>> Not sure it makes sense to build ETHTOOL_NETLINK as a module, but at
>>> least ensuring that ETHTOOL_NETLINK is built into the kernel if PHYLIB=y
>>> or PHYLIB=m would make sense, or, better we find a way to decouple the
>>> two by using function pointers from the phy_driver directly that way
>>> there is no symbol dependency (but reference counting has to work).
>>
>> Hi Florian
>>
>> It is not so easy to make PHYLIB=m work. ethtool netlink needs to call
>> into the phylib core in order to trigger a cable test, not just PHY
>> drivers.
>>
>> Ideas welcome.
>>
> When looking at functions like phy_start_cable_test() we could do the
> following: Most of it doesn't need phylib and could be moved to
> ethtool/cabletest.c. Or maybe into a separate ethtool phylib glue
> code source file. The phylib calls (phy_link_down, phy_trigger_machine)
> then would have to be moved into the cable_test_start callback.
> I see that each callback implementation then would have some
> boilerplate code. But maybe we could facilitate this with few helpers,
> so that a cable test callback would look like:
> 
> phy_cable_test_boiler_start()
> actual_cable_test()
> phy_cable_test_boiler_end()

Yes, that could work, the other possibility would be to extend
ethtool_ops and add cable_test_start function pointers, and then we just
punt onto the network device driver to call the appropriate PHYLIB
function. That way we already have a mechanism in place for registering
callbacks which is based upon the network device driver lifecycle, and
from the network device driver is guaranteed to load PHYLIB because of
direct symbol dependencies. The caveat with that approach is that each
network device driver needs top opt in for those, as opposed to us
defaulting to using PHYLIB and enabling all drivers that use PHYLIB by
default.
-- 
Florian
