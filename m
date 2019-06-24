Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013FE51C3D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbfFXUZB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Jun 2019 16:25:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFXUZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:25:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 378BE126B52D0;
        Mon, 24 Jun 2019 13:24:59 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:24:56 -0700 (PDT)
Message-Id: <20190624.132456.2013417744691373807.davem@davemloft.net>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com,
        wens@csie.org, robh+dt@kernel.org, jernej.skrabec@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, mark.rutland@arm.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v7 0/6] Add support for Orange Pi 3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190624174637.6sznc5ifiuh4c3sm@core.my.home>
References: <20190620134748.17866-1-megous@megous.com>
        <20190624.102927.1268781741493594465.davem@davemloft.net>
        <20190624174637.6sznc5ifiuh4c3sm@core.my.home>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Jun 2019 13:24:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondøej Jirman <megous@megous.com>
Date: Mon, 24 Jun 2019 19:46:37 +0200

> This series was even longer before, with patches all around for various
> maintainers. I'd expect that relevant maintainers pick the range of patches
> meant for them. I don't know who's exactly responsible for what, but I think,
> this should work:
> 
> - 2 stmmac patches should go together via some networking tree (is there
>   something specific for stmmac?)
> - all DTS patches should go via sunxi
> - hdmi patches via some drm tree

Thank you.  So I'll merge the first two patches that touch the stmmac
driver via my net-next tree.
