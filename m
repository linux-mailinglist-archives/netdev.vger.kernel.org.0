Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556EB2A9F20
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgKFVga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:36:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgKFVga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:36:30 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5883F2087E;
        Fri,  6 Nov 2020 21:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604698589;
        bh=D3FjfZi6m2jT3x7CBU5ckCdq0M6lu/VG+o3b2LMZzdA=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=lF2EnK4hcaF/4pCPVyCzkongDZh/GQILqHx8iiLSS+fDNxG6lg44oaYIOYJMn2cEa
         E6c3YT27ZuVPsreB+geYf/t7so9ro4hH/65KsaAsOn+NMtYTqX7bPhRaGtSvf8yYhl
         jRCuD/3QKBq1Jydh2UvogAU8hutXrV+UF4KNhepk=
Message-ID: <56adebac425535ca884f55f7ace6a93019921382.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 0/8] ionic updates
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Fri, 06 Nov 2020 13:36:28 -0800
In-Reply-To: <20201106001220.68130-1-snelson@pensando.io>
References: <20201106001220.68130-1-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 16:12 -0800, Shannon Nelson wrote:
> These updates are a bit of code cleaning and a minor
> bit of performance tweaking.
> 
> v2: added void cast on call to ionic_lif_quiesce()
>     lowered batching threshold
>     added patch to flatten calls to ionic_lif_rx_mode
>     added patch to change from_ndo to can_sleep
> 
> Shannon Nelson (8):
>   ionic: start queues before announcing link up
>   ionic: check for link after netdev registration
>   ionic: add lif quiesce
>   ionic: batch rx buffer refilling
>   ionic: use mc sync for multicast filters
>   ionic: flatten calls to ionic_lif_rx_mode
>   ionic: change set_rx_mode from_ndo to can_sleep
>   ionic: useful names for booleans

Other than the minor comments on patches #3 and #6, please feel free to
add:

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com> 


