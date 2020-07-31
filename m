Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875F0233FD7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbgGaHRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731419AbgGaHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 03:17:04 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CFAC061574;
        Fri, 31 Jul 2020 00:17:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 184so8304939wmb.0;
        Fri, 31 Jul 2020 00:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E+tw2VAROExVGHLJNmJ9/Lq7zWPSq7S6kqBOfS0IpPs=;
        b=CNNbMOaZdUSCoO+D9Utq8Gp4hQ62Gyez7Y80sarcNTZsdqkKumqIea6371xjdWRfqD
         Yl8+1vUjxO1ZJS/NBcejCBvoQk8TDxVhEaKkauKBIS+JmAzPKrLxfQE7bmHfYJCqYoa3
         q/V5HhH8YzlnzHG2wuqpb8mlixAJqs4juppg0oXfhnMobiMxxscMJ3L0Twd9aZ6b8i8p
         xoX8uNhC5sTX9XTYz/kkQ1UAvTnEuCudw/3LxNVvSsfAZ/o/+jzlTCLPytNQ/B9v076j
         ZX5Uvi76z5GY1rU0Dxx9jdsTl5EYJCF/v0MbDOJG7zcIhd+fLfMXTCyVp/ZdyiaQ83ge
         itjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E+tw2VAROExVGHLJNmJ9/Lq7zWPSq7S6kqBOfS0IpPs=;
        b=HEYmgCoG6Igodix0SE3wnhojV2gvbo3+EElLD6xMaQpRA3CVnBg2inBfifeayE8j1e
         dwCqpwZ9cKT5yPsczprZAw+zf7oHiYZUtzp10X4Ch95scRbuSPWbLQii2KuF+eHV8Va3
         QxJ6LIoSEcqzUVCBwbZW8v0H3+0Tyxw9Q//BJOukhAydVWvzgIutaQxIFmN2kqIzaSME
         LXX25RUjH+ZRixy9LHXlvUgur6BddKuCaR2OpRnRB5raQ44MO4ZvNhWr6ot82CN8e8bY
         tu1X/MZCNLSsU/5bFhkc6UWXGuccL6KZ6AsR3kwpZ387kwsPEDC4CTEutcam9JdZ2dk1
         05ZQ==
X-Gm-Message-State: AOAM530al4p4scPgSVqqCnuVVMs+cbv6xR8qIHxCqOlA3TpnFMm6key4
        rPMpzrvNwnFXj9ugH5/Bt74tB4BIvQT5Dmmu1Qg=
X-Google-Smtp-Source: ABdhPJwo9EuO2/yVoxRxwlf9LsVN2UI7WLueZMkZmvA+8GS3BX71QFSw/oSkGbLHOB+Zb97AEGyOWAKL3KCx9mVHz5c=
X-Received: by 2002:a1c:cc0c:: with SMTP id h12mr2529357wmb.111.1596179822962;
 Fri, 31 Jul 2020 00:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200731064952.36900-1-yuehaibing@huawei.com>
In-Reply-To: <20200731064952.36900-1-yuehaibing@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 31 Jul 2020 15:28:26 +0800
Message-ID: <CADvbK_c8LtT1Jfbf4h1HrAC4p9wGproDgDieSV-roSWEEN=M0A@mail.gmail.com>
Subject: Re: [PATCH net-next] ip_vti: Fix unused variable warning
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 2:50 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> If CONFIG_INET_XFRM_TUNNEL is set but CONFIG_IPV6 is n,
>
> net/ipv4/ip_vti.c:493:27: warning: 'vti_ipip6_handler' defined but not used [-Wunused-variable]
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Fixes: 55a48c7ec75a ("ip_vti: not register vti_ipip_handler twice")
Acked-by: Xin Long <lucien.xin@gmail.com>

> ---
>  net/ipv4/ip_vti.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
> index 49daaed89764..f687abb069fa 100644
> --- a/net/ipv4/ip_vti.c
> +++ b/net/ipv4/ip_vti.c
> @@ -490,6 +490,7 @@ static struct xfrm_tunnel vti_ipip_handler __read_mostly = {
>         .priority       =       0,
>  };
>
> +#if IS_ENABLED(CONFIG_IPV6)
>  static struct xfrm_tunnel vti_ipip6_handler __read_mostly = {
>         .handler        =       vti_rcv_tunnel,
>         .cb_handler     =       vti_rcv_cb,
> @@ -497,6 +498,7 @@ static struct xfrm_tunnel vti_ipip6_handler __read_mostly = {
>         .priority       =       0,
>  };
>  #endif
> +#endif
>
>  static int __net_init vti_init_net(struct net *net)
>  {
> --
> 2.17.1
>
>
