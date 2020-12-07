Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437CC2D1E45
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgLGXWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgLGXWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:22:48 -0500
Date:   Mon, 7 Dec 2020 15:22:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607383328;
        bh=wv8xR6yJxIIjebHMBmPqiXSKXoBduILUHwiJVvlS7W4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=o3NKFNDs2FYOHBrBPOtQ+HOvC178lfS1q8Qh8smrsmcTuXN73TMJfiAq6vkZ5tvba
         x1xYh5nYRi6tkWkIfmVZGsHFYIjdpXYPnGytEDLv/2qe2Bo29labfs6Hsou+j0LbId
         3QfP2ZFnrgPZ+QXPBLNgYEV/BAiKa9BEzvhi5ayc1ZsFYJE7tfY9QBxNNQKO1u2cZT
         2cuefMczjvsWKkNTHjpvG4f/RsABQyQHi/wU0y3Acvn1NiMlKeTjy3NlUBZ6XMeRlz
         EBI6rOHofJfnBfh6klm8glE82f26ozl+KN3240irULShn0U+KWE493m1OTUeNZaV+V
         6LGuRqK+XH6Og==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 6/9] igc: Add support for tuning frame
 preemption via ethtool
Message-ID: <20201207152207.0c0d6edd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <87a6up1cw2.fsf@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-7-vinicius.gomes@intel.com>
        <20201205100030.2e3c5dd2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87a6up1cw2.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Dec 2020 14:15:25 -0800 Vinicius Costa Gomes wrote:
> > WARNING: 'PREEMPTABLE' may be misspelled - perhaps 'PREEMPTIBLE'?  
> 
> In the datasheet the term PREEMPTABLE is used, and when refering to
> register values I chose to be consistent with the datasheet. But as the
> margin for confusion is small, I can change to use "preemptible"
> everywhere, no problem.

If there is a reason to it feel free to keep as is.
