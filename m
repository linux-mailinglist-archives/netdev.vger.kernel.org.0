Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9380C546EEA
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 23:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbiFJVCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 17:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346839AbiFJVCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 17:02:10 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072674DF5F;
        Fri, 10 Jun 2022 14:02:06 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1654894924; bh=nJ5MFlI7bZgvfzzBUZG0yDIB0cURw2j0N/Z0XV16DgM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ona/SbCQfx0pRd6c3vM6AB+M0QbCy3M9JMTMdO7aqXiEbNpmwTYGd77hskQc1PATt
         MjrEuszx+mhwOQw0lj5br+mlKrCA5G9ik2v36JbE8u+dGNcSgmZ1kkexrzIFQpN393
         zFeV3e0+oGAVmYTvmV3qbtjBjO/54H7VphjA9gsfvyoBwWOZIpfvUJYH/HNp0XZUx2
         Ydj5MmxW7Cr1rPzBBWNc5wY3LvokXPmst0Bs54ctXNvAaT5sH7HyfdvRz3f/UuTOc2
         aCk6QpEMyXxRZfbmaOOk/kc2QRu9LMe6IE7SuuM0MvfnVDKWhXVIELUPJsoV5a3LOZ
         IdYwUTuN3C+xg==
To:     Pavel Skripkin <paskripkin@gmail.com>, Takashi Iwai <tiwai@suse.de>
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, senthilkumar@atheros.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v5 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <dabcbe61-5d77-7290-efd5-3fe71ca60640@gmail.com>
References: <961b028f073d0d5541de66c00a517495431981f9.1653168225.git.paskripkin@gmail.com>
 <87bkv0vg2p.wl-tiwai@suse.de> <87r13w2wxq.fsf@toke.dk>
 <dabcbe61-5d77-7290-efd5-3fe71ca60640@gmail.com>
Date:   Fri, 10 Jun 2022 23:02:04 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878rq42pwz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Hi Toke,
>
> On 6/10/22 21:30, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> In general, if a patch is marked as "changes requested", the right thing
>> to do is to bug the submitter to resubmit. Which I guess you just did,
>> so hopefully we'll get an update soon :)
>>=20
>
>
> I agree here. The build fix is trivial, I just wanted to reply to
> Hillf like 2 weeks ago, but an email got lost in my inbox.
>
> So, i don't know what is correct thing to do rn: wait for Hillf's
> reply or to quickly respin with build error addressed?

Up to you. If you respin it now we can just let it sit in patchwork over
the weekend and see if it attracts any further comment; or you can wait
and respin on Monday...

-Toke
