Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DEC699D2B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjBPTtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBPTtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:49:09 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1982A3B0FF;
        Thu, 16 Feb 2023 11:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=WNdiQ0yBLM1h4tRsy9XJpXwPANeEXou8utTvULJaBs8=;
        t=1676576948; x=1677786548; b=JuutzsYnl+A5g6WQD8zt0x/yhByw8cMrKCV1BMwPCJ7Ga5h
        lObOMU+1dVdMerXe28rMMMkvmineUsULTOrnCFKGAzxwYoF4HZbsvP15Qv4FEnnHD2srAla6AJiK3
        vvEH/VjEIVwZHLJnhZd+E5gBq3aZn6g5qgrN7BVqfrQOZt2ds8i660gosYzA4yLAZPkpWgQTWa1hM
        T2W0eL3+NlwX9rNYMhCD97s6VRiRL529qV6KW8ZoHDRHF59mhbDVsJEiGjcGHrFLagHd6KhqTRJ8+
        2ZfDS+jOCZaiyWd6qnqaQ6kvUdfu6I88fRsnf0//o7p99nZqCFPjEH2IPXeSnsBg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSkFd-00EB5g-28;
        Thu, 16 Feb 2023 20:49:05 +0100
Message-ID: <fbae8518cdb529e175ee771bdd288bd64858f67c.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2023-03-16
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@kernel.org>
Date:   Thu, 16 Feb 2023 20:49:04 +0100
In-Reply-To: <20230216113253.2cbb360e@kernel.org>
References: <20230216105406.208416-1-johannes@sipsolutions.net>
         <20230216113253.2cbb360e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-16 at 11:32 -0800, Jakub Kicinski wrote:
> On Thu, 16 Feb 2023 11:54:05 +0100 Johannes Berg wrote:
> > Here's a last (obviously) set of new work for -next. The
> > major changes are summarized in the tag below.
> >=20
> > Please pull and let me know if there's any problem.
>=20
> Could you follow up soon with fixes for the compilation warnings?

Huh, yes, sorry about that.

> drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c:441:21: warning: unu=
sed function 'iwl_dbgfs_is_match' [-Wunused-function]
> static inline char *iwl_dbgfs_is_match(char *name, char *buf)
>                     ^
>=20

That's particularly odd, feels like that was already unused since (my)
commit 3a894a9f319f ("iwlwifi: remove TOF implementation")? But that's
_ancient_.

So I think probably the new ones are different than that one, how did
you find this one?

Anyway there are far too many left ...

johannes
