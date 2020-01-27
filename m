Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF60F14A1E8
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgA0KZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:25:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37094 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgA0KZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:25:10 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8BD731513DD3F;
        Mon, 27 Jan 2020 02:25:08 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:25:06 +0100 (CET)
Message-Id: <20200127.112506.1247864116213060981.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2020-01-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200126140123.GA77676@pmessmer-mobl1.ger.corp.intel.com>
References: <20200126140123.GA77676@pmessmer-mobl1.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:25:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Sun, 26 Jan 2020 16:01:23 +0200

> Here's (probably) the last bluetooth-next pull request for the 5.6 kernel.
> 
>  - Initial pieces of Bluetooth 5.2 Isochronous Channels support
>  - mgmt: Various cleanups and a new Set Blocked Keys command
>  - btusb: Added support for 04ca:3021 QCA_ROME device
>  - hci_qca: Multiple fixes & cleanups
>  - hci_bcm: Fixes & improved device tree support
>  - Fixed attempts to create duplicate debugfs entries
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks Johan.
