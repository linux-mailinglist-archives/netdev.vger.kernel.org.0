Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B02C24EFB4
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 22:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHWUkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 16:40:12 -0400
Received: from matrix.voodoobox.net ([172.105.149.185]:51106 "EHLO
        voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgHWUkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 16:40:11 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2020 16:40:10 EDT
Received: from [192.168.0.125] (c-67-180-109-87.hsd1.ca.comcast.net [67.180.109.87])
        (authenticated bits=0)
        by voodoobox.net (8.14.4/8.14.4) with ESMTP id 07NKV1pd024784
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 23 Aug 2020 16:31:03 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 voodoobox.net 07NKV1pd024784
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thedillows.org;
        s=default; t=1598214664;
        bh=wmUG6o89gBX1TLqYAralUXM07OLbYdPOGB6qiq1e56I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UGnj71wKv/4O9nTL74ZuOnrANwEOcPk5lYcY/GlQh/Jh/WlDN1vMV1bMpCh/bsVTF
         JUnGhJWAAffgfC+MPk7oxpuDoYSlX2TbmayMqFVkrd0phHRaDZlUy7D2Q/FdaxT9KT
         joq8gpOUqpOiDQCa38KuUry0FnE2Cy3fPLWsaLPzvJMvXI17VczjF8Osp/us6RjCFd
         cpAN65ueBzNgFDkd7enVSkBxdM0dMVde3f9EhlijreEZYXDmrITMpaspUUyiDmL2wO
         Babcq7GJkJ9aftL6pUCytvI3CBrtBc0KF1MkHp7tSm7W2UF2P/mnJZEZ1VgFSRxUVJ
         LYLfWYm8XZD9Q==
Message-ID: <5659ca27570189d51d99d69e4bb91b7b996a7084.camel@thedillows.org>
Subject: Re: [PATCH] typhoon: switch from 'pci_' to 'dma_' API
From:   David Dillow <dave@thedillows.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Sun, 23 Aug 2020 13:31:01 -0700
In-Reply-To: <20200823061150.162135-1-christophe.jaillet@wanadoo.fr>
References: <20200823061150.162135-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-08-23 at 08:11 +0200, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has
> been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.

Looks good, thanks!

Reviewed-by: David Dillow <dave@thedillows.org>

