Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC917423B34
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbhJFKGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:06:50 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51247 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229874AbhJFKGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:06:49 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D9F205C0598;
        Wed,  6 Oct 2021 06:04:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 06 Oct 2021 06:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DHdY0P
        8t+NxfmohgFjnCgxIWqZvj1Cdhe7owPofDXRA=; b=eZa3tSBFRb2wcoQmhi0gnR
        Ig28yEHInV5ap6/ZlCUXfSKhtunJqTw8I0LsIuu034hfo69wdlV3N9csG4H4Sy6g
        1g/h+jrlSYA9Z8b4WKcX0Uq5Juy+a4wRHSb1aA1gWZ5z9RZp7O97rsb92R8ZPfWp
        GxPasoIF6MOVrCISRiAqZ0OFqREFhYEgiqvfI5zw+s35QMxh+iarQQuEqlXhtHAC
        4fDVVvcX5YFAQQuGI+jZ0f0FrYOGjDTvKMb4YTS1/BxkTkuirelX9xXG3pw3PNZy
        3PDNssKwXz5nm1UWs9YaDNCqifqjZqlIgrIhJUkdbT40JdR+npIRm9u/AiaBFSoQ
        ==
X-ME-Sender: <xms:xnRdYbeTrLTMrpmNqdrfYaEbspfnPCMOpvElkSF5L2hU17uzTsjWjw>
    <xme:xnRdYRNr2yCOQgk_jDDunjV2pqx2WFQ6BHuZ-Yuk8qYGewBipjN0uoreyKwiSqj2c
    eLliE01vLTxCvw>
X-ME-Received: <xmr:xnRdYUgBhEaKOjXiulcThXjnjVJl3N0feyMFy-MEIxJXWKQmWFf-NhrfipmunWOr5pOL34KXojj-6uxAhd3EhUISZ6TV4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeliedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xnRdYc-nnoJUDjLErFS3gGd3_CSOiBKRSrpJdZxoNDdwFGYlDshqfg>
    <xmx:xnRdYXsxaZmtzyAkLoMmtBrhWpjiJmm5gLiuxquF8nYKbRGo2oCIag>
    <xmx:xnRdYbEviZyyeAX-F8tGH2BGCegXhDQcSalYn0NngO1FnvQOdPuFww>
    <xmx:xnRdYRIuEaCpCSJ0TqNfrmlIdbEalOL9ek6J5ZBwZnpKQ5PJDRt8PQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Oct 2021 06:04:54 -0400 (EDT)
Date:   Wed, 6 Oct 2021 13:04:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: spectrum_buffers: silence uninitialized
 warning
Message-ID: <YV10w28vbsenFRFU@shredder>
References: <20211006073347.GB8404@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006073347.GB8404@kili>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 10:33:47AM +0300, Dan Carpenter wrote:
> Static checkers and runtime checkers such as KMSan will complain that
> we do not initialize the last 6 bytes of "cb_priv".  The caller only
> uses the first two bytes so it doesn't cause a runtime issue.  Still
> worth fixing though.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
