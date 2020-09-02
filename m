Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0C25B4C1
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIBTut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBTus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:50:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA0EC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 12:50:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FD3D15633C04;
        Wed,  2 Sep 2020 12:34:01 -0700 (PDT)
Date:   Wed, 02 Sep 2020 12:50:46 -0700 (PDT)
Message-Id: <20200902.125046.1982291852377954168.davem@davemloft.net>
To:     Shyam-sundar.S-k@amd.com
Cc:     thomas.lendacky@amd.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: Add support for new port mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200902092807.2412071-1-Shyam-sundar.S-k@amd.com>
References: <20200902092807.2412071-1-Shyam-sundar.S-k@amd.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 12:34:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Date: Wed,  2 Sep 2020 09:28:07 +0000

> Add support for a new port mode that is a backplane connection without
> support for auto negotiation.
> 
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Applied, thank you.
