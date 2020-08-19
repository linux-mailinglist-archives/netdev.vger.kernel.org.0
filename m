Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E956524A68E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHSTHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgHSTHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 15:07:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A34820882;
        Wed, 19 Aug 2020 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597864068;
        bh=XCNDAm4/i4+hu73ZLRziHYFKO+PtCRHRihwxtI3YDtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lf/QvYrUeaPVFpq3rCwOTXapzB8YMnuGFVpI92Dp4wA52UZ/Cd0SyCjKxsjmtiepd
         KnjqHzaWm/8IKIjw4oVA3CQn+UM55fztW+PCsJnkq0/9KLMGxRzhkNw2JP0wDlml3Z
         lD77vg4mAbpfX1ET0/KM+EPhwdSeQCpEe5xndp08=
Date:   Wed, 19 Aug 2020 12:07:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     andriin@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, ast@kernel.org
Subject: Re: xdp generic default option
Message-ID: <20200819120746.468990f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819092811.GA2420@lore-desk>
References: <20200819092811.GA2420@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 11:28:11 +0200 Lorenzo Bianconi wrote:
> Hi Andrii,
> 
> working on xdp multi-buff I figured out now xdp generic is the default choice
> if not specified by userspace. In particular after commit 7f0a838254bd
> ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device"), running
> the command below, XDP will run in generic mode even if the underlay driver
> support XDP in native mode:

Make me wonder if bpf/test_offload.py was ever run on those changes :/
