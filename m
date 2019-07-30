Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AB77AE7D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfG3Q4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:56:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfG3Q4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:56:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B63FD1264EC71;
        Tue, 30 Jul 2019 09:56:36 -0700 (PDT)
Date:   Tue, 30 Jul 2019 09:56:36 -0700 (PDT)
Message-Id: <20190730.095636.109543400421016878.davem@davemloft.net>
To:     h.feurstein@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: use link-down-define instead of
 plain value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730101142.548-1-h.feurstein@gmail.com>
References: <20190730101142.548-1-h.feurstein@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 09:56:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>
Date: Tue, 30 Jul 2019 12:11:42 +0200

> Using the define here makes the code more expressive.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Applied, thank you.
