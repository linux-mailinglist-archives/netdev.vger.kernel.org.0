Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E819B2261B9
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGTOP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:15:57 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:47054 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgGTOP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:15:56 -0400
Received: from localhost.localdomain (p200300e9d7371614ec13d59c95910a08.dip0.t-ipconnect.de [IPv6:2003:e9:d737:1614:ec13:d59c:9591:a08])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id D8E46C0D06;
        Mon, 20 Jul 2020 16:15:54 +0200 (CEST)
Subject: Re: [PATCH v2 net] ieee802154: fix one possible memleak in
 adf7242_probe
To:     Liu Jian <liujian56@huawei.com>, michael.hennerich@analog.com,
        alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kjlu@umn.edu, netdev@vger.kernel.org
References: <20200720143001.40194-1-liujian56@huawei.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <3a35ee9a-d10d-96b7-2804-025b00e5bd0d@datenfreihafen.org>
Date:   Mon, 20 Jul 2020 16:15:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200720143001.40194-1-liujian56@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 20.07.20 16:30, Liu Jian wrote:
> When probe fail, we should destroy the workqueue.
> 
> Fixes: 2795e8c25161 ("net: ieee802154: fix a potential NULL pointer dereference")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2:
> Change targeting from "net-next" to "net"


Before sending a second version make sure you check replies to your 
patch postings. I already applied the v1 patch to my wpan tree which 
goes into net.

As v2 it is identical v1 therei s nothing to do here for me.

regards
Stefan Schmidt
