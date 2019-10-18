Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90131DD55F
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbfJRXbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:31:10 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46271 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRXbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:31:10 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so11473754qtq.13
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OKhpwFmGIE5D5P3Wf1NMb4ssB6bFjLOC+QgRBUNlztk=;
        b=Vp2LwzSkMtzzfzsNXm2DgY4dRUPy0iLACB4J5gDby8w9RiQfqMVrNVjfjtTwcVQE3Z
         3BtnB5dzIG7luCx7dR5/wLZqn7CnNztoJzwbIuV/sS07poTkCW9KJoTIhC73RGGUu2Eb
         /YTdO4LxCTW+dystVJ1muTix8hC0KSP9DsnJVHV2M1zIEIHJZmZ7n3woJaHHJk+YQj7Y
         Q1l3C4OnklqqbFPq4I8QA+XcsBmmH1x3mVIR2uwGhC7x0PRTB5+JTk4081J5UK+tumZJ
         AN46PIKOiL6Tw8Ix3xsmOfwP7q/nUwxchwKC5BK1Hylra81Mtybc+BD+d98lgkDsmWzI
         9eeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OKhpwFmGIE5D5P3Wf1NMb4ssB6bFjLOC+QgRBUNlztk=;
        b=UgHx1uEMIqaSMP1+Jhs1hlqgn1qvme4DhltTw79+Npwt5hNEPNoZyrKjQFwa7PgpFS
         LwnJLriXOSGR6EK7ja71v5nduQEfm+V+z+d9jpYTUmaGIkcWePKnGDNhnHkU2EgMDPiE
         Iav1r9SLnbhEAmLba1Nuk7fnw9lheCcucUhmmOrYiv9z0H5ZqXq0LbNoCu3tsac7P6LY
         0Kp+bdphYYTwnJd7u0P+h/JL7JRUUi0jOXy4dIYyyOxeiH0/+WkUK/tkvOPJnjKZaf8E
         SdWVj+MBRxr31M0yleHLeySakZeYHOfXeiLdfGoVQZQLfSEZ9VersBQSbsLvwP+/8S87
         VSPw==
X-Gm-Message-State: APjAAAVK803q4GDwxPQK1fxaug2jgUPqiTM5yrB6weWX53fWttVfysNO
        p9S7DDYQ1jRULlLYVx1O3/dqaQVs0cezGuA2Z6U=
X-Google-Smtp-Source: APXvYqw1gIFqwkIO3GzScC4rdY2sqS3Wuwyc0jYKq2GylJ6DZu+aBaUl7Bp48+4Ak/zFi3IMZRvIfvGBqWsjLzB07nQ=
X-Received: by 2002:ac8:28e3:: with SMTP id j32mr8279110qtj.212.1571441469709;
 Fri, 18 Oct 2019 16:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-3-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-3-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:30:34 -0700
Message-ID: <CALDO+SZystd020AMALA+uAt4q_KQkc6MAX5A2A23_4XCXO7x6A@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 02/10] net: openvswitch: convert
 mask list in mask array
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:52 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Port the codes to linux upstream and with little changes.
>
> Pravin B Shelar, says:
> | mask caches index of mask in mask_list. On packet recv OVS
> | need to traverse mask-list to get cached mask. Therefore array
> | is better for retrieving cached mask. This also allows better
> | cache replacement algorithm by directly checking mask's existence.
>
> Link: https://github.com/openvswitch/ovs/commit/d49fc3ff53c65e4eca9cabd52ac63396746a7ef5
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---

LGTM
Acked-by: William Tu <u9012063@gmail.com>
