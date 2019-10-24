Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5673E2806
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408011AbfJXCSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:18:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406401AbfJXCSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 22:18:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4705314B6823D;
        Wed, 23 Oct 2019 19:18:31 -0700 (PDT)
Date:   Wed, 23 Oct 2019 19:18:30 -0700 (PDT)
Message-Id: <20191023.191830.347702095940587406.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH v5 0/2] mv88e6xxx: Allow config of ATU hash algorithm
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191022013436.29635-1-andrew@lunn.ch>
References: <20191022013436.29635-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 19:18:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrew, this only applies to 'net' but it feels more like a feature
to me.

Please give me some guidance and use [PATCH net-next .. ] in the future.

Thanks.
