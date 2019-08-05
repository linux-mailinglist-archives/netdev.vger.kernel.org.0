Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDBF825FF
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHEUWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:22:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHEUWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:22:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98E7615431983;
        Mon,  5 Aug 2019 13:22:19 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:22:19 -0700 (PDT)
Message-Id: <20190805.132219.833968941437361765.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, hslester96@gmail.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net-next] cnic: Explicitly initialize all reference
 counts to 0.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564726671-7094-1-git-send-email-michael.chan@broadcom.com>
References: <1564726671-7094-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:22:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Fri,  2 Aug 2019 02:17:51 -0400

> The driver is relying on zero'ed allocated memory and does not
> explicitly call atomic_set() to initialize the ref counts to 0.  Add
> these atomic_set() calls so that it will be more straight forward
> to convert atomic ref counts to refcount_t.
> 
> Reported-by: Chuhong Yuan <hslester96@gmail.com>
> Cc: Rasesh Mody <rmody@marvell.com>
> Cc: <GR-Linux-NIC-Dev@marvell.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied.
