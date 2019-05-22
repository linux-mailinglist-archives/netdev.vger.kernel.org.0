Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1875926672
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 17:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfEVPAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 11:00:37 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:46010 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfEVPAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 11:00:37 -0400
Received: from localhost ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x4MF0V95031483;
        Wed, 22 May 2019 08:00:32 -0700
Date:   Wed, 22 May 2019 20:30:34 +0530
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Indranil Choudhury <indranil@chelsio.com>, dt <dt@chelsio.com>
Subject: Re: [PATCH net-next] cxgb4: Enable hash filter with offload
Message-ID: <20190522150033.GB8075@chelsio.com>
References: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
 <20190521.132410.376317891388238361.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521.132410.376317891388238361.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, May 05/22/19, 2019 at 01:54:10 +0530, David Miller wrote:
> From: Vishal Kulkarni <vishal@chelsio.com>
> Date: Tue, 21 May 2019 09:10:37 +0530
> 
> > This patch enables hash filter along with offload
> > 
> > Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
> 
> This commit message is too terse.
> 
> What is going on here.  Why does this change need to made?  Why did
> you implement it this way?
> 
> Is this a bug fix?  If so, target 'net' instead of 'net-next'.

Will resend path with modified commit message.

-Vishal
