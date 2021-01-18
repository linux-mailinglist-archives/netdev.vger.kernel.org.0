Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B73B2FABCA
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394188AbhARUsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388420AbhARUo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:44:56 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA04C061574;
        Mon, 18 Jan 2021 12:44:10 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l1bNg-008OYU-5Y; Mon, 18 Jan 2021 21:44:08 +0100
Message-ID: <65dac56400051cb2b462fa838e48f45e253e8e9e.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-01-18
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 18 Jan 2021 21:44:07 +0100
In-Reply-To: <20210118091235.68511-1-johannes@sipsolutions.net> (sfid-20210118_213844_572089_62710982)
References: <20210118091235.68511-1-johannes@sipsolutions.net>
         (sfid-20210118_213844_572089_62710982)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-18 at 10:12 +0100, Johannes Berg wrote:
> Hi Jakub,
> 
> Here are some fixes for wireless - probably the thing people
> have most been waiting for is the kernel-doc fixes :-)

Now that the email finally went through, let me withdraw this, there's a
sparse error in one of the patches.

johannes

