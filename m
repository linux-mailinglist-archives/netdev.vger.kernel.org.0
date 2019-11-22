Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2246107694
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfKVRkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:40:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKVRkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:40:06 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B47C21527BEF3;
        Fri, 22 Nov 2019 09:40:05 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:40:05 -0800 (PST)
Message-Id: <20191122.094005.1244294795423045685.davem@davemloft.net>
To:     kalesh-anakkur.purayil@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] be2net: gather more debug info and display on
 a tx-timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191122104352.3864-1-kalesh-anakkur.purayil@broadcom.com>
References: <20191122104352.3864-1-kalesh-anakkur.purayil@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Nov 2019 09:40:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please post only one copy of your patch.

You can wait 15 minutes or half an hour when you don't see your posting
hit the mailing list yet.

Again, please be patient in the future as posting multiple copies makes
more work for me.
