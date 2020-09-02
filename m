Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B36D25A245
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIBA27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBA26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:28:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D6A52068E;
        Wed,  2 Sep 2020 00:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599006538;
        bh=PCYMHx+CCQOzgydXX9s+x0EtUVSDR3k34wkaQxQTJAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vme0LcV9SePI2oSx+uu77IjVE400CrEI6hh0vcirN+qXQtaxjm41abcNdfyeYdHEY
         Qm2PEVVmP048pjHQxKbUotAYc4cGphJDKnn0YXdcDllnBOwMoQNur7ngFWaBk1T+XZ
         IXX8RQZv5SzD5xFW9OBBdj6YBh4w7uKqhDSs5qAU=
Date:   Tue, 1 Sep 2020 17:28:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 2/9] gve: Add stats for gve.
Message-ID: <20200901172856.19c573c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901215149.2685117-3-awogbemila@google.com>
References: <20200901215149.2685117-1-awogbemila@google.com>
        <20200901215149.2685117-3-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Sep 2020 14:51:42 -0700 David Awogbemila wrote:
> From: Kuo Zhao <kuozhao@google.com>
> 
> Sample output of "ethtool -S <interface-name>" with 1 RX queue and 1 TX
> queue:

Acked-by: Jakub Kicinski <kuba@kernel.org>

Looking forward to the standard stats.
