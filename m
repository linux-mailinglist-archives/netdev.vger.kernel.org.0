Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1326B595ED0
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbiHPPLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiHPPLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:11:43 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D980B1408A;
        Tue, 16 Aug 2022 08:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=AnHbybbrXeCL0DxbE8ki5M5WAm/DsTNQ38HW5TopKkA=;
        t=1660662700; x=1661872300; b=X3t6t0tv/ISzVUkt9rX9LMgyHDW7Uzp+0QEIu1Ih3ZtLTLT
        UrC/AWjztf6aGBeWly8+SlkzvI98dv1KZ/yx/x/ha3veaMgf4Oy/0lXSuql2LWsQdDj1imsvbdMgZ
        1xjeijBo4OZci3/CxeDG9y12dgI6Fgnof4GdNR+kvYfk8P8LWtqvO/G7TrqW+38N6n874Vd9UeWes
        YApF5jsTNXy4HP0sOBBAZGuapXO165cq0otPOg5GDHBS3X6+ngkx2TNZWiijHJTTOwUbZWBQV5ApV
        FkorQiQGiNSwbq7VqH4KT7+TVhS2xqfFhXBNBEnerJhFqbM/xOWTAWaKFGaoMycg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNyE9-009ZK8-2r;
        Tue, 16 Aug 2022 17:11:33 +0200
Message-ID: <6a7b0bc82647440a9036a8e637807da618552cc5.camel@sipsolutions.net>
Subject: Re: [syzbot] upstream boot error: general protection fault in
 nl80211_put_iface_combinations
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+684d4ca200fda0b2141e@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Date:   Tue, 16 Aug 2022 17:11:32 +0200
In-Reply-To: <00000000000033169005e657a852@google.com>
References: <00000000000033169005e657a852@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hmm.

> HEAD commit:    568035b01cfb Linux 6.0-rc1
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D145d8a4708000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D126b81cc3ce4f=
07e
>=20

I can't reproduce this, and I don't see anything obviously wrong with
the code there in hwsim either.

Similarly with
https://syzkaller.appspot.com/bug?extid=3D655209e079e67502f2da

Anyone have any ideas what to do next?

johannes
