Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBD19C310
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbgDBNu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:50:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732392AbgDBNu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:50:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27346128A0357;
        Thu,  2 Apr 2020 06:50:28 -0700 (PDT)
Date:   Thu, 02 Apr 2020 06:50:27 -0700 (PDT)
Message-Id: <20200402.065027.1657998110188544898.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     ap420073@gmail.com, netdev@vger.kernel.org, elder@linaro.org,
        stranche@codeaurora.org
Subject: Re: [PATCH net] net: qualcomm: rmnet: Allow configuration updates
 to existing devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331224348.12539-1-subashab@codeaurora.org>
References: <20200331224348.12539-1-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 06:50:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Tue, 31 Mar 2020 16:43:48 -0600

> This allows the changelink operation to succeed if the mux_id was
> specified as an argument. Note that the mux_id must match the
> existing mux_id of the rmnet device or should be an unused mux_id.
> 
> Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
> Reported-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied, thanks.
