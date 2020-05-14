Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8E1D2D8A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgENKy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:54:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:46358 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENKyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:54:25 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jZBVO-0007Im-82; Thu, 14 May 2020 12:54:22 +0200
Date:   Thu, 14 May 2020 12:54:22 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kernel list <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: Re: netfilter: does the API break or something else ?
Message-ID: <20200514105422.GO17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Xiubo Li <xiubli@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kernel list <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
References: <cf0d02b2-b1db-7ef6-41b8-7c345b7d53d5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf0d02b2-b1db-7ef6-41b8-7c345b7d53d5@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 13, 2020 at 11:20:35PM +0800, Xiubo Li wrote:
> Recently I hit one netfilter issue, it seems the API breaks or something 
> else.

Just for the record, this was caused by a misconfigured kernel.

Cheers, Phil
