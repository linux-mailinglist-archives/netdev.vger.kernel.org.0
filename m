Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B571973A3
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgC3FCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:02:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33220 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3FCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:02:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1BEA15C5C89D;
        Sun, 29 Mar 2020 22:02:33 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:02:32 -0700 (PDT)
Message-Id: <20200329.220232.362049697685982643.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net] s390/qeth: support net namespaces for L3 devices
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327110042.50797-1-jwi@linux.ibm.com>
References: <20200327110042.50797-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:02:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Fri, 27 Mar 2020 12:00:42 +0100

> Enable the L3 driver's IPv4 address notifier to watch for events on qeth
> devices that have been moved into a net namespace. We need to program
> those IPs into the HW just as usual, otherwise inbound traffic won't
> flow.
> 
> Fixes: 6133fb1aa137 ("[NETNS]: Disable inetaddr notifiers in namespaces other than initial.")
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied to net-next.
