Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B1F170F89
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgB0EPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:15:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbgB0EPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:15:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35CC815B4633C;
        Wed, 26 Feb 2020 20:15:24 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:15:21 -0800 (PST)
Message-Id: <20200226.201521.831786980010249804.davem@davemloft.net>
To:     christian.brauner@ubuntu.com
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v7 0/9] net: fix sysfs permssions when device changes
 network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
References: <20200227033719.1652190-1-christian.brauner@ubuntu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:15:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Series applied and I will push out after the build test passes.

Thanks.
