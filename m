Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F95263373
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIIREJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgIIPqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 11:46:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA91E206A5;
        Wed,  9 Sep 2020 15:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599666373;
        bh=02vN5pgMPCEY7Ju7SyyzuzR16DkEm6P7ELfIY1ffJPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f96qahEY5RG+qoZ9D5DA3fPZdQLTadxH4AWcZx9mruPK8F/r/3D0OPAN64V30ZDY2
         bXEJFQoXQioYhPTR49DcbRbKcDz8L0xymjaF8nS7ORC5RUwNNed3rjo6UJ8BCa6aQ3
         xo+lrP5LAQJYvrpQ8ry78VojlvagBvgxeuxzEP0s=
Date:   Wed, 9 Sep 2020 08:46:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, jes@trained-monkey.org,
        dougmill@linux.ibm.com, cooldavid@cooldavid.org,
        mlindner@marvell.com, stephen@networkplumber.org,
        borisp@mellanox.com, netdev@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 16/20] ethernet: netronome: convert tasklets to use
 new tasklet_setup() API
Message-ID: <20200909084611.07d4e41a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909084510.648706-17-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
        <20200909084510.648706-17-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 14:15:06 +0530 Allen Pais wrote:
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
