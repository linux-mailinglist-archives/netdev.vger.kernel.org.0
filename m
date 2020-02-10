Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E811577F7
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgBJNDw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 10 Feb 2020 08:03:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbgBJNDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:03:51 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DD09D14DD5523;
        Mon, 10 Feb 2020 05:03:49 -0800 (PST)
Date:   Mon, 10 Feb 2020 14:03:48 +0100 (CET)
Message-Id: <20200210.140348.1963500382587025261.davem@davemloft.net>
To:     bjorn@mork.no
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        kristian.evensen@gmail.com, aleksander@aleksander.es
Subject: Re: [PATCH net-next] qmi_wwan: unconditionally reject 2 ep
 interfaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200208155504.30243-1-bjorn@mork.no>
References: <20200208155504.30243-1-bjorn@mork.no>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 05:03:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Sat,  8 Feb 2020 16:55:04 +0100

> We have been using the fact that the QMI and DIAG functions
> usually are the only ones with class/subclass/protocol being
> ff/ff/ff on Quectel modems. This has allowed us to match the
> QMI function without knowing the exact interface number,
> which can vary depending on firmware configuration.
> 
> The ability to silently reject the DIAG function, which is
> usually handled by the option driver, is important for this
> method to work.  This is done based on the knowledge that it
> has exactly 2 bulk endpoints.  QMI function control interfaces
> will have either 3 or 1 endpoint. This rule is universal so
> the quirk condition can be removed.
> 
> The fixed layouts known from the Gobi1k and Gobi2k modems
> have been gradually replaced by more dynamic layouts, and
> many vendors now use configurable layouts without changing
> device IDs.  Renaming the class/subclass/protocol matching
> macro makes it more obvious that this is now not Quectel
> specific anymore.
> 
> Cc: Kristian Evensen <kristian.evensen@gmail.com>
> Cc: Aleksander Morgado <aleksander@aleksander.es>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Applied.
