Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36199338336
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 02:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCLBhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCLBgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 20:36:48 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232E1C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 17:36:48 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id w34so13754100pga.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 17:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SqPkcKYR1Kw6+9xzKvZqP+ltyEgdKJeg3LcA+iir5YQ=;
        b=mG0pbKGJYU9RVorY5KguTke3dAGHjaOAyoKsNgtKjLPGpKHWsihsJ0sG9TwEMWukBW
         PLivjfLoBHIRLrf4Za5y8A4szfNpKF1o0cgCVogRT8dAnR4jcxDLCOv813KJgP6Zgk9m
         SWXTOzd54OcY9Ju56HFr64EWYG8sbSxFzV9jn5UHnWCzVBD9sfmSLNZElO49o3W+WOnX
         7QDYFHkMce8V76CbK62DVvNVQnLURODmh81yCwc9ZJCS3ENsuWcoEPz6gb+iuLinPpHH
         +nWReLAyhhb+4myxeGMMkdgbd0Dg5JCjss5g6FxMsx+EcEL7Ik4AsE4+dFEbnpoBuknE
         l7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SqPkcKYR1Kw6+9xzKvZqP+ltyEgdKJeg3LcA+iir5YQ=;
        b=HXOqRg5IvMC8oidLINcikazLNjaJTb4ZS3AmhSXl3xAflHIlLIdJeGEKXVAY7Rsscd
         knCFG4XLrCOwI5+TbZTJTKahPJIpPsro2gVHs2WKpr1k2lZxptBS/tJ8EI+SbvRoOJLb
         bX//HKuTmRD7SIIv9mEBUqZojiZpptce1u95LKnFyNzRz+3okO0M49kpAb6cNnhQ1YHS
         1e9z1IQxruzsgkYoqeCq6vOk16ZLPx0jUZiqe/1X5CkFWhnxYqOnhmGhzL2zSGp2b/dy
         NIvVDDlk/gNg3KSzJA57E+Ks8hpx23XI5B9mRbPqKw7rlPzrPmht1p9Y1PA3jTzosAC9
         jAkw==
X-Gm-Message-State: AOAM533B5xn4tOxXNuKkYLSybFDVON6xuKgd/1JIPuxWIWdEcZITl7Wd
        rEY1Km1CDbaAOR0oj6q24WWu/DMWbA3kIWFHYuw=
X-Google-Smtp-Source: ABdhPJwGyIcFpHRGQRXk6ujemW6cX/tYLNMnK/zpCKHogYK4D2tyWaSNOFKHvFhhqyRilDY/e1KpohNG1q5IiP+ZTrw=
X-Received: by 2002:a62:8485:0:b029:1fc:d912:67d6 with SMTP id
 k127-20020a6284850000b02901fcd91267d6mr10099298pfd.80.1615513007739; Thu, 11
 Mar 2021 17:36:47 -0800 (PST)
MIME-Version: 1.0
References: <20210311144206.2135872-1-maximmi@nvidia.com>
In-Reply-To: <20210311144206.2135872-1-maximmi@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 11 Mar 2021 17:36:36 -0800
Message-ID: <CAM_iQpUs42exz_r-L=EWzbaL8J-jmxUDPy8NWu08f_FpjHCLeA@mail.gmail.com>
Subject: Re: [PATCH net 0/2] Bugfixes for HTB
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 6:42 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> The HTB offload feature introduced a few bugs in HTB. One affects the
> non-offload mode, preventing attaching qdiscs to HTB classes, and the
> other affects the error flow, when the netdev doesn't support the
> offload, but it was requested. This short series fixes them.

Both look good to me.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
