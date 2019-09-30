Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694A7C1B6D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfI3GZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:25:26 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:45618 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729521AbfI3GZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:25:26 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iEp7P-0008PC-DE; Mon, 30 Sep 2019 09:25:12 +0300
Message-ID: <933ba10a5deb8402067df224900c5f4bf573413b.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 30 Sep 2019 09:25:09 +0300
In-Reply-To: <20190913042331.27080-1-navid.emamdoost@gmail.com>
References: <20190913042331.27080-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-12 at 23:23 -0500, Navid Emamdoost wrote:
> In alloc_sgtable if alloc_page fails, the alocated table should be
> released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks, Navid! I have applied this to our internal tree and it will
reach the mainline following our usual upstreaming process.

--
Cheers,
Luca.

