Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C702AF22B2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfKFXeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:34:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfKFXef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:34:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17F8A14FA6818;
        Wed,  6 Nov 2019 15:34:35 -0800 (PST)
Date:   Wed, 06 Nov 2019 15:34:32 -0800 (PST)
Message-Id: <20191106.153432.1145184423294304852.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] Bonding fixes for Ocelot switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105215014.12492-1-olteanv@gmail.com>
References: <20191105215014.12492-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 15:34:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  5 Nov 2019 23:50:12 +0200

> This series fixes 2 issues with bonding in a system that integrates the
> ocelot driver, but the ports that are bonded do not actually belong to
> ocelot.

Series applied and queued up for -stable.
