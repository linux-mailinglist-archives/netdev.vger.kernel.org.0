Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7981FEAA2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFRFIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:08:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:5607 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgFRFIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 01:08:38 -0400
Received: from localhost ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05I58XZJ029895;
        Wed, 17 Jun 2020 22:08:34 -0700
Date:   Thu, 18 Jun 2020 10:38:33 +0530
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        dt <dt@chelsio.com>
Subject: Re: [PATCH net-next 3/5] cxgb4: add support to flash boot image
Message-ID: <20200618050833.GA10675@chelsio.com>
References: <20200617062907.26121-1-vishal@chelsio.com>
 <20200617062907.26121-4-vishal@chelsio.com>
 <20200617092527.30333c1f@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617092527.30333c1f@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, June 06/17/20, 2020 at 21:55:27 +0530, Jakub Kicinski wrote:
> On Wed, 17 Jun 2020 11:59:05 +0530 Vishal Kulkarni wrote:
> > Update set_flash to flash boot image to flash region
> >
> > Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
> 
> This patch adds 4 new warnings to the plethora of warnings in
> drivers/net/ethernet/chelsio/cxgb4/t4_hw.c when built with W=1 C=1 flags.
> 
> Please don't add new ones. And preferably address the existing
> hundreds of warnings in your driver.
Hi Jakub,

Thank you for feedback. I will fix those 4 new warnings and post v2.
As for old ones, We have already started on addressing them
and will post patches soon.

-Vishal
