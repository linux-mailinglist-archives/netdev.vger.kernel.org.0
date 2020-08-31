Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6826025817E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgHaTDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgHaTDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 15:03:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14EF207DA;
        Mon, 31 Aug 2020 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598900587;
        bh=fp6UulPXr1zsw3UvlY0/Mw4dmjJz5jjttHaxd+RpbN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=keW2VCJHhuOY77XMTUdvX8SOTfadAEUuadMkAIBLC5seJuGCqXCZLDjwq7rRmdZsl
         07JCS1aSV4Y9D61qaZszC4MuHWC8OfZ5Evu4R0U1urnxIpRsgot1kZ+nUMZJPzILzO
         NfG4vi42xpsTr/ELnlPQICP5chgMLUSESNYRF5LI=
Date:   Mon, 31 Aug 2020 12:03:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: add a dpaa2_eth_ prefix to all
 functions
Message-ID: <20200831120305.4e913ea3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200831181240.21527-1-ioana.ciornei@nxp.com>
References: <20200831181240.21527-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 21:12:37 +0300 Ioana Ciornei wrote:
> This is just a quick cleanup that aims at adding a dpaa2_eth_ prefix to
> all functions within the dpaa2-eth driver even if those are static and
> private to the driver. The main reason for doing this is that looking a
> perf top, for example, is becoming an inconvenience because one cannot
> easily determine which entries are dpaa2-eth related or not.

Yes!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
