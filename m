Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C482CF8B8
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgLEBlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgLEBlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 20:41:35 -0500
Date:   Fri, 4 Dec 2020 17:40:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607132455;
        bh=2ohMN0i/Pm1Qkq3iBbTXMUnqzHZIjLA/hLTHyRetanc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LbWvLZ74pu0B692JiY419HOap+gnVVTTQqBgo3BVZ7R1ecO87vvMMMAzYhFD9X0mw
         wI3IuxOwLJwR3GDc3sey7MTlahv25g6+olQ3fQfLfxg0arEcIK6UnSeleeEZRJ0oSJ
         256DdktzM/FqkK7UqmnmEOR8p2NHfq5mF/4l9Nobo/gSYLhyobF93QxytM5JLqLK/N
         GgUVpKjNYW/D1H6/RADM6dQYGgB7sy6JgXHgNCZ2I/XtozIbjS5bEM+AUfxj+8HKNN
         hQPe4UHZha+n+evUlaEPU8FoGpt02pYJegG+rUuAz1IW2jOT2R/QtgF1OJUGPApyqQ
         h/ZT6sBYM/how==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: support 128bit node identity for peer removing
Message-ID: <20201204174053.0ac56a79@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203035045.4564-1-hoang.h.le@dektech.com.au>
References: <20201203035045.4564-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 10:50:45 +0700 Hoang Huu Le wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> We add the support to remove a specific node down with 128bit
> node identifier, as an alternative to legacy 32-bit node address.
> 
> example:
> $tipc peer remove identiy <1001002|16777777>
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied, thanks!
