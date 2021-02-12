Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1ECF319B54
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBLIif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBLIi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 03:38:29 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562F1C061574;
        Fri, 12 Feb 2021 00:37:48 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lATxP-001m2c-9O; Fri, 12 Feb 2021 09:37:43 +0100
Message-ID: <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Abhishek Kumar <kuabhs@chromium.org>,
        Youghandhar Chintala <youghand@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Date:   Fri, 12 Feb 2021 09:37:41 +0100
In-Reply-To: <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com> (sfid-20210205_225202_513086_43C9BBC9)
References: <20201215172352.5311-1-youghand@codeaurora.org>
         <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
         <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
         <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
         (sfid-20210205_225202_513086_43C9BBC9)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-05 at 13:51 -0800, Abhishek Kumar wrote:
> Since using DELBA frame to APs to re-establish BA session has a
> dependency on APs and also some APs may not honour the DELBA frame.


That's completely out of spec ... Can you say which AP this was?

You could also try sending a BAR that updates the SN.

johannes

