Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0A627EDD0
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgI3Pt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730804AbgI3Pt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 11:49:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D70220754;
        Wed, 30 Sep 2020 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601480997;
        bh=29RtIMKkABGiqKe1CHPMvspT078NN0NeN+g55IIz6Eg=;
        h=Date:From:To:Cc:Subject:From;
        b=sLK8DPgGqN0TzFfuTqPHG7/w+pRqBUI971RfHiejbmxlFz3ZP8lJOWlmzrNUZ/dcR
         WdFQ0W6Krx9lrow665euuOjFbVUAfSelAkNtH7Y7g7t3P7crn0c53LRFtLTddPYgLQ
         A425/ue/uj/JD0Tn0sR/TwxlbMy7eotsWrQ7h+p0=
Date:   Wed, 30 Sep 2020 08:49:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>, johannes@sipsolutions.net,
        Michal Kubecek <mkubecek@suse.cz>, dsahern@kernel.org,
        pablo@netfilter.org
Cc:     netdev@vger.kernel.org
Subject: Genetlink per cmd policies
Message-ID: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I'd like to be able to dump ethtool nl policies, but right now policy
dumping is only supported for "global" family policies.

Is there any reason not to put the policy in struct genl_ops, 
or just nobody got to it, yet?

I get the feeling that this must have been discussed before...
