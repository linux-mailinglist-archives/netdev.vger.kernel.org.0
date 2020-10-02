Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEADF281D05
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJBUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBUiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:38:52 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD90C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 13:38:52 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kORpK-00FSAX-N3; Fri, 02 Oct 2020 22:38:50 +0200
Message-ID: <185e714a1d205c3cdf0f655630f8c3edf552fc1a.camel@sipsolutions.net>
Subject: Re: [PATCH 3/5] netlink: rework policy dump to support multiple
 policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Fri, 02 Oct 2020 22:38:49 +0200
In-Reply-To: <20201002133720.7fb5818c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
         <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
         <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <580e017d3acc8dda58507f8c4d5bbe639a8cecb7.camel@sipsolutions.net>
         <20201002133720.7fb5818c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 13:37 -0700, Jakub Kicinski wrote:
> 
> I guess it's because of the volume of messages this would cause.

There's actually been a large cleanup, so it wouldn't be too bad.

I had really just suspected tooling/build system issues, you know which
C files you're compiling, but not easily which headers they're
including, so how to run the checker script on them?

Anyway, never really looked into it.

johannes

