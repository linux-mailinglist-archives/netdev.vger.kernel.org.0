Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E86CD8322
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfJOWDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:03:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40812 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfJOWDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:03:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 445B8150F0C75;
        Tue, 15 Oct 2019 15:03:05 -0700 (PDT)
Date:   Tue, 15 Oct 2019 15:03:04 -0700 (PDT)
Message-Id: <20191015.150304.37567793624114718.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 0/2] mlxsw: Add support for 400Gbps (50Gbps
 per lane) link modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191012162758.32473-1-jiri@resnulli.us>
References: <20191012162758.32473-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 15:03:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 12 Oct 2019 18:27:56 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add 400Gbps bits to ethtool and introduce support in mlxsw. These modes
> are supported by the Spectrum-2 switch ASIC.

Series applied, thanks.
