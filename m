Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD561280D7C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgJBGa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 02:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgJBGaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 02:30:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83BEC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 23:30:55 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOEaf-00F5T7-0j; Fri, 02 Oct 2020 08:30:49 +0200
Message-ID: <31b9f6c154d853e3755cb0f90005945ef43c82ad.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 08/10] genetlink: use parsed attrs in
 dumppolicy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Fri, 02 Oct 2020 08:30:47 +0200
In-Reply-To: <20201001225933.1373426-9-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001225933.1373426-9-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 15:59 -0700, Jakub Kicinski wrote:
> Attributes are already parsed based on the policy specified
> in the family and ready-to-use in info->attrs. No need to
> call genlmsg_parse() again.

:)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

