Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDEB7AE79
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfG3Qzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:55:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfG3Qzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:55:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 934681264EC66;
        Tue, 30 Jul 2019 09:55:34 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:55:34 -0700 (PDT)
Message-Id: <20190730.095534.1629843557426676625.davem@davemloft.net>
To:     h.feurstein@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH] net: phy: fixed_phy: print gpio error only if gpio
 node is present
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730094623.31640-1-h.feurstein@gmail.com>
References: <20190730094623.31640-1-h.feurstein@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 09:55:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>
Date: Tue, 30 Jul 2019 11:46:23 +0200

> It is perfectly ok to not have an gpio attached to the fixed-link node. So
> the driver should not throw an error message when the gpio is missing.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Applied and queued up for -stable, thanks.
