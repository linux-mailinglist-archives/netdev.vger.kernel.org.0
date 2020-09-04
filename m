Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EBB25E1FA
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgIDTa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgIDTa6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 15:30:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115372083B;
        Fri,  4 Sep 2020 19:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599247858;
        bh=yVfay0lnd28NGJIxYtJjCxfY3h/kQDiVEdTJTo3zdqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sbjs4j1GsbYMvW8mYOyi3jkEfTGFjmwIdbDQIje4T8Py5E4fP1yW7CbFP0/9oNNxr
         cdyX8Uyi3PSx+gBh2kD1JZasP61J1SwQmp0Dg1lfldTUKQbo0Hcqgu+kiSC7Ap5xGk
         /sNIoQeSfqaBqfm3tn3OhAqQf5EZTM2Ua8pBZ4DU=
Date:   Fri, 4 Sep 2020 12:30:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     David Miller <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv2] selftests: rtnetlink: load fou module for
 kci_test_encap_fou()
Message-ID: <20200904123056.5f00ff9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMy_GT8jOOPw+esd53X2LQ4aY9eqpE0rv9vDgr_eBD6fy5Wmqg@mail.gmail.com>
References: <20200813044422.46713-1-po-hsu.lin@canonical.com>
        <CAMy_GT8jOOPw+esd53X2LQ4aY9eqpE0rv9vDgr_eBD6fy5Wmqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 17:10:39 +0800 Po-Hsu Lin wrote:
> Hello David,
> 
> do you need more information for this V2 patch?

Something strange happened here, did you perhaps edit the patch
manually and resend the same email? I think the Message-ID header 
may had been the same on v1 and v2 of your patch and it confused 
all systems indexing by Message-ID..

Please regenerate the patch fully and resend.
