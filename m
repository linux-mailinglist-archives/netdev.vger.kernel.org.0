Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97EE24A4E7
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHSR3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:29:07 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:42232 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHSR3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597858146; x=1629394146;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=7DUVfDRV1PDgvamuZOBXMNd+SzRR+jhZA2pfWfP/4XY=;
  b=GswjjGhv2R6+GVoc8kHh0Jq3BURmZ0mAnVODH8Xw11yoqP7FJbeu/Fgd
   5HT/exeNnbVeRCWlqOZmnqMldfYc/2TiycS2ULing95/r60HuaxdqXY7m
   CeG4xGtO71bfBaqmDOZ19lICjh9Wc58T5CYHPkobsW352vsiyzpPqBmK4
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="61064297"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 19 Aug 2020 17:29:00 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id C08AEA215E;
        Wed, 19 Aug 2020 17:28:59 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:28:58 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.40) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:28:50 +0000
References: <20200819090443.24917-1-shayagr@amazon.com> <20200819090443.24917-2-shayagr@amazon.com> <20200819084617.67cc69a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 1/3] net: ena: Prevent reset after device destruction
In-Reply-To: <20200819084617.67cc69a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 19 Aug 2020 20:27:49 +0300
Message-ID: <pj41zlft8ibl62.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.40]
X-ClientProxiedBy: EX13D02UWC004.ant.amazon.com (10.43.162.236) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 19 Aug 2020 12:04:41 +0300 Shay Agroskin wrote:
>> Fixes: 84a629e ("[New feature] ena_netdev: Add hibernation 
>> support")
>
> Fixes tag: Fixes: 84a629e ("[New feature] ena_netdev: Add 
> hibernation support")
> Has these problem(s):
> 	- Target SHA1 does not exist
>
>
> Also hash needs to be 12 characters.

Yup, sorry for that. Should have been more careful with it.

I'll fix it in next patchset. Thanks
