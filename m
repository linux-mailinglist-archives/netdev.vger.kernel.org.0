Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D2A1232DF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfLQQqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:46:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727947AbfLQQqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:46:39 -0500
Received: from localhost (lfbn-tou-1-1502-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C581924655;
        Tue, 17 Dec 2019 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576601199;
        bh=dtdHww0rQgXjndhYivazqMjYBkTgiymWRHanmNJmHDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i1Sf0cFRdfMGLk1h3va55thwoCVMSSepJ1VffDuYuF3UGsvI/X4MLb5ga81p5okm/
         RcNO4KMYaRYu29YGS1/NsGrhz+pQr8WP8ewQIOtWkdUWt+maU1H9TOkumYi9Yisp0I
         wvWWTThcO29+zhXTiS6j6ZB9V8L4SLcjDUo9dk68=
Date:   Tue, 17 Dec 2019 17:46:36 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: Add missing 'properties' keyword enclosing
 'snps,tso'
Message-ID: <20191217164636.663okrgubucuvmcv@gilmour.lan>
References: <20191217163946.25052-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217163946.25052-1-robh@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:39:46AM -0600, Rob Herring wrote:
> DT property definitions must be under a 'properties' keyword. This was
> missing for 'snps,tso' in an if/then clause. A meta-schema fix will
> catch future errors like this.
>
> Fixes: 7db3545aef5f ("dt-bindings: net: stmmac: Convert the binding to a schemas")
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime
