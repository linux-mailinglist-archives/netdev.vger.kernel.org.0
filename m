Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20053512458
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiD0VMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiD0VLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:11:45 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52558241
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 14:08:31 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 23RL6ZcO875538;
        Wed, 27 Apr 2022 23:06:35 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 23RL6ZcO875538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1651093595;
        bh=b1nfBR8Jq/MHh1zUw+KFsnGqw5uEqUdl395ahOTkcPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lWIP0qA9QmBo51EsUW41CELNCv+1RJdmW3XeRGSl9DavBxCG+eIOMVQNA0v3HjFT3
         Xzt5qQYrSjFUJHVfK1QtqbIALSaDblSYWx1L7IXp+20j2yflK4SkhTuPaGQRNxu3fU
         dCF0uFkJxWYHQcWrh4HhpgzsSK1l9BERABiDBh1U=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 23RL6XeG875537;
        Wed, 27 Apr 2022 23:06:33 +0200
Date:   Wed, 27 Apr 2022 23:06:33 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "chi.minghao@zte.com.cn" <chi.minghao@zte.com.cn>,
        "toke@redhat.com" <toke@redhat.com>,
        "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH net-next 03/14] eth: cpsw: remove a copy of the
 NAPI_POLL_WEIGHT define
Message-ID: <YmmwWSCLFjRIUX3J@electric-eye.fr.zoreil.com>
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-4-kuba@kernel.org>
 <20220427154702.fbpxfjp4h7ey5ea2@skbuf>
 <20220427085314.326be7d0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427085314.326be7d0@kernel.org>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> :
> On Wed, 27 Apr 2022 15:47:03 +0000 Vladimir Oltean wrote:
[...]
> > Why is the weight even an argument to netif_napi_add() anyway?
> 
> Right, not sure, see the cover letter.

bea3348eef27e6044b6161fd04c3152215f96411 had to deal with different
per-driver weight values when napi_struct and netif_napi_add were
introduced back in 2007.

From there you can almost jump back to NAPI origin when drivers
had to be converted one by one and distros did not provide udev
tooling to tweak what could had been a one-size-fits-all kernel
setting.

-- 
Ueimor
