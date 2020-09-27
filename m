Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DAC27A414
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgI0UcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgI0UcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:32:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938D1C0613CE;
        Sun, 27 Sep 2020 13:32:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D1B013BB09D4;
        Sun, 27 Sep 2020 13:15:32 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:32:18 -0700 (PDT)
Message-Id: <20200927.133218.1538000520701421658.davem@davemloft.net>
To:     prabhakar.mahadev-lad.rj@bp.renesas.com
Cc:     kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        sergei.shtylyov@gmail.com, linux-kernel@vger.kernel.org,
        prabhakar.csengg@gmail.com,
        marian-cristian.rotariu.rb@bp.renesas.com
Subject: Re: [RESEND PATCH] dt-bindings: net: renesas,ravb: Add support for
 r8a774e1 SoC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927123439.29300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20200927123439.29300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:15:32 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Date: Sun, 27 Sep 2020 13:34:39 +0100

> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> 
> Document RZ/G2H (R8A774E1) SoC bindings.
> 
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Rob Herring <robh@kernel.org>

Applied.
