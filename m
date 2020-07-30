Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4984233C34
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgG3XhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgG3XhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:37:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7886C20829;
        Thu, 30 Jul 2020 23:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596152236;
        bh=AQRB1MFq+ualDllV5T2e5pkh5TEsStq7EiGhrRptrgs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n+i9W0Lk2WF9l3gxKDYtAZ3s+aS222OkE+k9Js9gJ3DcxI91XCgzdr5C7Yua3S6QZ
         whpxQq3Bmi+JjSDFkYdfF7+Sn0n8/LbOlwA2nFAyYpxib5WEJqbHWSemdo2i8QQ/DW
         UWCHdF+a9e9Xb0ROIQI4i6v7BAJjhwBr9R1cqht8=
Date:   Thu, 30 Jul 2020 16:37:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next 4/4] s390/qeth: use all configured RX buffers
Message-ID: <20200730163714.7d6a5017@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730150121.18005-5-jwi@linux.ibm.com>
References: <20200730150121.18005-1-jwi@linux.ibm.com>
        <20200730150121.18005-5-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 17:01:21 +0200 Julian Wiedmann wrote:
> The (misplaced) comment doesn't make any sense, enforcing an
> uninitialized RX buffer won't help with IRQ reduction.
> 
> So make the best use of all available RX buffers.

Often one entry in the ring is left free to make it easy to
differentiate between empty and full conditions. 

Is this not the reason here?
