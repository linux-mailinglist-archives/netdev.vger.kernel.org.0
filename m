Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B5B157804
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgBJNE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:04:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730115AbgBJNE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:04:28 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D66C314DD5523;
        Mon, 10 Feb 2020 05:04:27 -0800 (PST)
Date:   Mon, 10 Feb 2020 14:04:26 +0100 (CET)
Message-Id: <20200210.140426.1361189082811150275.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: vlan: suppress "failed to kill vid"
 warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200210123553.89842-1-jwi@linux.ibm.com>
References: <20200210123553.89842-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Feb 2020 05:04:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please resend this without the <> around the netdev list, I think that
caused it to not make it to the mailing list (and thus patchwork).

Thank you.
