Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2956516860C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgBUSE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:04:27 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:65499 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgBUSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:04:27 -0500
X-Originating-IP: 92.184.108.100
Received: from localhost (unknown [92.184.108.100])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id BA3EA40004;
        Fri, 21 Feb 2020 18:04:24 +0000 (UTC)
Date:   Fri, 21 Feb 2020 19:04:23 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [RFC 10/18] net: macsec: enable HW offloading by default (when
 available)
Message-ID: <20200221180423.GE3530@kwain>
References: <20200214150258.390-1-irusskikh@marvell.com>
 <20200214150258.390-11-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200214150258.390-11-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Feb 14, 2020 at 06:02:50PM +0300, Igor Russkikh wrote:
> From: Mark Starovoytov <mstarovoitov@marvell.com>
> 
> This patch makes HW offload to be enabled by default (when available).
> This patch along with the next one (reporting real_dev features) are
> both required to fix the issue described below.
> 
> Issue description:
> real_dev features are disabled upon macsec creation.
> 
> Root cause:
> Features limitation (specific to SW MACSec limitation) is being applied
> to HW offloaded case as well.
> This causes 'set_features' request on the real_dev with reduced feature
> set due to chain propagation.
> IF SW MACSec limitations are not applied to HW offloading case (see the
> next path), then we still face an issue, because SW MACSec is enabled by
> default.
> 
> Proposed solution:
> Enable HW offloading by default (when available).

I would say enabling offloading by default is a no-go, and was discussed
when MACsec offloading was initially proposed. But as you said in the
cover letter, a good way to do this would be to allow setting the
offloading mode when the MACsec interface is created (-> an option in
iproute2).

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
