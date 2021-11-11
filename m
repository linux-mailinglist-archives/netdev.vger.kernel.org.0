Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB0744DAC3
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhKKQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:52:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233867AbhKKQwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 11:52:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1D3B61264;
        Thu, 11 Nov 2021 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636649402;
        bh=51HV5mKQra9//QardxIsZThqAWeIEV0HwhilxwaGBn4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IceVoHjviKtrlOA5AThqARgr9Y9AehkaSzV17p2RO0oc8IrsRK9G7S6Za/z+BSLZD
         LbQXulzxt7vvzEf8PrVXEqE3D57WNtk8l2fTj942Bh/RiFNAROGbzB5Hak8c0uqi/C
         CYxu7dmpWE6ccczMhuMOi40PB2bAUqTBNMJ1LdxeBMFKusmRbA3pcj5WwjzhQEx9PI
         eW0DPYiD9+tH8lmgC3uiGSZqH5E6/FLd51x1uviJ76Pdj1bO+BC91OHFoOMmaReu5A
         OFTPwuEIQ0u6J1HL9DTBlq6HbTxCCed7zCbRYX09f4AVi1eZarRnfllH7amhjffruW
         l6ztzkELs2Bkw==
Date:   Thu, 11 Nov 2021 08:50:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     cgel.zte@gmail.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        kbuild-all@lists.01.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux] e1000e: Delete redundant variable definitions
Message-ID: <20211111085001.24b58b5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202111112246.M0trEfiC-lkp@intel.com>
References: <20211111090555.158828-1-luo.penghao@zte.com.cn>
        <202111112246.M0trEfiC-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 22:56:38 +0800 kernel test robot wrote:
> >> drivers/net/ethernet/intel/e1000e/e1000.h:31:20: error: 'hw' undeclared (first use in this function)  
>       31 |         netdev_dbg(hw->adapter->netdev, format, ## arg)

Yeah, the infinite wisdom of Intel drivers using macros with implicit
arguments :/

You should build test your patches, tho.
