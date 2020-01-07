Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A40131D9C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 03:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgAGCag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 21:30:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbgAGCag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 21:30:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 470AC159E7B15;
        Mon,  6 Jan 2020 18:30:35 -0800 (PST)
Date:   Mon, 06 Jan 2020 18:30:34 -0800 (PST)
Message-Id: <20200106.183034.1628108721792526991.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, cphealy@gmail.com
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Unique ATU and VTU
 IRQ names
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106161352.4461-6-andrew@lunn.ch>
References: <20200106161352.4461-1-andrew@lunn.ch>
        <20200106161352.4461-6-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jan 2020 18:30:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Mon,  6 Jan 2020 17:13:52 +0100

> Dynamically generate a unique interrupt name for the VTU and ATU,
> based on the device name.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Series applied, thanks Andrew.
