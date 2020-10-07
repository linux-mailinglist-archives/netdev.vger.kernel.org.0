Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC6D28656C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgJGRGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbgJGRGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 13:06:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 691A621582;
        Wed,  7 Oct 2020 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602090392;
        bh=CLekkomzfrCOSQyfgDJ4AsbNaDHOlGZN87kfejQlUnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gW4N4p4eM07y9a/YyzN3Faxx8JDYue5JAXKzNEXW+Kzpdn01Hi21vdUHe9IxQ0sl3
         EaiKby7BuggY4GdjOd2KYUFIQzm8ITe19se9+wF1jp0wuZlDYsu3QsXsERBwv+UQfX
         yL+XTrCDX3vRvyi+SntWZLL87BEsQy06i+ZbEJoM=
Date:   Wed, 7 Oct 2020 10:06:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2 1/2] netlink: policy: refactor per-attr policy
 writing
Message-ID: <20201007100630.396f573c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006201333.8ab12687d931.Id092e96bbd4df7102eea602baf20a409bff3b9b0@changeid>
References: <20201006181555.103140-1-johannes@sipsolutions.net>
        <20201006201333.8ab12687d931.Id092e96bbd4df7102eea602baf20a409bff3b9b0@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 20:15:54 +0200 Johannes Berg wrote:
> +	const struct nla_policy *pt;
> +	struct nlattr *policy;
> +	int err;
> +	bool again;

nit: rev-xmas tree
