Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FD82B2E59
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 17:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgKNQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 11:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgKNQGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 11:06:35 -0500
X-Greylist: delayed 1624 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Nov 2020 08:06:34 PST
Received: from iam.tj (soggy.cloud [IPv6:2a01:7e00:e000:151::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA340C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 08:06:34 -0800 (PST)
Received: from [10.0.40.123] (unknown [51.155.44.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id A6616340AD;
        Sat, 14 Nov 2020 16:06:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1605369993; bh=CmSsL4QWFFw7wYkkaS7n1xmLtV9lnSawojHwGa6s7l0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XnQeM8QlUVHgN5D2l5xQRg7bg/E9pdIB+G9OhwuGc+Cslpo7+FBK/wlLREBZGHsRl
         ZaRMd9eCu4INBx+tC+pEEoz83FN0LCGz4lgLorzr0RjrvwW3xh93ycls/KzNo63+nn
         uYG/QGCViRzIxpKLzupQ/eAOTP1GcB6DwN6lomHgxrbOJVrCa1eHxkkfu+Ttg6CPUy
         qjLfpHZKRubS1TEFHRxrRSTWCk6GtOmBDiA7HnfdxQgYtLjAKBw1Xcl7LawxAssr0b
         OPsjuzcCpnUu2Y3o1AoxeNqhQe9IFqby1sdetE0bLqF6SrchfChw/GEPpfCe2M28B/
         NQSPSynG/0vig==
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, chris.packham@alliedtelesis.co.nz,
        f.fainelli@gmail.com, marek.behun@nic.cz, vivien.didelot@gmail.com,
        info <info@turris.cz>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
 <20201114155614.GZ1480543@lunn.ch>
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Organization: Elloe CIC
Message-ID: <eed7bc92-e1e6-35df-a2cf-97e74a8730fd@elloe.vision>
Date:   Sat, 14 Nov 2020 16:06:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201114155614.GZ1480543@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/11/2020 15:56, Andrew Lunn wrote:
>> 1) with isc-dhcp-server configured with very short lease times (180
>> seconds). After mox reboot (or systemctl restart systemd-networkd)
>> clients successfully obtain a lease and a couple of RENEWs (requested
>> after 90 seconds) but then all goes silent, Mox OS no longer sees the
>> IPv6 multicast RENEW packets and client leases expire.
> 
> So it takes about 3 minutes to reproduce this?
> 
> Can you do a git bisect to figure out which change broke it? It will
> take you maybe 5 minutes per step, and given the wide range of
> kernels, i'm guessing you need around 15 steps. So maybe two hours of
> work.
> 
> 	Andrew
>

I'll check if we can - the problem might be the Turris Mox kernel is
based on a board support package drop by Marvell so I'm not clear right
now how divergent they are. Hopefully the Turris kernel devs can help on
that.

