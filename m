Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ACB33DEE1
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhCPUfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhCPUfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 292AF64F7B;
        Tue, 16 Mar 2021 20:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615926915;
        bh=rYPnOeemjC/NbCo/IqAWv9T9AP+wO0yQJEru9136Wj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHRYaE+TEK7p1EpiXviuwzmyutN+TBgorbv3Sa1cGxDepwZzhVLSuxFexFzhffFL/
         KIM+jdzetf3bohWSgKlEPxFuK3dbAr+Il+WI/yBrf1oL64OiG3WhWC278Eiz/C2rTD
         CYnWkknLDppv948R0OJLfK7TGgYg+3mgj4ElO/q4gIihG26VL0FzlJMpQ/CPWP7+QE
         KyF7rtob6ryh88DGEBMBchh4c9ku5Td7LBSvaapb/IRNtj6/hzA7Iam2QzX0/tl7xL
         gwwI2hlmpXHA1vS5NWPBfacFSMb5JkSNQOp62tU458jmCZqnVdknBqZvMRFytFOO1f
         8TwnxtfxVQY9Q==
Date:   Tue, 16 Mar 2021 13:35:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        kai.heng.feng@canonical.com, rjw@rjwysocki.net,
        len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        yu.c.chen@intel.com
Subject: Re: [PATCH net-next v2 0/2][pull request] 1GbE Intel Wired LAN
 Driver Updates 2021-03-15
Message-ID: <20210316133514.10b4fa2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
References: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 20:16:57 -0700 Tony Nguyen wrote:
> The NIC is put in runtime suspend status when there is no cable connected.
> As a result, it is safe to keep non-wakeup NIC in runtime suspended during
> s2ram because the system does not rely on the NIC plug event nor WoL to
> wake up the system. Besides that, unlike the s2idle, s2ram does not need to
> manipulate S0ix settings during suspend.
> 
> v2: remove __maybe_unused from e1000e_pm_prepare()

Thanks!

Acked-by: Jakub Kicinski <kuba@kernel.org>
