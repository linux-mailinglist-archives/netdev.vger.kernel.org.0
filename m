Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBECB2F8159
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbhAOQ53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727475AbhAOQ52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 11:57:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7979C20738;
        Fri, 15 Jan 2021 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610729807;
        bh=65KME7dlQ6ZxSIcs/tBhxcihrYV+4nzB/aZGW3JS39U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iW5vxKMW9vNDJos4it09xTOONBPZKklsLnEyxEmE4xEDwArUAAIjUc6JNJFqx7Ijw
         DyGUNyWEQI19X/6El61kkAvRhz4DXcIaGio0nqsD8aSOld7nU8cL2WOHM817fNloUF
         bRJsslHS7zn51K8eZee/SERyxtjaG9PT8mU/+Iz6VtMcwkYZgkiVusJE1xYp8IpK3c
         Y7pJgKlcI/1XyLYRlU4875q9xrd8YpE2GDuJM3JPykPxcZ+5gKYBq/0Zl5nJ/pZvRr
         7iH+PfMh+QvJHiDK9j99EYhdStd2dpM7vx3ND4d8ntZqm8bBB7rXitiWgoecnzTKQk
         oBFQNYyCMINqA==
Date:   Fri, 15 Jan 2021 08:56:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Durrant <paul@xen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Peter Cammaert <pc@denkart.be>,
        Paul Mackerras <paulus@samba.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Wei Liu <wei.liu@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Santiago Leon <santi_leon@yahoo.com>,
        xen-devel@lists.xenproject.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Daris A Nevil <dnevil@snmc.com>,
        Lijun Pan <ljp@linux.ibm.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Erik Stahlman <erik@vt.edu>,
        John Allen <jallen@linux.vnet.ibm.com>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v2 0/7] Rid W=1 warnings in Ethernet
Message-ID: <20210115085645.0f27864a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115133848.GK3975472@dell>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
        <20210113183551.6551a6a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114083349.GI3975472@dell>
        <20210114091453.30177d20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114195422.GB3975472@dell>
        <20210115111823.GH3975472@dell>
        <bc775cc3-fda3-0280-5f92-53058996f02f@csgroup.eu>
        <20210115133848.GK3975472@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 13:38:48 +0000 Lee Jones wrote:
> Okay, so what would you like me to do?  Would you like me to re-submit
> the set based only on net-next

Yes, rebase your patches on net-next, recheck everything builds okay
and resubmit. You should always develop against the tree that will
merge your patches. I appreciate for your janitorial work using
linux-next is more expedient, but as you can see it causes trouble,
this is not the first time your patches don't apply to net-next IIRC.
