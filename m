Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A808F7213B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391941AbfGWVEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:04:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbfGWVEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:04:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AC9F153BF118;
        Tue, 23 Jul 2019 14:04:45 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:04:44 -0700 (PDT)
Message-Id: <20190723.140444.1126474066269131522.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     kai.heng.feng@canonical.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, aaron.f.brown@intel.com
Subject: Re: [net-next 6/6] e1000e: disable force K1-off feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723173650.23276-7-jeffrey.t.kirsher@intel.com>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
        <20190723173650.23276-7-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:04:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 23 Jul 2019 10:36:50 -0700

> diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
> index eff75bd8a8f0..e3c71fd093ee 100644
> --- a/drivers/net/ethernet/intel/e1000e/hw.h
> +++ b/drivers/net/ethernet/intel/e1000e/hw.h
> @@ -662,6 +662,7 @@ struct e1000_dev_spec_ich8lan {
>  	bool kmrn_lock_loss_workaround_enabled;
>  	struct e1000_shadow_ram shadow_ram[E1000_ICH8_SHADOW_RAM_WORDS];
>  	bool nvm_k1_enabled;
> +	bool disable_k1_off;
>  	bool eee_disable;

I don't see any code actually setting this boolean, how does it work?
