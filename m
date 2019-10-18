Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4BBDC02B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 10:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632753AbfJRIn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 04:43:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52954 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfJRIn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 04:43:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iLNqy-000676-20; Fri, 18 Oct 2019 10:43:20 +0200
Message-ID: <e30e0dfb989efa4314070b7194097001230210b7.camel@sipsolutions.net>
Subject: Re: [PATCH] net/lib80211: scrubbing the buffer for key
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 18 Oct 2019 10:43:19 +0200
In-Reply-To: <20191018045305.8108-1-kjlu@umn.edu>
References: <20191018045305.8108-1-kjlu@umn.edu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-17 at 23:53 -0500, Kangjie Lu wrote:
> The "key" is not scrubbed. As what peer modules do, the fixes zeros
> out the key buffer.

Why do you think this is useful/necessary? Please always describe that
in the commit log.

FWIW, I'm convinced that it's not at necessary at all, looking at how
this is allocated ...

johannes

