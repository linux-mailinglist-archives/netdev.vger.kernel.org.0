Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACFC25CE2E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgICXDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgICXDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 19:03:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2273520639;
        Thu,  3 Sep 2020 23:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599174226;
        bh=szEWoD/i2uegw+Zgrt1BJJyfyA5WSuZO+JBPgIENNUw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yNXZNVJ50LDBBXC4kf1OWY2W4fOAwKS5ZZs+JVb8HDL/Ehpbc9/heS9Vpvv7ND6bf
         KgY0OgypKVRGjs3mUHjCecM/sSdc6pJ55zguZ3LGKtnaKcdZXpTU+Uj/EiPYPupu95
         AhB35Ei4dHZkUfDfQnhfAydFgNnwOL9XzfT8F1Rw=
Date:   Thu, 3 Sep 2020 16:03:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jwi@linux.ibm.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        edwin.peer@broadcom.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next] net: tighten the definition of interface
 statistics
Message-ID: <20200903160344.51824f3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903160228.53f68526@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200903020336.2302858-1-kuba@kernel.org>
        <01db6af0-611d-2391-d661-60cfb4ba2031@gmail.com>
        <20200903160228.53f68526@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 16:02:28 -0700 Jakub Kicinski wrote:
> > > +This simple interface is convenient especially in constrained/embedded
> > > +environments without access to tools. However, it's sightly inefficient    
> > 
> > sightly seems like the wrong word. Did you mean 'highly inefficient'?  
> 
> Indeed, I'll drop the "slightly". Hopefully the info below is clear
> enough for users to understand what's happening. 

Ah, I realized now I was missing the 'l'. Anyway, I dropped the word,
it didn't add much.
