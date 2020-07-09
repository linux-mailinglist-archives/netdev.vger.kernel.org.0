Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A92A219FE6
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 14:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGIMVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgGIMVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 08:21:48 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D793AC061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 05:21:47 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id o4so1015548lfi.7
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 05:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=MYqN9GwvxDULCNeXLySa8pNzJyV/Zz3BtJrQac+7wS4=;
        b=Yyk/I5VWh+NoBhKtnJPoq5rxzIuy7xDA3N07dQ3QZp3Nk10PTRC82wHrZ2/G6ASjZ1
         3JJjmH7vnBUEx+lQN72rKQTKsq7e7is0H5lPUDIX1CCrpAFJTpnLA4r61gsEKvHDru9s
         Fm8VR8uDsAtb7FW0+bKERLZ0K0bhMgWIbyjvZP1wFLxaMySLGn3ZBrI2MA/Vw5ORP+42
         Nd50a0+j1PmBQSRExQky9D0d1Rn6n/6AAUtUnHe4p4N1eT5j0Yf6MPekDs+dZCMZF/nv
         jK7HWvyJ0lFRsfnyxzl8nPwlZUhD8WiErfQfrabR6GSB/TVe+pjEplePKRrViTk9+3AE
         HqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=MYqN9GwvxDULCNeXLySa8pNzJyV/Zz3BtJrQac+7wS4=;
        b=ZEEnimrZBSFQSFRzRv1GA+Ht+Ag0Gw6kL4KIDVKavyNcKHRBbnm5WM9TyUcux7k4jz
         Or/xZZtpXJXqu5poGhA8fNwBk0+yhUp3Qk7/ieHR2WPtFXL9UXCN5zMtWQb8DCLsIg0P
         QSiPrDQTm7QmJb/q5Q3qVvZYkyNB+N6pIWEXk19oF3xeApF7PiznZtsYUkcxESYdpFZ2
         /3wXyEp/DGVZePzRhiGrFAyS9Mj9g6vhvUn7lZQnlqgGaig9kvQZB/diwuiQCXr6Zp54
         7QaQnosvpxXcp3DANx1HJdSHd92NNcKFEy22luexSlKcO8dfPZDPvRe0WaAAcTFFjwyT
         57fg==
X-Gm-Message-State: AOAM533wmTc8dySGyBBvyayWw97b4RcfP2VCYGXMMyg+LQH+KWOwDhFy
        bgJi7YvAugV0jt6EnzbYC8g=
X-Google-Smtp-Source: ABdhPJzlEFp/nnLIGArQr76qm/W75VVgKm0AlBHSmC6lH1MQU/haDAKw+go5egvFpE5GLKWiKA8k6g==
X-Received: by 2002:a05:6512:54d:: with SMTP id h13mr39596661lfl.8.1594297306228;
        Thu, 09 Jul 2020 05:21:46 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id l5sm1111463lfp.9.2020.07.09.05.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 05:21:45 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH] docs: networking: timestamping: add section for stacked
 PHC devices
References: <20200708205621.1463971-1-olteanv@gmail.com>
Date:   Thu, 09 Jul 2020 15:21:44 +0300
In-Reply-To: <20200708205621.1463971-1-olteanv@gmail.com> (Vladimir Oltean's
        message of "Wed, 8 Jul 2020 23:56:21 +0300")
Message-ID: <87mu48ho9z.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> The concept of timestamping DSA switches / Ethernet PHYs is becoming
> more and more popular, however the Linux kernel timestamping code has
> evolved quite organically and there's layers upon layers of new and old
> code that need to work together for things to behave as expected.
>
> Add this chapter to explain what the overall goals are.

Nice job! That'd definitely save me a day or two if it were there a
month ago.

Please see one minor doubt below.

>
> Loosely based upon this email discussion plus some more info:
> https://lkml.org/lkml/2020/7/6/481
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  Documentation/networking/timestamping.rst | 149 ++++++++++++++++++++++
>  1 file changed, 149 insertions(+)
>
> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index 1adead6a4527..14df58c24e8c 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -589,3 +589,152 @@ Time stamps for outgoing packets are to be generated as follows:
>    this would occur at a later time in the processing pipeline than other
>    software time stamping and therefore could lead to unexpected deltas
>    between time stamps.
> +
> +3.2 Special considerations for stacked PTP Hardware Clocks
> +----------------------------------------------------------
> +
> +There are situations when there may be more than one PHC (PTP Hardware Clock)
> +in the data path of a packet. The kernel has no explicit mechanism to allow the
> +user to select which PHC to use for timestamping Ethernet frames. Instead, the
> +assumption is that the outermost PHC is always the most preferable, and that
> +kernel drivers collaborate towards achieving that goal. Currently there are 3
> +cases of stacked PHCs, detailed below:
> +
> +- DSA (Distributed Switch Architecture) switches. These are Ethernet switches
> +  which have one of their ports connected to an (otherwise completely unaware)
> +  host Ethernet interface, and perform the role of a port multiplier with
> +  optional forwarding acceleration features.  Each DSA switch port is visible
> +  to the user as a standalone (virtual) network interface, however network I/O
> +  is performed under the hood indirectly through the host interface.

Here, "however" somehow makes me feel uneasy. "even though" maybe?

[...]

Thanks,
-- Sergey
