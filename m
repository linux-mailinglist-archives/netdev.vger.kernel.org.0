Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3291122745A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgGUBFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGUBFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:05:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD8BC061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:05:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7493E11FFC7FC;
        Mon, 20 Jul 2020 17:48:48 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:05:32 -0700 (PDT)
Message-Id: <20200720.180532.27170467390695676.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, richardcochran@gmail.com,
        jacob.e.keller@intel.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/2] Extend testptp with PTP perout waveform
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720175559.1234818-1-olteanv@gmail.com>
References: <20200720175559.1234818-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:48:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 20 Jul 2020 20:55:57 +0300

> Demonstrate the usage of the newly introduced flags in the
> PTP_PEROUT_REQUEST2 ioctl:
> 
> https://www.spinics.net/lists/netdev/msg669346.html

Series applied, thank you.
