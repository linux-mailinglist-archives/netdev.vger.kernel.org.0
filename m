Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0012CC786
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbgLBULn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:11:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbgLBULm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:11:42 -0500
Date:   Wed, 2 Dec 2020 14:11:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606939862;
        bh=ZStLK7wKntRm02Bqw/laVzgLBledV/u9Ab/YK1z07Vk=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=OG2DmvqtxBqytPwxrIdBVblA491YcuiJd9AjbOL8fwoQBOT4r0xKrqOG8b/Xn9WwO
         PJR4XUUOoiKk5ovDi3k1M+CEh8mMoP3XP2Bz5YcEZV7wXi8sZhiput85T+JQr0gtZj
         mtiLej7c6jIagbC4zEJiKS1e3FhS2ZTGsjYFzhC03nnnH3jAP4LCbsykIqTYZA3LCN
         r/DCF8KQFMbckmnmZWnbLsRzDz+Mrc4MlomXx/l5by7irDpsup89z9PfblBPYm6DeT
         6wlit8K2cuSstOLn0VNWkAMIq32u5K2w2FOVTdopeLYBxC8+cR+FWmxBZB77knS/1V
         PcrVnS5Apy7xw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com
Subject: Re: [PATCH v2 2/5] e1000e: Move all s0ix related code into it's own
 source file
Message-ID: <20201202201100.GA1466664@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202161748.128938-3-mario.limonciello@dell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/it's/its/ (in subject as well as below).

Previous patches used "S0ix", not "s0ix" (in subject as well as
below, as well as subject and commit log of 3/5 and 5/5).

On Wed, Dec 02, 2020 at 10:17:45AM -0600, Mario Limonciello wrote:
> Introduce a flag to indicate the device should be using the s0ix
> flows and use this flag to run those functions.

Would be nicer to have a move that does nothing else + a separate
patch that adds a flag so it's more obvious, but again, not my circus.

> Splitting the code to it's own file will make future heuristics
> more self containted.

s/containted/contained/

Bjorn
