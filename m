Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF871C20D6
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgEAWmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgEAWmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:42:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C477C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:42:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B592414F9AF79;
        Fri,  1 May 2020 15:42:15 -0700 (PDT)
Date:   Fri, 01 May 2020 15:42:14 -0700 (PDT)
Message-Id: <20200501.154214.1513420460598704739.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: Re: [PATCH v2 net-next 0/4] Cross-chip bridging for disjoint DSA
 trees
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430202542.11797-1-olteanv@gmail.com>
References: <20200430202542.11797-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:42:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 30 Apr 2020 23:25:38 +0300

> This series adds support for boards where DSA switches of multiple types
> are cascaded together.
 ...

I'm expecting another respin of this once you sort out the symmetry
issues.
