Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20B72AE3E8
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgKJXPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJXPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:15:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1243B20781;
        Tue, 10 Nov 2020 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050117;
        bh=wUI+7ugFkt9U9seRdSeTP+YeMrLvFzF1CzzDKLwl52s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D+0HbooiFcKYj0oPOmGOi+Z4gWddYe1pwYorgkewwqq4L7x6+6hOToyPcvGpQoGrU
         HWjo/3Gl5Ls/wfnbdhtsUhZPcXGWYTL0MXnftRbLkf0pkpl4llZODh+BMnVGlZIEO6
         xnMcdRbAN3mwMav+2VByzNvj5xr71/3MY71zaWIM=
Date:   Tue, 10 Nov 2020 15:15:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: disable rp_filter when testing
 bareudp
Message-ID: <20201110151516.171de6f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <28140b7d20161e4f766b558018fe2718f9bc1117.1604767577.git.gnault@redhat.com>
References: <28140b7d20161e4f766b558018fe2718f9bc1117.1604767577.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Nov 2020 17:47:17 +0100 Guillaume Nault wrote:
> Some systems have rp_filter=1 as default configuration. This breaks
> bareudp.sh as the intermediate namespaces handle part of the routing
> with regular IPv4 routes but the reverse path is done with tc
> (flower/tunnel_key/mirred).
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks!
