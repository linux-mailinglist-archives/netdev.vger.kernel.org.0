Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D351623EE5C
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 15:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHGNj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 09:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgHGNjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 09:39:19 -0400
Received: from [10.20.23.223] (unknown [12.97.180.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C614520866;
        Fri,  7 Aug 2020 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596807559;
        bh=djVAZ8bgNnDd5s20tDbtmbbCi6mAMF/eFolBBmMjS/4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=M2t8KqC8r0URtDNpW9FSWMTYh/AqHEhN8JK9uqdfkyd61X7sFgA6WeVL9bX34Bf77
         l80ZFYD73auUDGxQSXdi5NS03vbp3/IVW2FGapuluwwl45VS2XFJGRnUE9PdzTZKL6
         2HjUIkDnNrxmao+96kag6Vd8PXuTAVDCR25wvCmM=
Subject: Re: [PATCH net] net: qcom/emac: Fix missing clk_disable_unprepare()
 in error path of emac_probe
To:     "wanghai (M)" <wanghai38@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200806140647.43099-1-wanghai38@huawei.com>
 <87f41175-689e-f198-aaf6-9b9f04449ed8@kernel.org>
 <df1bad2e-2a6a-ff70-9b91-f18df20aaec8@huawei.com>
From:   Timur Tabi <timur@kernel.org>
Message-ID: <9ec9b9ab-48d9-9d38-8f58-27e2556c141a@kernel.org>
Date:   Fri, 7 Aug 2020 08:38:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <df1bad2e-2a6a-ff70-9b91-f18df20aaec8@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/20 8:54 PM, wanghai (M) wrote:
> Thanks for your suggestion. May I fix it like this?
> 
Yes, this is what I had in mind.  Thanks.

Acked-by: Timur Tabi <timur@kernel.org>
