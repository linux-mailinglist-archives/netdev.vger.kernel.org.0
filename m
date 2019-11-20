Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC001044BD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfKTUFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:05:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfKTUFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:05:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA9E114C1A0A0;
        Wed, 20 Nov 2019 12:05:41 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:05:41 -0800 (PST)
Message-Id: <20191120.120541.2179935914746776644.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v5 0/3] cxgb4: add TC-MATCHALL classifier
 offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574176510.git.rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:05:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Wed, 20 Nov 2019 05:46:05 +0530

> This series of patches add support to offload TC-MATCHALL classifier
> to hardware to classify all outgoing and incoming traffic on the
> underlying port. Only 1 egress and 1 ingress rule each can be
> offloaded on the underlying port.
> 
> Patch 1 adds support for TC-MATCHALL classifier offload on the egress
> side. TC-POLICE is the only action that can be offloaded on the egress
> side and is used to rate limit all outgoing traffic to specified max
> rate.
> 
> Patch 2 adds logic to reject the current rule offload if its priority
> conflicts with existing rules in the TCAM.
> 
> Patch 3 adds support for TC-MATCHALL classifier offload on the ingress
> side. The same set of actions supported by existing TC-FLOWER
> classifier offload can be applied on all the incoming traffic.
 ...

Series applied, thanks.

