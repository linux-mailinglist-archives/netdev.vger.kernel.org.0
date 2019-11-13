Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5535FFB10E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 14:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfKMNG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 08:06:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38899 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfKMNG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 08:06:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so1933939wmk.3
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 05:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MmwAOCkHZnQczjf/4u00s0RSSjKAlRte6ZN3K39fH70=;
        b=uamPwWnuG/QA1D72/Izib9qnst6IUGS47DbsS1BQJoBtaTqwWucweWe+0hagkdTOne
         KlVuCLzNf0tsxOCAfSFGROfvFMCUG8JzTjgbrtLubag1q7lc5l51OJQVMjzw1nHinbjZ
         7aUGBlLAey8L7J00mEFVW/nTh5XpuTRxDqYBr7Lrs4bYbvywGhgrlTBHdPNIK2Z7SOeb
         ta0YdhE2I/+OvGjeJnLbPkIYvvFzpBk2TAIEY+E/osUZA4GAqEVLLrxHQHps8wffgY/g
         WIOsTwiZxvLbjJ7m2kgcVcdd3St262t7imBUqbAuUwSko5SfPCfQfR5uHV5mh8GfR999
         1MaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MmwAOCkHZnQczjf/4u00s0RSSjKAlRte6ZN3K39fH70=;
        b=iBfIxG4v+2Vp8FESGtPWlREMxRG+f64kT38I/9k+9OG96RWXjWjyElDVZ5HWZOWdpg
         VY5NyytL3LnOKml1DWVKIut039+b8Tx2FuSe3V4GvGkxYzKWxY/HAV51gyV4N/0PVLCm
         2MeQB3Kg8N3prfhCSIB7yelcH+rRfgU9ESQXQERD6Ydxa/Bv1cflU615hhTE4C1h0KTT
         g5Nmt8APk5kfk9/scimclrw2WsxYSS9HPhFtJw2brFWhlNfEeQiA0EGB2mgG91coddHD
         /M6icrgF8JKEqr2zE2X8pKgj68/BynPmhOtBu7rIIfnd/oYWQwd980VXL7XGbjiW0tP3
         Mp+w==
X-Gm-Message-State: APjAAAXqO7nxDkILYxCkjwR47bRVOPXTeAoBGqHE+cIZcEwYaEN4cVnj
        hPX0hTgcVtB+KYnT/d+bKr2u/Q==
X-Google-Smtp-Source: APXvYqzzqSb3tLQBaW32RIel7L0waNj7SH2zOk6r9Df8vcPiB11k/UDBEREJzDyQOoPrlWhB0OK0+g==
X-Received: by 2002:a05:600c:2944:: with SMTP id n4mr2749481wmd.57.1573650412897;
        Wed, 13 Nov 2019 05:06:52 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id n1sm2810908wrr.24.2019.11.13.05.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 05:06:52 -0800 (PST)
Date:   Wed, 13 Nov 2019 14:06:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Message-ID: <20191113130651.GA2176@nanopsycho>
References: <20191112171313.7049-1-saeedm@mellanox.com>
 <20191112171313.7049-9-saeedm@mellanox.com>
 <20191112154124.4f0f38f9@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112154124.4f0f38f9@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 13, 2019 at 12:41:24AM CET, jakub.kicinski@netronome.com wrote:
>On Tue, 12 Nov 2019 17:13:53 +0000, Saeed Mahameed wrote:
>> From: Ariel Levkovich <lariel@mellanox.com>
>> 
>> Implementing vf ACL access via tc flower api to allow
>> admins configure the allowed vlan ids on a vf interface.
>> 
>> To add a vlan id to a vf's ingress/egress ACL table while
>> in legacy sriov mode, the implementation intercepts tc flows
>> created on the pf device where the flower matching keys include
>> the vf's mac address as the src_mac (eswitch ingress) or the
>> dst_mac (eswitch egress) while the action is accept.
>> 
>> In such cases, the mlx5 driver interpets these flows as adding
>> a vlan id to the vf's ingress/egress ACL table and updates
>> the rules in that table using eswitch ACL configuration api
>> that is introduced in a previous patch.
>
>Nack, the magic interpretation of rules installed on the PF is a no go.

For the record, I don't like this approach either. The solution is
out there, one just have to properly implement bridge offloading.
