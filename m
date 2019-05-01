Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A1410A02
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfEAPZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:25:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEAPZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:25:47 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 424821473A490;
        Wed,  1 May 2019 08:25:45 -0700 (PDT)
Date:   Wed, 01 May 2019 11:24:28 -0400 (EDT)
Message-Id: <20190501.112428.331673135522488793.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH net-next] sfc: mcdi_port: Mark expected switch
 fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429153755.GA10596@embeddedor>
References: <20190429153755.GA10596@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:25:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Mon, 29 Apr 2019 10:37:55 -0500

> In preparation to enabling -Wimplicit-fallthrough, mark switch
> cases where we are expecting to fall through.
> 
> This patch fixes the following warning:
 ...
> Warning level 3 was used: -Wimplicit-fallthrough=3
> 
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
