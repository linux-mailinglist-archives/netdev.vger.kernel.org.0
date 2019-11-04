Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67C3ED775
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 03:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfKDCIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 21:08:12 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39683 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfKDCIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 21:08:12 -0500
Received: by mail-qk1-f196.google.com with SMTP id 15so16120686qkh.6
        for <netdev@vger.kernel.org>; Sun, 03 Nov 2019 18:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=coverfire.com; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NZjd1aiE9ljfVyAYAzmVOMl1dm7M7bVI1+859Yvsuy4=;
        b=Mn9trFmjs68dJ50ygRmLgqUHFvL0TJmACdy2aoW2tUO3BLClWdSF1qTRAfQRD/Hkrr
         TMgF3WdJGW2WKP6rrgRH4ONQcj+Vjrc16KSroyYRYwWQFSr/iPQr8GlzM6Ith9qMQo8O
         gT8D8y8dp3kiShYRaL2yOK//vS4viogmucdRoJQhmjb0Wkl8FA0lzcNR191wN3htQDz+
         5yPEp98QWhZ9MLZArTjs0Ch/9u1uzBzc5xu4V3iHk0BUV4M+gwSaRF8ikMG4ouDlkkvN
         rLOCD7bI/zjPdZStNDzddlA16eRy9ecHjShjmbx0wn4ut/H/ImOpAEIQjshZ9XvQ1QeH
         JljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NZjd1aiE9ljfVyAYAzmVOMl1dm7M7bVI1+859Yvsuy4=;
        b=UBAtB9XmozXJq3X9j2fv3elOQzX0Mt1UCtegpOsHZh7LRHzhJ/ulPCQWNrOwiC9s3/
         R24AjbiVFNmLxScAI8vx9qhU4n7JthQ8TN5wDf+yyuSl3CNhdibcZ3AKiVVBpSAW+qcb
         40Fb7u+VUU6draW6B/Qa6VO7y/qlhG40qsMMw1WQV0KnJ218vTB1cWJ3NfHYsQMr4YZI
         FMTiZcc4WDsNoKCL97Vwb7I9GTAlO80nLGlQtpCuUgjQXTgQMst2ih8P1tueGI4H51IX
         WGQwyn6LImgiPKsBHq5KXF9mG+HdEpzZxTqqqfBwBfgHmajn0Liw5UEwsF1QQFW2fVlk
         MA8g==
X-Gm-Message-State: APjAAAUB7zjHV31wUtjwgHiYaB7oJcSta7fjOmMk7rl1WfByHfXepEeH
        Dunne1q0OYUhl2ByS6xiEdVJFQ==
X-Google-Smtp-Source: APXvYqyfHeKPje0Zs+td+720nNdYHowg5XX/TSNKHED/Ko7t6ratKpzO8Pb3oTDD4F8fUFumf1/Opw==
X-Received: by 2002:a37:a00f:: with SMTP id j15mr6707654qke.103.1572833291510;
        Sun, 03 Nov 2019 18:08:11 -0800 (PST)
Received: from localhost.home ([69.41.199.68])
        by smtp.gmail.com with ESMTPSA id x194sm3617001qkb.66.2019.11.03.18.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 18:08:10 -0800 (PST)
Message-ID: <82fb2eba56d84887772f9d533faa7bda9e3b2ee4.camel@coverfire.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
From:   dan@coverfire.com
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     bjorn.topel@gmail.com, alexei.starovoitov@gmail.com,
        bjorn.topel@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        tom.herbert@intel.com, David Miller <davem@davemloft.net>
Date:   Sun, 03 Nov 2019 21:08:08 -0500
In-Reply-To: <20191031172148.0290b11f@cakuba.netronome.com>
References: <CAJ+HfNigHWVk2b+UJPhdCWCTcW=Eh=yfRNHg4=Fr1mv98Pq=cA@mail.gmail.com>
         <2e27b8d9-4615-cd8d-93de-2adb75d8effa@intel.com>
         <20191031172148.0290b11f@cakuba.netronome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-31 at 17:21 -0700, Jakub Kicinski wrote:
> 
> My concern was that we want the applications to encode fast path
> logic
> in BPF and load that into the kernel. So your patch works
> fundamentally
> against that goal:

I'm only one AF_XDP user but my main goal is to get packets to
userspace as fast as possible. I don't (currently) need a BPF program
in the path at all. I suspect that many other people that look at
AF_XDP as a DPDK replacement have a similar view.

