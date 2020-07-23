Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4722B40E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgGWRCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWRCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 13:02:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3664D20771;
        Thu, 23 Jul 2020 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595523739;
        bh=wrogHpONO91/W2SUExal6b+mQNpuJDj4/U/GuUfG7aY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yDxoEWihKKaT8iJJqsXEjl8y+y/hp6jsYjN/T+ps2QNHmEk7/trAonizuGetK+IEK
         XbKKE6gGI01thLj+Z0b7lYkWlE4txvH7w0vlGzE0Uw5V3W+vGvQn8F0Uhipod0hn9R
         i7bz7r2XAvlHMy/j5MftzP3l4re+hp3mCIQhC/n0=
Date:   Thu, 23 Jul 2020 10:02:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com
Subject: Re: [PATCH net-next v3] cxgb4: add loopback ethtool self-test
Message-ID: <20200723100217.787c36f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200723124950.21035-1-vishal@chelsio.com>
References: <20200723124950.21035-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jul 2020 18:19:50 +0530 Vishal Kulkarni wrote:
> In this test, loopback pkt is created and sent on default queue.
> The packet goes until the Multi Port Switch (MPS) just before
> the MAC and based on the specified channel number, it either
> goes outside the wire on one of the physical ports or looped
> back to Rx path by MPS. In this case, we're specifying loopback
> channel, instead of physical ports, so the packet gets looped
> back to Rx path, instead of getting transmitted on the wire.
> 
> v3:
> - Modify commit message to include test details.
> v2:
> - Add only loopback self-test.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
