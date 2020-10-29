Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298C129EF80
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 16:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgJ2PQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 11:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgJ2PQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 11:16:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85ABD2076E;
        Thu, 29 Oct 2020 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603984594;
        bh=hSnuwO9i8vYH0fM2M1kE2SHiaxuaeLezHgMHWhG8V9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XbVyagwuUvo3mgBgegI8R2C6DUf8z+nfLWVxD8eCFBM8CKf/XAJh7MJcATdjT2WEC
         WJqYC6Gfu/LYbKNzMLEMayZAHlJsZjMbqslsM2tquD7sMQRWA6DIWRKCYkUDWM7DXJ
         Hv4wqriHP/QKnMLKwGln2G/beNWq7paPv2DM5bJg=
Date:   Thu, 29 Oct 2020 08:16:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH net-next 2/3] net/core: introduce default_rps_mask netns
 attribute
Message-ID: <20201029081632.2516a39b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9e86568c264696dbe0fd44b2a8662bd233e2c3e8.1603906564.git.pabeni@redhat.com>
References: <cover.1603906564.git.pabeni@redhat.com>
        <9e86568c264696dbe0fd44b2a8662bd233e2c3e8.1603906564.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 18:46:02 +0100 Paolo Abeni wrote:
> @@ -46,6 +47,54 @@ int sysctl_devconf_inherit_init_net __read_mostly;
>  EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
>  
>  #ifdef CONFIG_RPS
> +struct cpumask rps_default_mask;

net/core/sysctl_net_core.c:50:16: warning: symbol 'rps_default_mask' was not declared. Should it be static?
