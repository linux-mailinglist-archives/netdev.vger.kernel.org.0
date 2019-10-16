Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32147D8717
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 06:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfJPEAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 00:00:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfJPEAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 00:00:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63D25108AE0D6;
        Tue, 15 Oct 2019 21:00:50 -0700 (PDT)
Date:   Tue, 15 Oct 2019 21:00:50 -0700 (PDT)
Message-Id: <20191015.210050.2009076485951831312.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bcmgenet: Fix RGMII_MODE_EN value for GENET
 v1/2/3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191015174547.9837-1-f.fainelli@gmail.com>
References: <20191015174547.9837-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 21:00:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 15 Oct 2019 10:45:47 -0700

> The RGMII_MODE_EN bit value was 0 for GENET versions 1 through 3, and
> became 6 for GENET v4 and above, account for that difference.
> 
> Fixes: aa09677cba42 ("net: bcmgenet: add MDIO routines")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable.
