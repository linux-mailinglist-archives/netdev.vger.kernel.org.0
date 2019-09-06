Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9288BABB4C
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394557AbfIFOrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:47:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730799AbfIFOrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:47:43 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E105815355C43;
        Fri,  6 Sep 2019 07:47:41 -0700 (PDT)
Date:   Fri, 06 Sep 2019 16:47:37 +0200 (CEST)
Message-Id: <20190906.164737.1509857493765158370.davem@davemloft.net>
To:     horms+renesas@verge.net.au
Cc:     sergei.shtylyov@cogentembedded.com, magnus.damm@gmail.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] ravb: remove use of undocumented
 registers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905151059.26794-1-horms+renesas@verge.net.au>
References: <20190905151059.26794-1-horms+renesas@verge.net.au>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 07:47:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms+renesas@verge.net.au>
Date: Thu,  5 Sep 2019 17:10:55 +0200

> this short series cleans up the RAVB driver a little.
 ...

Series applied, thanks Simon.
