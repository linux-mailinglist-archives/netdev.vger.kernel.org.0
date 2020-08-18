Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE9D248E56
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHRS6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgHRS6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:58:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE5EF206B5;
        Tue, 18 Aug 2020 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597777085;
        bh=k/vVNPuTXbs3t5Qi9TqGDtRXS9Go1NUeRpRBFN2Mg2w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UgwCyutnyVfYOCYmyBesZ9R8sKxMIvrR5EPgjkJVRDs4BKUph97jcgCB513ZV4AuJ
         FjjaOxKeg3M2X8a0ue48Yyi95p0kruodIEKNkN5jkvTbbgE2Of7bCpH4ynj8lWd9bw
         ubgsteI5+uBGXOEleqhab6PfdauEvmVfzCEe+ZOE=
Date:   Tue, 18 Aug 2020 11:58:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ooi, Joyce" <joyce.ooi@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v6 08/10] net: eth: altera: add support for ptp and
 timestamping
Message-ID: <20200818115803.5169d7a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818154613.148921-9-joyce.ooi@intel.com>
References: <20200818154613.148921-1-joyce.ooi@intel.com>
        <20200818154613.148921-9-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 23:46:11 +0800 Ooi, Joyce wrote:
> From: Dalon Westergreen <dalon.westergreen@intel.com>
> 
> Add support for the ptp clock used with the tse, and update
> the driver to support timestamping when enabled.  We also
> enable debugfs entries for the ptp clock to allow some user
> control and interaction with the ptp clock.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>

Please address the W=1 warning:

drivers/net/ethernet/altera/intel_fpga_tod.c:293:55: warning: Using plain integer as NULL pointer
