Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81EA49CFAD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243129AbiAZQ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbiAZQ1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:27:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02106C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ohvPSkDs/aifj8rWlJUUjhYBVZs6sT28gR/eoqY+U44=; b=sEiMzLoqgSMcz4tb346Pn/3ct/
        g1XVJrH7LuD2/m12ckP1+sSkbfDWFQTmv76nMf7zhjZqUQStoCTVgFF1g4g/gL6HpxzzqsNOz64Kl
        rxO9tThvXeKZB9Q30R2eFk9apSqmoaOWwNaQkDw5ONXucnV6K02wW7DhM8zjl3dPftyPV1na9x+xE
        fwsmkpJX7BpFHXzHKy8tivdv2x2yeh2VZ6RktyoF63aHS35p2fmxpyt5C4bszp2w3MzMdHhXv9IxF
        ERb9B1JOmMlf7ZkjL1pYfhm+bhHpQllhJVKoHshBx6f6s3tCCMMhzwF7hTERQE1tR5Fso+r6eMLHQ
        aSZXgMPg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nCl95-004DNB-AK; Wed, 26 Jan 2022 16:27:44 +0000
Message-ID: <9e4593ab-1ccc-85e2-811e-3bf6d7c47941@infradead.org>
Date:   Wed, 26 Jan 2022 08:27:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] nfp: only use kdoc style comments for kdoc
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
References: <20220126090803.5582-1-simon.horman@corigine.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220126090803.5582-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/22 01:08, Simon Horman wrote:
> Update comments to only use kdoc style comments, starting with '/**',
> for kdoc.
> 
> Flagged by ./scripts/kernel-doc
> 
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

> ---
>  .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 81 ++++++-------------
>  .../ethernet/netronome/nfp/nfp_net_sriov.h    |  3 +-
>  drivers/net/ethernet/netronome/nfp/nfp_port.h |  3 +-
>  3 files changed, 28 insertions(+), 59 deletions(-)


-- 
~Randy
