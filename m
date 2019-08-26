Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE28B9CF7B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 14:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfHZMVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 08:21:10 -0400
Received: from mail.nic.cz ([217.31.204.67]:58432 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbfHZMVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 08:21:09 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id E944C140B28;
        Mon, 26 Aug 2019 14:21:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566822068; bh=fhrq1RQCyq9lJwWOcVea8IAJ8dFyBUseB4/cMNCq7XQ=;
        h=Date:From:To;
        b=KaWeZ1WnSHadDILVwoxX715jLzswty4fHIV5LalLQiR3OA7XSwNKcvmAVqfiQgZpY
         2iGKTVSFBMKFtICiXLIJjOLH8p8vPDTAh6p8kDzUuLLtkA8OzN5LrTM6TINFTDRF8s
         pog/fkJ/4ReAt8SPZ+DmlMsMLzsoSokrf0i/hrYk=
Date:   Mon, 26 Aug 2019 14:21:07 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 3/6] net: dsa: mv88e6xxx: create
 serdes_get_lane chip operation
Message-ID: <20190826142107.092b7f08@nic.cz>
In-Reply-To: <20190825121214.GJ6729@t480s.localdomain>
References: <20190825035915.13112-1-marek.behun@nic.cz>
        <20190825035915.13112-4-marek.behun@nic.cz>
        <20190825121214.GJ6729@t480s.localdomain>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Aug 2019 12:12:14 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> In fact you're also relying on -ENODEV, which is what you return here (and in
> other places) instead of 0. So I'm afraid you have to address my comment now...

Vivien, you are right. I returned -ENODEV for Peridot when no lane was
to be on port. It should return 0.
I am sending v4 now with this corrected, and tested on Turris Mox with
combinations Peridot, Topaz and Peridot + Topaz.

Marek
