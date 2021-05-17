Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31513827FD
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbhEQJQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236053AbhEQJPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:15:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5355CC061344;
        Mon, 17 May 2021 02:13:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1liZIn-00AGiS-Hq; Mon, 17 May 2021 11:12:41 +0200
Message-ID: <42f98bf9dd5919a0bb2184360b3181f68d303fd4.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2 net-next] alx: unlock on error in
 alx_set_pauseparam()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Mon, 17 May 2021 11:12:40 +0200
In-Reply-To: <YKIwPe2/k1R+PTWU@mwanda>
References: <YKIwPe2/k1R+PTWU@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-05-17 at 11:58 +0300, Dan Carpenter wrote:
> We need to drop the lock before returning on this error path.

Haha, how many locking errors can I have in a single patch :(

Sorry, and thanks for all the fixes!

johannes

