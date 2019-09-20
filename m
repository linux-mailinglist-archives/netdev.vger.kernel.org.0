Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD439B9767
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 20:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406366AbfITSyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 14:54:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41783 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406336AbfITSyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 14:54:23 -0400
Received: by mail-qk1-f193.google.com with SMTP id p10so8322973qkg.8
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2XRuCvTuHa57zT3SwqmvbYr5uuudY9ytTQ1/TE5sYrs=;
        b=cQj5UR+wPwubIyUN3GZiiJzNtMLjki8oy+f+8i0VjYMbLSM0YvbSjjYNa8JY2MLJni
         21+f+fSPUAqqF1587hYdHIMlR02u+sSfQ2130j2bwNMclaJMj359RL/l2WWBV6LBaXx3
         03CXV13jmPbgcmbc1Fx+PNzhtc+tw0lngI3ddGiHDBCfYdJZf39gWyX4zpsOvfuCjljJ
         RQI0Th3XYUxAon/LP4J83oKw3g48uEdNb86rm3rhXwhbPckazFpU+ocKB26tM/UcYC8H
         9SjSn8B1seIL8JCSw83ht7ckcZtfODVEy4jZHIjqVa0cxg2A1b7Q/8qYZSbQPEX+pTaZ
         leOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2XRuCvTuHa57zT3SwqmvbYr5uuudY9ytTQ1/TE5sYrs=;
        b=mpRZQNV4u1wntGHOrlUhCkXzTBktGhlo9lWgFvav+jxPy5+ZDLRfV/jYrmfgOARmKp
         aa51oFlmXaoxRm5emZKJ/oCol15gfUzfaBDRwATLXAanjDIt5gKVatXZf8xHHlu6sfMj
         6R1kOMXTq3vfTb2RzHx7Fsa/1lW2y+dDpNq+qdb5UjGwdFCFmieF5tch0yGNFo9UUnBO
         n14xYsJ8E/G4TOCmcnTh0LYnxues8ji6gA136sJNIdnk2zCML6GvdXgsDjXsed0umMRI
         m0gBA1bRGars+W0QF4a0/FsICg+H8eZnZhlhXB7MwwhH/f0dmr23te6L4X3mO6kcs71i
         nh2g==
X-Gm-Message-State: APjAAAUgNvr0F8rPgDbpCTPVeCHU4deyd2KoAgSp/naNpSFnEWg2O4Pw
        Qu8k3Q6tHDsz4AVvQXunnpyph/z/Fc0=
X-Google-Smtp-Source: APXvYqy1SHeo5iJduvzfhL7vdX1xkkBh+tlmHxzegf9e1+qZ2rQOhdmogLeiQwxyASSBow2I7ZX6KQ==
X-Received: by 2002:a37:af02:: with SMTP id y2mr5309112qke.305.1569005662787;
        Fri, 20 Sep 2019 11:54:22 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g10sm1325659qkm.38.2019.09.20.11.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 11:54:22 -0700 (PDT)
Date:   Fri, 20 Sep 2019 11:54:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Peter Fink <pedro@pixelbox.red>
Cc:     netdev@vger.kernel.org, pfink@christ-es.de, davem@davemloft.net,
        linux@christ-es.de
Subject: Re: [PATCH net-next] net: usb: ax88179_178a: allow optionally
 getting mac address from device tree
Message-ID: <20190920115418.682d0fc7@cakuba.netronome.com>
In-Reply-To: <1568962710-14845-2-git-send-email-pedro@pixelbox.red>
References: <1568962710-14845-1-git-send-email-pedro@pixelbox.red>
        <1568962710-14845-2-git-send-email-pedro@pixelbox.red>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 08:58:30 +0200, Peter Fink wrote:
> From: Peter Fink <pfink@christ-es.de>
> 
> Adopt and integrate the feature to pass the MAC address via device tree
> from asix_device.c (03fc5d4) also to other ax88179 based asix chips.
> E.g. the bootloader fills in local-mac-address and the driver will then
> pick up and use this MAC address.
> 
> Signed-off-by: Peter Fink <pfink@christ-es.de>

net-next is now closed [1], and will reopen some time after the merge
window is over. Hopefully you can gather feedback now, but I'm dropping
the patch from patchwork, and you'll have to resubmit once Dave opens
net-next again.

[1] https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
