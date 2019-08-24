Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8649BA14
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfHXBbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:31:22 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43621 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfHXBbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 21:31:22 -0400
Received: by mail-qt1-f193.google.com with SMTP id b11so12983832qtp.10
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 18:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8G5uMptjck2OP2FUS8zc0SRewV3RKb8ooyAmm2AE0Yo=;
        b=uHHVbunSGhKjhL+031QN8F/AfsPY18yLyhCQA4pdbtWwakG1ohiy/5+3rmdBJNC0Xd
         F29KR9ETiFBJ/LFfq/lA9CBzMbhVwAKmCEtkZUN2/5Dn7XhJnzrVeNSzUtJyQVyRK17v
         jh+CigorZ2yCHkPoQnxRdceWxI3ql1Nnf1vreUFSkp7Pd1QMeEAAGczDxh6YIK3R2D7v
         kKjNR4kK47gb40TtMcpcBysDRljPvS9wujrLNK5Cn8HIdaYQY9dTa1Y1kRdld01lJc0r
         HlVmJOwg+zZP8oIc4VZS3g16oouZsWmv35RwZne88v0DSg/bYZCcnMJuVwI7FUCyVcBr
         7v4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8G5uMptjck2OP2FUS8zc0SRewV3RKb8ooyAmm2AE0Yo=;
        b=kEypbRwWDcDjPG3nJNQiKxZ7Mbl8js1DiUiMHnTbRUFJizT447by4zOsPO9Iq+NPCU
         k4CZFxiXDngmJLZFjSM1BqyDSkoIp0R28brZwx85SM8qBS4nwZr3GExbsz5anaqVuYnk
         aI2LhqGY87TMbmVX2qzH8wjjitKAwt5vSwkllwyWgWIPAwtf8CBPCsjfZY9KP0YGRAjo
         dl/CPHnPeQtQ3gALFME9+UB2hx7EHfd0ugb3lSIdbvK3tQ0dY2GbJt2xp86CD4R9+0up
         l+Je4koSIIEA8J6gR0jQwbdZoiHgiBxRhiXVV6iBVZAEaIe/0xMJqqy1931/+I7kSESF
         zxHw==
X-Gm-Message-State: APjAAAXsPyhlo2fMDbSPUKNv+WFIeJiSz0mD6lBVY8HpjRPfgFIgwR8q
        bn+VkbYy1oTSthGWyQNp6ie/rg==
X-Google-Smtp-Source: APXvYqzvW5/wqAWXpYANj9XMXPCLblokzuTbXLoNGuDt7h3W/VAagmen7fr/8dyISLXY93cPQF1KQA==
X-Received: by 2002:ac8:670a:: with SMTP id e10mr7601444qtp.244.1566610281430;
        Fri, 23 Aug 2019 18:31:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r14sm2378187qke.47.2019.08.23.18.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 18:31:21 -0700 (PDT)
Date:   Fri, 23 Aug 2019 18:31:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 07/14] ice: Rename ethtool private flag for lldp
Message-ID: <20190823183111.509e176c@cakuba.netronome.com>
In-Reply-To: <20190823233750.7997-8-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
        <20190823233750.7997-8-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 16:37:43 -0700, Jeff Kirsher wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The current flag name of "enable-fw-lldp" is a bit cumbersome.
> 
> Change priv-flag name to "fw-lldp-agent" with a value of on or
> off.  This is more straight-forward in meaning.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Just flagging this for Dave, it was introduced in v5.2 by:

commit 3a257a1404f8bf751a258ab92262dcb2cce39eef
Author: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Date:   Thu Feb 28 15:24:31 2019 -0800

    ice: Add code to control FW LLDP and DCBX
    
    This patch adds code to start or stop LLDP and DCBX in firmware through
    use of ethtool private flags.
    
    Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

And changed once already in v5.3-rc by:

commit 31eafa403b9945997cf5b321ae3560f072b74efe
Author: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Date:   Tue Apr 16 10:24:25 2019 -0700

    ice: Implement LLDP persistence
    
    Implement LLDP persistence across reboots, start and stop of LLDP agent.
    Add additional parameter to ice_aq_start_lldp and ice_aq_stop_lldp.
    
    Also change the ethtool private flag from "disable-fw-lldp" to
    "enable-fw-lldp". This change will flip the boolean logic of the
    functionality of the flag (on = enable, off = disable). The change
    in name and functionality is to differentiate between the
    pre-persistence and post-persistence states.
    
    Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Perhaps the rename should target net? IDK how much driver flag renaming
is okay otherwise, I guess this will only affect Intel users.
