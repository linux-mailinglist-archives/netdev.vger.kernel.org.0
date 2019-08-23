Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143039A748
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392191AbfHWFws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 01:52:48 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:38260 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392163AbfHWFws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 01:52:48 -0400
X-Greylist: delayed 2505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2019 01:52:47 EDT
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i11qf-0003ji-VH; Fri, 23 Aug 2019 08:10:54 +0300
Message-ID: <df4c42b44950c8d145479ade68786335f9d0526c.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Colin King <colin.king@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Aug 2019 08:10:52 +0300
In-Reply-To: <20190801164419.3439-1-colin.king@canonical.com>
References: <20190801164419.3439-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iwlwifi: remove redundant assignment to variable bufsz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-01 at 17:44 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable bufsz is being initialized with a value that is never
> read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Thanks! I applied this to our internal tree and it will reach the
mainline following our usual upstreaming process.

--
Cheers,
Luca.

