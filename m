Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E986A2AA5
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 17:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBYQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 11:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBYQMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 11:12:00 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A6213DF0
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 08:11:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677341499; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=fH/dyHQ0Ij8NPYAxDnpSemvgGqkI9yws09pIwshPokbF5/iVXwcw1uZupFUh1J8l8U6Ej98gLCQXqoOb9C3ugI6J4J92ZfdgplyxasuVy0+MKfQb8tU1hbI/KU6xLSbOY7Ss4BItDeFXUmxfN/7VaEmXtQWWRfOFa4EbIK0BuYo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1677341499; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=YUx2KkGL8ke5qIfXRNLYZgMpJlwGXVU4Gtc/DRe550Y=; 
        b=c1RFgEUBgByXK7FpD64lOiai4fiFdWZIfFH9FOLsijB6cDFDnHk9SAYU2Bb+YTzft6SHAeqKFUUu+KDes2ORqfhYsRR2mfvouhlNHPfjJbhPbtzRzyTABefMUWatNuNHKG7rbqmTluK3CYizl+dVGNgH9UfDGllGRfHlYUN6rdU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1677341499;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=YUx2KkGL8ke5qIfXRNLYZgMpJlwGXVU4Gtc/DRe550Y=;
        b=ScWnOQwtP93Eu/ZHcw+AkyhAY28C8tZqyd/HdNl+6rmLdKO2SQxDGji8CRkmrIGy
        wUjvDWSUssfWnM7MYYGnk8O+XZKq2lN6pfphjSLoESoe0XaIwR3tzOkFKXreQ4cSudV
        ZWrI5kjJ4WuX5UQOaLZMImLlvGfPjuJoC9cXBAE0=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1677341497073306.9797400087788; Sat, 25 Feb 2023 08:11:37 -0800 (PST)
Message-ID: <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com>
Date:   Sat, 25 Feb 2023 19:11:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: Aw: Re: Choose a default DSA CPU port
To:     Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
 <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2023 16:50, Frank Wunderlich wrote:
> Hi
> 
>> Gesendet: Freitag, 24. Februar 2023 um 22:08 Uhr
>> Von: "Vladimir Oltean" <olteanv@gmail.com>
> 
>> On Fri, Feb 24, 2023 at 09:44:43PM +0100, Frank Wunderlich wrote:
>>> 6.1.12 is clean and i get 940 Mbit/s over gmac0/port6
>>
>> Sounds like something which could be bisected?
> 
> managed to do a full bisect...
> 
> most steps needed the fix from Vladimir (1a3245fe0cf84e630598da4ab110a5f8a2d6730d net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0)
> 
> here is the result:
> 
> f63959c7eec3151c30a2ee0d351827b62e742dcb is the first bad commit

Thanks a lot for finding this. I can confirm reverting this fixes the 
low throughput on my Bananapi BPI-R2 as well.

$ iperf3 -c 192.168.2.1 -R
Connecting to host 192.168.2.1, port 5201
Reverse mode, remote host 192.168.2.1 is sending
[  5] local 192.168.2.2 port 56840 connected to 192.168.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  74.6 MBytes   626 Mbits/sec
[  5]   1.00-2.00   sec  74.4 MBytes   624 Mbits/sec
[  5]   2.00-3.00   sec  74.4 MBytes   624 Mbits/sec
[  5]   3.00-4.00   sec  74.3 MBytes   624 Mbits/sec
[  5]   4.00-5.00   sec  74.4 MBytes   624 Mbits/sec
[  5]   5.00-6.00   sec  74.3 MBytes   623 Mbits/sec
[  5]   6.00-7.00   sec  74.4 MBytes   624 Mbits/sec
[  5]   7.00-8.00   sec  74.3 MBytes   623 Mbits/sec
[  5]   8.00-9.00   sec  74.4 MBytes   624 Mbits/sec
[  5]   9.00-10.00  sec  74.3 MBytes   624 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   745 MBytes   625 Mbits/sec    0             sender
[  5]   0.00-10.00  sec   744 MBytes   624 Mbits/sec 
receiver

After reverting f63959c7eec3151c30a2ee0d351827b62e742dcb (and removing 
the lines that appeared on HEAD which caused a conflict):

$ iperf3 -c 192.168.2.1 -R
Connecting to host 192.168.2.1, port 5201
Reverse mode, remote host 192.168.2.1 is sending
[  5] local 192.168.2.2 port 36364 connected to 192.168.2.1 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   112 MBytes   938 Mbits/sec
[  5]   1.00-2.00   sec   112 MBytes   939 Mbits/sec
[  5]   2.00-3.00   sec   112 MBytes   939 Mbits/sec
[  5]   3.00-4.00   sec   112 MBytes   939 Mbits/sec
[  5]   4.00-5.00   sec   112 MBytes   939 Mbits/sec
[  5]   5.00-6.00   sec   112 MBytes   939 Mbits/sec
[  5]   6.00-7.00   sec   112 MBytes   939 Mbits/sec
[  5]   7.00-8.00   sec   112 MBytes   939 Mbits/sec
[  5]   8.00-9.00   sec   112 MBytes   939 Mbits/sec
[  5]   9.00-10.00  sec   112 MBytes   939 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.09 GBytes   939 Mbits/sec 
receiver

Arınç
