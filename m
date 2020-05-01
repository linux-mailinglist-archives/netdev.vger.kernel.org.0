Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381E71C207F
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgEAWVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAWVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:21:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D953C061A0C;
        Fri,  1 May 2020 15:21:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF92B14EFC4E4;
        Fri,  1 May 2020 15:21:30 -0700 (PDT)
Date:   Fri, 01 May 2020 15:21:30 -0700 (PDT)
Message-Id: <20200501.152130.2290341369746144284.davem@davemloft.net>
To:     hayashi.kunihiko@socionext.com
Cc:     robh+dt@kernel.org, yamada.masahiro@socionext.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] dt-bindings: net: Convert UniPhier AVE4 controller
 to json-schema
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1588055482-13012-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:21:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Date: Tue, 28 Apr 2020 15:31:22 +0900

> Convert the UniPhier AVE4 controller binding to DT schema format.
> This changes phy-handle property to required.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

DT folks, is it ok if I take this into net-next or do you folks want to
take it instead?

Thanks.
