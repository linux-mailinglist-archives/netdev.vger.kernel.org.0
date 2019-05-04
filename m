Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A38E139FD
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfEDNQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:16:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41979 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfEDNQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:16:57 -0400
Received: by mail-wr1-f65.google.com with SMTP id c12so11249872wrt.8
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z8C/BhtrLEjrG8XUHXgd+oKCTRZFb2QqrDk06Na1SBE=;
        b=uJGrBNKVAZ0+LB0t+ww7ITkSgJwcCeLYxD/bNAIeNlR9nPcH/hm2Zo5bQU5CfxEKL2
         YwT2Z+ShBzo3YePv7sxR3rvMTPmkqjEzuPG2ii6IprwoGnS+c2WLfw1wrSE1OAz5zJ7C
         +R/CPQxNsFLR5DO2u1Q98O8Iw+Rwl3GIjfHLnenDqOMSFJW9hM9XNSSY6cssn0wCo6EP
         qvWeLkYrOJzRbc7nT85dy4miUG6u03/qarIBeTHj6iWLhnY5myoR6re2Mhl+BvFrfe4W
         Qacm2ZRrao+CBKmHnVt5lF9yzfVKLfyBKSLXHLe5bl5+1wjIJ3Jmob21tomxnBanlTmf
         B2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z8C/BhtrLEjrG8XUHXgd+oKCTRZFb2QqrDk06Na1SBE=;
        b=sgr5ngAtfel+2ctFqcg90dO3foNAOnIrY7/OorXM1ccHRRvyUpie8k9VocFdSz5tc5
         KprDdkRgBPLgnuHxv6IHqCp+gCms1Ee2GRtWvFmeXFV7ZkmE8R9NzfpBZMcRq5X9CFUZ
         koX8CI4Z2yvIhoa/pjonN9raz1m9ygFDoLgEhXtbo3eEZtcWpTkNl6JAWCqD0KTG8N2s
         2v7QXJ3wdLzXwjI39SiJCAf9R7wZhboUFGMoj76SUfanbJTE+ZxKEzROdHQ3K91/vlmQ
         YGHVPbb1r72G0nzPNVaqsqEoDHL02eyIKvUj6nwhYD9LrbB6J5B9GRIRqUUqxgbxqs5L
         vCOQ==
X-Gm-Message-State: APjAAAVfbncHLSsha/VaFAAfi5MOK2MmwN5oLTvinrjCub0X/oU4DWpk
        on5QpV+IcLQZyAtk/9FAKkZ4HA==
X-Google-Smtp-Source: APXvYqx2HQheBFTMX9TlsxXXCaBIRMKjkJFjfyx31d5p4WtWcycS9E9loUh38Q0V9vI7AEpPbZdWlA==
X-Received: by 2002:adf:e88b:: with SMTP id d11mr11242148wrm.327.1556975815799;
        Sat, 04 May 2019 06:16:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y6sm9515604wra.24.2019.05.04.06.16.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:16:55 -0700 (PDT)
Date:   Sat, 4 May 2019 15:16:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 10/13] net/sched: add block pointer to
 tc_cls_common_offload structure
Message-ID: <20190504131654.GJ9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-11-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-11-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:25PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Some actions like the police action are stateful and could share state
>between devices. This is incompatible with offloading to multiple devices
>and drivers might want to test for shared blocks when offloading.
>Store a pointer to the tcf_block structure in the tc_cls_common_offload
>structure to allow drivers to determine when offloads apply to a shared
>block.

I don't this this is good idea. If your driver supports shared blocks,
you should register the callback accordingly. See:
mlxsw_sp_setup_tc_block_flower_bind() where tcf_block_cb_lookup() and
__tcf_block_cb_register() are used to achieve that.
