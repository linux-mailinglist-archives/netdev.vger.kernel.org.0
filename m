Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A156F5A9C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbfKHWL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:11:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:11:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF0D7153B4DC5;
        Fri,  8 Nov 2019 14:11:26 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:11:26 -0800 (PST)
Message-Id: <20191108.141126.499156209602458565.davem@davemloft.net>
To:     magnus.karlsson@intel.com
Cc:     bjorn.topel@intel.com, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH net 1/2] i40e: need_wakeup flag might not be set for Tx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
References: <1573243090-2721-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:11:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jeff, please pick these up.

Thanks.
