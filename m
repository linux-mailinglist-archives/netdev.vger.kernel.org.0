Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E90EB9AD4
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 01:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407208AbfITXn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 19:43:59 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:10739 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404923AbfITXn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 19:43:59 -0400
Date:   Fri, 20 Sep 2019 23:43:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=proton;
        t=1569023036; bh=47Duq67pVI2xFxsBASVycK9qqTo5wnymJB3pOutg6yo=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=H6eHMzSG4s8w9w6UdjMO7MamROj4rLwbXJkLRAdwXYTfpsfR23SoQDVYYKtoCUCES
         jnPX/xfftQE+J/88mgfqIrkvxypB4hd8fMty/DzNEzjFIDseo5NoN/2PMJcEM3qJFW
         bleRtXbU+nauz5au+y99LQbg8L7gGCNXPmo/fD3pYGLey3OznUonVCAv7F/vuOvaXL
         QH+Tk9YxTchRYjysX8S1hI5KHl6sVeULDrlZlNY4kTHmUKmjWb/ieLd5p2qd4grkwa
         s+EKCeCIP8nYdVliVfgwM+elLhhpa/YVtYcBzIm1lEqLYQABZg2+OdbGao8xCEbBGC
         8RL52TzEFawxw==
To:     netdev@vger.kernel.org
From:   Swarm <thesw4rm@pm.me>
Reply-To: Swarm <thesw4rm@pm.me>
Subject: Verify ACK packets in handshake in kernel module (Access TCP state table)
Message-ID: <20190920234346.kz22qswwvjxjins7@chillin-at-nou>
Feedback-ID: 3r-4xLrInLN6M9PyG0idwey-nTYP2NtIrzugujjDb-SZA5fiXIYohG8L8IPXLtJh8TGI5F1ZDuZlj6I-GleTeA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First time emailing to this mailing list so please let me know if I made a =
mistake in how I sent it. I'm trying to receive a notification from the ker=
nel once it verifies an ACK packet in a handshake. Problem is, there is no =
API or kernel resource I've seen that supports this feature for both syncoo=
kies and normal handshakes. Where exactly in the kernel does the ACK get ve=
rified? If there isn't a way to be notified of it, where should I start add=
ing that feature into the kernel?

