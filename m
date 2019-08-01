Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F272F7E544
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 00:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbfHAWR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 18:17:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729971AbfHAWR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 18:17:58 -0400
Received: from localhost (unknown [172.58.27.22])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 641D915434E3E;
        Thu,  1 Aug 2019 15:17:57 -0700 (PDT)
Date:   Thu, 01 Aug 2019 18:17:55 -0400 (EDT)
Message-Id: <20190801.181755.447790448046340664.davem@davemloft.net>
To:     h.feurstein@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: extend PTP gettime function to
 read system clock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730101007.344-1-h.feurstein@gmail.com>
References: <20190730101007.344-1-h.feurstein@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 15:17:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hubert Feurstein <h.feurstein@gmail.com>
Date: Tue, 30 Jul 2019 12:10:07 +0200

> This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

This patch applies neither to net nor net-next.
