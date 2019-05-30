Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109F730265
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfE3SzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:55:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfE3SzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:55:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1A1114D9DD5B;
        Thu, 30 May 2019 11:55:07 -0700 (PDT)
Date:   Thu, 30 May 2019 11:55:07 -0700 (PDT)
Message-Id: <20190530.115507.1344606945620280103.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, robh+dt@kernel.org,
        willemb@google.com
Subject: Re: [PATCH V4 net-next 0/6] Peer to Peer One-Step time stamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1559109076.git.richardcochran@gmail.com>
References: <cover.1559109076.git.richardcochran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:55:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Tue, 28 May 2019 22:58:01 -0700

> This series adds support for PTP (IEEE 1588) P2P one-step time
> stamping along with a driver for a hardware device that supports this.
> 
> If the hardware supports p2p one-step, it subtracts the ingress time
> stamp value from the Pdelay_Request correction field.  The user space
> software stack then simply copies the correction field into the
> Pdelay_Response, and on transmission the hardware adds the egress time
> stamp into the correction field.
> 
> This new functionality extends CONFIG_NETWORK_PHY_TIMESTAMPING to
> cover MII snooping devices, but it still depends on phylib, just as
> that option does.  Expanding beyond phylib is not within the scope of
> the this series.
> 
> User space support is available in the current linuxptp master branch.
> 
> - Patch 1 adds the new option.
> - Patches 2-5 add support for MII time stamping in non-PHY devices.
> - Patch 6 adds a driver implementing the new option.

Series applied, thanks Richard.
