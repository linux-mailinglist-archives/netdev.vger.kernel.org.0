Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA513BC6DF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 08:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhGFGtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 02:49:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48532 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhGFGtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 02:49:41 -0400
Received: from [222.129.38.159] (helo=[192.168.1.18])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <aaron.ma@canonical.com>)
        id 1m0erG-0006la-0q; Tue, 06 Jul 2021 06:47:02 +0000
Subject: Re: [Intel-wired-lan] [PATCH 2/2] igc: wait for the MAC copy when
 enabled MAC passthrough
To:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Edri, Michael" <michael.edri@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Shalev, Avi" <avi.shalev@intel.com>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210702045120.22855-2-aaron.ma@canonical.com>
 <613e2106-940a-49ed-6621-0bb00bc7dca5@intel.com>
 <ad3d2d01-1d0a-8887-b057-e6a9531a05f4@canonical.com>
 <f9f9408e-9ba3-7ed9-acc2-1c71913b04f0@intel.com>
From:   Aaron Ma <aaron.ma@canonical.com>
Message-ID: <96106dfe-9844-1d9d-d865-619d78a0d150@canonical.com>
Date:   Tue, 6 Jul 2021 14:46:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f9f9408e-9ba3-7ed9-acc2-1c71913b04f0@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/5/21 7:54 PM, Neftin, Sasha wrote:
> Hello Aaron, Thanks to point me on this document. I see... This is recommendation for Windows driver. Anyway, "delay" approach is error-prone. We need rather ask for MNG FW confirmation (message) that MAC address is copied.
> Can we call (in case we know that MNG FW copied MAC address):
> igc_rar_set (method from igc_mac.c), update the mac.addr and then perform": memcpy(netdev->dev_addr, hw->mac.addr, netdev->addr_len);?

Without delay, after igc_rar_set, the MAC address is all 0.
The MAC addr is the from dock instead of MAC passthrough with the original driver.

Thanks,
Aaron
