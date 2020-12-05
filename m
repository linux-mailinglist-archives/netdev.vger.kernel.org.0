Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE62CF8CC
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgLEBqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgLEBqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 20:46:33 -0500
Date:   Fri, 4 Dec 2020 17:45:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607132753;
        bh=aHlfbSBd752VidVFfhJa96mNfXk+/xnDUgic+t/6awE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qz4fleSCf/qdXv4I1HNcvU20L8eTa9tz3kNTGo3YzxSImIonl3nAPQfDH1jrF3I+k
         Nc4kyjqDmHeGKUOLh53IM54T59IwOzJiAzWllOE6jCYYS+RnEicWxREvFjcX0jXH22
         USom1S0+nDxWI40ESYfvvJNlWjPBB9JXXFWx1rQm7/J1fxi6o+u6F/Lf3hC0CYhBHL
         Mu6S4F2cegCRxI8JJ5xssA78sJirrBXylKbBRjjFnYr4EKz5ZlFemHygrU1ZoB1qi/
         YEuyvjX83K8CCKfQgoPdgpviy3kdH7nyFVLWlvD0nItzg7yJsbxT0gx89Gc0Oda3Qp
         CfafJSN+ZQnlw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH net-next] selftests: forwarding: Add MPLS L2VPN test
Message-ID: <20201204174552.120ee60f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <625f5c1aafa3a8085f8d3e082d680a82e16ffbaa.1606918980.git.gnault@redhat.com>
References: <625f5c1aafa3a8085f8d3e082d680a82e16ffbaa.1606918980.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 15:35:43 +0100 Guillaume Nault wrote:
> Connect hosts H1 and H2 using two intermediate encapsulation routers
> (LER1 and LER2). These routers encapsulate traffic from the hosts,
> including the original Ethernet header, into MPLS.
> 
> Use ping to test reachability between H1 and H2.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks!
