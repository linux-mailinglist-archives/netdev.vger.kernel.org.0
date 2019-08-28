Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D009F9A4
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfH1E74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:59:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfH1E74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:59:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC768153C954B;
        Tue, 27 Aug 2019 21:59:55 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:59:55 -0700 (PDT)
Message-Id: <20190827.215955.401060732796152198.davem@davemloft.net>
To:     weifeng.voon@intel.com
Cc:     mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joabreu@synopsys.com,
        peppe.cavallaro@st.com, andrew@lunn.ch, alexandre.torgue@st.com,
        boon.leong.ong@intel.com
Subject: Re: [PATCH v1 net-next 0/4] Add EHL and TGL PCI info and PCI ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
References: <1566869891-29239-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 21:59:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Tue, 27 Aug 2019 09:38:07 +0800

> In order to keep PCI info simple and neat, this patch series have
> introduced a 3 hierarchy of struct. First layer will be the
> intel_mgbe_common_data struct which keeps all Intel common configuration.
> Second layer will be xxx_common_data which keeps all the different Intel
> microarchitecture, e.g tgl, ehl. The third layer will be configuration
> that tied to the PCI ID only based on speed and RGMII/SGMII interface.
> 
> EHL and TGL will also having a higher system clock which is 200Mhz.

Series applied.
