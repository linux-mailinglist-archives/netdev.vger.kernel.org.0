Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2902D16B2D
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEGTUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 15:20:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfEGTUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 15:20:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD22F14B752EA;
        Tue,  7 May 2019 12:20:03 -0700 (PDT)
Date:   Tue, 07 May 2019 12:20:03 -0700 (PDT)
Message-Id: <20190507.122003.2228959889232131549.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] vrf: sit mtu should not be updated when vrf netdev
 is the link
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190506190001.6567-1-ssuryaextr@gmail.com>
References: <20190506190001.6567-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 May 2019 12:20:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Mon,  6 May 2019 15:00:01 -0400

> VRF netdev mtu isn't typically set and have an mtu of 65536. When the
> link of a tunnel is set, the tunnel mtu is changed from 1480 to the link
> mtu minus tunnel header. In the case of VRF netdev is the link, then the
> tunnel mtu becomes 65516. So, fix it by not setting the tunnel mtu in
> this case.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Applied and queued up for -stable.
