Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC5134DD3
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgAHUoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:44:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47648 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAHUoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:44:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF15B1584BD2F;
        Wed,  8 Jan 2020 12:44:37 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:44:37 -0800 (PST)
Message-Id: <20200108.124437.1060627270805429228.davem@davemloft.net>
To:     niklas.cassel@wdc.com
Cc:     vkoul@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] MAINTAINERS: Remove myself as co-maintainer
 for qcom-ethqos
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106163130.258694-1-niklas.cassel@wdc.com>
References: <20200106163130.258694-1-niklas.cassel@wdc.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:44:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>
Date: Mon,  6 Jan 2020 17:31:30 +0100

> As I am no longer with Linaro, I no longer have access to documentation
> for this IP. The Linaro email will start bouncing soon.
> 
> Vinod is fully capable to maintain this driver by himself, therefore
> remove myself as co-maintainer for qcom-ethqos.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

As this is a doc fix, I've applied it to 'net', thank you.
