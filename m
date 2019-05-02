Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD5D1147A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 09:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfEBHqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 03:46:49 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44114 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfEBHqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 03:46:48 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hM6QU-0002Hq-Ha; Thu, 02 May 2019 09:46:42 +0200
Date:   Thu, 2 May 2019 09:46:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter
 on flush
Message-ID: <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
 <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
 <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> I understand your point, but this is a regression. Ignoring a field/attribute of
> a netlink message is part of the uAPI. This field exists for more than a decade
> (probably two), so you cannot just use it because nobody was using it. Just see
> all discussions about strict validation of netlink messages.
> Moreover, the conntrack tool exists also for ages and is an official tool.

FWIW I agree with Nicolas, we should restore old behaviour and flush
everything when AF_INET is given.  We can add new netlink attr to
restrict this.

