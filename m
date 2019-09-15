Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46285B2F3D
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 10:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfIOIh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 04:37:27 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:34039 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbfIOIh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 04:37:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id EE2ED15AF;
        Sun, 15 Sep 2019 04:37:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 15 Sep 2019 04:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=D9np/Q
        Sc1+4VFNHkIHacsErC3VZPbG2UrbGRIq6i1BE=; b=cajDoaQJiCxflEbWI3eRod
        f8P2E+RzICvNMkaY44AkcpXPUsXiiSsfbtpxvUDoTfBK7OizpVq8cospzAU5HFd1
        9ytCirhUf086BeUPw5e3USHqk0zKDmAdc8itGVf9XWMfRh5I9ukekO23sNJT3qDH
        gvYtkqsQVSeXPpK9WCndMMB4O7D0iqLsAr0zhlSjkCjlnzz/t+VhbTtcQAejhqAF
        9iwJC++4kNuqONbkFWNSMMmSn0GF4YSjl9olwBVOrY5SoAVN9Z1TS97Wl5Zvch/+
        WkuAGRwnxp+yReIpOfaMVM/fRkPjkzYekk414V3l9mrMRrjGZKEkb1Vk2k5qAjwQ
        ==
X-ME-Sender: <xms:RPh9XZ6g6vnk7kcMprA4g-MOtz6Ns0oGD6RHV4bbiwR9AOfH2ohxYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddugddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:RPh9XbJMAexDz2zPC7wXZDyplHh_FrbBAMQgSUB6qz3vwbGqcDwQPQ>
    <xmx:RPh9XbeAOHnZO-bHCplgfcB-XpusgH-HrQ4qAC2mYueU5voTh6t-kA>
    <xmx:RPh9XWdBZsrjVh90f79WbBJ7ICAwVjM7VxsD3HO3VI5d8tKXZNd5rQ>
    <xmx:Rfh9XSECwUE4hq-4me_pOI4zY9YAPiNzfBvQ28HJptDlYfFLfAu32Q>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD4118005B;
        Sun, 15 Sep 2019 04:37:23 -0400 (EDT)
Date:   Sun, 15 Sep 2019 11:37:21 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        tariqt@mellanox.com, saeedm@mellanox.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 08/15] mlxsw: Register port netdevices into net
 of core
Message-ID: <20190915083721.GC11194@splinter>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190914064608.26799-9-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190914064608.26799-9-jiri@resnulli.us>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 08:46:01AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> When creating netdevices for ports, put then under network namespace

s/then/them/

> that the core/parent devlink belongs to.
