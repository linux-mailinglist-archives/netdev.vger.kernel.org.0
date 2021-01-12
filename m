Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9752F4024
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731822AbhALXQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 18:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbhALXQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:16:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0DD823123;
        Tue, 12 Jan 2021 23:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610493372;
        bh=FmBwcgX4nGV3TRqHyfBaYi3z5rHJ9QE0r4J31C6lwPw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D0UaCFy6Cp0B9wJIytQgXvtJrgBgHrzqNIOV9OzRE5hdzVMY6cnzAPxu+odDgxfov
         OC1wyAm7vQQHBDahkPgwTZgoBVJcbsoTMNzbigLXrGmqwRPwZdsirNiDt4WX2fPWYM
         nZr6sgxdHyTAOJOMMzQOdzWLUnlKr0Wf0E/W7u9xokCUb5e0enlT6oK2rVkrVGxTjq
         ge5aTIz4keb1DsyoTzT96BDD5caJdVGV7l3gRZR3FZNVJOJUY+cy5FO098rpFCGxlS
         +k517Ls1MT/F2z9/RcehPK/BK4ma6oU3HscJT+LNHOnNYsREIiCl7MCTyTctf0NZSR
         qV/oPYb3dXwvg==
Message-ID: <5f140376c36bbe47edeb8784ada3b74fafe05afe.camel@kernel.org>
Subject: Re: [PATCv4 net-next] octeontx2-pf: Add RSS multi group support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org
Date:   Tue, 12 Jan 2021 15:16:10 -0800
In-Reply-To: <20210104072039.27297-1-gakula@marvell.com>
References: <20210104072039.27297-1-gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-04 at 12:50 +0530, Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS
> groups/contexts
> and use the same as destination for flow steering rules.
> 
> usage:
> To steer the traffic to RQ 2,3
> 
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
> 
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
> 
> To delete the context
> ethtool -X eth0 context 1 delete
> 
> When an RSS context is removed, the active classification
> rules using this context are also removed.
> 
> Change-log:
> 
> v4
> - Fixed compiletime warning.
> - Address Saeed's comments on v3.
> 

This patch is marked as accepted in patchwork
https://patchwork.kernel.org/project/netdevbpf/patch/20210104072039.27297-1-gakula@marvell.com/

but it is not actually applied, maybe resend..


you can add:
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


