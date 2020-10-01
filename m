Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FE927FADF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731390AbgJAH4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgJAH4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:56:12 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769ADC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:56:12 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNtRi-00ESVo-NM; Thu, 01 Oct 2020 09:56:10 +0200
Message-ID: <706936107b15974af0dd51b22f9e4f3927eddef6.camel@sipsolutions.net>
Subject: Re: [RFC net-next 8/9] genetlink: use per-op policy for
 CTRL_CMD_GETPOLICY
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, jiri@resnulli.us, mkubecek@suse.cz,
        dsahern@kernel.org, pablo@netfilter.org
Date:   Thu, 01 Oct 2020 09:56:09 +0200
In-Reply-To: <20201001000518.685243-9-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
         <20201001000518.685243-9-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 17:05 -0700, Jakub Kicinski wrote:
> Wire up per-op policy for CTRL_CMD_GETPOLICY.
> This saves us a call to genlmsg_parse() and will soon allow
> dumping this policy.
> 
> Create a new policy definition, since we don't want to pollute
> ctrl_policy with attributes which CTRL_CMD_GETFAMILY does not
> support.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

