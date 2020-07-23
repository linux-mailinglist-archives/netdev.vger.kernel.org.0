Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864D122AF81
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 14:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgGWMfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 08:35:44 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:35394 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWMfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 08:35:43 -0400
Received: from localhost (lakshmi-pc.asicdesigners.com [10.193.177.132] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06NCZYGH012447;
        Thu, 23 Jul 2020 05:35:35 -0700
Date:   Thu, 23 Jul 2020 18:05:33 +0530
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next v2] cxgb4: add loopback ethtool self-test
Message-ID: <20200723123533.GA20236@chelsio.com>
References: <20200722135844.7432-1-vishal@chelsio.com>
 <20200722100414.6e4e07ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722100414.6e4e07ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, July 07/22/20, 2020 at 10:04:14 -0700, Jakub Kicinski wrote:
> On Wed, 22 Jul 2020 19:28:44 +0530 Vishal Kulkarni wrote:
> > In this test, loopback pkt is created and sent on default queue.
> > 
> > v2:
> > - Add only loopback self-test.
> 
> Thanks for dropping the rest of the patches. Is it worth specifying
> what level of loopback this test is? PCI / MAC / PHY / other?

Hi Jakub,

I will add details to commit message and send v3.

-Vishal
