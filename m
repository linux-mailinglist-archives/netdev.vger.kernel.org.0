Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6461F2B952
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 19:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfE0RJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 13:09:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59732 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfE0RJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 13:09:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3371D14FF9883;
        Mon, 27 May 2019 10:09:06 -0700 (PDT)
Date:   Mon, 27 May 2019 10:09:05 -0700 (PDT)
Message-Id: <20190527.100905.243238262400642258.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190527033110.9861-1-liuhangbin@gmail.com>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 May 2019 10:09:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon, 27 May 2019 11:31:10 +0800

> Like bond, add ethtool get_link_ksettings to show the total speed.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Yeah, this mirrors what bonding does.

Jiri, please review.
