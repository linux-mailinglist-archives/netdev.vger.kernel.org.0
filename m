Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6BA0DAE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfH1WkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:40:16 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:42872 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfH1WkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:40:16 -0400
Received: by mail-ed1-f50.google.com with SMTP id m44so1748021edd.9
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 15:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oQVbJsEh+YX42zALAgnv+XyVyPpRC0+3XvOuDWZEhSw=;
        b=JTgRn/1jw0VBnXKoyHBj7ly0tvKmrQddlH5dTTVtuZRQGDLvH11oIF8WQUWX95dxLE
         m66Hkmpv1dEb7uUbaj/4R/9PJXbDhQyolWgJoUy2oSUr2uuuPWd9nFfxBxrCEEWmHU1u
         XZiSaRo+mUp8LMhxvvZFy0Pr1fy43q8y+2STQblozCwpEdNCNwKFliRJ1JxdhSH08aCu
         C3ohtMWZyUY+QihC6HJ4MoIbcqBio4RCWKtsAm/WK1NWJ2aKnEQeaYWE8aiHtrKoE1O7
         fO1DAoW4SsxPtAiKLfBW5M5ZzHggA6Ip4x7BPRjVflVIaC9feoaxnniqRpZPwOtPPHm8
         C2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oQVbJsEh+YX42zALAgnv+XyVyPpRC0+3XvOuDWZEhSw=;
        b=J5Zil9U2DbvobMDC7mLrPaPMSGRS3bhY/wo6AfwXYKVBuGStatuMbeGAKopSAjeiQp
         Bh6vxBLg4auFyXzYNlYOXxghJgA9EeNFS9qahZGnR3QGUrr48rNizPYoopynIMtV5bnb
         6cwhtyDYre47WFB19UjNeKmaAtfQGDl39uIIVtVjM/sD2KkIIBdiwl2bKlILKoKTUtlL
         KJ1SiMZMHQ3M6XKTuCG7DnSKTA5qNL63Bo4gaxeMeQhxiiKVmVFWZUnbYocVHhLpNJrQ
         IspCtTA6vWYNXZKeF9NVrvd3+Ts6IhqC4N7Y3NAhlPfraQa3yt44S7qGD/2sFQiusOwm
         BOkg==
X-Gm-Message-State: APjAAAVwLF91EQN0cugNF15PayfTl4gvQzlbvQ73KbT/yFmeUFyocn0c
        6tZqj30Dsijn/RpnzHbnpcoxww==
X-Google-Smtp-Source: APXvYqw47F2iCCVdtWOAlY9qLvA8wK2iRYXqwr0ZCCnp9CWKpP9KUU24EzTi5v0IxyZo+np4RdMzmQ==
X-Received: by 2002:a17:906:305b:: with SMTP id d27mr5156814ejd.311.1567032014819;
        Wed, 28 Aug 2019 15:40:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a16sm95788ejr.10.2019.08.28.15.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 15:40:14 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:39:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 11/15] i40e: Implement debug macro hw_dbg using
 pr_debug
Message-ID: <20190828153936.57ababbc@cakuba.netronome.com>
In-Reply-To: <20190828064407.30168-12-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
        <20190828064407.30168-12-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 23:44:03 -0700, Jeff Kirsher wrote:
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
> index a07574bff550..c0c9ce3eab23 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
> @@ -18,7 +18,12 @@
>   * actual OS primitives
>   */
>  
> -#define hw_dbg(hw, S, A...)	do {} while (0)
> +#define hw_dbg(hw, S, A...)							\
> +do {										\
> +	int domain = pci_domain_nr(((struct i40e_pf *)(hw)->back)->pdev->bus);	\
> +	pr_debug("i40e %04x:%02x:%02x.%x " S, domain, (hw)->bus.bus_id,		\
> +		 (hw)->bus.device, (hw)->bus.func, ## A);			\

This looks like open coded dev_dbg() / dev_name(), why?

> +} while (0)
