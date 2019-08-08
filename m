Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9247A859CB
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfHHF3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:29:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:2630 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730857AbfHHF3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:29:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 22:29:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,360,1559545200"; 
   d="scan'208";a="374730250"
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.39.134])
  by fmsmga006.fm.intel.com with ESMTP; 07 Aug 2019 22:29:44 -0700
Date:   Wed, 7 Aug 2019 22:29:43 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     <jcliburn@gmail.com>, <davem@davemloft.net>,
        <chris.snook@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH 1/2] net: ag71xx: Slighly simplify code in
 'ag71xx_rings_init()'
Message-ID: <20190807222943.0000718b@intel.com>
In-Reply-To: <08fbcfe0f913644fe538656221a15790a1a83f1d.1564560130.git.christophe.jaillet@wanadoo.fr>
References: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
        <08fbcfe0f913644fe538656221a15790a1a83f1d.1564560130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 10:06:38 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> A few lines above, we have:
>    tx_size = BIT(tx->order);
> 
> So use 'tx_size' directly to be consistent with the way 'rx->descs_cpu' and
> 'rx->descs_dma' are computed below.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
