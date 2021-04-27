Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A2936BC86
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 02:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhD0ASy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 20:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhD0ASx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 20:18:53 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AA4C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 17:18:11 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r5so7904234ilb.2
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 17:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=feclZ3+4A23tEnxB+qNcXpvGFi89Qn9RhRub1KE2XC0=;
        b=TWmZ3gYBHSj2Jz/SHlMDhYEthC627lvFLrSQy4ZRn18Hghgpxf4tLB/bzEa25bVnlc
         Vr3/hMAJwWboiiQYYP3j87reIKjGn0oBtZ3Yp1eZzRMERlKHgwJGjklo33mu2vLXTQZb
         hOhIotW7IRw+qKdM5J7mw8BRtz7ndNkmZzUBh3wk4Cslq+AZI0/dCe1txjlacPZ26Vq6
         Uxk7UepHF4mTQYkeCqnuLb+gig9qas8wo92NnMc48+Eq/6iN/ZIbX92zYwEyYBAIyVVG
         kw7DB9Ux40/6NhqHgQi6T6ihZDbviEzuweQdihTb13d1hzKhqYIAgv1afntpdyfOAe8d
         bvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=feclZ3+4A23tEnxB+qNcXpvGFi89Qn9RhRub1KE2XC0=;
        b=hfHaMAS5bxNxNNtWhLamv/NHCiJo0/ALC+AzKhlbsW18KDne2l/JkYlHlXQ2nkAVZr
         9SWl5ofXWZGPzHh51eeVD3zbd7OTBO61+TmcF8aXFjCqJEekAJJkX7Cpya8y1ElQvvhu
         EZy6ICOUC8ToBDtX5RbGDlM6/xsbXhJy/sxJG7uF07wLnjlscZ2B5/lQa3YxHB+hhFr3
         n4YEG43bF8x0XnBYc1NxUv6lE4MyMZgRuVFPxUXgn9Ume5ZmxWTzZ2UfBlnwqIvRxQgF
         ZYUemoNUmCPckQ+0agv/s9TuS/sedbXchud91qhUHSH6BBeFd0MqI/l7Ck4VA6Eeu6Vo
         TBwQ==
X-Gm-Message-State: AOAM533DETbCJMBwTLagTms0SGdlpZ3X8ViRI8xPIEoh0MZxkxJBqapl
        YWDgExDei0Eq/fJ1pkE0jDDheA6/ViefdqjV3Yg=
X-Google-Smtp-Source: ABdhPJx7p4VfJbtjW+cNpJ255jPdtVpB59KdKXG9snR3JLnw9dPvM2uYEs5hvHicmpwrINankoYr1J0HaL5GqgY+rqk=
X-Received: by 2002:a92:de4e:: with SMTP id e14mr17195198ilr.129.1619482690955;
 Mon, 26 Apr 2021 17:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210426233441.302414-1-andrew@lunn.ch> <YIdOmvPFTCcmwP/W@lunn.ch>
In-Reply-To: <YIdOmvPFTCcmwP/W@lunn.ch>
From:   =?UTF-8?B?5pu554Wc?= <cao88yu@gmail.com>
Date:   Tue, 27 Apr 2021 08:18:00 +0800
Message-ID: <CACu-5+0bnMJPOUZHKfSTEQiFgAVX9kjbgTTQtqLDT57yv0MDHQ@mail.gmail.com>
Subject: Re: [PATCH net] dsa: mv88e6xxx: 6161: Use chip wide MAX MTU
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
I'll test the patch later, but what about the 88e6171r switch chip,
this chip also got this issue since kernel 5.9.0 Many thanks.

Andrew Lunn <andrew@lunn.ch> =E4=BA=8E2021=E5=B9=B44=E6=9C=8827=E6=97=A5=E5=
=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=887:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, Apr 27, 2021 at 01:34:41AM +0200, Andrew Lunn wrote:
> > The datasheets suggests the 6161 uses a per port setting for jumbo
> > frames. Testing has however shown this is not correct, it uses the old
> > style chip wide MTU control. Change the ops in the 6161 structure to
> > reflect this.
> >
> > Fixes: 1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size=
 for MTU")
> > Reported by: =E6=9B=B9=E7=85=9C <cao88yu@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>
> Hi Dave
>
> I have no way to test this. Please don't commit it until we get feedback =
from =E6=9B=B9=E7=85=9C.
>
> Thanks
>         Andrew
