Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863881BA4D0
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD0NfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:35:01 -0400
Received: from mleia.com ([178.79.152.223]:47768 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgD0NfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:35:01 -0400
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2020 09:35:00 EDT
Received: from mail.mleia.com (localhost [127.0.0.1])
        by mail.mleia.com (Postfix) with ESMTP id E6E983DC9E9;
        Mon, 27 Apr 2020 13:24:41 +0000 (UTC)
Subject: Re: [PATCH net-next] net: lpc-enet: fix error return code in
 lpc_mii_init()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "stigge @ antcom . de" <stigge@antcom.de>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, kernel-janitors@vger.kernel.org
References: <20200427121507.23249-1-weiyongjun1@huawei.com>
From:   Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <936fc5fb-25a1-8974-71e2-80c2c4bdd0f4@mleia.com>
Date:   Mon, 27 Apr 2020 16:24:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200427121507.23249-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20200427_132441_970355_2770457E 
X-CRM114-Status: UNSURE (   7.89  )
X-CRM114-Notice: Please train this message. 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 3:15 PM, Wei Yongjun wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
Best wishes,
Vladimir
