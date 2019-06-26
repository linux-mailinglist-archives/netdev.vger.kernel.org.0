Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDD65726A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZURb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 16:17:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfFZURb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 16:17:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E4BF14DB8391;
        Wed, 26 Jun 2019 13:17:31 -0700 (PDT)
Date:   Wed, 26 Jun 2019 13:17:30 -0700 (PDT)
Message-Id: <20190626.131730.543273202348780763.davem@davemloft.net>
To:     Igor.Russkikh@aquantia.com
Cc:     netdev@vger.kernel.org, Dmitry.Bogdanov@aquantia.com
Subject: Re: [PATCH net] net: aquantia: fix vlans not working over bridged
 network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f9ccf4959d8efed1ee8832c56c59f5adfe2f9fd7.1561028841.git.igor.russkikh@aquantia.com>
References: <f9ccf4959d8efed1ee8832c56c59f5adfe2f9fd7.1561028841.git.igor.russkikh@aquantia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 13:17:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>
Date: Sat, 22 Jun 2019 08:46:37 +0000

> From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
> 
> In configuration of vlan over bridge over aquantia device
> it was found that vlan tagged traffic is dropped on chip.
> 
> The reason is that bridge device enables promisc mode,
> but in atlantic chip vlan filters will still apply.
> So we have to corellate promisc settings with vlan configuration.
> 
> The solution is to track in a separate state variable the
> need of vlan forced promisc. And also consider generic
> promisc configuration when doing vlan filter config.
> 
> Fixes: 7975d2aff5af ("net: aquantia: add support of rx-vlan-filter offload")
> Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Applied and queued up for -stable, thanks.
