Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF452899FB
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388117AbgJIUtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgJIUtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:49:24 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D46C0613D2;
        Fri,  9 Oct 2020 13:49:24 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so11565608ior.2;
        Fri, 09 Oct 2020 13:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=l6E4B46e2XeP9h+qJ2Ghhmtiv8oTVWyHQipTgIS48gY=;
        b=mTs3JpJYvoM31Wsn0xENzCmbYma6XACEtukcUiHp2VAdCVorpafI11+3nrJOK9/lRT
         V34st9fKO3/pGPJEsvOwlnZ10ipwCKYC0I6lmfAkeJdcGf5reNLq4SHHQVzdZdcHyqZ7
         Lw3n0mvhAX7S9XGA291PmHSF6HSlLS+H+BvNavlX/vPGyrPC8e6BMNPyjLaCgiPgFUBN
         gg4MClPzy7mlvz7TeOoT1AinBuwYJ58eZCWwJ71d4Oa5HlUkMzBOUv9ijLu/+PVkxgxi
         pHSb0tUgjwWsnnj+8cHWkMyivNQrOxvqF1NVL0USIJkkavlKLG0ncNwXsjsWOubp9K6Y
         awIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=l6E4B46e2XeP9h+qJ2Ghhmtiv8oTVWyHQipTgIS48gY=;
        b=MezBC6/9dieQ5245/ERgLvNiP5R1xrvfTdVxnMI+YGGNU7jgukXkhR2qLiIAKl9ndv
         uQ5MIYHyUQdWBlahWyKsu8xSk5JctQKZ/UKubIilpWhc6hFeiW4XqISP14TiYjJCGcCs
         kixrpATCA2+M4Dy2wRpDEHYEk5TuZeCvyHlmH0CsM1Wj52kTH73u8blrUdq84sA/vDXB
         ADSHrWDpcrBKNCfBAdQRM+I9xnXfEgnBy4GW2SQqVQdXJSKVwxRgL59M9Sp3zDthCRm/
         mKb7WNRLbK8adI7tubkTpFG80/bWJqyYMOpFbxyVqMEEb+lQuOx82Vy2VxEWs8b8V8Gb
         cPkQ==
X-Gm-Message-State: AOAM531RXcYc5DL6RGJf+sw4NGuB7l84P/FQsJUCP2hDQxZoci1U+sE3
        iynBZcDBw5PQ1h9/xyrcq4s=
X-Google-Smtp-Source: ABdhPJz0mDjWI9cLGZI1APL1SkK/C90ahx8YNdOQKSadUt03k1qQAZbFQ4v0iJX2QgAk2JhI5vXHPw==
X-Received: by 2002:a5d:9e4e:: with SMTP id i14mr10583360ioi.22.1602276563613;
        Fri, 09 Oct 2020 13:49:23 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z20sm3941046ior.2.2020.10.09.13.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 13:49:22 -0700 (PDT)
Date:   Fri, 09 Oct 2020 13:49:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        eyal.birger@gmail.com
Message-ID: <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
In-Reply-To: <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 08 Oct 2020 16:08:57 +0200 Jesper Dangaard Brouer wrote:
> > V3: Drop enforcement of MTU in net-core, leave it to drivers
> 
> Sorry for being late to the discussion.
> 
> I absolutely disagree. We had cases in the past where HW would lock up
> if it was sent a frame with bad geometry.
> 
> We will not be sprinkling validation checks across the drivers because
> some reconfiguration path may occasionally yield a bad packet, or it's
> hard to do something right with BPF.

This is a driver bug then. As it stands today drivers may get hit with
skb with MTU greater than set MTU as best I can tell. Generally I
expect drivers use MTU to configure RX buffers not sure how it is going
to be used on TX side? Any examples? I just poked around through the
driver source to see and seems to confirm its primarily for RX side
configuration with some drivers throwing the event down to the firmware
for something that I can't see in the code?

I'm not suggestiong sprinkling validation checks across the drivers.
I'm suggesting if the drivers hang we fix them.
