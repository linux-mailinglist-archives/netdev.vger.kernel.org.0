Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DCA1B0E25
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgDTOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727890AbgDTOT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:19:28 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37079C061A0C;
        Mon, 20 Apr 2020 07:19:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p8so5115915pgi.5;
        Mon, 20 Apr 2020 07:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Oc/KRBHqlQprPdvnTLqMbhtCWWPMn2exeuWGDF3KzlU=;
        b=GXCiErdkfQ0qX4801Rs3N1pO7ZWEOtFWeC2KR3dhAQ+zZqYLBxi7cui6milccfS40R
         AkP+CJov+oaKX410WOIjQbYlKxb4dyggkzLd4SZNFKH7AQjCku0RtY8LRzNk3i78zbtW
         O9bVKbSlRdbkcU2rWKTdsmpUxSHXNX7b48Bq30OwkipttV348+E6ccY7fGfG5KKd4lfh
         2UfdB5OnmKUiJKrrXJHDFJmPYu6Zv5F71aUx2ZW2b2uBE06D90MWTpflSpqeaKPEtcrc
         e00R8VuSSdH+Zj7TsvCDi9qdI3zqCGVRBZ+ZASZ2fN0t2hOgy1hkGWn7glWsXEQyuwIZ
         k1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Oc/KRBHqlQprPdvnTLqMbhtCWWPMn2exeuWGDF3KzlU=;
        b=OwG2fP3rFKkciYTgMKRUQ4xHzDfvTsNXjE1L1Rn2DzZDjIptcNDJZ9ubXCOI99bWY8
         bC9x8rYI+OXWABMDVs0kjzd/3AaXMG8eWpih/Xh719p0U90AlCz9b2DCgkKEBEONWS4+
         Kv1bIWgfgrqkbYbsZGnzW/3moIzL6vzR0sxhnoVPB17c2VR6xnQ6wbhveddcdGuU+Aa4
         7hbIqti0WKE8fq4dqwgGi91GVqJjVQEEb6wCTnzkJvRPDE6vlxsnTsJuXZvrRNCxZ80L
         63UcUntB+NAwhYYFOLHdA8caHE3icZFy1RziQ6gxEjM19GttDb/gyEdUb7xK4Shs3nqC
         FpMw==
X-Gm-Message-State: AGi0PuZx9g466XuXuX59/19VBxs89BJ7OR2at+Hrs1qbMaATBHRaP1pO
        Bz06r7e+KD/tJ8bOVAwGKSM=
X-Google-Smtp-Source: APiQypK6bUWGZim1c3a5w2WnE1rOtTBk0cPjSKazzS7J7xM68FgM0NahUfiaGmZyG1LzBarwt4odhQ==
X-Received: by 2002:a63:1961:: with SMTP id 33mr17394449pgz.282.1587392367820;
        Mon, 20 Apr 2020 07:19:27 -0700 (PDT)
Received: from localhost ([89.208.244.140])
        by smtp.gmail.com with ESMTPSA id t188sm1281766pgb.80.2020.04.20.07.19.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 07:19:26 -0700 (PDT)
Date:   Mon, 20 Apr 2020 22:19:21 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [net-next v2] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
Message-ID: <20200420141921.GA10880@nuc8i5>
References: <20200420132207.8536-1-zhengdejin5@gmail.com>
 <940fcaa1-8500-e534-2380-39419f1ac5a0@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <940fcaa1-8500-e534-2380-39419f1ac5a0@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 04:00:54PM +0200, Markus Elfring wrote:
> > v1 -> v2:
> > 	- modify the commit comments by Markus's suggestion.
> 
> Thanks for another wording fine-tuning.
> 
> Would you like to extend your adjustment interests to similar update candidates?
> 
> Example:
> bgmac_probe()
> https://elixir.bootlin.com/linux/v5.7-rc2/source/drivers/net/ethernet/broadcom/bgmac-platform.c#L201
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom/bgmac-platform.c?id=ae83d0b416db002fe95601e7f97f64b59514d936#n201
>
Markus, Thanks very much for your info, I will do it. Thanks again.

BR,
Dejin

> Regards,
> Markus
