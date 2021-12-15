Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDC0475D5D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 17:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbhLOQ1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 11:27:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47136 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbhLOQ1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 11:27:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46EF761993;
        Wed, 15 Dec 2021 16:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D68C36AE0;
        Wed, 15 Dec 2021 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639585659;
        bh=sZucjtaSMSPMq/qhSebZcilNEy4m3JBM4SmRBFW6p84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jQjP3jIitxhGLVviieQ6h9pKATAjyJkxA1oo+zjRPi+Gb28MUwEXtYBtjQymi5ZFc
         uFIaJwYwtjDt3Vp5EvjmL1jX6TZBI8VuSuaY0euXGqwowv7JBEwRBjU0KruFoPud3y
         pZ1xr9oy8K7vPXNHDPGdatBWkP6x1Gel0hBnsAeE8frXGeSSAM/aVt8iyg+FnhlIom
         H1Dr1pv6FBlULJqXnzXvFhKsCraQ/Q8WZ9SvGBuNKVj6km9bYWyooJw+pwIzts75w2
         e3UUXvsUMQaF0D2+lpmMkbBVwx+LjQqYRIcRQqbcmRFcIMtuu4BObJAFoiMQShhyYc
         4MR1ckMUeWrrg==
Date:   Wed, 15 Dec 2021 08:27:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5, 1/2] yaml: Add dm9051 SPI network yaml file
Message-ID: <20211215082738.26b41966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YboO9DVkX3wMb9Z2@robh.at.kernel.org>
References: <20211215073507.16776-1-josright123@gmail.com>
        <20211215073507.16776-2-josright123@gmail.com>
        <YboO9DVkX3wMb9Z2@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 09:51:16 -0600 Rob Herring wrote:
> On Wed, 15 Dec 2021 15:35:06 +0800, JosephCHANG wrote:
> > This is a new yaml base data file for configure davicom dm9051 with
> > device tree
> > 
> > Signed-off-by: JosephCHANG <josright123@gmail.com>
> 
> Please add Acked-by/Reviewed-by tags when posting new versions. However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.
> 
> If a tag was not added on purpose, please state why and what changed.

And general changelog would be useful, what changed between v4 and v5?
Again, no need to create v6 just for that, you can reply with the
change log and include it with next versions if there are any.
