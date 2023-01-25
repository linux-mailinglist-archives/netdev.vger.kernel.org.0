Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14BC667A9FD
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjAYFe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAYFez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:34:55 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BC53CE1F;
        Tue, 24 Jan 2023 21:34:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1674624875; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=PEzdFTFkNZOUdFSaAcNemSKww9U6vSJrOpZU7jktUEzwa2B0cCXgXxlH+0SFkaPCtSDca9Uv6HGH/JnZRgeHZT7XvdE5M4RxS0hCbML2d57KBbHeZ2cKarzTlREVTIYqSHUPm7h5lZqm7WYFVQEBTjtt5SEM356PqnQ5jLDdHu4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1674624875; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=1T7HNJXIHg2UTJ+bfgTgUwnUvVRcQuFybMkS/9ZYQRo=; 
        b=L0uFYzgDrFBfVYOdd4xrY4cb0mNZh1GpfyfpavOIPNSP75xXhHuRxQETpnQArAPaS46fwodYbwLFyMRfA7hMC0/U6exqU/z0Yrbqew4lEfFtgQIlmiCi64l42URocW3hdB5QmfNPeHrI7dq3AyAwOBw9BSYqfRJ+Oz1VrCJvbCg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1674624875;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=1T7HNJXIHg2UTJ+bfgTgUwnUvVRcQuFybMkS/9ZYQRo=;
        b=D0VoWL8GTORuGifyPnFi95832PkWH1GYef+Lu0bEOS6eM/Qt5DIIUinwwbe0Duj/
        zv7eSYaEcSkBM6rslkehrkmIS6nRhlTOdKqPpQPZjcejkgS+YBzyNJScSSyRJcuptw4
        95mepzHEAit9noPszfzuWngNaq5/x+jju48tKaYY=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 16746248725217.955622735674183; Tue, 24 Jan 2023 21:34:32 -0800 (PST)
Message-ID: <7ea0f205-f6cb-c608-4205-fa5bd7ba5a6f@arinc9.com>
Date:   Wed, 25 Jan 2023 08:34:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: dsa: mt7530: fix tristate and help description
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
References: <20230123170853.400977-1-arinc.unal@arinc9.com>
 <20230124181650.6f2c28c0@kernel.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230124181650.6f2c28c0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.2023 05:16, Jakub Kicinski wrote:
> On Mon, 23 Jan 2023 20:08:53 +0300 Arınç ÜNAL wrote:
>> Fix description for tristate and help sections which include inaccurate
>> information.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The patch didn't make it to patchwork or lore for some reason :(
> Could you repost? And when you do - add the tree name in the subject?
> If the chips you're listing are supported in Linus's tree then
> [PATCH net] ?

Yup it's for net, thanks for the heads up Jakub.

Arınç
