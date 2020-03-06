Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3305E17B664
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 06:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgCFFdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 00:33:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59662 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgCFFdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 00:33:25 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AB7215ADABCB;
        Thu,  5 Mar 2020 21:33:24 -0800 (PST)
Date:   Thu, 05 Mar 2020 21:33:21 -0800 (PST)
Message-Id: <20200305.213321.1243150631582322410.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     christophe.ricard@gmail.com, kuba@kernel.org,
        gregkh@linuxfoundation.org, kstewart@linuxfoundation.org,
        allison@lohutok.net, netdev@vger.kernel.org, surenb@google.com,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: nfc: fix bounds checking bugs on "pipe"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304142429.2734khtbfyyoxmwc@kili.mountain>
References: <20200304142429.2734khtbfyyoxmwc@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 21:33:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 4 Mar 2020 17:24:31 +0300

> This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
> corruption when handling SHDLC I-Frame commands") and commit d7ee81ad09f0
> ("NFC: nci: Add some bounds checking in nci_hci_cmd_received()") which
> added range checks on "pipe".
> 
> The "pipe" variable comes skb->data[0] in nfc_hci_msg_rx_work().
> It's in the 0-255 range.  We're using it as the array index into the
> hdev->pipes[] array which has NFC_HCI_MAX_PIPES (128) members.
> 
> Fixes: 118278f20aa8 ("NFC: hci: Add pipes table to reference them with a tuple {gate, host}")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied and queued up for -stable, thanks Dan.
