Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E4E394C63
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 15:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhE2N7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 09:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhE2N7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 09:59:30 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADE1C061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 06:57:52 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id q1so9606470lfo.3
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 06:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-transfer-encoding;
        bh=wzKE3SH1xJB5wz3mDSTXZWWcaszaleN1bEF5rSCPtfM=;
        b=a2gHlFvRP2L+1OWim1Lu2BGWRRRsn7VX9bZUpZPBlBD4Z++3CqKc+MTBDJ/yuL9sr0
         t1ADWKyYQCR1E4QCa5+lqmFqVHPXIqlk7cTKvjLXcbuGm88EtkodCMcmbPKA1uBvt11R
         PgBg57lT5LpROoqfCACuNfwnuK/ty11OGrUU/ecP3yyhQVdQClMIdPFj6xBrFyl3JAfZ
         qaZaO1dTmRxsCS4FTlOHw1YIGTKvH6F/biosA/zdfFn6iaiRzse9jC8ZZe/n0BooZmjy
         F6ap0zLu5i/aPWm7FGkTLxPAATb4KdJrcm/OydkwVHApf4rksw6Lavnwbo9OqItACSuU
         SOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :subject:content-transfer-encoding;
        bh=wzKE3SH1xJB5wz3mDSTXZWWcaszaleN1bEF5rSCPtfM=;
        b=E2KM4tseCYrIUUbuYehwNHjCU05UcoNeuTs4cNR6BW5EYesDf+dlLyNPZKEhwahe/S
         l/xt4HFgeBD9eaJhPojh1K/B8GMt94Rjn4HTanGgwfu0vEdbLKeypXUjmP4WwCS5pOjj
         dSqqtGxufKuFxQODUgNG1sYxyaKD7rtjovU22FJ3ueFrKf/9rhzYPwiePnWEAqkQ6pMk
         ow9S9DetdTp1rpSgwuZ3EMatRSYgKVm80+IpldAILn5W2gRQpf0rwLy5RwBxWMza8cKu
         2VR1BujMCBI3h8tgtt6G9OnWSkodt4sRNqjWHmmDGLLcaQJ2jgKQjR42QidrotiwN4zV
         MRyA==
X-Gm-Message-State: AOAM5325p05FApgGwesVYMwF3kBsL9SO4WqG3+akBbKaaterImHwAHxo
        0q3XILJX0ffDDZRClAALjx0KFmwGiOmgnQ==
X-Google-Smtp-Source: ABdhPJyMSjqWUYAP0raFj2/v8CivZefvff9OEnHYwJEgQ8u64ntAyl29ougcF9PfwMkqBD5EMBcIlA==
X-Received: by 2002:a05:6512:3da0:: with SMTP id k32mr9250143lfv.1.1622296668949;
        Sat, 29 May 2021 06:57:48 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id t9sm865782ljk.114.2021.05.29.06.57.48
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 29 May 2021 06:57:48 -0700 (PDT)
Message-ID: <60B24AC2.9050505@gmail.com>
Date:   Sat, 29 May 2021 17:08:02 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     netdev@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Realtek 8139 problem on 486.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I'm observing a problem with Realtek 8139 cards on a couple of 486 
boxes. The respective driver is 8139too. It starts operation 
successfully, obtains an ip address via dhcp, replies to pings steadily, 
but some subsequent communication fails apparently. At least, nfsroot is 
unusable (it gets stuck in "... not responding, still trying" forever), 
and also iperf3 -c xxx when run against a neighbour box on a lan prints 
2-3 lines with some reasonable 7Mbit/s rate, then just prints 0s and 
subsequently throws a panic about output queue full or some such.

My kernel is 4.14.221 at the moment, but I can compile another if 
necessary.
I've already tried the "#define RTL8139_DEBUG 3" and "8139TOO_PIO=y" and 
"#define RX_DMA_BURST 4" and "#define TX_DMA_BURST 4" (in case there is 
a PCI burst issue, as mentioned somewhere) and nothing changed whatsoever.

Some additional notes:
- the problem is 100% reproducable;
- replacing this 8139 card with some entirely different 8139-based card 
changes nothing;
- if I replace this 8139 with a (just random) intel Pro/1000 card, 
everything seem to work fine;
- if I insert this 8139 into some other 486 motherboard (with a 
different chipset), everything seem to work fine again;
- etherboot and pxelinux work fine.

I'm willing to do some debugging but unfortunately I'm not anywhere 
familiar with this driver and network controllers in general, therefore 
I'm asking for some hints/advice first.


Thank you,

Regards,
Nikolai
