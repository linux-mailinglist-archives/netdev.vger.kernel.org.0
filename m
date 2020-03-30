Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF81981F6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgC3RMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:12:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgC3RMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:12:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5510B15BFD4FD;
        Mon, 30 Mar 2020 10:12:05 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:12:02 -0700 (PDT)
Message-Id: <20200330.101202.660829992934953878.davem@davemloft.net>
To:     skashyap@marvell.com
Cc:     martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, jhasan@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update and misc
 fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
References: <20200330063034.27309-1-skashyap@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:12:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You add the new qed_bw_update() function but nothing invokes it.

Remove this from the patch series until you are submitting changes
that actually use the function.
