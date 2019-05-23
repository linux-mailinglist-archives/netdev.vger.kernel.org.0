Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76202737F
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 02:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbfEWAoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 20:44:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbfEWAoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 20:44:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA7BD14577841;
        Wed, 22 May 2019 17:44:02 -0700 (PDT)
Date:   Wed, 22 May 2019 17:44:02 -0700 (PDT)
Message-Id: <20190522.174402.536799926980375439.davem@davemloft.net>
To:     tpiepho@impinj.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com
Subject: Re: [PATCH net-next v2 2/8] dt-bindings: phy: dp83867: Add
 documentation for disabling clock output
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190522184255.16323-2-tpiepho@impinj.com>
References: <20190522184255.16323-1-tpiepho@impinj.com>
        <20190522184255.16323-2-tpiepho@impinj.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 17:44:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trent Piepho <tpiepho@impinj.com>
Date: Wed, 22 May 2019 18:43:21 +0000

> The clock output is generally only used for testing and development and
> not used to daisy-chain PHYs.  It's just a source of RF noise afterward.
> 
> Add a mux value for "off".  I've added it as another enumeration to the
> output property.  In the actual PHY, the mux and the output enable are
> independently controllable.  However, it doesn't seem useful to be able
> to describe the mux setting when the output is disabled.
> 
> Document that PHY's default setting will be left as is if the property
> is omitted.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Applied.
