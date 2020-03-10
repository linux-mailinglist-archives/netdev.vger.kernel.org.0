Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24E717EEA3
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgCJCeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:34:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgCJCeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:34:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69B79120ED56C;
        Mon,  9 Mar 2020 19:34:20 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:34:19 -0700 (PDT)
Message-Id: <20200309.193419.1584438482708231790.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/8] ionic updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:34:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Fri,  6 Mar 2020 17:04:00 -0800

> This is a set of small updates for the Pensando ionic driver, some
> from internal work, some a result of mailing list discussions.
> 
> v4 - don't register mgmt device netdev
> v3 - changed __attribute__(packed)) to __packed
> v2 - removed print from ionic_init_module()

Series applied, thanks Shannon.

