Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC32B55DA
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgKQAsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:48:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgKQAsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:48:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2AA2467A;
        Tue, 17 Nov 2020 00:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605574103;
        bh=nogkuIg9ypmqP8vPLq103jU1SC77exfAsSVzIHfx6Gg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tKB4MI7WpL7obebNi3T42f4BNygeKDsk5T07LC78IVKxilgVKj+6B4vjAc5sbht77
         Bew6VpCj+SRj7Hi3i0hsVG27cktbaSBdSkYSKIZjyvzzXKVVYxZUXwNwZR+aXM4Gi6
         TVVuqoj6e670XAvnbCyKMohrviOaG1fc5CkrzJqU=
Date:   Mon, 16 Nov 2020 16:48:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 1/4] ethtool: add
 ETHTOOL_COALESCE_ALL_PARAMS define
Message-ID: <20201116164822.65ef488a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113231655.139948-1-acardace@redhat.com>
References: <20201113231655.139948-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please add a cover letter to this series.

Preferably with the output of the test passing :)
