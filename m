Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2F859CD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 07:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbfHHFaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 01:30:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:57046 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730505AbfHHFaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 01:30:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 22:30:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,360,1559545200"; 
   d="scan'208";a="374730476"
Received: from jbrandeb-mobl2.amr.corp.intel.com (HELO localhost) ([10.254.39.134])
  by fmsmga006.fm.intel.com with ESMTP; 07 Aug 2019 22:30:05 -0700
Date:   Wed, 7 Aug 2019 22:30:04 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     <jcliburn@gmail.com>, <davem@davemloft.net>,
        <chris.snook@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH 2/2] net: ag71xx: Use GFP_KERNEL instead of GFP_ATOMIC
 in 'ag71xx_rings_init()'
Message-ID: <20190807223004.00001947@intel.com>
In-Reply-To: <75ee52ae065ce9cb1f32d88939b166773316dc45.1564560130.git.christophe.jaillet@wanadoo.fr>
References: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
        <75ee52ae065ce9cb1f32d88939b166773316dc45.1564560130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 10:06:48 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> There is no need to use GFP_ATOMIC here, GFP_KERNEL should be enough.
> The 'kcalloc()' just a few lines above, already uses GFP_KERNEL.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
