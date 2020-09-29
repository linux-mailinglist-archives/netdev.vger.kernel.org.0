Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD41427D1B5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgI2Oqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbgI2Oqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 10:46:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA86A20757;
        Tue, 29 Sep 2020 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601390811;
        bh=yvr2LgsHeBUwSehSCkpozDO4/RLdGtxAV4HSyubV94U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qEfNVEM9+Z4Mb9+EzqtVs2JmMYvIn4nCCpbfrAlZc6t1qPalo0cdGRzDm3C3qxwdY
         WJvdfyN9VJzu44y09ood3U6VgMcIJZ/s4SZ56x2goRSRQ4lhpXHh3stBLn0vhzMMd5
         g58JNfhMWV51krwc+8JjocdONxkrpLjXR2cZMnfE=
Date:   Tue, 29 Sep 2020 07:46:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Howard Chung <howardchung@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, mmandlik@chromium.org, alainm@chromium.org,
        mcchou@chromium.org, "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 4/4] Bluetooth: Add toggle to switch off interleave
 scan
Message-ID: <20200929074649.20dfda35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929192508.v7.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
References: <20200929192508.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
        <20200929192508.v7.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Sep 2020 19:25:26 +0800 Howard Chung wrote:
> This patch add a configurable parameter to switch off the interleave
> scan feature.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>

One more:

net/bluetooth/mgmt_config.c:79:17: warning: incorrect type in initializer (different base types)
net/bluetooth/mgmt_config.c:79:17:    expected restricted __le16 [usertype] type
net/bluetooth/mgmt_config.c:79:17:    got int
