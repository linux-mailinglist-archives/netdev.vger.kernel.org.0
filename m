Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6EE4C8CA4
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbiCAN3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiCAN3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:29:48 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3489D069
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 05:29:08 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2db2add4516so111800707b3.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 05:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EYVVHEvaFUWb8RXgfUlNeRmfKhq3Sbbd6xq/uoJdbzM=;
        b=HHLe6B3de2umeugPMns7YcbGdWa1Gz/BTLoFhg3j/Pvg9e3vqT9a2U5Qxdu4ZC21zR
         841GydLRo9g2I/XncvMo6NPmbeok5h/TkfLyJX/OrfZRDdnfKDVoelTxn9Xjl1U15sAa
         sy6Uq+NamCB1pK8Fjx3KKdj1Qg8qrtMohSBKr/8G6DJ709kNucFBfnjZGrMGIj/KO+sV
         k3Pgm7urh3erWlMT6V7kYxv5FAFum8RD64TRyF8bRDcqhumtcoqn3K+4o6aqEYiV0biQ
         Mu20x2/LhDv6xxL1nOzV/OPpRufEGD0FYAhHJDtOy0vpYhqt3sDz0JcFtG497T/iaUaz
         jHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EYVVHEvaFUWb8RXgfUlNeRmfKhq3Sbbd6xq/uoJdbzM=;
        b=a6P0cLOBDC3+0q1Obg6L9uLp4MTQkUFH+VV5WUuILlWXocj7zOVogIJt7Uw1TmbhEX
         hkGB0M1YblTFxzCXdoDXO+y75T1nYgOownJqfZTJW7LLOrne0ECSBf+dnUfeEgmw4+Eh
         UxPTvYUv2xPdBqhCQVMZaEqXLp98M5D0u7Ejc4byyYvQyNyuMp0xeLAOQVlYWvB49b4B
         E74K0tY6N9B/4w6GOLNd4GHrrzosc6pwh36sp7SgurTXkkx3LLkTMAnU/owHYG20qSiQ
         9W/wK9R6fn92fLeEDVVImcsDvSS9AGJD75pozMWbeyQk6Zc8Qe7NbT3v3JDIvWK84VXF
         mdnw==
X-Gm-Message-State: AOAM532H/830Oq24kXf1R6rkYOC2BMu7WJkMuePjuGwcCcbCbx8vxdHQ
        QDem+xJFuPhbO5t4Dr3Abk86xK39pHbZRAtDwRMMpDUke0/NoA==
X-Google-Smtp-Source: ABdhPJyHE1uAUqWpvkiLxi/mSMxiTjU+ukincq8A0qxNny9BYBRQvZVR27eADFou3omS/ZyzjYACqD+PIfvUFIHl5V8=
X-Received: by 2002:a81:7d0b:0:b0:2d8:2280:a0f1 with SMTP id
 y11-20020a817d0b000000b002d82280a0f1mr20488148ywc.435.1646141347140; Tue, 01
 Mar 2022 05:29:07 -0800 (PST)
MIME-Version: 1.0
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
In-Reply-To: <20220301131512.1303-1-kailueke@linux.microsoft.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 1 Mar 2022 15:28:56 +0200
Message-ID: <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return error"
To:     kailueke@linux.microsoft.com
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai,

On Tue, Mar 1, 2022 at 3:15 PM <kailueke@linux.microsoft.com> wrote:
>
> From: Kai Lueke <kailueke@linux.microsoft.com>
>
> This reverts commit 8dce43919566f06e865f7e8949f5c10d8c2493f5 because it
> breaks userspace (e.g., Cilium is affected because it used id 0 for the
> dummy state https://github.com/cilium/cilium/pull/18789).
>
> Signed-off-by: Kai Lueke <kailueke@linux.microsoft.com>

From the pull request you mentioned I understand the commit which affected
Cilium userspace is 68ac0f3810e7
("xfrm: state and policy should fail if XFRMA_IF_ID 0").

Whereas 8dce43919566 ("xfrm: interface with if_id 0 should return error")
involves xfrm interfaces which don't appear in the pull request.

In which case, why should that commit be reverted?

Eyal.
