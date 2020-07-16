Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5D2221938
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgGPBBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPBBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:01:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CADCD2078C;
        Thu, 16 Jul 2020 01:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594861306;
        bh=H0H1cfpKnnKuRaYYxUYCzxKrgJeczTSwegc9TcO0VAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QSv1YLr1usVlJCw6XJOYCwZrbBpoj49kSi0E7j03zq9o84atnIeHjJEBjoM6hbFtR
         dIr4hDDPgdHhGE6HzJp1ys9PZHDacnckoeShXBvXqxNQq2tjSAoXUrY5ks5BuqkdBL
         NE8V+XPYjeFo40cdmba3AVHi/zaDUCps0R127rjA=
Date:   Wed, 15 Jul 2020 18:01:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Pisati <paolo.pisati@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: ip_defrag: modprobe missing
 nf_defrag_ipv6 support
Message-ID: <20200715180144.02b83ed5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714124032.49133-1-paolo.pisati@canonical.com>
References: <20200714124032.49133-1-paolo.pisati@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 14:40:32 +0200 Paolo Pisati wrote:
>  #
>  # Run a couple of IP defragmentation tests.
>  
> +modprobe -q nf_defrag_ipv6
> +
>  set +x
>  set -e
>  

Any reason you add this command before set -e ?

It seems we want the script to fail if module can't be loaded.
