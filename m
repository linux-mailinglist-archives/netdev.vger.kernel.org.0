Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E13EBB69
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 01:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfKAAWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 20:22:01 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32837 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfKAAWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 20:22:01 -0400
Received: by mail-lf1-f68.google.com with SMTP id y127so6048705lfc.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 17:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EV2fbUKu73gEX5+CIj3b5YkYQITcbwccDU3gSlwZNAU=;
        b=itp86BjsasKlqgiwsIms8Ib6Hdl0ma48ViJ4vhEXxoXhlR6DRi1aTylRXntCcq9Ws4
         8soRV0LTFl27mtSTVh1OYImgL1OR0o6hh+wqfTKN6K/wnltUPIHuRvLnWggtt1es++sO
         sQbWaBtzpGw6lfZ+wTdmIICENwt86tFCLpvVW5g7tjFbmpRSqa+gmhMWbfD8lHqVvGtw
         fXanExQxG6sW7ICqVeakTqeT8w7jJIPxBIxKPdnbOBHPSRKkqG+Cm8m7R3HI3mG1AKno
         /WgPaSnGskagXLeWHhVFZSBFk0rIAFurvKXMDoDsEW0aV9epr/fBqJwH4sqcr/NfPgPl
         FCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EV2fbUKu73gEX5+CIj3b5YkYQITcbwccDU3gSlwZNAU=;
        b=ocDqcI9JwvXZhFDzuGD5Pjtz7ACexLif10r6E073dswY/7J10tWvHBL1AGNrso3BJy
         pFDiBDoiuID4KdZPsE18Rxt8RkcIF/S+VuHONGzhXM15z8DhSOU/PgT1qE9j+uWmoa6A
         HIBWbnRCuB2u4uQnwpPuDcNzgMIHRgV+yYftD9sS0VjIpqBfb98dFSJUUHWcYau8jifT
         BzzXfW5Wri2GQ2zZa0ZrhqmNVnzABprDIo94IBYGYhnM0GRcdlq2jcuNJkMZr3GPmiQQ
         JmkUgAmwKT1bzHk8Lj5y0GCrXGypr8vr9YShY9I3cUQJmlZ4Oq6miPF+h31BhaALCdB5
         soGw==
X-Gm-Message-State: APjAAAVk1uZYaiLdlxPrhSgWWZRoXtzjOi3UdG0c96IvZlAqqEUVuJUs
        Vh5X+HbjxBR576gRzDhvziZzpw==
X-Google-Smtp-Source: APXvYqwdOpLsUGthqHH2HozLFklWyWYEyoWpdzJcVOkKt3ba3wg8Z1Oo9UPDW0MZ+NNaTICdOe91/g==
X-Received: by 2002:ac2:5109:: with SMTP id q9mr5383215lfb.145.1572567717894;
        Thu, 31 Oct 2019 17:21:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 141sm1899971ljj.37.2019.10.31.17.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 17:21:57 -0700 (PDT)
Date:   Thu, 31 Oct 2019 17:21:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     bjorn.topel@gmail.com, alexei.starovoitov@gmail.com,
        bjorn.topel@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        tom.herbert@intel.com, David Miller <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
Message-ID: <20191031172148.0290b11f@cakuba.netronome.com>
In-Reply-To: <2e27b8d9-4615-cd8d-93de-2adb75d8effa@intel.com>
References: <CAJ+HfNigHWVk2b+UJPhdCWCTcW=Eh=yfRNHg4=Fr1mv98Pq=cA@mail.gmail.com>
        <2e27b8d9-4615-cd8d-93de-2adb75d8effa@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 15:38:42 -0700, Samudrala, Sridhar wrote:
> Do you think it will be possible to avoid this overhead when mitigations are turned ON?
> The other part of the overhead is going through the redirect path.

Yes, you should help Maciej with the XDP bulking.

> Can i assume that your silence as an indication that you are now okay with optional bypass
> flag as long as it doesn't effect the normal XDP datapath. If so, i will respin and submit
> the patches against the latest bpf-next

This logic baffles me. I absolutely hate when people repost patches
after I nack them without even as much as mentioning my objections in
the cover letter.

My concern was that we want the applications to encode fast path logic
in BPF and load that into the kernel. So your patch works fundamentally
against that goal:

I worry that with the volume of patches that get posted each day
objections of a measly contributor like myself will get forgotten 
if I don't reply to each posting, yet replying each time makes me look
bullish or whatnot (apart from being an utter waste of time).

Ugh.
