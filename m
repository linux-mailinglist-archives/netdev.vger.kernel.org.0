Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9821E4EB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGNA62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGNA62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:58:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECC9C061755;
        Mon, 13 Jul 2020 17:58:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAF39129877FB;
        Mon, 13 Jul 2020 17:58:26 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:58:25 -0700 (PDT)
Message-Id: <20200713.175825.1534786004215530376.davem@davemloft.net>
To:     loberman@redhat.com
Cc:     linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com,
        netdev@vger.kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com
Subject: Re: [PATCH] iscsi: qedi (qed_int.c) disable "MFW indication via
 attention" SPAM every 5 minutes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1594674941-32092-1-git-send-email-loberman@redhat.com>
References: <1594674941-32092-1-git-send-email-loberman@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:58:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurence Oberman <loberman@redhat.com>
Date: Mon, 13 Jul 2020 17:15:41 -0400

> This is likely firmware causing this but its starting to annoy customers.
> Change the message level to verbose to prevent the spam.
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>

"iscsi:" doesn't belong in this Subject line.

Please look at recent changes to this driver and what commit header
line subsystem prefixes and layout is being used.

Thanks.
