Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07631BB3C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfEMQqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:46:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39898 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbfEMQqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:46:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3747314E266A1;
        Mon, 13 May 2019 09:46:33 -0700 (PDT)
Date:   Mon, 13 May 2019 09:46:32 -0700 (PDT)
Message-Id: <20190513.094632.2251179341102416171.davem@davemloft.net>
To:     jay.vosburgh@canonical.com
Cc:     jarod@redhat.com, linux-kernel@vger.kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: fix arp_validate toggling in active-backup
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6720.1557765810@famine>
References: <26675.1557528809@famine>
        <2033e768-9e35-ac89-c526-4c28fc3f747e@redhat.com>
        <6720.1557765810@famine>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:46:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jay Vosburgh <jay.vosburgh@canonical.com>
Date: Mon, 13 May 2019 09:43:30 -0700

> 	That would be my preference, as the 29c4948293bf commit looks to
> be the change actually being fixed.

Sorry I pushed the original commit message out :-(

But isn't the Fixes: tag he choose the one where the logic actually
causes problems?  That's kind of my real criteria for Fixes: tags.
