Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB51D59DC
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgEOTUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgEOTUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:20:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 403182070A;
        Fri, 15 May 2020 19:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589570441;
        bh=LTWIDpA3gp7Nmtl3BK2ma4Tw+j9V/FnQv5//ie/P54o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v5NkmdFTPrIDcp+6Rsey3E8l/NgXLSZKWcoIDjtdmRCmELtjByGm0nIjAY9pYvFgK
         pUPcwNZNHfnwbKt79gXDkJ6baO0EE9HPdomOr+QGXPfdITlt9P9GduJCRrcU7ukQof
         Er9j1PXHkoEtLWYUkTmKBFH0aBAaiDrNQQiASezk=
Date:   Fri, 15 May 2020 12:20:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Message-ID: <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515184753.15080-1-ioana.ciornei@nxp.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 21:47:46 +0300 Ioana Ciornei wrote:
> This patch set adds support for Rx traffic classes on DPAA2 Ethernet
> devices.
> 
> The first two patches make the necessary changes so that multiple
> traffic classes are configured and their statistics are displayed in the
> debugfs. The third patch adds a static distribution to said traffic
> classes based on the VLAN PCP field.
> 
> The last patches add support for the congestion group taildrop mechanism
> that allows us to control the number of frames that can accumulate on a
> group of Rx frame queues belonging to the same traffic class.

Ah, I miseed you already sent a v2. Same question applies:

> How is this configured from the user perspective? I looked through the
> patches and I see no information on how the input is taken from the
> user.
