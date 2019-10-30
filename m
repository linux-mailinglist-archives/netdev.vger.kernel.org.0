Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F2EA5A7
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfJ3VpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:45:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfJ3VpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:45:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 767B614CDE8C1;
        Wed, 30 Oct 2019 14:45:00 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:44:59 -0700 (PDT)
Message-Id: <20191030.144459.2303767694974492293.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/2] net: dsa: Add ability to elect CPU port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028223236.31642-1-f.fainelli@gmail.com>
References: <20191028223236.31642-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:45:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Mon, 28 Oct 2019 15:32:34 -0700

> This patch series solves a problem we have with Broadcom switches
> whereby multiple CPU ports can be defined, and while they should all be
> possible choices, it may not be desirable to use, say port 5 instead of
> port 8 because port 8 is hard wired as the management port in the switch
> logic, or because it simply offers more features.
> 
> Add an election callback into the driver to allow the selection of a
> particular CPU port when multiple are defined.

I sense there will be another spin of this, so marking it changes-requrested
in patchwork.
