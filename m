Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C820AEF94
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436785AbfIJQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 12:30:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436473AbfIJQaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 12:30:46 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85B94154F9E17;
        Tue, 10 Sep 2019 09:30:42 -0700 (PDT)
Date:   Tue, 10 Sep 2019 18:30:35 +0200 (CEST)
Message-Id: <20190910.183035.1659598063632819738.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net-next v2 00/11] nfp: implement firmware loading
 policy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 09:30:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Mon,  9 Sep 2019 00:54:16 +0100

> Dirk says:
> 
> This series adds configuration capabilities to the firmware loading policy of
> the NFP driver.
> 
> NFP firmware loading is controlled via three HWinfo keys which can be set per
> device: 'abi_drv_reset', 'abi_drv_load_ifc' and 'app_fw_from_flash'.
> Refer to patch #11 for more detail on how these control the firmware loading.
> 
> In order to configure the full extend of FW loading policy, a new devlink
> parameter has been introduced, 'reset_dev_on_drv_probe', which controls if the
> driver should reset the device when it's probed. This, in conjunction with the
> existing 'fw_load_policy' (extended to include a 'disk' option) provides the
> means to tweak the NFP HWinfo keys as required by users.
> 
> Patches 1 and 2 adds the devlink modifications and patches 3 through 9 adds the
> support into the NFP driver. Furthermore, the last 2 patches are documentation
> only.
> 
> v2:
>   Renamed all 'reset_dev_on_drv_probe' defines the same as the devlink parameter
>   name (Jiri)

Series applied, thanks Simon.
