Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D042CFFA9
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgLEXMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgLEXMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:12:01 -0500
Date:   Sat, 5 Dec 2020 15:11:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607209881;
        bh=Ywby+8XMzP0Av2thUOEP6ZXttQZb//VuVq4y2k1chKg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=fYnalPWsf3DujLmB/JviIIvLqekXPIYxkUiQ0v2V4mgkWPxPe7uGTjHwJ1xUBD5k7
         u15QImMLiY7zKujwzQIxWWz0rJYiRba3b6D7wuUJndRMjdRIBL/ANwDxsGFC5OQiOw
         vI9wwHXeb3sgl0+Mkqh+Y7YkS1Bukb0OfahyskHAb0AqrmvWy2XTTKfD0rTdLVKJic
         36d2AcqOlovGcJ41cnPNl5ISbPjavh/IobDlY0MEUdHC9SdT/3tIB/xwBIaq4cadys
         BlfA6zPoTZzQeSszzgKYG1DFRb6yEIgVLs1VzrTGZkk3VMJLi5rc3Vw9ZcWix5Auap
         VpVky8d/r4TFw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/8] pull request for net-next: batman-adv 2020-12-04
Message-ID: <20201205151120.7e51413f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204154631.21063-1-sw@simonwunderlich.de>
References: <20201204154631.21063-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 16:46:23 +0100 Simon Wunderlich wrote:
> This cleanup patchset includes the following patches:
> 
>  - bump version strings, by Simon Wunderlich
> 
>  - update include for min/max helpers, by Sven Eckelmann
> 
>  - add infrastructure and netlink functions for routing algo selection,
>    by Sven Eckelmann (2 patches)
> 
>  - drop deprecated debugfs and sysfs support and obsoleted
>    functionality, by Sven Eckelmann (3 patches)
> 
>  - drop unused include in fragmentation.c, by Simon Wunderlich

Pulled, thanks!
