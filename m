Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C66F46370
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfFNPz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:55:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45480 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfFNPz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:55:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A32414B8C96F;
        Fri, 14 Jun 2019 08:55:27 -0700 (PDT)
Date:   Fri, 14 Jun 2019 08:55:26 -0700 (PDT)
Message-Id: <20190614.085526.2102172573025775357.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190614083225.GE2242@nanopsycho>
References: <20190528112431.GA2252@nanopsycho>
        <20190613061648.GE18865@dhcp-12-139.nay.redhat.com>
        <20190614083225.GE2242@nanopsycho>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 08:55:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri, 14 Jun 2019 10:32:25 +0200

> Long story short, I'm okay with your patch. Thanks!

This patch should therefore be reposted.
