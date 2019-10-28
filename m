Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D196E7A4B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfJ1Ujx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Oct 2019 16:39:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44664 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJ1Ujx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:39:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A81BD14B79ED3;
        Mon, 28 Oct 2019 13:39:52 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:39:52 -0700 (PDT)
Message-Id: <20191028.133952.1976538256995008859.davem@davemloft.net>
To:     michal.vokac@ysoft.com
Cc:     vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: qca8k: Initialize the switch with
 correct number of ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
References: <1571924818-27725-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:39:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Vok·Ë <michal.vokac@ysoft.com>
Date: Thu, 24 Oct 2019 15:46:58 +0200

> Since commit 0394a63acfe2 ("net: dsa: enable and disable all ports")
> the dsa core disables all unused ports of a switch. In this case
> disabling ports with numbers higher than QCA8K_NUM_PORTS causes that
> some switch registers are overwritten with incorrect content.
> 
> To fix this, initialize the dsa_switch->num_ports with correct number
> of ports.
> 
> Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
> Signed-off-by: Michal Vok·Ë <michal.vokac@ysoft.com>

Applied.
