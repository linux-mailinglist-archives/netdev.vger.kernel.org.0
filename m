Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C277C35789D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhDGXiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:38:04 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:43610 "EHLO
        esgaroth.petrovitsch.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhDGXiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:38:01 -0400
X-Greylist: delayed 3592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 19:38:00 EDT
Received: from thorin.petrovitsch.priv.at (80-110-93-117.cgn.dynamic.surfer.at [80.110.93.117])
        (authenticated bits=0)
        by esgaroth.petrovitsch.at (8.16.1/8.16.1) with ESMTPSA id 137MbjSX2151151
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT);
        Thu, 8 Apr 2021 00:37:47 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 esgaroth.petrovitsch.at 137MbjSX2151151
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=petrovitsch.priv.at;
        s=default; t=1617835069;
        bh=sRQ/Lrm5YctprFhxVHSSckbUfrGsc6U25VUJIbk4UJU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=sFdwdWcj9OdVPl+hUYQs5bYYEjLpxNKhph00ykqVUPTIsmJd4ovnE4aheyihdisgs
         dJOqJI/cU4Y8XtPpeXlGCm2kJ8UXa3VH9R4TV8zFxdbjWb6VOIMegEtv/SqgOAHJMe
         gt/pSEO4b8pMyxbsx9ncVr5F/kY/j7VJVG7tH9y4=
X-Info-sendmail: I was here
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
To:     Dexuan Cui <decui@microsoft.com>, Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG1qF8lULn8lLJa/@unreal>
 <MW2PR2101MB08923F19D070996429979E38BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG2pMD9eIHsRetDJ@unreal>
 <MW2PR2101MB0892AC106C360F2A209560A8BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
From:   Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Bimi-Selector: v=BIMI1; s=default
Message-ID: <0d84ef1b-debf-8d5b-0c8d-cb83427b0435@petrovitsch.priv.at>
Date:   Thu, 8 Apr 2021 00:37:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <MW2PR2101MB0892AC106C360F2A209560A8BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-DCC-Etherboy-Metrics: esgaroth.petrovitsch.priv.at 1002; Body=13 Fuz1=13
        Fuz2=13
X-Spam-Status: No, score=-1.2 required=5.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A
        autolearn=unavailable autolearn_force=no version=3.4.4
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 NICE_REPLY_A Looks like a legit reply (A)
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        esgaroth.petrovitsch.priv.at
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

On 07/04/2021 23:59, Dexuan Cui wrote:
[...]
> FWIW, {0} and { 0 } are still widely used, but it looks like
> {} is indeed more preferred:
> 
> $ grep "= {};" drivers/net/  -nr  | wc -l
> 829

$ egrep -nr "=[[:space:]]*{[[:space:]]*};" drivers/net/  | wc -l
872

> $ grep "= {0};" drivers/net/  -nr  | wc -l
> 708

$ egrep -nr "=[[:space:]]*{[[:space:]]*0[[:space:]]*};" drivers/net/  |
wc -l
1078

> $ grep "= {};" kernel/  -nr  | wc -l
> 29

$ egrep -nr "=[[:space:]]*{[[:space:]]*};" kernel/  | wc -l
45

> $ grep "= {0};" kernel/  -nr  | wc -l
> 4

$ egrep -nr "=[[:space:]]*{[[:space:]]*0[[:space:]]*};" kernel  | wc -l
8

MfG,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
     There is NO CLOUD, just other people's computers. - FSFE
                     LUGA : http://www.luga.at
