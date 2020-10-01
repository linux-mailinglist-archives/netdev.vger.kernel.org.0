Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299E727FA67
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgJAHkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgJAHkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:40:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F99C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:40:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtCf-00ES5U-1b; Thu, 01 Oct 2020 09:40:37 +0200
Message-ID: <a8075d1426695435d821331db03765ee8f38d5fa.camel@sipsolutions.net>
Subject: Re: [RFC net-next 3/9] genetlink: add small version of ops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:40:35 +0200
In-Reply-To: <20201001000518.685243-4-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-4-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> We want to add maxattr and policy back to genl_ops, to enable
> dumping per command policy to user space. This, however, would
> cause bloat for all the families with global policies. Introduce
> smaller version of ops (half the size of genl_ops). Translate
> these smaller ops into a full blown struct before use in the
> core.

LGTM. That part about the WARN_ON was even easier than I thought :)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

