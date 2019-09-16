Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A707B3C4E
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388458AbfIPOO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:14:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfIPOO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:14:58 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D6D8153CA71C;
        Mon, 16 Sep 2019 07:14:56 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:14:55 +0200 (CEST)
Message-Id: <20190916.161455.1015414751228915954.davem@davemloft.net>
To:     james.byrne@origamienergy.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Correct the documentation of KSZ9021
 skew values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0102016d2b84f180-bd396cb9-16cf-4472-b718-7a4d2d8d8017-000000@eu-west-1.amazonses.com>
References: <0102016d2b84f180-bd396cb9-16cf-4472-b718-7a4d2d8d8017-000000@eu-west-1.amazonses.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 07:14:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Byrne <james.byrne@origamienergy.com>
Date: Fri, 13 Sep 2019 16:46:35 +0000

> The documentation of skew values for the KSZ9021 PHY was misleading
> because the driver implementation followed the erroneous information
> given in the original KSZ9021 datasheet before it was corrected in
> revision 1.2 (Feb 2014). It is probably too late to correct the driver
> now because of the many existing device trees, so instead this just
> corrects the documentation to explain that what you actually get is not
> what you might think when looking at the device tree.
> 
> Signed-off-by: James Byrne <james.byrne@origamienergy.com>

What tree should this go into?

