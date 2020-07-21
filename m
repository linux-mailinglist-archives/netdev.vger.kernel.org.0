Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0E228913
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730726AbgGUTXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728700AbgGUTXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:23:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3947B206F2;
        Tue, 21 Jul 2020 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359411;
        bh=UNWHGfy6grRsreHc8tIYMNKsYHv2DrahFHweExENGbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1Cny7YLjYY6xFicHDesO1/f0cgFUJ4Yi9cPFZUPu7vuegR2+bWRGgvRHv+0a13evA
         26R7ZpTB8Zx5nAhTMWM7yrPDuiBRbzHaa5btUjkQj2/uEzyABv1iBqH5ilxnn1jrYh
         f8Unk8rnIwg6kBnFWgTvlkTkU7D+BXrLfbcp2wqY=
Date:   Tue, 21 Jul 2020 12:23:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     rakeshs.lkm@gmail.com
Cc:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Interrupt handler support for NPA and NIX in
 Octeontx2.
Message-ID: <20200721122329.4d785138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
References: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 08:08:45 +0530 rakeshs.lkm@gmail.com wrote:
> From: Rakesh Babu <rakeshs.lkm@gmail.com>
> 
> Changes from v1.
> 1. Assigned void pointers to another type of pointers without type casting.
> 2. Removed Switch and If cases in interrupt handlers and printed the hexa
> value of the interrupt

These days error events should be reported via devlink health, 
not printing messages to the logs.
