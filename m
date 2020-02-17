Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B9316086F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgBQDDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:03:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48076 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:03:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 529B21554647B;
        Sun, 16 Feb 2020 19:03:54 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:03:53 -0800 (PST)
Message-Id: <20200216.190353.651751869121496314.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, dbogdanov@marvell.com, pbelous@marvell.com,
        ndanilov@marvell.com
Subject: Re: [PATCH net 0/8] Marvell atlantic 2020/02 updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1580299250.git.irusskikh@marvell.com>
References: <cover.1580299250.git.irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:03:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Fri, 14 Feb 2020 18:44:50 +0300

> Hi David, here is another set of bugfixes on AQC family found on
> last integration phase.

Series applied, thanks.
