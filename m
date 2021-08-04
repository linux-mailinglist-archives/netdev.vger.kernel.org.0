Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9483E0646
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbhHDRBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbhHDRBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:01:04 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679B0C061799
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 10:00:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d1so3695097pll.1
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 10:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKvWHJfaSDTzQwVq10q9CLpsqGloGDn6CBvV+94/tKU=;
        b=N9saiqNhvMV+sJwE5DjQDubVei7A5YoElOdlmlL9+WRJjJ4p+0Q1E4btJc3dyvpawk
         SNh10Moa/MTNkpq8UKxPhk7ASOww8ND6jLbKHeVMUHIhtWQBrGcQI421EHVlmSowKOqP
         Vyn7IEIPEcbO+5BYIVLA8eySZV7WpCtX90MgZ7AqJ1DZkm7wR/Yz5coklszt3ILb0WY+
         AjcG4k7S/KmIGInvpfNG+AqeItkn2/o9E/RyQggcxwf/Yr9jYB5sBjBekRFIzSiH3ZKk
         PN0TIrf3ejKch1MkM7FSHhawFOlnME5DE2zNvtttXB1FfGX8KaJh81snVJRfCLEZ0kHg
         N/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKvWHJfaSDTzQwVq10q9CLpsqGloGDn6CBvV+94/tKU=;
        b=iuIlviaQlrlGpuiMgwbXrTpzL8AQFqy0IpB/3q/pMAr+nCvZ/C7EXMVbcVtQqvSVc5
         42YHqeB4Lebz1tCwSMgWe25XjmjyJlHy1+X3xhRZx8fFxfuDybjD9TBAfdmZteSgEsJP
         ySgwdXKsDq4ttJuZ7tZ0ATNUY3AKWQOIF+qrS/fVqY3c8q1E0evLWU5SEubgREroWoLm
         mXVVcOQdhmi8V8qdEvpq5D6ABRq3eZ1t2f1tTqmWwumK3NmqI4YuJ9c6X0Iv9x8mnvAc
         01n6YS22x4LriHruXHaKe2mCEEGZ9v/tCe8UrTOWba/yzOEVDmE9dT+ZixO9Iz+N4Osu
         eGtA==
X-Gm-Message-State: AOAM530jqpJuWzlHk3uFeBFRceJPZJwvgbNXVNgbN2XcQSxdEf8/xG1q
        rXTNPkJCS6Gq9coqy69t64Oznw1iPHo9HwILxY3MHA==
X-Google-Smtp-Source: ABdhPJyYBoL7zV5HSnt+X9+yiJAZhpSZgf3ZKWqNP+3Z/G/w7IaSyMLU2C7PXkM0RGA0vYvhAVXGHdVvjsUQgKMb++M=
X-Received: by 2002:a17:90a:a896:: with SMTP id h22mr10929593pjq.231.1628096450948;
 Wed, 04 Aug 2021 10:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com> <20210804160952.70254-4-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210804160952.70254-4-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 4 Aug 2021 19:10:33 +0200
Message-ID: <CAMZdPi-YeJg7zwndHRDtwopO2He+F1wXdVqM6JfL3gLyLhwtYA@mail.gmail.com>
Subject: Re: [PATCH 3/4] net: wwan: iosm: correct data protocol mask bit
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 at 18:11, M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
>
> Correct ul/dl data protocol mask bit to know which protocol capability
> does device implement.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
