Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8372F804E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbhAOQKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbhAOQKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:10:10 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1F0C0613C1;
        Fri, 15 Jan 2021 08:09:15 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DHR2J0pZ0z1rspt;
        Fri, 15 Jan 2021 17:09:08 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DHR2D14rrz1tYWR;
        Fri, 15 Jan 2021 17:09:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 7kEKBGdiBY6k; Fri, 15 Jan 2021 17:09:06 +0100 (CET)
X-Auth-Info: Vj8+/1od6rEBBzbfIm+0iNjQRk/UCqGp2M1lVqlesjY=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 15 Jan 2021 17:09:06 +0100 (CET)
Subject: Re: [PATCH] net: ks8851: remove definition of DEBUG
To:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, zhengyongjun3@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210115153128.131026-1-trix@redhat.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e7844d89-b0af-53ce-c923-a1d91b4ec0cc@denx.de>
Date:   Fri, 15 Jan 2021 17:09:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115153128.131026-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 4:31 PM, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Defining DEBUG should only be done in development.
> So remove DEBUG.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Marek Vasut <marex@denx.de>

Thanks
