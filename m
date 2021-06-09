Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B003E3A0D51
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 09:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhFIHNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 03:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbhFIHNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 03:13:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22203C06175F;
        Wed,  9 Jun 2021 00:11:50 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lqsNO-0047ZF-NQ; Wed, 09 Jun 2021 09:11:46 +0200
Message-ID: <3ec0432ac974be9d4d2e246fc22538b76854e9ec.camel@sipsolutions.net>
Subject: Re: [PATCH V4 00/16] net: iosm: PCIe Driver for Intel M.2 Modem
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>, m.chetan.kumar@intel.com
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Date:   Wed, 09 Jun 2021 09:11:45 +0200
In-Reply-To: <20210608.160028.2094273846699936083.davem@davemloft.net>
References: <20210608170449.28031-1-m.chetan.kumar@intel.com>
         <20210608.160028.2094273846699936083.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-06-08 at 16:00 -0700, David Miller wrote:
> 
> drivers/net/wwan/iosm/iosm_ipc_wwan.c: At top level:
> drivers/net/wwan/iosm/iosm_ipc_wwan.c:231:30: error: storage size of
> ‘iosm_wwan_ops’ isn’t known
>   231 | static const struct wwan_ops iosm_wwan_ops = {
>       |                              ^~~~~~~~~~~~~
> cc1: some warnings being treated as errors

Yeah, that was expected - needs Loic's WWAN series applied first. :)

johannes

