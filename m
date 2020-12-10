Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0069A2D6982
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393846AbgLJVPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:15:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45452 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729382AbgLJVPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:15:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 96F1B4D2ED6E6;
        Thu, 10 Dec 2020 13:15:11 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:15:11 -0800 (PST)
Message-Id: <20201210.131511.281381112212499584.davem@davemloft.net>
To:     anthony.l.nguyen@intel.com
Cc:     kuba@kernel.org, sasha.neftin@intel.com, netdev@vger.kernel.org,
        sassmann@redhat.com, aaron.f.brown@intel.com
Subject: Re: [PATCH net-next] igc: Add new device ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210190812.413143-1-anthony.l.nguyen@intel.com>
References: <20201210190812.413143-1-anthony.l.nguyen@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 13:15:11 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Thu, 10 Dec 2020 11:08:12 -0800

> From: Sasha Neftin <sasha.neftin@intel.com>
> 
> Add new device ID for the next step of the silicon and
> reflect the I226_K part.
> 
> Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>
Applied.
