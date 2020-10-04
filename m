Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280392827AA
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgJDAfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgJDAfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:35:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4315EC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 17:35:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A4F411E3E4CB;
        Sat,  3 Oct 2020 17:19:05 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:35:52 -0700 (PDT)
Message-Id: <20201003.173552.2073522479861180434.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Specify unit
 address in hex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003093051.7242-1-kurt@linutronix.de>
References: <20201003093051.7242-1-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:19:05 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Sat,  3 Oct 2020 11:30:50 +0200

> The unit address should be 1e, because the unit address is supposed
> to be in hexadecimal.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Applied.
