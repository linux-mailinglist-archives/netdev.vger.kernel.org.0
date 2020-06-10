Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25CD1F5EB0
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgFJX3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgFJX3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:29:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C2BC03E96B;
        Wed, 10 Jun 2020 16:29:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A66FF11F5F667;
        Wed, 10 Jun 2020 16:29:02 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:29:01 -0700 (PDT)
Message-Id: <20200610.162901.2096273100044042523.davem@davemloft.net>
To:     noodles@earth.li
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/2] net: dsa: qca8k: Improve SGMII interface
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1591816172.git.noodles@earth.li>
References: <20200606105909.GN311@earth.li>
        <20200608183953.GR311@earth.li>
        <cover.1591816172.git.noodles@earth.li>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 16:29:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please, when you post an RFC patch set, put "RFC" into the Subject lines
of the patches as well as the introductory posting.

This helps me categorize changes properly in patchwork.

Thank you.
