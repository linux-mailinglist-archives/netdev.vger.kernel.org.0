Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E45455E83
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhKROux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:50:53 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:17159 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhKROux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1637246873; x=1668782873;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ooc+9ajbFTu8Zm2ebiyDnY2oS/xRRKmFnMNQRhlZffs=;
  b=q9S7pnG96kPhTK7kfiImYUe05JKg+/tE6d1JnwkvuAzmv8hoLsz+4qyn
   v1eN4FDpxGngtn4uRF7uC/i+TGEI/YkCytW1tdONfnln4cWgMCJoz3/hw
   Kj/EvXL9CIte8C70BGC23j9PQMC4/bJQlMFiJwNyc4wSm+U7m9PK8jsI5
   C/sFi2RAl4rF3QU43ctmALLpLukCYUiThfGCpMD1gYKKBArD7FM1YzAHI
   lgNsSmbk+b1yyDIvFiKhq0LXQ6B3cSEphNWVtAEDtNbVcCZRt6W069rNi
   xDVPKoYRbObk9kZVbZvuLUss/jrWETdP861jQ1zjwUYE/aFt59WOjeGJw
   A==;
X-IronPort-AV: E=Sophos;i="5.87,245,1631570400"; 
   d="scan'208";a="20545537"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 18 Nov 2021 15:47:52 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 18 Nov 2021 15:47:52 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 18 Nov 2021 15:47:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1637246872; x=1668782872;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ooc+9ajbFTu8Zm2ebiyDnY2oS/xRRKmFnMNQRhlZffs=;
  b=fqnNGU12oPlc4efoN99xDo6coQd1LUMUOvWXqutBzKveKEImrXBpuSUy
   H9g2qaxIzQySASSIedGt6G/xiUU6cG83d2A3v7nXGljSMYQ8ecqqbcGcc
   pmAxmT0IQEP00Ukdl7PwAeV6I4Qix9LZsP5E2Q/tKSJ2iplwhXGGKzhoZ
   RAquUJwU+0MB3OKqGAdkkP1BjudG9AbR/L4A3mnRoB7SGVsvlvr4+zjqI
   vM/arFSK+fdeaWQDtA+y7Kw10yeZx3cai5SmCbUtXJKulzlskq1KBAd0G
   9tTkfL71NCKhtVnEXYYGNbtXbKhb6/hRSkkLhxdbS3Go2S/xWJrsQn5JG
   g==;
X-IronPort-AV: E=Sophos;i="5.87,245,1631570400"; 
   d="scan'208";a="20545536"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 18 Nov 2021 15:47:52 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 75326280065;
        Thu, 18 Nov 2021 15:47:50 +0100 (CET)
Message-ID: <c17640ea3468b78ffe1f073f0a0c51ddfe89836f.camel@ew.tq-group.com>
Subject: Re: [PATCH net 0/4] Fix bit timings for m_can_pci (Elkhart Lake)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date:   Thu, 18 Nov 2021 15:47:47 +0100
In-Reply-To: <72489ea7-cf81-2446-3620-06a98f53ce54@linux.intel.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
         <e38eb4ca0a03c60c8bbeccbd8126ffc5bf97d490.camel@ew.tq-group.com>
         <72489ea7-cf81-2446-3620-06a98f53ce54@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-17 at 14:14 +0200, Jarkko Nikula wrote:
> Hi
> 
> On 11/16/21 3:58 PM, Matthias Schiffer wrote:
> > I just noticed that m_can_pci is completely broken on 5.15.2, while
> > it's working fine on 5.14.y.
> > 
> 
> Hmm.. so that may explain why I once saw candump received just zeroes on 
> v5.15-rc something but earlier kernels were ok. What's odd then next 
> time v5.15-rc was ok so went blaming sun spots instead of bisecting.
> 
> > I assume something simliar to [1] will be necessary in m_can_pci as
> > well, however I'm not really familiar with the driver. There is no
> > "mram_base" in m_can_plat_pci, only "base". Is using "base" with
> > iowrite32/ioread32 + manual increment the correct solution here?
> > 
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=99d173fbe8944861a00ebd1c73817a1260d21e60
> > 
> 
> If your test case after 5.15 reliably fails are you able to bisect or 
> check does the regression originate from the same commit?
> 
> Jarkko

The Fixes tag of 99d173fbe894 ("can: m_can: fix iomap_read_fifo() and
iomap_write_fifo()") is off AFAICT, the actual breakage happened with
812270e5445b ("can: m_can: Batch FIFO writes during CAN transmit") and
1aa6772f64b4 ("can: m_can: Batch FIFO reads during CAN receive");
reverting these two patches fixes the regression.

I just sent a patch for m_can_pci that applies the same fix that was
done in m_can_platform in 99d173fbe894, and verified that this makes
CAN communication work on Elkhart Lake with Linux 5.15.y together with
my other patches.

Matthias

