Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDECF0BB5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbfKFBiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:38:54 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41390 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729614AbfKFBiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:38:54 -0500
Received: by mail-lf1-f65.google.com with SMTP id j14so16652913lfb.8
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 17:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=51v6UI6uaOClfeVr+6y9I6KAsc08NeIgdwV4JO9PJ88=;
        b=z6IDvQhHU+jashlwnInEASfzuirBzpAj9FxSvGPWCGP4Q0iIUfnxtPxGGTRoUzb5ND
         KDp9FuJChW4F9xtv/kYFyRjw81RE+LmFngKE9Z25WBO/pZyTMzkV5rPjs7pIEZA+H4cB
         ZPRf3J6E9V73FKTd1noSN2WbwmXZR5c+ekPLF9QpQGq2tW6iiEslMuQgKoLgOpvpNqbQ
         Ty7GafGR+P10SmOrmpH3x+6azHJuodYhlmzQOZbIS5//J7R5xlVYgQBM2ZkQNoZvNkIB
         B/Xc/SgHmDaDRjN9Pt4zHYngoElWW1JMB86cVCS/hbiIWvZR8+Si2IfXXgaJp0gWiy1H
         negw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=51v6UI6uaOClfeVr+6y9I6KAsc08NeIgdwV4JO9PJ88=;
        b=pDZUsrxxWdWriAd7YYsKWhTt19nLFCgHfHOTVOFe//jD0z+Fjb7hrZvrobbzho9wgv
         jJyIKvMNINdB0Fa9n49+pjmkxXOEegYpOWolbez0FZ9I8ExC3fqRVc3liq3F/f/0RcvK
         YisrIuSz5stN7aAwQPDtgEDDgcL7c4Pn0oeQ+WXd04BmvWIXSilqkDYmAL1wCh5bYICS
         nVJ6l71zqbF4T3i06bfI3/0NfXhgylPJ1QdvEzeSpR8lVNZtbFNUhPdpLIG4L4Gjd/Mq
         xjluFWDk1gn6g2LycGqm1xRzXuh54zXjfvJR6ilNiT7UrIv5MQG1vIUBW2iVyU+alUcD
         ngzw==
X-Gm-Message-State: APjAAAVdUs5P9in61O3GkxXrSre39wYa7UFzZFmU6Y21881/BcXWuqF1
        U64nHzqdRI+STKDaMyLQGfZfzw==
X-Google-Smtp-Source: APXvYqz57chZ/h6isvi7/PjhrlyRByAIole7jBUFqSZ0BKIG3VXJUx750drfpCt2w46O8eouslY6jQ==
X-Received: by 2002:a19:651b:: with SMTP id z27mr22262672lfb.117.1573004331486;
        Tue, 05 Nov 2019 17:38:51 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n19sm4504279lfl.85.2019.11.05.17.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 17:38:51 -0800 (PST)
Date:   Tue, 5 Nov 2019 17:38:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191105173841.43836ad7@cakuba.netronome.com>
In-Reply-To: <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031172330.58c8631a@cakuba.netronome.com>
        <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
        <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
        <20191101172102.2fc29010@cakuba.netronome.com>
        <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
        <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
        <20191104183516.64ba481b@cakuba.netronome.com>
        <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
        <20191105135536.5da90316@cakuba.netronome.com>
        <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
        <20191105151031.1e7c6bbc@cakuba.netronome.com>
        <a4f5771089f23a5977ca14d13f7bfef67905dc0a.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 23:48:15 +0000, Saeed Mahameed wrote:
> On Tue, 2019-11-05 at 15:10 -0800, Jakub Kicinski wrote:
> > But switchdev _is_ _here_. _Today_. From uAPI perspective it's done,
> > and ready. We're missing the driver and user space parts, but no core
> > and uAPI extensions. It's just L2 switching and there's quite a few
> > switch drivers upstream, as I'm sure you know :/ 
> 
> I can say the same about netlink, it also was there, the missing part
> was the netlink ethtool connection and userspace parts .. 

uAPI is the part that matters. No driver implements all the APIs. 
I'm telling you that the API for what you're trying to configure
already exists, and your driver should use it. Driver's technical 
debt is not my concern.

> Just because switchdev uAPI is powerful enough to do anything it
> doesn't mean we are ready, you said it, user space and drivers are not
> ready, and frankly it is not on the road map, 

I bet it's not on the road map. Product marketing sees only legacy
SR-IOV (table stakes) and OvS offload == switchdev (value add). 
L2 switchdev will never be implemented with that mind set.

In the upstream community, however, we care about the technical aspects.

> and we all know that it could take years before we can sit back and
> relax that we got our L2 switching .. 

Let's not be dramatic. It shouldn't take years to implement basic L2
switching offload.

> Just like what is happening now with ethtool, it been years you know..

Exactly my point!!! Nobody is going to lift a finger unless there is a
loud and resounding "no".

> > ethtool is not ready from uAPI perspective, still.
> 
> ethool is by definition a uAPI only tool, you can't compare the
> technical details and challenges of both issue, each one has different
> challenges, we need to compare complexity and deprecation policy impact
> on consumers.

Well, you started comparing the two.

API deprecation is always painful. The further you go with the legacy
API the more painful it will be to deprecate.

> > It'd be more accurate to compare to legacy IOCTLs, like arguing that 
> > we need a small tweak to IOCTLs when Netlink is already there..  
> 
> Well, no, The right analog here would be:
> 
> netlink == switchdev mode
> ethtool == legacy mode
> netlink-ethtool-interface == L2 bridge offloads 
> 
> you do the math.

My reading of the situation is that your maintenance cost goes down if
you manage to push some out of tree uAPI upstream, while the upstream
has no need for that uAPI. In fact it'd be far better for the project
to encourage people to work on SR-IOV offloads via normal kernel
constructs and not either some special case legacy VF ops or franken tc
OvS.

> It is not about uAPI, uAPI could be ready for switchdev mode, maybe, it
> just no one even gave this a real serious thought, so i can't accept
> that bridge offloads is just around the corner just because switchdev
> uAPI feels like ready to do anything, it is seriously not.

I had given switchdev L2 some thought. IDK what you'd call serious, 
I don't have code. We are doing some ridiculously complex OvS offloads
while most customers just need L2 plus maybe VXLAN encap and basic
ACLs. Which switchdev can do very nicely thanks to Cumulus folks.
