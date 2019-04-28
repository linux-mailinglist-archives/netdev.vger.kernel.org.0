Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F39D9F4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 01:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfD1Xl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 19:41:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfD1Xl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 19:41:26 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1B2A12EB0324;
        Sun, 28 Apr 2019 16:41:24 -0700 (PDT)
Date:   Sun, 28 Apr 2019 19:41:21 -0400 (EDT)
Message-Id: <20190428.194121.545225180994349344.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v4 net-next 00/14] Make DSA tag drivers kernel modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190428173723.5112-1-andrew@lunn.ch>
References: <20190428173723.5112-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Apr 2019 16:41:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun, 28 Apr 2019 19:37:09 +0200

> Historically, DSA tag drivers have been compiled into the kernel as
> part of the DSA core. With the growing number of tag drivers, it makes
> sense to allow this driver code to be compiled as a module, and loaded
> on demand.
> 
> Tested-by: Vivien Didelot <vivien.didelot@gmail.com>

Series applied, thanks Andrew.
