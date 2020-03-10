Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95EF917EEF2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 04:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgCJDF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 23:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgCJDF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 23:05:57 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97B1205F4;
        Tue, 10 Mar 2020 03:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583809556;
        bh=41sVyPq8m8AjlbaGmToeD4KjKX8nRokDDrSUSYDzBq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=emGpi/edgnUjEFjilMsx0hNkCzKCZowdNcQEFGfV9dlQ9Q6Y+OA4XK5mbpfgOdA8D
         fRW/HC4iU8RKxt9c9Zho5VFEGdRSjqRqM5NQzYAKfv7/oO6g/5VKUW/SffRO+a0e/G
         dWhc75NqK0IgGyS9ubbYOBCPqtTBpKXmspur6h44=
Date:   Mon, 9 Mar 2020 20:05:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org
Subject: Re: [PATCH net-next 00/15] ethtool: consolidate irq coalescing -
 part 3
Message-ID: <20200309200553.770819bc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200309.194313.585990109584018645.davem@davemloft.net>
References: <20200310021512.1861626-1-kuba@kernel.org>
        <20200309.194313.585990109584018645.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Mar 2020 19:43:13 -0700 (PDT) David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon,  9 Mar 2020 19:14:57 -0700
> 
> > Convert more drivers following the groundwork laid in a recent
> > patch set [1] and continued in [2]. The aim of the effort is to
> > consolidate irq coalescing parameter validation in the core.
> > 
> > This set converts 15 drivers in drivers/net/ethernet.
> > 3 more conversion sets to come.
> > 
> > None of the drivers here checked all unsupported parameters.
> > 
> > [1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
> > [2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/  
> 
> I'll let this sit for a day for review(s).

Makes sense, this is partially manual work, good to have it double
checked by folks.
