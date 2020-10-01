Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3005527FA69
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgJAHml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgJAHml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:42:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5DEC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:42:40 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtEc-00ES7z-Sc; Thu, 01 Oct 2020 09:42:38 +0200
Message-ID: <f103cde405173327d0e8232d2fa86f4382b0be01.camel@sipsolutions.net>
Subject: Re: [RFC net-next 4/9] genetlink: move to smaller ops wherever
 possible
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:42:23 +0200
In-Reply-To: <20201001000518.685243-5-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-5-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> Bulk of the genetlink users can use smaller ops, move them.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

