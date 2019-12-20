Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F9F1272D3
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfLTBee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:34:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfLTBed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:34:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 133921540B9A3;
        Thu, 19 Dec 2019 17:34:33 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:34:32 -0800 (PST)
Message-Id: <20191219.173432.1907178642147983703.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, tglx@linutronix.de, elfring@users.sourceforge.net,
        gregkh@linuxfoundation.org, kstewart@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hdlcdrv: replace unnecessary assertion in
 hdlcdrv_register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217210620.29775-1-pakki001@umn.edu>
References: <20191217210620.29775-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:34:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Tue, 17 Dec 2019 15:06:19 -0600

> In hdlcdrv_register, failure to register the driver causes a crash.
> The three callers of hdlcdrv_register all pass valid pointers and
> do not fail. The patch eliminates the unnecessary BUG_ON assertion.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied to net-next.
