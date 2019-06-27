Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F47589B3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfF0SRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:17:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF0SRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:17:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC434133EB066;
        Thu, 27 Jun 2019 11:17:40 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:17:40 -0700 (PDT)
Message-Id: <20190627.111740.996764157890306139.davem@davemloft.net>
To:     chunkeey@gmail.com
Cc:     netdev@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH v1 1/2] dt-bindings: net: dsa: qca8k: document
 reset-gpios property
From:   David Miller <davem@davemloft.net>
In-Reply-To: <08e0fd513620f03a2207b9f32637cdb434ed8def.1561452044.git.chunkeey@gmail.com>
References: <08e0fd513620f03a2207b9f32637cdb434ed8def.1561452044.git.chunkeey@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:17:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>
Date: Tue, 25 Jun 2019 10:41:50 +0200

> This patch documents the qca8k's reset-gpios property that
> can be used if the QCA8337N ends up in a bad state during
> reset.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Applied.
