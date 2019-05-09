Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4875518DDF
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfEIQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:19:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIQTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:19:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABB0414CF788D;
        Thu,  9 May 2019 09:19:51 -0700 (PDT)
Date:   Thu, 09 May 2019 09:19:48 -0700 (PDT)
Message-Id: <20190509.091948.1094964791714124541.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com
Subject: Re: [PATCH] ptp_qoriq: fix NULL access if ptp dt node missing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509030845.36713-1-yangbo.lu@nxp.com>
References: <20190509030845.36713-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:19:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Y.b. Lu" <yangbo.lu@nxp.com>
Date: Thu, 9 May 2019 03:07:12 +0000

> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Make sure ptp dt node exists before accessing it in case
> of NULL pointer call trace.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied, thanks.
