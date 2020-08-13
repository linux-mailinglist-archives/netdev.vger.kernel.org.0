Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52888243CAE
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHMPk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 11:40:29 -0400
Received: from verein.lst.de ([213.95.11.211]:46768 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgHMPk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 11:40:28 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E699968C65; Thu, 13 Aug 2020 17:40:26 +0200 (CEST)
Date:   Thu, 13 Aug 2020 17:40:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, hch@lst.de,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter/ebtables: reject bogus getopt len value
Message-ID: <20200813154026.GA14095@lst.de>
References: <000000000000ece9db05ac4054e8@google.com> <20200813074611.281558-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813074611.281558-1-fw@strlen.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good, sorry:

Reviewed-by: Christoph Hellwig <hch@lst.de>
