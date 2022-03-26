Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8599E4E80D6
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiCZMiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiCZMiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:38:15 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92B72980D;
        Sat, 26 Mar 2022 05:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=e2bXraZC1MZ6r0WNb+kmC83YHU78suKj4HNBRd+g+tU=; b=W4O09IqdLN4E6xqnWRKpC0vaSF
        XBVEVG4v7m2iYMczRlDpSC92tbckxn/5SWO1xk7ThFI8/K0l2DtxCJ27OGHi9PRGYa0a8Y8Ofciza
        /sRsfq5044BOjqWD/HMTWQfljLMze3UL/03/bnyUsPHXpNVREUeh5D3RRBreveMcDYirPlcSyq4+L
        zVUQrRYeQJKZ7DMca+7JPKMUSd30xBjB6hzXYcJYXjH0G+01oC915R0LFNQYHWqWvLFj2HcfmJRPj
        b0bIqhNmg3TmTra6BwyeMvgJY7eTvLuhaOpqh1680y0S7oGWR5HBa/qThLBk/gKKiKfr5b6qwOWHo
        BGHueX9XDF7EyclhrnoEVlfzqW9MN/kpakkFcQEoOBt6C3gG1xWL4pF+l8mmQPw14blyyrNN76/el
        BZJpUgCCKhHjwMw3uXGJE0mYwN8uKk8yTshtp0Ge648P6f34Ru1HVrx7TVtU6vT5B1AIsHQif+wnD
        Gpyg5rg8P6dSKGyUJFuOs+R1ozCdwGCJR6uzwhcKoBhLv3nrikLpBUNDVfpU0eaHy5nPte9ZJm+i6
        Fi3Jev5d05ri95PtcnBrFqwAOwHPQ9UiHwCKzH9/IpoPEssbpQ+t8kyCEZv7lQC0OKzSHWuYTqrCr
        jXzrEJN7QcgO4ZXQM2poUlUV+nwLtzDowWlRZJSss=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net,
        syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com
Subject: Re: [syzbot] WARNING in p9_client_destroy
Date:   Sat, 26 Mar 2022 13:36:31 +0100
Message-ID: <2582025.XdajAv7fHn@silver>
In-Reply-To: <Yj8F6sQzx6Bvy+aZ@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3597833.OkAhqpS0b6@silver> <Yj8F6sQzx6Bvy+aZ@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Samstag, 26. M=E4rz 2022 13:24:10 CET asmadeus@codewreck.org wrote:
> Christian Schoenebeck wrote on Sat, Mar 26, 2022 at 12:48:26PM +0100:
> > [...]
> >=20
> > > Signed-off-by: David Kahurani <k.kahurani@gmail.com>
> > > Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com
>=20
> Looks good to me - it's pretty much what I'd have done if I hadn't
> forgotten!
> It doesn't strike me as anything critical and I don't have anything else
> for this cycle so I'll just queue it in -next for now, and submit it
> at the start of the 5.19 cycle in ~2months.

BTW, another issue that I am seeing for a long time affects the fs-cache: W=
hen
I use cache=3Dmmap then things seem to be harmless, I periodically see mess=
ages
like these, but that's about it:

[90763.435562] FS-Cache: Duplicate cookie detected
[90763.436514] FS-Cache: O-cookie c=3D00dcb42f [p=3D00000003 fl=3D216 nc=3D=
0 na=3D0]
[90763.437795] FS-Cache: O-cookie d=3D0000000000000000{?} n=3D0000000000000=
000
[90763.440096] FS-Cache: O-key=3D[8] 'a7ab2c0000000000'
[90763.441656] FS-Cache: N-cookie c=3D00dcb4a7 [p=3D00000003 fl=3D2 nc=3D0 =
na=3D1]
[90763.446753] FS-Cache: N-cookie d=3D000000005b583d5a{9p.inode} n=3D000000=
00212184fb
[90763.448196] FS-Cache: N-key=3D[8] 'a7ab2c0000000000'

The real trouble starts when I use cache=3Dloose though, in this case I get=
 all
sorts of misbehaviours from time to time, especially complaining about inva=
lid
file descriptors.

Any clues?

Best regards,
Christian Schoenebeck


