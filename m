Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDF319C164
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 14:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbgDBMrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 08:47:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43008 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387654AbgDBMrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 08:47:47 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jJzG4-0003LW-3p; Thu, 02 Apr 2020 14:47:44 +0200
Date:   Thu, 2 Apr 2020 14:47:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     sbezverk <sbezverk@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] nftables 0.9.4 release
Message-ID: <20200402124744.GY7493@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, sbezverk <sbezverk@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, lwn@lwn.net
References: <20200401143114.yfdfej6bldpk5inx@salvia>
 <8174B383-989D-4F9D-BDCA-3A82DE5090D2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8174B383-989D-4F9D-BDCA-3A82DE5090D2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Serguei,

On Thu, Apr 02, 2020 at 08:38:10AM -0400, sbezverk wrote:
> Did this commit make into 0.9.4?
> 
> https://patchwork.ozlabs.org/patch/1202696/

Sadly not, as it is incomplete (anonymous LHS maps don't work due to
lack of type info). IIRC, Florian wanted to address this but I don't
know how far he got with it.

Cheers, Phil
