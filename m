Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58DAFF812E
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfKKU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:26:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfKKU0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:26:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8469153D45BA;
        Mon, 11 Nov 2019 12:25:59 -0800 (PST)
Date:   Mon, 11 Nov 2019 12:25:57 -0800 (PST)
Message-Id: <20191111.122557.1883926638228518772.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Unlock new potential in SJA1105 with PTP
 system timestamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hpaaDbnq9dXWj9sRwgExP304DrbghPTHGttyc=izkMncA@mail.gmail.com>
References: <20191109113224.6495-1-olteanv@gmail.com>
        <20191109151942.GA1537@localhost>
        <CA+h21hpaaDbnq9dXWj9sRwgExP304DrbghPTHGttyc=izkMncA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 12:26:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 11 Nov 2019 15:19:26 +0200

> David, I noticed you put these patches in Patchwork in the 'Needs
> Review / ACK' state. Do you need more in-depth review, or did you just
> miss Richard's tag, since Patchwork ignores them if they're posted on
> the cover letter?

Nothing needs to happen, I will take care of this series and apply it.

Thanks.
