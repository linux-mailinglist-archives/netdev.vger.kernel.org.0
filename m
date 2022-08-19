Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6C59A652
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351459AbiHSTVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350677AbiHSTUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:20:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982AE4F67B;
        Fri, 19 Aug 2022 12:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=aImKszdCz8DSBMWnelI8Y9kP2xOJdf0XcOOgW/Sq8Es=;
        t=1660936843; x=1662146443; b=WOloKTe6BW7r5mGaB2J8zvz+oS20bE3v6YKpWUqec2PWDmD
        UskzsnVm1GUgTnD0gGrYBGtjIuHHEsPIoJACWXEpHKpawhuqLIgC9yDCLYwJD+cYEZdrk4tXbNxG0
        cvKsRp46DyY8jF6XRFCPC95MCVbziZHnn1dZQ5B2iSesf7RCv1H1kwtBoHnvw+JBJuKlFIpa93xzT
        zJqSh9MlFZpNKcw2ZcSepyAeznMx0H82EnypdIFQgjEYYkDb/dHmU2EjJjr33JIvWqtZSv3Eys4C0
        j1ie8vcvkOtoEdi7rbUn3krt9JhuwbKWhQbtcCAasLHb8F9PhCZ+PQXU3cMxHY1w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oP7Xj-00C8jo-0a;
        Fri, 19 Aug 2022 21:20:31 +0200
Message-ID: <84601312213cfd8568be221038c94ab72c9eeccc.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        stephen@networkplumber.org, sdf@google.com, ecree.xilinx@gmail.com,
        benjamin.poirier@gmail.com, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org, jhs@mojatatu.com,
        tgraf@suug.ch, jacob.e.keller@intel.com, svinota.saveliev@gmail.com
Date:   Fri, 19 Aug 2022 21:20:30 +0200
In-Reply-To: <20220819121640.11e7e2f7@kernel.org>
References: <20220818023504.105565-1-kuba@kernel.org>
         <20220818023504.105565-2-kuba@kernel.org>
         <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
         <20220819092029.10316adb@kernel.org>
         <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
         <20220819105451.1de66044@kernel.org> <20220819121640.11e7e2f7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 2022-08-19 at 12:16 -0700, Jakub Kicinski wrote:
> On Fri, 19 Aug 2022 10:54:51 -0700 Jakub Kicinski wrote:
> > > Ugh, I repressed all those memories ... I don't remember now, I guess
> > > I'd have to try it. Also it doesn't just apply to normal stuff but al=
so
> > > multicast, and that can be even trickier. =20
> >=20
> > No worries, let me try myself. Annoyingly I have this doc on a differen=
t
> > branch than my netlink code, that's why I was being lazy :)
>=20
> Buffer sizing
> -------------
>=20
> Netlink sockets are datagram sockets rather than stream sockets,
> meaning that each message must be received in its entirety by a single
> recv()/recvmsg() system call. If the buffer provided by the user is too
> short, the message will be truncated and the ``MSG_TRUNC`` flag set
> in struct msghdr (struct msghdr is the second argument
> of the recvmsg() system call, *not* a Netlink header).
>=20
> Upon truncation the remaining part of the message is discarded.
>=20
> Netlink expects that the user buffer will be at least 8kB
>=20

I guess technically 8 KiB ;-)

>  or a page
> size of the CPU architecture, whichever is bigger. Particular Netlink
> families may, however, require a larger buffer. 32kB buffer is recommende=
d
> for most efficient handling of dumps (larger buffer fits more dumped
> objects and therefore fewer recvmsg() calls are needed).

Seems reasonable, thanks :)

Honestly most of our problems came from ever-growing message sizes, and
userspace having defaulted to 4k buffers ... annoyingly. Even 8k may not
always be enough for future - so for the kernel guide maybe say we
should mostly not even have GET operations but have a way to restrict
DUMP operations to a certain (set of) object(s), and have the ability to
split objects in the middle when they have a lot of properties ...

johannes
