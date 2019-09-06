Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82230ABB4E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394569AbfIFOr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:47:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394559AbfIFOrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:47:55 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D24F115355C4A;
        Fri,  6 Sep 2019 07:47:53 -0700 (PDT)
Date:   Fri, 06 Sep 2019 16:47:52 +0200 (CEST)
Message-Id: <20190906.164752.2021789297971211632.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: remove redundant assignment to variable
 rx_process_result
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905140135.26951-1-colin.king@canonical.com>
References: <20190905140135.26951-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 07:47:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  5 Sep 2019 15:01:35 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable rx_process_result is being initialized with a value that
> is never read and is being re-assigned immediately afterwards. The
> assignment is redundant, so replace it with the return from function
> lan743x_rx_process_packet.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks.
