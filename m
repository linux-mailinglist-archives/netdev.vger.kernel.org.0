Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5333BF611
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhGHHQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:16:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46564 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhGHHQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:16:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id D39234D0F3489;
        Thu,  8 Jul 2021 00:14:04 -0700 (PDT)
Date:   Thu, 08 Jul 2021 00:14:04 -0700 (PDT)
Message-Id: <20210708.001404.122934424143086559.davem@davemloft.net>
To:     dariobin@libero.it
Cc:     linux-kernel@vger.kernel.org, jonathan.lemon@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] ptp: fix PTP PPS source's lookup cookie set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210708050849.11959-1-dariobin@libero.it>
References: <20210708050849.11959-1-dariobin@libero.it>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 08 Jul 2021 00:14:05 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this pastch does not apply to the current net tree, that is why I keep marking it "Not Applicable"
in patchwork.
