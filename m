Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1469C2B095E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgKLP6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbgKLP6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:58:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8607322227;
        Thu, 12 Nov 2020 15:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605196697;
        bh=HNane0fTZaNd9zIE50Z8zt6tdzDyBOHDJPVAVJ3rQ9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UJYzJRFaEBEGrStPLSkfu+i623AfLqzYa6x1s/hooSJZtidG/cdfR4rD/if/odtRL
         9bk0kl2fKlX0nw15GX19CKAg8A7/QU3ciLSak70MVhAK5hkvCGvxhCSsQj8LYI+kBs
         Bt0SA4FxxygzR2ooEhMKisPA84lnpOUcSipBsKxI=
Date:   Thu, 12 Nov 2020 07:58:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        skhan@linuxfoundation.org
Subject: Re: [PATCHv2 0/2] selftests: pmtu.sh: improve the test result
 processing
Message-ID: <20201112075815.6f9b8efc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110020049.6705-1-po-hsu.lin@canonical.com>
References: <20201110020049.6705-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 10:00:47 +0800 Po-Hsu Lin wrote:
> The pmtu.sh test script treats all non-zero return code as a failure,
> thus it will be marked as FAILED when some sub-test got skipped.
> 
> This patchset will:
>   1. Use the kselftest framework skip code $ksft_skip to replace the
>      hardcoded SKIP return code.
>   2. Improve the result processing, the test will be marked as PASSED
>      if nothing goes wrong and not all the tests were skipped.

Applied, thank you!
