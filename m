Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76102E9CF5
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 19:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbhADSX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 13:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbhADSX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 13:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C2282075E
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609784567;
        bh=31SNZIqyUY1TyqAxxsB011lU/MSiVtnj6ArB2ICHNHY=;
        h=Date:From:To:Subject:From;
        b=q60ggLv2+/gb8rqm6nnJRbSbVTUM/gWK7++ZUZJ8AyYEb6V0mD1tmWHbAIyY/p73L
         jvltEDvusi/4lqmUuJbuOsqF6IaO99aR4bBZPLdk1Y6jIvgtFefF6lUY7TqZlvVieN
         U2FTBKS7ND+dWYA/9CuhLNzH6hMmyI1IS/ZHxyX3xrZKAhFCKvybivxKOJR04w3iZT
         tirHEGf96iFAcwpe7ccGYUbiusFQu//IywiynzIsjgoOg3WtZ+45Lzt3bEDzqbwLP1
         tvbcRD5PIelchYdPdfSJCGerCvTLDP+oMAh3+uU9+j6fN9kwcOETYXBKKL0rIaAmJg
         xbGdiE8hMO7Dg==
Received: by pali.im (Postfix)
        id ECC797F0; Mon,  4 Jan 2021 19:22:44 +0100 (CET)
Date:   Mon, 4 Jan 2021 19:22:40 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] igmpproxy 0.3
Message-ID: <20210104182240.ezdyv2gtbm575tnv@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello! I would like to announce a new version of igmpproxy 0.3

https://github.com/pali/igmpproxy/releases/tag/0.3

Changes since previous version:
* Show error message when maximum number of multicast groups were
  exceeded and hint for linux systems how to increase this limit
* Improve downstream host tracking for quickleave mode via hashing table
  with MurmurHash3 hash function and pseudorandom seed
* Fix compilation on FreeBSD
* Use only one mrouter socket also for sending join/leave messages to
  upstream router
