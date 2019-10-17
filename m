Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E7BDB0A3
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409417AbfJQPBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:01:14 -0400
Received: from mta02.prd.rdg.aluminati.org ([94.76.243.215]:38790 "EHLO
        mta02.prd.rdg.aluminati.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731768AbfJQPBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:01:14 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2019 11:01:13 EDT
Received: from mta02.prd.rdg.aluminati.org (localhost [127.0.0.1])
        by mta02.prd.rdg.aluminati.org (Postfix) with ESMTP id B34921FF31;
        Thu, 17 Oct 2019 15:52:24 +0100 (BST)
Received: from localhost (localhost [127.0.0.1])
        by mta02.prd.rdg.aluminati.org (Postfix) with ESMTP id 7D6E6245;
        Thu, 17 Oct 2019 15:52:24 +0100 (BST)
Authentication-Results: mta02.prd.rdg.aluminati.org (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=cantab.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cantab.net; h=
        mime-version:message-id:date:date:references:in-reply-to:subject
        :subject:from:from:received:received; s=dkim; t=1571323836; bh=J
        jMTI1mLIeg+pwWKnhkMc702J98xkf6BBs+6/SkWTsc=; b=fs/8l9xqRSdubarQO
        bteOz8qDIXnVy/y9zsTDnMLpcMjzzSPwg2pm/DB6R1YsVs7MdrIA1/kRsAFYInv/
        jDG70ObvLRNT6ysfoNAhnSeZCLwnK7gH+x/8SFMc+JZ1PulraJ36vxNUxHmD6AEz
        0STfq2YFImCgkpeOijyFe050E1fVjSHhjprnkh9b8k0+rBKDE/uLbsYV3oayk06P
        E76PgsT4DCtwYz4ES87x24bCOqclFyXinHtlHEGpsr5cyvb+o0Kp5whvdBYPtEWC
        KWZalQgJf9NgA+1LEO/0sxSJRA/+aSoNZ/8W0RY5oEh+mtxmWcXaDvZvV9bCU4Az
        BBapQ==
X-Quarantine-ID: <TPhAEx1RnaC6>
X-Virus-Scanned: Debian amavisd-new at mta02.prd.rdg.aluminati.org
Received: from mta.aluminati.local ([127.0.0.1])
        by localhost (mta02.prd.rdg.aluminati.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TPhAEx1RnaC6; Thu, 17 Oct 2019 15:50:36 +0100 (BST)
Received: from henry.ossau.homelinux.net (79-65-71-34.host.pobb.as13285.net [79.65.71.34])
        by mta02.prd.rdg.aluminati.org (Postfix) with ESMTPSA id CEF10D0;
        Thu, 17 Oct 2019 15:50:31 +0100 (BST)
From:   Neil Jerram <neiljerram@cantab.net>
To:     Oliver Neukum <oneukum@suse.com>, davem@davemloft.net,
        netdev@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCHv2] usb: hso: obey DMA rules in tiocmget
In-Reply-To: <20191017132548.21888-1-oneukum@suse.com>
References: <20191017132548.21888-1-oneukum@suse.com>
Date:   Thu, 17 Oct 2019 15:50:31 +0100
Message-ID: <87tv87qvd4.fsf@ossau.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

> The serial state information must not be embedded into another
> data structure, as this interferes with cache handling for DMA
> on architectures without cache coherence..
> That would result in data corruption on some architectures

Could you say more what you mean by "some architectures"?  I wonder if
this is responsible for long-standing flakiness dealing with the HSO
modem in the GTA04 phone?

Best wishes,
   Neil
