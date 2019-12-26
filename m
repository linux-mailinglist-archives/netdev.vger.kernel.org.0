Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB3B12AA18
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 04:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLZDvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 22:51:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37360 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLZDvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 22:51:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 441E1154141AB;
        Wed, 25 Dec 2019 19:51:52 -0800 (PST)
Date:   Wed, 25 Dec 2019 19:51:51 -0800 (PST)
Message-Id: <20191225.195151.1515066361114222949.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacob.e.keller@intel.com, jakub.kicinski@netronome.com,
        mark.rutland@arm.com, mlichvar@redhat.com, m-karicheri2@ti.com,
        robh+dt@kernel.org, willemb@google.com, w-kwok2@ti.com
Subject: Re: [PATCH V9 net-next 00/12] Peer to Peer One-Step time stamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 19:51:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Wed, 25 Dec 2019 18:16:08 -0800

> This series adds support for PTP (IEEE 1588) P2P one-step time
> stamping along with a driver for a hardware device that supports this.

Series applied, will push out after build testing.

Thanks.
