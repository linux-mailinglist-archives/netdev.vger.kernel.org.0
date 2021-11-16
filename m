Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB26145347A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbhKPOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237552AbhKPOmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:42:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 410B163219;
        Tue, 16 Nov 2021 14:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637073584;
        bh=d6+65OYJUKCsgHGbaTtTYMHLr9Wx5QIVE074iYcpvMg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u5QorKBgCpyUN4e4hHV/j3/MpUdhkUSCteDC1qKlb8J4Xo1g8E/LwVqKkg59oEkD1
         j9WVOpHSY4strEvOmlI+5X1vLmNgVSRYsVZLg4/m5UZdNmYcSQsCmpJOVcfwJXq7fu
         RdNN+e2I0KufCmB3QmOuuq/bTZ0xBTDtf16GDNMT6BTz3dpoxeK/ru2YF0TbHorjc2
         B+wmn5zFnuchtCCf6DmAz4P28A85RmQ/wqUqg+GlIOb7H1WUuL+4aDdT6VLVANcWOr
         uoVbnxmGu8onp1xVbXOunSKwLgulQjtd78CjlUoMf0cDYrQQkYD6e1RVsfC85TG8O8
         JH6dx0c5iv+PQ==
Date:   Tue, 16 Nov 2021 06:39:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     kernel test robot <lkp@intel.com>, davem@davemloft.net,
        llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net 1/3] bnxt_en: extend RTNL to VF check in devlink
 driver_reinit
Message-ID: <20211116063943.7aa27c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202111160027.hFgVPM0z-lkp@intel.com>
References: <1636961881-17824-2-git-send-email-michael.chan@broadcom.com>
        <202111160027.hFgVPM0z-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 00:30:34 +0800 kernel test robot wrote:
> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c:445:48: error: no member named 'sriov_cfg' in 'struct bnxt'  
>                    if (BNXT_PF(bp) && (bp->pf.active_vfs || bp->sriov_cfg)) {
>                                                             ~~  ^

Hi Michael, is this a false positive? Is the fix coming?
