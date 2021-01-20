Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3212FC7C3
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbhATCYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:24:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbhATCYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:24:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B55452251D;
        Wed, 20 Jan 2021 02:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611109434;
        bh=JIngvo/gLL0np8/0GdMsYcplKvOBUvSZQ6TQAwbmqik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ulq9oBEFLABNxyLpx4OC2BvM5iMkVgxvDCjF+A6jopPjnYsvqAJgQRl6qHYEiqyQB
         rXuY9rkUMQE3lWXdBoCo155flsKyuYoKZpFIS5hXtpXOqT2GWYv0oPcZMNip5LtFqm
         uniA8gje2cmCgC6vO+sonTxh8DGuAFalH2vrQPAZpcbIh4VtFMXQpj/cRAvO4MpHkR
         fFPHT0HtQQe28zZBd65lHIPRf32S1VF0kdFwa/znUITTrYQ0lajjgdUKnENNjc2NMw
         P8z43vxodkzeo2fRp7+BZJAFsjTBFPmw2YVv6FsKh6LpK1QA0+SBv1koxUrtD7orQs
         ZYuNBXPMJv+Hg==
Date:   Tue, 19 Jan 2021 18:23:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 6/8] igc: Add support for tuning frame
 preemption via ethtool
Message-ID: <20210119182352.17635829@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119004028.2809425-7-vinicius.gomes@intel.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
        <20210119004028.2809425-7-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 16:40:26 -0800 Vinicius Costa Gomes wrote:
> +		NL_SET_ERR_MSG(extack, "Invalid value for add-frag-size");

NL_SET_ERR_MSG_MOD
