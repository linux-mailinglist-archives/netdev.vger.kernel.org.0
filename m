Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D413E25383A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgHZTX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHZTXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:23:25 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A98CC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:23:25 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id 68so925188ual.3
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 12:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=el5C8VGimQbhJC5S5Are2GRwW9nrAyB40KGB2ruX1Ao=;
        b=p8gr+lwrmEmoUL1cOEuQURiU08XITIwxHPZsca3SO8J+zzcOWzr00OvAFGEHlv1ZVB
         f6WuAs5d3tBeivzVandUbGN0VMQTUEvmynCNgCbMK9m3RDbWSQ/fUnViATSQM+dTYUPP
         oLWJAcVEjyYxK0YpUpojpcZVNYbBn5IOtwCTiFleMdnif+IvuKM231UnZz+o0jb5HShF
         9eRzZ0iHg+Pijyzf1kaJDzK+LcQiXjUwt/afxABHeH9NptAG7cnLyT4nuU/qPT1WhhRQ
         Ptshems5ZJDLfMqGlvNZmwDC1c2q0III2mlYxMf2RKcaKOqWENs+W5vwXqNf8MyMCS/p
         KIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=el5C8VGimQbhJC5S5Are2GRwW9nrAyB40KGB2ruX1Ao=;
        b=JjGTQYGlk1lRFXfd+djX9fNMgd9zTdc93VIjVfOuFi65rurx3R1as6dL1bwQ5i0oHC
         3nXZ94A8OBj7/T313ToGAAyFJDjdmaXh7/vFMDD/NMmgcU+Rteqrl1ZVKdLqXfsbQG68
         Sa5iVJ9R1r5MJw5zKgAzCFIF7c0rPXIZjvjQWLDHspyxFlx0GUKG1YkGNPxu9l3LCfeU
         nj1YQg+yxtdECtATmdo+lgJuW9BYB5HP9Nb01UvC2KomQLYVh0PD5nW0ekGyh3leKYVs
         QTTRGnQDWGnfl9goG/MhN8Y9+mvX4vO1yXv95XBAGnf8eCWm96ePBu+RDkGG767fK4WB
         V0+Q==
X-Gm-Message-State: AOAM5324fl2HLZj7oMNeqBNDj2TM2yCX8olq+4+dNAQtsnt5qbuMIWJm
        GVVrKI8jspH2ORJDjvsZvWGKMoOLi4J+BuHHGlA=
X-Google-Smtp-Source: ABdhPJxj7v2mJM2hnh9Cxlj3I1qzHpEKO6Ik8kQYebp0XkmEVpY3ngu+V1GoK90Q4DRep6Zc6yWe42JEilmV77HlWeo=
X-Received: by 2002:ab0:37d3:: with SMTP id e19mr9452646uav.64.1598469804548;
 Wed, 26 Aug 2020 12:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200824073602.70812-1-xiangxia.m.yue@gmail.com> <20200824073602.70812-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200824073602.70812-2-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 26 Aug 2020 12:23:13 -0700
Message-ID: <CAOrHB_BaechPpGLPdTsFjcPHhzaKQ+PYePrnZdcSkJWm0oC+sA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: openvswitch: improve coding style
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 12:37 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Not change the logic, just improve coding style.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Acked-by: Pravin B Shelar <pshelar@ovn.org>
