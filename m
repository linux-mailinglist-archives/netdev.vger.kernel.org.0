Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049AD381C3
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfFFXYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:24:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFFXYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:24:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 689C614E7899B;
        Thu,  6 Jun 2019 16:24:50 -0700 (PDT)
Date:   Thu, 06 Jun 2019 16:24:47 -0700 (PDT)
Message-Id: <20190606.162447.996092716635696388.davem@davemloft.net>
To:     hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, anirudh@xilinx.com, John.Linn@xilinx.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next v5 00/20] Xilinx axienet driver updates (v5)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
References: <1559860104-927-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 16:24:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>
Date: Thu,  6 Jun 2019 16:28:04 -0600

> This is a series of enhancements and bug fixes in order to get the mainline
> version of this driver into a more generally usable state, including on
> x86 or ARM platforms. It also converts the driver to use the phylink API
> in order to provide support for SFP modules.
> 
> Changes since v4:
> -Use reverse christmas tree variable order

Series applied, thanks.
