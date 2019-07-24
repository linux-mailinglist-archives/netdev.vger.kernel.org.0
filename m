Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C04D7328D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbfGXPPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:15:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41023 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387503AbfGXPPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 11:15:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so44203324wrm.8
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 08:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5JJ6D0lhyG/lALCSbovEZ0BrJf6z/4H/u4qF2hwfeO4=;
        b=NXx8bDuFD3Vgwdve81IOL2NFshYgOcmhi/LeEcj7mIph0NreLvy/rrMV28SVuENVp1
         L9wH1jw3yvuXLCzEQKOrv2U5grD8ybRTLZ8EdzZxKkCGSA6Uy6z/T34UaquA3AhBXc0e
         AbPThO+g+pVYDaYKsmtGl1SLWkfOU96a+zcs1S0ZRfdMi4mV3e1CDGVOlUPPzTMMg+fU
         LkYo0fzgDhAex3MZtCJfdxN2Xfr9TcM+QoNRzVhpjGU4Lnz1zSkoAEHczlOJlCihXB77
         rO5PQuPJaiI2v18IXIusawvgZu+Og4iBkyv19bYh73arqCjE1+/xclz3NPI9TCGRjBKl
         Ke9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5JJ6D0lhyG/lALCSbovEZ0BrJf6z/4H/u4qF2hwfeO4=;
        b=poe9kBeZZSh5AxwhjxQR919eQTFwDdxaOVHkSY0rngJkfw43PLhi/1BrBplODYXrgG
         KS2DGeNuW1+1PpYp6P7iKVl+hw6Mv+xH4mpWeLdo66bOu4AtiA49Snu8pvJVcclhXIA5
         /bQdn7ChJLh8BQWlr3OmInOKjZXRcQG+tE7MBpD1Q0ZMYKLGSpG7PyD6sxl02lkauwJE
         v//A9WSVSJXMF8WxAiXShhSpC56qiCVMliGVAHQkINKIVKUFs+dmGQQ00sjZQ4U8hzO3
         lFIAcwKbSImpSNsWDwd1Uo+P2TNW7knmmlq0gNX1HSckctGNTDP9pU10evmdcxQvnmU0
         2B6A==
X-Gm-Message-State: APjAAAXKbhLkQDjq+ckS8Rr2pEK7TjWzYzdW4tCiCD87CrPahl8oZnaB
        kH8G5VlJMAYbhAPg98O2gSM=
X-Google-Smtp-Source: APXvYqwWuSjtF8Cc1YjHaL16ugHyzdhFNQBgdG+A4V3cSD/Ys8DF0kK6vNYUuuQjDVzgEnvsaCgF9Q==
X-Received: by 2002:adf:e343:: with SMTP id n3mr48804222wrj.103.1563981343711;
        Wed, 24 Jul 2019 08:15:43 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id f12sm50645639wrg.5.2019.07.24.08.15.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 08:15:43 -0700 (PDT)
Date:   Wed, 24 Jul 2019 17:15:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        toke@redhat.com, andy@greyhouse.net, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
Message-ID: <20190724151540.GE2225@nanopsycho>
References: <20190722183134.14516-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722183134.14516-1-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 22, 2019 at 08:31:22PM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>So far drop monitor supported only one mode of operation in which a
>summary of recent packet drops is periodically sent to user space as a
>netlink event. The event only includes the drop location (program
>counter) and number of drops in the last interval.
>
>While this mode of operation allows one to understand if the system is
>dropping packets, it is not sufficient if a more detailed analysis is
>required. Both the packet itself and related metadata are missing.
>
>This patchset extends drop monitor with another mode of operation where
>the packet - potentially truncated - and metadata (e.g., drop location,
>timestamp, netdev) are sent to user space as a netlink event. Thanks to
>the extensible nature of netlink, more metadata can be added in the
>future.
>
>To avoid performing expensive operations in the context in which
>kfree_skb() is called, the dropped skbs are cloned and queued on per-CPU
>skb drop list. The list is then processed in process context (using a
>workqueue), where the netlink messages are allocated, prepared and
>finally sent to user space.
>
>As a follow-up, I plan to integrate drop monitor with devlink and allow
>the latter to call into drop monitor to report hardware drops. In the
>future, XDP drops can be added as well, thereby making drop monitor the
>go-to netlink channel for diagnosing all packet drops.
>
>Example usage with patched dropwatch [1] can be found here [2]. Example
>dissection of drop monitor netlink events with patched wireshark [3] can
>be found here [4]. I will submit both changes upstream after the kernel
>changes are accepted.
>
>Patches #1-#6 are just cleanups with no functional changes intended.
>
>Patches #7-#8 perform small refactoring before the actual changes are
>introduced in the last four patches.

In general, this looks very good to me. Thanks!
