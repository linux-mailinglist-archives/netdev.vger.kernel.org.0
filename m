Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C570A24987B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgHSIqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHSIqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 04:46:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CBAC061757;
        Wed, 19 Aug 2020 01:46:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k8Jjx-006jl5-TI; Wed, 19 Aug 2020 10:46:38 +0200
Message-ID: <2893e041597524c19f45fa7e58cf92d8234893e7.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: switch from WARN() to pr_warn() in
 is_user_regdom_saved()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rustam Kovhaev <rkovhaev@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 19 Aug 2020 10:46:34 +0200
In-Reply-To: <20200804210546.319249-1-rkovhaev@gmail.com> (sfid-20200804_230749_046801_76E2A4D8)
References: <20200804210546.319249-1-rkovhaev@gmail.com>
         (sfid-20200804_230749_046801_76E2A4D8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-08-04 at 14:05 -0700, Rustam Kovhaev wrote:
> this warning can be triggered by userspace, so it should not cause a
> panic if panic_on_warn is set

This is incorrect, it just addresses a particular symptom. I'll make a
proper fix.

johannes

