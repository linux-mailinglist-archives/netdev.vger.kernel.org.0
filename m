Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A527A24E14E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgHUTzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:55:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:62120 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbgHUTyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 15:54:14 -0400
IronPort-SDR: CMQ8kCqn4spD6VXHuxOq8O4gUROR4pzuVEFtlPkClC10CTFXfmTTQXmuxcdn+nRutUxn8xLng4
 7A50roCmysjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="219899755"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="219899755"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 12:54:12 -0700
IronPort-SDR: 076Of3LciIw7/GB5bOZ8fvDae1vsHWXBgPvifTvTdUci2onh/Q3cbkCwEeLN4S/dumQZGN6h1H
 k2ZiLLWvsMtQ==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="298043991"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 12:54:12 -0700
Date:   Fri, 21 Aug 2020 12:54:10 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: Re: [PATCH v6 net-next 00/10] qed: introduce devlink health support
Message-ID: <20200821125410.00005c08@intel.com>
In-Reply-To: <20200820185204.652-1-irusskikh@marvell.com>
References: <20200820185204.652-1-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> This is a followup implementation after series
> 
> https://patchwork.ozlabs.org/project/netdev/cover/20200514095727.1361-1-irusskikh@marvell.com/
> 
> This is an implementation of devlink health infrastructure.
> 
> With this we are now able to report HW errors to devlink, and it'll take
> its own actions depending on user configuration to capture and store the
> dump at the bad moment, and to request the driver to recover the device.
> 
> So far we do not differentiate global device failures or specific PCI
> function failures. This means that some errors specific to one physical
> function will affect an entire device. This is not yet fully designed
> and verified, will followup in future.
> 
> Solution was verified with artificial HW errors generated, existing
> tools for dump analysis could be used.
> 
> v6: patch 4: changing serial to board.serial and fw to fw.app
> v5: improved patch 4 description
> v4:
>  - commit message and other fixes after Jiri's comments
>  - removed one patch (will send to net)
> v3: fix uninit var usage in patch 11
> v2: fix #include issue from kbuild test robot.
> 

I think you're really close, please address the two patches I had
comments on and then I'd say you can add my Reviewed-by. 


