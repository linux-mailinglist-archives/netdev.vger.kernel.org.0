Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314793B6897
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhF1SlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 14:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232542AbhF1SlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 14:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE7D61456;
        Mon, 28 Jun 2021 18:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624905526;
        bh=Gb3b3ZJRYyF0mNEkOx7qg/gxLwwJM6soKUyjs07tJUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=njHptxD5rqQtaiVKqwi+MqLXi9O+FJDl3TXqA5Wyj3hnH+ZEFWrxK4a3VWMySoHIg
         PIjgu55F/FRcS31vdV5CJI5JM1W36l6wgTTeYRWI/zlPK/RwKYDYnlf5yxyTdxdwqb
         OzB0F/pzgyfpnR/wHM0IJZRndrcsGXHCGN8oHfiA91+nXip92jFP7OKBnrS+ZEgc7e
         spwMCTQRsWvg95YHZAEbGTS2L/UWUit+PxUPa49Qzf37rCzAcUrlvVdbQCHm97xoaR
         lv3L/2vW3jzHiGd3b7pZLogrZZoReYA+6c0f1UTzRpUWIYkg5I7Pgn29SzLz9hdbUy
         HgF8ON2BAUA+w==
Date:   Mon, 28 Jun 2021 11:38:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] udp: allow changing mapping of a socket to
 queue
Message-ID: <20210628113845.28bdc035@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210627075740.68554-1-xiangxia.m.yue@gmail.com>
References: <20210627075740.68554-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Jun 2021 15:57:40 +0800 Tonghao Zhang wrote:
> There are many containers running on host. These containers
> share the host resources(e.g. netdev rx/tx queue). For isolating
> tx/rx queue, when the process migrated to other cpu, we hope
> this process will use tx/rx queue mapped to this cpu.

What's the impact? UDP packets would never get out of order within the
source system and now they will? Could you explain why that's safe?
