Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC5179BC3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388484AbgCDWgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:36:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46928 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388312AbgCDWgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:36:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAF3F15AD9724;
        Wed,  4 Mar 2020 14:36:00 -0800 (PST)
Date:   Wed, 04 Mar 2020 14:36:00 -0800 (PST)
Message-Id: <20200304.143600.1488403518166537893.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] ionic updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 14:36:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon,  2 Mar 2020 20:15:37 -0800

> This is a set of small updates for the Pensando ionic driver, some
> from internal work, some a result of mailing list discussions.

Please use __packed and follow up on the driver version feedback.

Thank you.
