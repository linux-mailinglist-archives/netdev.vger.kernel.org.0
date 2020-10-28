Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0709F29DF74
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404001AbgJ2BB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731507AbgJ1WR1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12455221F8;
        Wed, 28 Oct 2020 01:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603847349;
        bh=UTP6m0hErt5YvbaiYwvFJWFMdgJIjAJJzmBNfb5t7+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n0k/xYJO5DEKAdAiakAi6Il6W4vqRsh26pp08LyV1G2lrFZzv9sVMJJjr5QY/8WDL
         2pU8EUKWhd/cz7K0eqi7p2YQvwDqVI0STvVRGOr1lgir7bZ75zKzAM3gQ5XjOapDFm
         Rsij78iBOLN6ZYzTT6OLxuOUbaovXcJX+LPcAsZU=
Date:   Tue, 27 Oct 2020 18:09:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH net-next] net: ceph: Fix most of the kerneldoc warings
Message-ID: <20201027180908.49885105@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028005907.930575-1-andrew@lunn.ch>
References: <20201028005907.930575-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 01:59:07 +0100 Andrew Lunn wrote:
> net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oid' not described in 'ceph_cls_break_lock'
> net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oloc' not described in 'ceph_cls_break_lock'
> ...

I think this will be for Ilya and Jeff to pick up. Doesn't seem
particularly network-centric.

