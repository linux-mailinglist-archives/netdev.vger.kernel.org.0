Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8672944BA
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbgJTVvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgJTVvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 17:51:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D0222247;
        Tue, 20 Oct 2020 21:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603230667;
        bh=47w19OyFW23jNae9ky8XXWZFl16VCSwI2Zb7VAujwYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kAnbB/IQIhn/Pb3bwonX5F6RP5JuYusT387j2p7I1X9XxSF4i6z4qCplwGjOmTG50
         0pZ62+83ajSn2vX2TSeoAccWkclLNpaUCHma/bOOOkNJO9qib/07e17aGDPeTfvh+6
         zQf6l7BwH4wG4m0nmcZzGjVb3ppgYKFWDqwZNcs8=
Date:   Tue, 20 Oct 2020 14:51:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool 0/4] add missing message descriptions
Message-ID: <20201020145105.04b64797@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1603142897.git.mkubecek@suse.cz>
References: <cover.1603142897.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 23:32:37 +0200 (CEST) Michal Kubecek wrote:
> Add message descriptions needed for pretty printing of netlink messages
> related to recently added features: genetlink policy dumps and pause frame
> statistics. First two patches extend pretty printing code with features
> used by these descriptions: support for 64-bit numeric attributes and
> and enumerated types (shown as symbolic names rather than numeric values).

Nice! I haven't crossed checked all the types but FWIW LGTM.
