Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA74059C47C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiHVQ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbiHVQ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:59:46 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8731582D;
        Mon, 22 Aug 2022 09:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661187572;
        bh=5PSC9KSJrN+I36eNSPKjGlpKRWxpUHmV809ABk5XYNA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kDfXABW7iW0nU9B1THa8LsK5H7JyeXUxYozdWiY9EqF+rfK7uQkvIGYIrS82RQXX6
         wIE+RlfCugVkpBrZULNlva9m+4Q7BmrMj1iuGsPZc8vZXo1kiZz8K9bYOXzz0eOVuH
         GzmAN0HEdag92KgJfXcbtYgXB10uUbbUydgoxP3U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.225.169] ([157.180.225.169]) by web-mail.gmx.net
 (3c-app-gmx-bap06.server.lan [172.19.172.76]) (via HTTP); Mon, 22 Aug 2022
 18:59:32 +0200
MIME-Version: 1.0
Message-ID: <trinity-94aeced0-7aab-4359-9c74-1616a17464bd-1661187572028@3c-app-gmx-bap06>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Aw: Re:  Re: help for driver porting - missing member
 preset_chandef in struct wireless_dev
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 22 Aug 2022 18:59:32 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <51a1b56a4d9ed825cb47cf364c5bd72f3338a1a6.camel@sipsolutions.net>
References: <trinity-de687d18-b2a2-4cde-9383-a4d6ddba6a77-1661177057496@3c-app-gmx-bap06>
 <b081ef6eb978070740f31f48a1f4be1807f51168.camel@sipsolutions.net>
 <trinity-64c5eed8-8b6b-4b33-9204-89aff4fce7db-1661186571606@3c-app-gmx-bap06>
 <51a1b56a4d9ed825cb47cf364c5bd72f3338a1a6.camel@sipsolutions.net>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:2s3gh0jmW12zBhGE7SZcZoJY4MnkmIMVIlAhSZp0+27jdAYGlfgY5+dx0cLwEW1WkBhfu
 NzOKvq2oSEll7T+WrIrS3F9724W7yC8Ux6OyBO5M7VR/IO19W3Bqg608FnVGAwV0wmIUFLbN/he2
 xKuXsHxtt2B8YolPYiu2cSq6zh29RF6xGkIpJvawOsnubVolBFbODCx3PYR1A5I+EWMN34ZG4R5/
 2Ye2gb4+AkE3Jw0mdkVsW3zfzgF/9MUySSg3cTf5fVzNkkWiT1AmJ2kOAHQgJN7wOXdHI1vAegp3
 bQ=
X-UI-Out-Filterresults: notjunk:1;V03:K0:CCSo7lWpAx0=:m6GmAua6YxcBSihifFIo1d
 oTmRhQMqfmNLyRR7AoxqBEeIogEADi0u+VunsDOUpu2j8/MjkzZyQHGiSU4HhfdJDTY4jxxkp
 /65XqW4dvodZLlkMrI38n/DJTZfojtaNDY5X2K+ghmsKRmHLu/Qt2zRWMVhA1NAPgOnc0NO4/
 +jXMiMbqYdapWEDFXBTHR114H5ygzWAxZWGW5Bk0/RM9SfpDLLAJ4e9KqebBabCdzv8qjL34N
 jrMhPmMgr2U4F0aIIgohIrt8Sao2dumCduAHeQMOxG7K+rmBs0dyFyYQhDjDAf30MT6pmyjcn
 NxRJUDqUXCyrjyr9WbDG1DehGa4/PEBPXufjbn+ENizi95PpHz0+AGdTgbPujqfvnZFIHdhZv
 ifFepjdO9J6QWKHHvvrOZzRiNo1HxCnabN5dGdZWTol7RoomFQOcpTvOsDgIZCtzjlOzhjprh
 w1Wl5yeH2bUttH4Ka9vBYuxONcKosCibwatH4I15Ly0649/VTFy6bIY+nC95HZOQqbVKkgDL+
 s1lCHOdVQHf6rKD+eHyhGA6XqBQkPxdnjmnhgmHve41rzTU5XDFk7Z72EbYBkLBV2TLmUxBaX
 CZJYKktV3Q4wHoy4KJkuDvmHaD+pbo1sS0cSoWOwXUsGktoV9tocQpov2dV1sJsBV2xiB6BBL
 Id3M4QQ4fbD9K+qLyyeiBjnKw9IrC8I+pdYEGeZcXi/zxyaQhX5LyATJtHIHHe4YZH/BFL3YW
 Ap5UhyS5kYu4904AGWSj9q5oEf2EUn7z+1o+N4yNWl2nf7fWsyOftlyOZIxugXKkui5jYuwy9
 5EMmFrK
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Montag, 22. August 2022 um 18:43 Uhr
> Von: "Johannes Berg" <johannes@sipsolutions.net>

> On Mon, 2022-08-22 at 18:42 +0200, Frank Wunderlich wrote:

> > thanks for response, commented out the use of the member and the wdev
> > assignment as it was then unused
> > can you tell me which api-call this should be?
> > i just want to make sure this is really done as i up-ported the driver
> > from 4.9, so if the api-call was introduced later it is maybe missing.
>
> No sorry, I don't know how the driver was/is using it, so I can't tell
> you how to replace it.

can you give me possible calls (if there are multiple candidates) which ma=
y set the channel (without mesh)
for me to check or maybe implement?

> johannes

Frank
