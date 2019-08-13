Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF588B5EF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfHMKww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:52:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37628 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfHMKwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:52:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so5375251wrt.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 03:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PcvPryrYHXGhavo5LsKp80la0PxOXMaHQ3N9MrrJEzg=;
        b=m37qZsz7v8FtyaWMuN7Lnx9JP1Gpi2+/fWLNB+tlq6D4Gppt8NlU2pa9rzdaAPhlqw
         fjfFFXAoWQ5SXPosDc4uL55JumHPzBaYN8Mt1SiAVICpBMqRB/arbqAbSdSNhzAJsXLH
         2YIDVbNSFpEJQt6+0nFRnOWs5Dudahclcxo+QCpwlsvER2nqFgD3eRR2gQ6saPkGYpUr
         ZOq9V3807fIHO4hdvi+DjlEkNW8fX20nM57WLufs78+0xLw/SzFgev3M594ygFx0BX7c
         Qf4YpO9+zboKaBBhIdfLbuSzIte/ZQoyw/cPvodkdPSbJi0boppvgei8FAHs+AI2NU7r
         liXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PcvPryrYHXGhavo5LsKp80la0PxOXMaHQ3N9MrrJEzg=;
        b=JahdEEHcuXALHskIAbBrcR87UbJ88/6Nd4TKsUbgOLA6yYmhiPeM8scjfTNA/gbhYX
         yD93Xxwz6Y8mYaodETHPSKNVMbjmOo1h9gj5F0sDVO6JeZTLRORTrCHe3A7a3kpPu/2u
         fp/0TDLjW/w8s3sO+ZpJVldiOgY9eNBBQFIXXm1Q5O7Ayj1Hd7m8XLyCxKaw1pGT8ggT
         /k9LUv3knygfDu/TVcPYgesACKKhMvzzhN9VDdd3jbBktJe8MQZPDt2c4deRFYYn9OSp
         WhUWCxOTL3TdWcItiuECzeqw20C3sz9V5WayxbIVFnfwKON6epEFDuNaBsyZVbDtEsPX
         s7AQ==
X-Gm-Message-State: APjAAAVXgH3A46MmS7Mv4uiTZKxXGtWe0PaPa8vbWRRxORnEfK3dl9Vp
        Vx1D5bjnUzfCsPrMjS9g9trHxQ==
X-Google-Smtp-Source: APXvYqxCskPQxt/C2ufusLnQ0Qt0oA1E1zjxBFHiy8eMT29LmX9gymj3iXLNc8MH5X4Z3U93n0Tw5g==
X-Received: by 2002:a5d:62c1:: with SMTP id o1mr45859475wrv.293.1565693569861;
        Tue, 13 Aug 2019 03:52:49 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id w5sm1261298wmm.43.2019.08.13.03.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 03:52:49 -0700 (PDT)
Date:   Tue, 13 Aug 2019 12:52:49 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 4/4] devlink: Add man page for
 devlink-trap
Message-ID: <20190813105248.GQ2428@nanopsycho>
References: <20190813083143.13509-1-idosch@idosch.org>
 <20190813083143.13509-5-idosch@idosch.org>
 <20190813102037.GP2428@nanopsycho>
 <20190813103904.GA16305@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813103904.GA16305@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 12:39:04PM CEST, idosch@idosch.org wrote:
>On Tue, Aug 13, 2019 at 12:20:37PM +0200, Jiri Pirko wrote:
>> Tue, Aug 13, 2019 at 10:31:43AM CEST, idosch@idosch.org wrote:
>> >From: Ido Schimmel <idosch@mellanox.com>
>> >
>> >Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>> >---
>> > man/man8/devlink-monitor.8 |   3 +-
>> > man/man8/devlink-trap.8    | 138 +++++++++++++++++++++++++++++++++++++
>> > man/man8/devlink.8         |  11 ++-
>> > 3 files changed, 150 insertions(+), 2 deletions(-)
>> > create mode 100644 man/man8/devlink-trap.8
>> >
>> >diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
>> >index 13fe641dc8f5..fffab3a4ce88 100644
>> >--- a/man/man8/devlink-monitor.8
>> >+++ b/man/man8/devlink-monitor.8
>> >@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
>> > .I OBJECT-LIST
>> > is the list of object types that we want to monitor.
>> > It may contain
>> >-.BR dev ", " port ".
>> >+.BR dev ", " port ", " trap ", " trap-group .
>> 
>> Looks like "trap-group" is a leftover here, isn't it?
>
>You get events when traps and groups are created / destroyed. See below output
>when creating a new netdevsim device:

Ah! Makes sense. Thanks!

>
>$ devlink mon trap-group
>[trap-group,new] netdevsim/netdevsim20: name l2_drops generic true
>[trap-group,new] netdevsim/netdevsim20: name l3_drops generic true
>[trap-group,new] netdevsim/netdevsim20: name buffer_drops generic true
>
>$ devlink mon trap
>[trap,new] netdevsim/netdevsim10: name source_mac_is_multicast type drop generic true action drop group l2_drops
>[trap,new] netdevsim/netdevsim10: name vlan_tag_mismatch type drop generic true action drop group l2_drops
>[trap,new] netdevsim/netdevsim10: name ingress_vlan_filter type drop generic true action drop group l2_drops
>[trap,new] netdevsim/netdevsim10: name ingress_spanning_tree_filter type drop generic true action drop group l2_drops
>[trap,new] netdevsim/netdevsim10: name port_list_is_empty type drop generic true action drop group l2_drops
>[trap,new] netdevsim/netdevsim10: name port_loopback_filter type drop generic true action drop group l2_drops
>[trap,new] netdevsim/netdevsim10: name fid_miss type exception generic false action trap group l2_drops
>[trap,new] netdevsim/netdevsim10: name blackhole_route type drop generic true action drop group l3_drops
>[trap,new] netdevsim/netdevsim10: name ttl_value_is_too_small type exception generic true action trap group l3_drops
>[trap,new] netdevsim/netdevsim10: name tail_drop type drop generic true action drop group buffer_drops
