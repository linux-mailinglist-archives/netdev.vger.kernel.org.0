Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E70190355
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCXBbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:31:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgCXBbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 21:31:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C02015B47E47;
        Mon, 23 Mar 2020 18:31:18 -0700 (PDT)
Date:   Mon, 23 Mar 2020 18:31:15 -0700 (PDT)
Message-Id: <20200323.183115.1544256233598523357.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, dmurphy@ti.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: dp83867: w/a for fld detect threshold
 bootstrapping issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e2f46a8d-b544-e31c-c994-672012bea866@ti.com>
References: <20200317180454.22393-1-grygorii.strashko@ti.com>
        <20200321.201022.719210614219273669.davem@davemloft.net>
        <e2f46a8d-b544-e31c-c994-672012bea866@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 18:31:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Mon, 23 Mar 2020 22:36:32 +0200

> On 22/03/2020 05:10, David Miller wrote:
>> Let me know if I should queue this up for -stable.
>> 
> 
> yes, please, as there are real link instability issues were observed
> without this change.

Ok, done.
