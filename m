Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7370A360317
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhDOHSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhDOHR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:17:59 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE87C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:17:33 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id y124-20020a1c32820000b029010c93864955so13971651wmy.5
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4L+ZAoqFAzFhWaAG7xzAUaO27laLeC8jL1+UVzKbFvU=;
        b=K9ZM/ghCjx83YmEKZh35n1pzJPWbRLn0YmONS3B5GMF6F9UleO8adQ29QbVsqOtPAq
         Iqclp8cZ3H8JhEvW1ML/z9yspGZ34W/MGoUcW+YuGJqjZcEZ6Dft7bRyCVZOjWgYmsYp
         W2dIAB3n/ZNwC7l/J9EGgn6hiJP3QvG2XIRWk6lTzNwJt+2aOYfhvCaRiuDJD/RqRgWl
         jrnR4JjF6THyFNzldidf8EkMxVsqLT04zcu6B5JDkXc78gFgPlqGb06xIMSNcG+uCBAS
         QUH33wr6/yanwvjbpOWzt0fwkstiH0JLNk3ow5/f+j2554JiqW5gUaiZHuNQR9T3HfL+
         Ythg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4L+ZAoqFAzFhWaAG7xzAUaO27laLeC8jL1+UVzKbFvU=;
        b=eQsSVdWCDrFxoTLwk7HWLjOZ81APfwFbBsNmFRkBYWuPTMTwH41neS1DE2cYNXikKN
         ChA7KK9VPuI/W/QipId60LsYi4josO9iJMSHBTX5rZuMZEc+7CGlO2iOnt2cTmLWiIRg
         IRLvLcGPTIx3tShq1TBvkpnQYL9Of5Y6DFHi0NqSoasTmaJxZmu/QulGnM6ahYF3bsqh
         HKUhv1/rB8sxNAsd3FBXMaoURQlB7Z7burWKm1j6ZoJOMHnHQy1qKhI9tdhzB2YfZ7q/
         dwCDn9uMIWO+k+z3CwAmbIXfuJUpJ9yGt+/QxXr2fPiywW2olvv20z7prGAem1a4MSlE
         COpQ==
X-Gm-Message-State: AOAM530Wug5wVsT/jYtuPPeww6IR4ndea5FtsM64JUpltPT1dSzuni9w
        eKrEDcskfA1wN5btMfqvpmwiRmxcuGgUziEEUqF13bGMzBgA5Q==
X-Google-Smtp-Source: ABdhPJwesAYVKuNVgiCtvwl0h2Z3kfP9A4BJ0aiDwVngskj8hZ/I1Kh5FIScf5CHKPM+axDburnhetqqdL3E4wXzoNA=
X-Received: by 2002:a1c:7e45:: with SMTP id z66mr1637023wmc.126.1618471052218;
 Thu, 15 Apr 2021 00:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
In-Reply-To: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
From:   Bala Sajja <bssajja@gmail.com>
Date:   Thu, 15 Apr 2021 12:47:21 +0530
Message-ID: <CAE_QS3fUAerYjK2FEoigdqyvpezo2XRzjoqAP-a-ETVQJ_rJvg@mail.gmail.com>
Subject: Re: Different behavior wrt VRF and no VRF - packet Tx
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forgot to mention Linux version:
Linux DR1 4.19.0-16-amd64 #1 SMP Debian 4.19.181-1 (2021-03-19) x86_64 GNU/Linux

On Thu, Apr 15, 2021 at 12:45 PM Bala Sajja <bssajja@gmail.com> wrote:
>
> When interfaces are not part of VRF  and below ip address config is
> done on these interfaces, ping with -I (interface) option, we see
> packets transmitting out of the right interfaces.
>
>  ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
>  ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8
>
>  ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
>  ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s8
>
> When interfaces are enslaved  to VRF  as below and ip are configured
> on these interfaces, packets go out of one  interface only.
>
>  ip link add MGMT type vrf table 1
>  ip link set dev MGMT up
>  ip link set dev enp0s3 up
>  ip link set dev enp0s3 master MGMT
>  ip link set dev enp0s8 up
>  ip link set dev enp0s8 master MGMT
>  ip link set dev enp0s9 up
>
>  ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
>  ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8
>
>  ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
>  ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s3
>
>
> Regards,
> Bala.
