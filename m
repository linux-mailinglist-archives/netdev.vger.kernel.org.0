Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9882000B6
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgFSDYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgFSDYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:24:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877D2C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:24:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D71FB120ED49C;
        Thu, 18 Jun 2020 20:24:40 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:24:40 -0700 (PDT)
Message-Id: <20200618.202440.282283857015020754.davem@davemloft.net>
To:     fido_max@inbox.ru
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH v2 01/02] net: phy: marvell: Add Marvell 88E1340 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <05f6912b-d529-ae7d-183e-efa6951e94b7@inbox.ru>
References: <05f6912b-d529-ae7d-183e-efa6951e94b7@inbox.ru>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:24:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


These patches have been corrupted by your email client, try to apply what
ended up in the mailing list and you will see, from "git am":

Applying: net: phy: marvell: Add Marvell 88E1340 support
error: corrupt patch at line 40
