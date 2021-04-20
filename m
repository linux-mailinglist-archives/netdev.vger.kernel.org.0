Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F06365F25
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhDTSY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhDTSY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 14:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D259861026;
        Tue, 20 Apr 2021 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618943066;
        bh=6jOAJ6sQHEf6mb58YZlL5s6+MpgvgNoGPkzPxY38S/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C2gfwXe+a/hKMySNenB6V27OQcAHnh8USmumTZACVVBvGblkpU0oS2jmZPZ/IeNUL
         g4ra75dGWY/Z9804zN1rwZXLIE5GM4amjaEiZps4GbZDUb/IOD9UyiKsPPyzdVuX71
         1manuJvauwlpMVTFCL1bkJwKNd2JTpFMv9xp3L0Fc5SSnd2sJr7kDmO98akvAKA14x
         lVzd94knwEX7hkDP/cWNTiwLvvnsYJYg8BIdYTdjbFJFjlTJ/1KP5Dnw4GHdG6gLJ4
         CaAV1yqn06rC0dldDj8tZls1Cyk7hMTRl6JGh9T99bCXes0+ZzqOHMDk78v4j7+zGu
         pVstl3YW9Jn+g==
Date:   Tue, 20 Apr 2021 11:24:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, saeedm@nvidia.com, leon@kernel.org,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com
Subject: Re: [PATCH net-next v2 5/6] sfc: ef10: implement
 ethtool::get_fec_stats
Message-ID: <20210420112424.364d9235@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bb02f3b8-8949-a2f0-3a56-5d17537f8bb6@gmail.com>
References: <20210415225318.2726095-1-kuba@kernel.org>
        <20210415225318.2726095-6-kuba@kernel.org>
        <bb02f3b8-8949-a2f0-3a56-5d17537f8bb6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 16:13:21 +0100 Edward Cree wrote:
> On 15/04/2021 23:53, Jakub Kicinski wrote:
> > Report what appears to be the standard block counts:
> >  - 30.5.1.1.17 aFECCorrectedBlocks
> >  - 30.5.1.1.18 aFECUncorrectableBlocks
> > 
> > Don't report the per-lane symbol counts, if those really
> > count symbols they are not what the standard calls for
> > (even if symbols seem like the most useful thing to count.)
> > 
> > Fingers crossed that fec_corrected_errors is not in symbols.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> For the record: yes, fec_[un]corrected_errors are counts of
>  FEC codewords, not symbols, so this patch is correct.
> 
> Whereas, the per-lane counts definitely are counting symbols.

Thanks for reviewing!
