Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143AE27FA9B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgJAHtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731353AbgJAHtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:49:49 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530EFC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:49:49 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtLX-00ESLU-HM; Thu, 01 Oct 2020 09:49:47 +0200
Message-ID: <540b707855144018d570a2ba528cf4b440e8c448.camel@sipsolutions.net>
Subject: Re: [RFC net-next 6/9] genetlink: use .start callback for dumppolicy
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:49:38 +0200
In-Reply-To: <20201001000518.685243-7-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-7-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> The structure of ctrl_dumppolicy() is clearly split into
> init and dumping. Move the init to a .start callback
> for clarity, it's a more idiomatic netlink dump code structure.

Yep, makes sense.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

