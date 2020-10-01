Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFEB2808B5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 22:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgJAUqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgJAUqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 16:46:51 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF5C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 13:46:50 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kO5TT-00EoOv-E5; Thu, 01 Oct 2020 22:46:47 +0200
Message-ID: <803c06dd47caadd7feae8782eca116d64efc6614.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 4/9] genetlink: add a structure for dump state
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 22:46:46 +0200
In-Reply-To: <20201001183016.1259870-5-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
         <20201001183016.1259870-5-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +struct netlink_policy_dump_state;

I was going to ask if it wouldn't be better to have that visible, but I
see now what you did there ... good idea :-)

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

