Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403311C46E5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgEDTPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:15:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81482C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:15:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x77so6024934pfc.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=4Ez0Tv9rz4ZuOE3+BcM2b4+/nWJ23zLkKCl43s5/Qkw=;
        b=DoMXKK9vjSwW2Y0WHY0kCPHQrCH8zrCnd91t/HA8yGsIQBmR3T+C+liC48wsvxNUYC
         KK0+STDqIvXg7vVOF3IwrsU4C+0/+PMVdSZlC3lGsscda2dnoqROAVoMhaenxduI5a5w
         oqRUxxvq2SBK3S+/9QjoGpQ6edEDb4iT9STE0VfdmzggWClayIOGuFQZ+/EmaM4mxOXm
         ONQzCqmVIyH0ZoxePOMvcwXPMFJ/IgDL+/UXTrLQ//8ansmqMEj/qVmCreSCpSj923tA
         i0dB3EjTWKcoNDBlKamcOUWi4dc/5fJvyhAapeHBcW5fZVKQlR6hoX+kLgkx9sVr8DpU
         xKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=4Ez0Tv9rz4ZuOE3+BcM2b4+/nWJ23zLkKCl43s5/Qkw=;
        b=WM8x0BhM00AEoD8FmhT9aoOsbr5RKyiYxVmr+qi7OcVwBjcsOiJq4tbuDrFc2a6u+G
         hQJQkDnkhiGiLPidmai35ONhPzYotvpY5/ZnkRtnFDhe0RLwcn63xlHcTzZj4c09BIEC
         nuLn1CQUpRZ6VCkMydBSe1hV0paZZJwQliTajFyi/ksymxWHB5OpSgHNlPA1O/2xGDPD
         +N6jAP32ls9hAW0h4ZKET2GBVuxUUIrerVxm4LXtqANeNfZjhz7t6ED5v7LeLzIeQIqm
         pUB3YKmgnVikEDRiT0IQXkELixU0OTlhPp7RiqFzhixDbkMMJTX5lHhBFPpeSIoAK7/X
         QT0A==
X-Gm-Message-State: AGi0PuaoQVHXFlM4s4JcCAxDg5AVnvGOlCD35tRUFO133QV0+WOPU7VN
        xcn4cAoY8s6Hz3hhJxJpAxY=
X-Google-Smtp-Source: APiQypLnNuchpKqrJNZn/Iy+deO8Mfa+EVTyUPngN5VfD/hvsxEHEuQp/gICj2mQ8pQSA/oZ5MhhJw==
X-Received: by 2002:a62:7b51:: with SMTP id w78mr19363891pfc.300.1588619720145;
        Mon, 04 May 2020 12:15:20 -0700 (PDT)
Received: from [100.108.141.115] ([2620:10d:c090:400::5:f6dd])
        by smtp.gmail.com with ESMTPSA id m3sm8544785pgt.27.2020.05.04.12.15.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 12:15:19 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] xsk: remove unnecessary member in xdp_umem
Date:   Mon, 04 May 2020 12:15:18 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <6DABD443-21AE-450E-9BF3-20A3775C618D@gmail.com>
In-Reply-To: <1588599232-24897-3-git-send-email-magnus.karlsson@intel.com>
References: <1588599232-24897-1-git-send-email-magnus.karlsson@intel.com>
 <1588599232-24897-3-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4 May 2020, at 6:33, Magnus Karlsson wrote:

> Remove the unnecessary member of address in struct xdp_umem as it is
> only used during the umem registration. No need to carry this around
> as it is not used during run-time nor when unregistering the umem.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
