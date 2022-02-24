Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE5F4C2200
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiBXDEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiBXDEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:04:50 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C7E61A0C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:04:22 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id v22so971537ljh.7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=1eMOSMVyI6SqyaDsM8FnzuqZuw4Dpaut7faFU2yjJ5U=;
        b=QXsRAYdc3wP1UoUup5hp0UcwPf/tNIsdMiOJiyVO1amIu892xdHUwiMyvn8tb5EtWw
         4M+hZx1NzWxZy49Ys/Iq4l33flxouXKEs3KkAJGkY0vPqAvNZ/jN1BzBVtq0F0ojHUiW
         t2Kuw6WLzl/KP+F7a9nxoHUB+zJY72as2YScMTCbgmCAW0y7bv1eN5JJWX2xNHmGH3VP
         1ldyYiXb0nK2cQitV1cD0EPCv1wdz9YU8yGaciQZRlGH+I0DJdC6haxHcd0Tx0VNrsXw
         lvHSHa/MmRDKeH5UersZ0eIKUTDgXdNvSofnDPUHtHyMTafri5jDJIBg0vAYoJQywbbY
         vd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1eMOSMVyI6SqyaDsM8FnzuqZuw4Dpaut7faFU2yjJ5U=;
        b=I9DPdLyFG0KfaI97L5hFgbygrA8zr9x6Wl6h681/9BL971j6Ovr++G3B5koU8gUML6
         suIPpExu4EhG9avBP+q82ubux3iIo6smaMvYDct/UaAVrcMkrWJTecWWId8Yn06tElH8
         /wCoSAQpcsupwEB1DKce2bhIMaQQh3Eikuvuuc8u+SQOaZzpVSGg8FF4E+/bszTiOoUj
         l8Oar8SL94AoJ4eg9XsaCN2AYTB6KAkvy6XVdKt2C9mImqSN4IT9PNWXDQjexngpxSIt
         M8CfXJimlUuFDPQASJug6hDQaRQar6TuNCbPnfAGSbXURmakA9Zbiv0YGGLBSODa5IEZ
         8sJw==
X-Gm-Message-State: AOAM531aMngawt8zW6NvUIph/p/K0sqH20OFf3se2hJSjW4XwRROk9ZS
        n6lYHH6PF2MVacyElj74Q5lM1w0K5up1gpgC7tEsEPYkgX6Y/Q==
X-Google-Smtp-Source: ABdhPJy8kw+7TK5WBSFAezjMPvr8RdjkJOuOru3cs0OljBYdnPSwMJdAZfeFecK9RUZKi25XTiROQxqfBqpUo1s2wdw=
X-Received: by 2002:a2e:91d7:0:b0:245:fce2:4551 with SMTP id
 u23-20020a2e91d7000000b00245fce24551mr455567ljg.446.1645671860466; Wed, 23
 Feb 2022 19:04:20 -0800 (PST)
MIME-Version: 1.0
From:   Krishna J <jkrishnamurthy2022@gmail.com>
Date:   Wed, 23 Feb 2022 19:04:09 -0800
Message-ID: <CAAFz61JhXv6Mv=xfhiBE8D4K00bofNS+4xs9nYZAcSPrfTnyng@mail.gmail.com>
Subject: realteck (rtl8218e) phy chip support
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have a NXP's LS1023 based board with realtek (rtl8218e) phy chip on
it. It has a phy id:[1_2] == 0x001c_c984.

I have it configured using the generic phy but no luck in bringing up the ports.
I cannot ping out or in.

I checked upstream to see if there is any support for this one. I did
not see even in 5.17 kernel.

The ODM  of the board recommends using phy_ctl  (some proprietary tool
from realtek).
I would rather add required support to drivers/net/phy/realtek.c

Can someone please chime on how to get started on that?
I don't even have the datasheet for rtl8218e (phy id:[1_2] ==
0x001c_c984). Any pointers will help greatly and the kernel can
benefit with new phy support.

Thanks,
Krishna
