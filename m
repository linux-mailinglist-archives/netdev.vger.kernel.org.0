Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252D15AE7F9
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbiIFMWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiIFMWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:22:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E8F78BE3;
        Tue,  6 Sep 2022 05:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hqCjtiyrJ6rGXCi+KJhh0cIm4lWy2egYvSinPQdu6Hc=; b=XJhOYk74ELHK8gVTOYvVFYDo3a
        a3RtNJTEJ8NKggTy06vcQ5vcCOqty6LYVSj3isgmjNkgJ8N1jbDgH/UoyB8MWeHKrLgGtnqSipV+B
        VSsGD+vfQ780NkNP9OsG4Ih4DlnZRKkoygupkCjAr/VQwN9wU+Oz7Llk9W5VoMptJEPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVXXP-00FkPq-Nc; Tue, 06 Sep 2022 14:18:43 +0200
Date:   Tue, 6 Sep 2022 14:18:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Olliver Schinagl <oliver@schinagl.nl>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] linkstate: Add macros for link state up/down
Message-ID: <Yxc6o+6u2zlPxU3a@lunn.ch>
References: <20220906083754.2183092-1-oliver@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906083754.2183092-1-oliver@schinagl.nl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 10:37:54AM +0200, Olliver Schinagl wrote:
> The phylink_link_state.state property can be up or down, via 1 and 0.
> 
> The other link state's (speed, duplex) are defined in ethtool.h so lets
> add defines for the link-state there as well so we can use macro's to
> define our up/down states.

Hi Olliver

The change itself is fine, but we don't add to the API without
users. Please make use of these two new values somewhere, to show they
are really useful.

    Andrew
