Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA744985E5
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbfHUUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 16:50:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbfHUUuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 16:50:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E31914D63A64;
        Wed, 21 Aug 2019 13:50:12 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:50:11 -0700 (PDT)
Message-Id: <20190821.135011.1257032842236120286.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/1] pull request for net: batman-adv 2019-08-21
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821133015.12778-1-sw@simonwunderlich.de>
References: <20190821133015.12778-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 13:50:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Wed, 21 Aug 2019 15:30:14 +0200

> here is a pull request with Erics bugfix from last week which we would
> like to have integrated into net. We didn't get anything else, so it's
> a short one this time. :)
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
