Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDE331578
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfEaTjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:39:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfEaTjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 15:39:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C812150060E4;
        Fri, 31 May 2019 12:39:17 -0700 (PDT)
Date:   Fri, 31 May 2019 12:39:16 -0700 (PDT)
Message-Id: <20190531.123916.1069279739953468206.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, olteanv@gmail.com
Subject: Re: [PATCH net-next 0/5] phylink/sfp updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
References: <20190520152134.qyka5t7c2i7drk4a@shell.armlinux.org.uk>
        <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 12:39:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 28 May 2019 10:56:39 +0100

> This is a series of updates to phylink and sfp:

Series applied.
