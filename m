Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291BCC43DB
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfJAWcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:32:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53852 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfJAWcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:32:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E180014770038;
        Tue,  1 Oct 2019 15:32:01 -0700 (PDT)
Date:   Tue, 01 Oct 2019 15:32:01 -0700 (PDT)
Message-Id: <20191001.153201.285366353051803207.davem@davemloft.net>
To:     horms+renesas@verge.net.au
Cc:     sergei.shtylyov@cogentembedded.com, magnus.damm@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: sh_eth convert bindings to json-schema
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930140352.12401-1-horms+renesas@verge.net.au>
References: <20190930140352.12401-1-horms+renesas@verge.net.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 15:32:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms+renesas@verge.net.au>
Date: Mon, 30 Sep 2019 16:03:52 +0200

> Convert Renesas Electronics SH EtherMAC bindings documentation to
> json-schema.  Also name bindings documentation file according to the compat
> string being documented.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Applied to net-next.
