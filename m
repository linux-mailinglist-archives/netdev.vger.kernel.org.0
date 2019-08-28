Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973CDA0E0F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfH1XI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:08:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38510 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfH1XI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:08:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1F48153B0C7D;
        Wed, 28 Aug 2019 16:08:27 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:08:27 -0700 (PDT)
Message-Id: <20190828.160827.2152520278672406476.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [PATCH net 0/2] nfp: flower: fix bugs in merge tunnel encap
 code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828055630.17331-1-jakub.kicinski@netronome.com>
References: <20190828055630.17331-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 16:08:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 27 Aug 2019 22:56:28 -0700

> John says:
> 
> There are few bugs in the merge encap code that have come to light with
> recent driver changes. Effectively, flow bind callbacks were being
> registered twice when using internal ports (new 'busy' code triggers
> this). There was also an issue with neighbour notifier messages being
> ignored for internal ports.

Series applied and queued up for v5.2 -stable, thanks.
