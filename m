Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E068229328D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 03:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgJTBC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 21:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgJTBC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 21:02:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4BF22224D;
        Tue, 20 Oct 2020 01:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603155748;
        bh=dVWKxJasSxeB6F1AN5koetCPNMgfVAq/tsFxlJjoSXY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dGeT7H+9aZh6m9Lja7KWiUXTLVf8AR0zJMSgv+RzVlTY6cmejGTYI3wbP/Dy5v/+d
         fKJSuLhR6NorzdEsqIYesgMyLlU5smtX6mkA5+P2Tf8+DtFBR0V470BnAiCGDo6SUr
         iUdCwKBaYVi0JpfXVSF2wEtPzv6xQl+0wYrWCEsk=
Date:   Mon, 19 Oct 2020 18:02:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     davem@davemloft.net, skhan@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCHv5] selftests: rtnetlink: load fou module for
 kci_test_encap_fou() test
Message-ID: <20201019180226.38934319@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019030928.9859-1-po-hsu.lin@canonical.com>
References: <20201019030928.9859-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 11:09:28 +0800 Po-Hsu Lin wrote:
> The kci_test_encap_fou() test from kci_test_encap() in rtnetlink.sh
> needs the fou module to work. Otherwise it will fail with:
> 
>   $ ip netns exec "$testns" ip fou add port 7777 ipproto 47
>   RTNETLINK answers: No such file or directory
>   Error talking to the kernel
> 
> Add the CONFIG_NET_FOU into the config file as well. Which needs at
> least to be set as a loadable module.
> 
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Applied, thank you!
