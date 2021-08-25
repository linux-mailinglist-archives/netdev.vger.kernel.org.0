Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA53F7BA5
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhHYRmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhHYRmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 13:42:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C273B610E8;
        Wed, 25 Aug 2021 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629913323;
        bh=GsUdoS3jLj07nvT77o5ndGgkfKL8qFEyXMG5tHrmCYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1ibAxxb8dAmcsNNKLKyIbKR2Xg9d/mRzIQHdYyFk7JpE1IcXSSHWUev/SLfNCAdz
         2HdQln9dW4wpRyFJEN4Lkk6O43lTka87faB6GsPv/1KeFyQ72ApuP4xgdcG1uHZvw/
         70ISt4kFr/weeqZXzJviidRCkZHwelPuJ6lt27S4eKXmqNQoXVHmphp4/QBdkcjR7o
         6oP9QgomrxolDGi8oPgGebhCwPo9QgGNJd/k6ZF01Ioq7syDJg9Ss8ePN5Z56Gc6nR
         0LvmjdxP8r6ZwOWJ4nr6Saw6Bkqv5vJ7sQRoIfnAdrVRRreZGE9L0FrA15DSQFftBj
         M5PMTaaBkFHcA==
Date:   Wed, 25 Aug 2021 10:42:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gilad Naaman <gnaaman@drivenets.com>
Cc:     davem@davemloft.net, luwei32@huawei.com, wangxiongfeng2@huawei.com,
        ap420073@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3] net-next: When a bond have a massive amount of VLANs
 with IPv6 addresses, performance of changing link state, attaching a VRF,
 changing an IPv6 address, etc. go down dramtically.
Message-ID: <20210825104202.5ae4337f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819071727.1257434-1-gnaaman@drivenets.com>
References: <20210819071727.1257434-1-gnaaman@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please repost with the subject fixed.

It should be something like:

[PATCH net-next v4] net: maintain rbtree of device hw addresses

not the first sentence of the commit message.
