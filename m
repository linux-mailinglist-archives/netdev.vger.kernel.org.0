Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58D8F487
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfHOT27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:28:59 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46576 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOT27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:28:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id p13so2713927qkg.13
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 12:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qnb1kJVM+ye3vGOEYAiSOgWaI3eqtlq3N9qsMgSh97Q=;
        b=JaxEwRb54HjwKuEneJpNZxQXixF0DRverv10uYcg0cKMh+ECh1y3PYBIoVR8Ow63CY
         /WKKphuy/0ciV1fNmih3/+fh1ESfjqrk8yHo0doVrzNTOxcJMsagAdyXMS8N/hUKLJPO
         ys+xqkbDGaAu2an70dXBKE7/dX6r7CD1hTWHgLBbP8r7EYoOkBUlQbeN2jIMyj9Dysla
         wDX7CxJU3y8ZMIq76PCJUoS7kW/AF751fzeef3qiIS7S2cYClSK9dT24i7ZuQPd5uFoz
         f6s3KOUMGs1sEJvIxWN86ubo0VVUcfS6hyOVGtopxRcSTT/nWToBiiYmv8ZNyyHvpMvH
         Y0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qnb1kJVM+ye3vGOEYAiSOgWaI3eqtlq3N9qsMgSh97Q=;
        b=AP5xQEW1DUY025wCm06X/9xkbcsXTllLGTgz1rpYrxALHpPHrvRQKBUKHEPFGTzHxQ
         ptgYsCFL35FPr0ZJ1PNFQCxC8/IARyxDXBFFpfn6x1fwSPGjJowmxWKe2aUKDg/mwd9C
         bMYmsjH3Di0cEYtgZrOxb2WTiB7LO0naaSHBGnkZgidDbg51muVRAg2J5Thkjm2FcWza
         83qNvKCexNK7qAVc1D0f+2BF4YyV7Onqs0HipxHC3fYDH/tLHG3g3rOMuoevhlSeuLWK
         3zMFZpHHiMyVTAZKOQjcOdTkrhzzYiUHSXRny9VlDW1JQ+vwW+FPCZAR6ko1CRJH7sX/
         8XMg==
X-Gm-Message-State: APjAAAWhldyIKOVWtuIHlbPy0fco4zgNjVRArCmyHcP2TapU9IXnOujE
        Xq8zsluQm8CYoA7/4tUoUr7xIw==
X-Google-Smtp-Source: APXvYqwkPh8ov3QUSzCWMxSKt+ziOPYpJfoCxehX3GtP2xT/V0Zjj4WnEp5aVw6Y7vkICXjTGBM3Aw==
X-Received: by 2002:a05:620a:100c:: with SMTP id z12mr5528461qkj.279.1565897338446;
        Thu, 15 Aug 2019 12:28:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x3sm1885999qkl.71.2019.08.15.12.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 12:28:58 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:28:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        tom.herbert@intel.com
Subject: Re: [PATCH bpf-next 0/5] Add support for SKIP_BPF flag for AF_XDP
 sockets
Message-ID: <20190815122844.52eeda08@cakuba.netronome.com>
In-Reply-To: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 20:46:18 -0700, Sridhar Samudrala wrote:
> This patch series introduces XDP_SKIP_BPF flag that can be specified
> during the bind() call of an AF_XDP socket to skip calling the BPF 
> program in the receive path and pass the buffer directly to the socket.
> 
> When a single AF_XDP socket is associated with a queue and a HW
> filter is used to redirect the packets and the app is interested in
> receiving all the packets on that queue, we don't need an additional 
> BPF program to do further filtering or lookup/redirect to a socket.
> 
> Here are some performance numbers collected on 
>   - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
>   - Intel 40Gb Ethernet NIC (i40e)
> 
> All tests use 2 cores and the results are in Mpps.
> 
> turbo on (default)
> ---------------------------------------------	
>                       no-skip-bpf    skip-bpf
> ---------------------------------------------	
> rxdrop zerocopy           21.9         38.5 
> l2fwd  zerocopy           17.0         20.5
> rxdrop copy               11.1         13.3
> l2fwd  copy                1.9          2.0
> 
> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
> ---------------------------------------------	
>                       no-skip-bpf    skip-bpf
> ---------------------------------------------	
> rxdrop zerocopy           15.4         29.0
> l2fwd  zerocopy           11.8         18.2
> rxdrop copy                8.2         10.5
> l2fwd  copy                1.7          1.7
> ---------------------------------------------	

Could you include a third column here - namely the in-XDP performance?
AFAIU the way to achieve better performance with AF_XDP is to move the
fast path into the kernel's XDP program..

Maciej's work on batching XDP program's execution should lower the
retpoline overhead, without leaning close to the bypass model.
