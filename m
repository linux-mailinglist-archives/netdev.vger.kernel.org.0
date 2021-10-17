Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE3430CBE
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhJQW0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:26:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53632 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbhJQW0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:26:00 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5B2D7605E1;
        Mon, 18 Oct 2021 00:22:08 +0200 (CEST)
Date:   Mon, 18 Oct 2021 00:23:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH] netfilter: ebtables: allocate chainstack on CPU local
 nodes
Message-ID: <YWyib1kOnx6f18lb@salvia>
References: <20211010182439.11036-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211010182439.11036-1-dave@stgolabs.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 11:24:39AM -0700, Davidlohr Bueso wrote:
> Keep the per-CPU memory allocated for chainstacks local.

Applied to nf.git, thanks
