Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632B3243CF2
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 18:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgHMQFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 12:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgHMQFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 12:05:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D0D2078D;
        Thu, 13 Aug 2020 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597334738;
        bh=D3C5GsFoP8h2Vn1RnIzbRRocg6o9ilb2MdYM5PUqX8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1Vs7T/05vH0NcNl9dRAKARWOvjkNUWyyTb2G4TAqozwLOiXRasjMyCU/WLd29+wA+
         U4YYQwf/Nk9R8gfu3chR0yrJ/WyFe+L/yJ12vj6ZzMbmAzgPBSUTd6AmIrqNDPpBv3
         pK//OVZRTo1CqMfSnHQVM/ztTtUEh2RLTW+llWA8=
Date:   Thu, 13 Aug 2020 09:05:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>, hch@lst.de,
        syzkaller-bugs@googlegroups.com, <netdev@vger.kernel.org>,
        syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter/ebtables: reject bogus getopt len value
Message-ID: <20200813090536.2e3eae14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200813074611.281558-1-fw@strlen.de>
References: <000000000000ece9db05ac4054e8@google.com>
        <20200813074611.281558-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Aug 2020 09:46:11 +0200 Florian Westphal wrote:
> Fixes: fc66de8e16e ("netfilter/ebtables: clean up compat {get, set}sockopt handling")

Fixes tag: Fixes: fc66de8e16e ("netfilter/ebtables: clean up compat {get, set}sockopt handling")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
