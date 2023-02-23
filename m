Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF776A0673
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjBWKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjBWKkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:40:05 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29280521CD;
        Thu, 23 Feb 2023 02:40:00 -0800 (PST)
Received: from fpc (unknown [10.10.165.5])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8DE0740737C4;
        Thu, 23 Feb 2023 10:39:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8DE0740737C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677148797;
        bh=rOgvnxN4F4u6VvOH7B7HyxPqwYamMpp+JH8vZmNlrQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pXebvjmfaTl73E+eNq07GzxRwDuBJXFzsREDKdYRkcak8K5M03JURKPbFZYrhIGGO
         shPPr/D6TyvxcTOVR8bngr+U19tVUpuBimoKE8d9A7h3pfyfj1NG8I4Vwxr6cGi/Ea
         B/l/6AxQ3wbhyKKdpDnLRhVO7Y55Mzbk1LG/Wz0I=
Date:   Thu, 23 Feb 2023 13:39:51 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+860268315ba86ea6b96b@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.4/5.10 1/1] mac80211: mesh: embedd mesh_paths and
 mpp_paths into ieee80211_if_mesh
Message-ID: <20230223103951.5hw3wtzx5rbhcbfb@fpc>
References: <20230222200301.254791-1-pchelkin@ispras.ru>
 <20230222200301.254791-2-pchelkin@ispras.ru>
 <Y/ctyzCtbPwyrrDI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/ctyzCtbPwyrrDI@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 10:11:39AM +0100, Greg Kroah-Hartman wrote:
> This also worked for 4.19.y, but not 4.14.y, care to also fix it there?

Yes, thank you. I missed 4.19.y - the bug can be triggered there and the fix
can be applied.

As for 4.14.y, there were some untrivial changes in the code so the
current fix cannot be backported safely.
