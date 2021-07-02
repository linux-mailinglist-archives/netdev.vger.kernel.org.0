Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D75F3BA4CF
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhGBUth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:49:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38266 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhGBUtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 16:49:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E78364D252307;
        Fri,  2 Jul 2021 13:47:02 -0700 (PDT)
Date:   Fri, 02 Jul 2021 13:47:02 -0700 (PDT)
Message-Id: <20210702.134702.1259586523365258193.davem@davemloft.net>
To:     i.mikhaylov@yadro.com
Cc:     kuba@kernel.org, sam@mendozajonas.com, joel@jms.id.au,
        benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH 0/2] Add NCSI Intel OEM command to keep PHY link up on
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210702112519.76385-1-i.mikhaylov@yadro.com>
References: <20210702112519.76385-1-i.mikhaylov@yadro.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 02 Jul 2021 13:47:03 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Mikhaylov <i.mikhaylov@yadro.com>
Date: Fri, 2 Jul 2021 14:25:17 +0300

> Add NCSI Intel OEM command to keep PHY link up and prevents any channel
> resets during the host load. Also includes dummy response handler for Intel
> manufacturer id.

Please fix the warnings found by:

https://patchwork.hopto.org/static/nipa/510079/12355969/build_32bit/stderr

Thank you.
