Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2ED280D80
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 08:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgJBGdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 02:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgJBGdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 02:33:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57920C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 23:33:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOEdN-00F5WK-HN; Fri, 02 Oct 2020 08:33:37 +0200
Message-ID: <0469185195b4a2f4a6e8f54d3815e289994fa461.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 09/10] genetlink: switch control commands to
 per-op policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Fri, 02 Oct 2020 08:33:36 +0200
In-Reply-To: <20201001225933.1373426-10-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
         <20201001225933.1373426-10-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 15:59 -0700, Jakub Kicinski wrote:
> In preparation for adding a new attribute to CTRL_CMD_GETPOLICY
> split the policies for getpolicy and getfamily apart.
> 
> This will cause a slight user-visible change in that dumping
> the policies will switch from per family to per op, but
> supposedly sniffer-type applications (which are the main use
> case for policy dumping thus far) 

For the record, I don't think anything there has actually been
implemented ... I've been meaning to, but not gotten to it, the only
thing I had done was a "dummy" policy dump helper in iproute2/genl.

Which I guess will no longer work with this, and thus I should in fact
implement the scheme I outlined for dumping all commands at once, so the
"manual" introspection there can work again.

Still, it's all very new and not really in use yet, so I see no issues
with it all.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes


