Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07845D02E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346469AbhKXWpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 17:45:08 -0500
Received: from hua.moonlit-rail.com ([45.79.167.250]:35212 "EHLO
        hua.moonlit-rail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346602AbhKXWpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 17:45:07 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2021 17:45:07 EST
Received: from 209-6-248-230.s2276.c3-0.wrx-ubr1.sbo-wrx.ma.cable.rcncustomer.com ([209.6.248.230] helo=boston.moonlit-rail.com)
        by hua.moonlit-rail.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <bugs-a21@moonlit-rail.com>)
        id 1mq0o9-0001r7-1c
        for netdev@vger.kernel.org;
        Wed, 24 Nov 2021 17:32:05 -0500
Received: from springdale.mc.moonlit-rail.com ([192.168.71.36])
        by boston.moonlit-rail.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <bugs-a21@moonlit-rail.com>)
        id 1mq0o8-0000dP-6a;
        Wed, 24 Nov 2021 17:32:04 -0500
Message-ID: <480a6f82-99c4-ad46-3878-6bb442d81496@moonlit-rail.com>
Date:   Wed, 24 Nov 2021 17:32:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net v2] igb: fix netpoll exit with traffic
Content-Language: en-US
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Danielle Ratson <danieller@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
From:   "Kris Karas (Bug reporting)" <bugs-a21@moonlit-rail.com>
In-Reply-To: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesse Brandeburg wrote:
> Oleksandr brought a bug report where netpoll causes trace
> messages in the log on igb.
> ---
> -	return min(work_done, budget - 1);
> +	return work_done;

I am able to reproduce the WARNING + stack trace at will.  It occurs on 
every boot.
Please see https://bugzilla.kernel.org/show_bug.cgi?id=212573 for details.

I have tested the simple patch (v2) against both kernels 5.14 and 5.15, 
and am happy to report that this fixes the issue for me.

Kris

