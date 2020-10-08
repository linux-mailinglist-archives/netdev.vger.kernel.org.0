Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F73C287C79
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 21:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgJHT1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 15:27:44 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:29533 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgJHT1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 15:27:44 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2020 15:27:44 EDT
Received: (qmail 10792 invoked by uid 89); 8 Oct 2020 19:21:02 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 8 Oct 2020 19:21:02 -0000
Date:   Thu, 8 Oct 2020 12:21:00 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next] virtio_net: handle non-napi callers to
 virtnet_poll_tx
Message-ID: <20201008192100.wk3pqsa4yimxrz3g@bsd-mbp.dhcp.thefacebook.com>
References: <20201008183436.3093286-1-jonathan.lemon@gmail.com>
 <20201008120102.0167559c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008120102.0167559c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 12:01:02PM -0700, Jakub Kicinski wrote:
> On Thu, 8 Oct 2020 11:34:36 -0700 Jonathan Lemon wrote:
> > From: Jonathan Lemon <bsd@fb.com>
> > 
> > netcons will call napi_poll with a budget of 0, indicating
> > a non-napi caller (and also called with irqs disabled).  Call
> > free_old_xmit_skbs() with the is_napi parameter set correctly.
> 
> This is a fix, can we get a Fixes tag, please?

As best as I can tell:

Fixes: df133f3f9625 ("virtio_net: bulk free tx skbs")
