Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94139CC99
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 05:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFFDxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 23:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFFDxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 23:53:42 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7BAC061766
        for <netdev@vger.kernel.org>; Sat,  5 Jun 2021 20:51:38 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 27so11181285pgy.3
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 20:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJ1gszHKQyIn0QDL1xL3wJ0cTXR20fOH9BhTc1L3+FA=;
        b=RWqYM2Rb45fvzV+In72Ejcc+Bk45gB7AosdnuRyaE6rERs96YyqQ/i2Jc9kuKYylTP
         LsUh6h3eLy2n91DrtfqWVF2rRspXfWIU9hfYQSKCnO+ruj2T0Ieu+vxEbWp5Ue8uYnLa
         H3ovQfyQE+n588chGAiD999TRpVrFCCoFGYvcJP0VhrWmU1942Y2e/hfF2Y0C3w1PjIm
         dLaG3sJjctNrgfqNNN4I0Owmf3oKdlyBjcIWgRtMxQLAlaO0+1CqO/2ctZ5po2mBzE0k
         YrccBxDDSxpjh7YNEHP67lYmNclVo4k/iZDg77MO/SGebizgLc6FV4LevTT25cGpAfWF
         6PWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJ1gszHKQyIn0QDL1xL3wJ0cTXR20fOH9BhTc1L3+FA=;
        b=bQYnlCbOFaKbFpJD0zBmuSK0eLBCk/0ny4slDyfKDJfrW8+E3n4lVsAtWjoNzQxeLI
         B7bjz1wANQQaE7Xgu52kAJkmuGdX9SZpLK6Q/pdTS0fGLrerKPsns8CFRgYNyb7A8IAv
         01qkkmzy862mbrB+T7YipdZCKW89kVGtITIjgu8dMBDyginX64pu5FjCZFrLBBE1IKwJ
         6xHRTeIGnjo00B6duXYfIH8i1sZ/Qm1AeMfJRpZQwl7sn37lAuChqMwR9XbMIh88Zdgs
         /7q1bg6oCRm76PxXuf1eDShLO8V/oPUaXrcg/uRclDCsU9Q7hnbr1i00oK+FjxwWWHaq
         IWjQ==
X-Gm-Message-State: AOAM532yUcDq+lTBdfIEWgAySkqbEDH33rvCRQ03UDCP33LMHWmIe4uc
        nkfdljQAuxd1L9eSNX1lE/y5tA==
X-Google-Smtp-Source: ABdhPJzl18hGCg+EIhR7whKdKOIsGhIC3VtgDeoSKoR/rCOfYVS9hM8QBujhKKM/bBdbvWyLemLa/w==
X-Received: by 2002:a65:6209:: with SMTP id d9mr12419611pgv.39.1622951496597;
        Sat, 05 Jun 2021 20:51:36 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id u23sm6096003pgk.38.2021.06.05.20.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 20:51:36 -0700 (PDT)
Date:   Sat, 5 Jun 2021 20:51:33 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ip link get dev if%u" now works
Message-ID: <20210605205133.38be83c5@hermes.local>
In-Reply-To: <CAEmTpZHK7OoWxpGXKc0_=yYhW0YxQVZUYU3_Gkpf2VeA9xBMXw@mail.gmail.com>
References: <CAEmTpZHK7OoWxpGXKc0_=yYhW0YxQVZUYU3_Gkpf2VeA9xBMXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Jun 2021 09:24:39 +0500
=D0=9C=D0=B0=D1=80=D0=BA =D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=
=D0=B3         <socketpair@gmail.com> wrote:

> The same:
> https://github.com/shemminger/iproute2/pull/43
>=20
> I give any rights on this code, please merge.
>=20

Read the comment, all patches for iproute be submitted as normal
patches to netdev@vger.kernel.org.
