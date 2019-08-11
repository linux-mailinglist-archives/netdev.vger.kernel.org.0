Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9673C88F26
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 05:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfHKDAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 23:00:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHKDAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 23:00:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 96AF015524E21;
        Sat, 10 Aug 2019 20:00:04 -0700 (PDT)
Date:   Sat, 10 Aug 2019 20:00:01 -0700 (PDT)
Message-Id: <20190810.200001.1046174945054576670.davem@davemloft.net>
To:     marek.behun@nic.cz
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        sebastian.reichel@collabora.co.uk, vivien.didelot@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 1/1] net: dsa: fix fixed-link port registration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190811040247.03dcc403@nic.cz>
References: <20190811014650.28141-1-marek.behun@nic.cz>
        <20190811034742.349f0ef1@nic.cz>
        <20190811040247.03dcc403@nic.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 10 Aug 2019 20:00:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behun <marek.behun@nic.cz>
Date: Sun, 11 Aug 2019 04:02:47 +0200

> Which means I should have added the Fixes tag /o\

Which means you need to repost this patch with it added.
