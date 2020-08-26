Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C40A252833
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 09:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHZHJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 03:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgHZHJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 03:09:36 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C845C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 00:09:36 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id k18so243820uao.11
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 00:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVZPtQKrFUjsTrBTBd2Ot5lsxpy+sE8QSoUTRLQdxEM=;
        b=s1pDIVqDdScbCVy7tyVi5liKXhJmAV4ekoFMiebmFz6ZmYBv7Lk7nwfeUM2YvAMTn3
         xQ9s0kU5T4nnlK59zt1f24/b7rXwKFwinmJNRQG4w5/260MOiQjN1UoW4cg2eHebkMht
         C/ZVUmUY1c6CR8afSxYEwkFgmZsIEfDPlGMSoqb8Tl/yMLOXy5gKvxkIIidVnr3Ogpa1
         QaDF1682vxeO7OZX5nM/wAgSM+IPmMQ78U0XWrfNfMw4BNGha+ldtwGMJhJsE7ZL4fyo
         HjCvNDANTKHzwfidN6B+AKM7lAkSJW0FhEuFFS0bi9TS5Gk+LqpL/ieCLwD+e+fiF0Bq
         U5oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVZPtQKrFUjsTrBTBd2Ot5lsxpy+sE8QSoUTRLQdxEM=;
        b=kkoYKfEIs78JGoJh7wQCfvQO3yVCu0Wv47MDVrWMkqPzCO2SZWWIlV0Be2RNgqaFK4
         dzNCD54WblNgA0Q1EN1Xku9SaXX2y6XCkVwdrXR9EBOnWOlk7P9rmMq/Ok0QujYR98p1
         JCeQrNbXxuWgXqjUV0b+qjMU/kkwy8OLJrRHb3qSLnMJJbHYAL7l4dUo1EimdlRl2qID
         Jihobx0s2MahGQvkS9tkd3MH/3gUpyrGZ26URA+QLPIo1i86J8gX2knNbcMMvYmB+N0C
         JYp2RF5JPhqNpAOoExGxc0GK8ZaVlG2OLEKaeYOg6o0xCRfnVrLopsXL7ysBhmQD3ohL
         y/Pg==
X-Gm-Message-State: AOAM532vJ+WrqwQa9f3jtCIjl6XzL3SBF9VVEi538eoGMZgryQjsYV1T
        /+E2+iHTJBdncS/zpNCG0oG+1mpvBsJddFSITVA=
X-Google-Smtp-Source: ABdhPJxYQZZFiDo+6A4ryh/RqY0rf8QGIFNvzceitKfNM3onh7XaRZeH5V8NlyHncDfv8vZD0M2zSKHfORpoEysmX5w=
X-Received: by 2002:ab0:3791:: with SMTP id d17mr7471819uav.28.1598425775164;
 Wed, 26 Aug 2020 00:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com> <20200825.093737.498387792119845500.davem@davemloft.net>
In-Reply-To: <20200825.093737.498387792119845500.davem@davemloft.net>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 26 Aug 2020 00:09:23 -0700
Message-ID: <CAOrHB_D+uow_8t9LHH+v0syE6f_+Ty_cO39+OLPVr=nvL=SbGw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] net: openvswitch: improve codes
To:     David Miller <davem@davemloft.net>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        ovs dev <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 9:37 AM David Miller <davem@davemloft.net> wrote:
>
> From: xiangxia.m.yue@gmail.com
> Date: Tue, 25 Aug 2020 13:06:33 +0800
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This series patches are not bug fix, just improve codes.
>
> Pravin, please review this patch series.
>
Sorry for delay. I will have a look tomorrow morning PST.
