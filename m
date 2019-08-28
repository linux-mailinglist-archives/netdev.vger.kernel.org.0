Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3D259F8B1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfH1DWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:22:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1DWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:22:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C53F8153B919B;
        Tue, 27 Aug 2019 20:22:18 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:22:18 -0700 (PDT)
Message-Id: <20190827.202218.1321124613646743040.davem@davemloft.net>
To:     marco.hartmann@nxp.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com
Subject: Re: [PATCH v2 net] Add genphy_c45_config_aneg() function to
 phy-c45.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827.202043.766506227116086877.davem@davemloft.net>
References: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
        <20190827.202043.766506227116086877.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:22:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 27 Aug 2019 20:20:43 -0700 (PDT)

> Applied to net-next.

My bad, applied to net and queued up for v5.2 -stable.
