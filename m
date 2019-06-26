Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6409956769
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFZLNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:13:24 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40158 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfFZLNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:13:24 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hg5re-0001V2-G3; Wed, 26 Jun 2019 13:13:22 +0200
Date:   Wed, 26 Jun 2019 13:13:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Naruto Nguyen <narutonguyen2018@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: Question about nf_conntrack_proto for IPsec
Message-ID: <20190626111322.gks5qptax3iqrjao@breakpoint.cc>
References: <CANpxKHHXzrEpJPSj3x83+WE23G1W0KPz9XbG=fCVzS21+-BpfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpxKHHXzrEpJPSj3x83+WE23G1W0KPz9XbG=fCVzS21+-BpfQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naruto Nguyen <narutonguyen2018@gmail.com> wrote:
> In linux/latest/source/net/netfilter/ folder, I only see we have
> nf_conntrack_proto_tcp.c, nf_conntrack_proto_udp.c and some other
> conntrack implementations for other protocols but I do not see
> nf_conntrack_proto for IPsec, so does it mean connection tracking
> cannot track ESP or AH protocol as a connection. I mean when I use
> "conntrack -L" command, I will not see ESP or AH  connection is saved
> in conntrack list. Could you please help me to understand if conntrack
> supports that and any reasons if it does not support?

ESP/AH etc. use the generic tracker, i.e. only one ESP connection
is tracked between each endpoint.
