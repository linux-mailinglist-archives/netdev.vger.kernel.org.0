Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6033BC6BD
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGFGow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:44:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48373 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhGFGot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:44:49 -0400
Received: from [222.129.38.159] (helo=[192.168.1.18])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1m0emX-0006MK-IK; Tue, 06 Jul 2021 06:42:09 +0000
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
To:     Dave Airlie <airlied@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <CAPM=9twzx0aa5Dq-L5oOSk+w8z7audCq_biXwtFVh3QVY1VceA@mail.gmail.com>
From:   Aaron Ma <aaron.ma@canonical.com>
Message-ID: <53691935-daee-9acc-93d2-414fb11ce2bc@canonical.com>
Date:   Tue, 6 Jul 2021 14:42:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPM=9twzx0aa5Dq-L5oOSk+w8z7audCq_biXwtFVh3QVY1VceA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/21 3:47 PM, Dave Airlie wrote:
> Drive-by, but won't this add a lot of overhead on every register
> access? has this been benchmarked with lots of small network transfers
> or anything?
> 

iperf3 is tested, the result is the same as before.
Due to the registers are rd/wr even after error_handler and remove.
Didn't find better fix.
Please let me know if you have any idea.

Thanks,
Aaron

> Dave.
