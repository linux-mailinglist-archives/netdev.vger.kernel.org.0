Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8AA3005DD
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 15:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbhAVOng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 09:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbhAVOm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 09:42:56 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98423C0613D6;
        Fri, 22 Jan 2021 06:42:09 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l2xdX-00AB97-3u; Fri, 22 Jan 2021 15:42:07 +0100
Message-ID: <3ab53428d2bf7a524b7929e67e1f7080f6aa643f.camel@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Date:   Fri, 22 Jan 2021 15:42:06 +0100
In-Reply-To: <85abb9009642c3a13321970c04f73cf0cf91c2e3.camel@sipsolutions.net> (sfid-20210120_190718_945232_7A287C28)
References: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
         (sfid-20210119_153923_221115_D0602D5A) <85abb9009642c3a13321970c04f73cf0cf91c2e3.camel@sipsolutions.net>
         (sfid-20210120_190718_945232_7A287C28)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-20 at 19:03 +0100, Johannes Berg wrote:

> Could you take a look at these bits to see if that's fine with you?

Actually, never mind. Given some bug reports, some rework was necessary,
and that means this is no longer needed :-)

johannes

