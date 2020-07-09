Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67454219660
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGIC44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgGIC4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 22:56:55 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA37C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:56:55 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q74so827476iod.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 19:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwi4XiRSiSHdZ35Fhs59FbXA4LdsHf9+LFsa9mWmJpw=;
        b=GoUMytjouTR+pFo7yqbmKClMAiSIzjfdPDYxzk+/0U1rnuqFrRWKWXyI/q8mr5gJZ6
         S4CX1vXFr+XzjsnrxafQwFkO82vLsjXFK49zainaT0mNFFDh4TRxRQUfl4Xzqtd8qJRd
         elurSssXBzgL2HxsbyK0cSdZRVY5rIljrp0ZyyooQSoEpN6mUpw7bFwZ7tPu4DHc66+n
         mNz3U+q+CFcS2EHEWq35HyCw2ySmapEzSUKM5syw92Lzno8JPa4z0GVC4MBHQH8HRk3R
         24bER5+ir7L0ERV3Hn1JMnloM/jdZV33qJSiCwYu2bpFeBy+++kWCCTe2zmFiOdaZA/S
         5k2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwi4XiRSiSHdZ35Fhs59FbXA4LdsHf9+LFsa9mWmJpw=;
        b=QQrTtL6oRNUD8AgElgRG0x+35p2nrrSLuI9/MP6H7uEOk6/SyPB+WjBtx8pcy03VEf
         FflBGxyYFXJueEginAa3pXI5GlBECz468plMNNy+x9JuiRhw/Kde7VDtsu6UICiRHTRh
         YvbH4YURFwtFgt4MSfSdQzUbtB/rMeGPmsTFrOVf8I61qr6co8rwGtC1qDOqV4Es9BbU
         SA3Kj3lULpUrdSAchvxz8GUErn+2SxfXWnfbUqE7YiEg5QshL+QN+cZGnneMgicSClk0
         SqGjb0wTPRG8A2Ih0ZhMKhDP855yEC6WYTUwrO1PlvaI9FK651A6ETT7HMnPyqeOnvYO
         T1wA==
X-Gm-Message-State: AOAM531lZ0Eyli68XAgWgPF/T11TyUmLUGMVmRMe4hN8e5CN+x/JbtH4
        mfDu7zj2YeHWojb+KQpp5tZTVCf8tOiJfR9tG09naDxq
X-Google-Smtp-Source: ABdhPJxQvBks76brYL22SCSS8XAE8rPqOpTGVPtwNtd0GDw65uFeLybzI5MjY0lJ0gpMwpRTCTda0FZn95QjdX2NAx0=
X-Received: by 2002:a02:a408:: with SMTP id c8mr71312527jal.59.1594263414769;
 Wed, 08 Jul 2020 19:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200707075833.1698-1-Tony.Ambardar@gmail.com> <20200708084904.5affa861@hermes.lan>
In-Reply-To: <20200708084904.5affa861@hermes.lan>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Wed, 8 Jul 2020 19:56:44 -0700
Message-ID: <CAPGftE_4ea+AVOEjM1CUsL-CvyR8oCk19hx69KS9SroRwzhBOg@mail.gmail.com>
Subject: Re: [PATCH iproute2] configure: support ipset version 7 with kernel
 version 5
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 at 08:49, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue,  7 Jul 2020 00:58:33 -0700
> Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> > The configure script checks for ipset v6 availability but doesn't test
> > for v7, which is backward compatible and used on kernel v5.x systems.
> > Update the script to test for both ipset versions. Without this change,
> > the tc ematch function em_ipset will be disabled.
> >
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
>
> Sure applied. Maybe it should just check for > 6 to be future proof.

Thank you. I kept the test as is since I couldn't confirm ipset
backward compatibility in
the future. If you have more insight, please let me know and I'll update it.
