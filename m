Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103802B99F1
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgKSRpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729675AbgKSRpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 12:45:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C505246CA;
        Thu, 19 Nov 2020 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605807952;
        bh=WY8lrP9gte0ZgxAd6VBueBmADx/RO2QpNenDUnj3lfA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xCGCV+3Q3Ctj9xvJvx0Md5ywEf9OloidQe9Rzi0cHCq11FquyH81OLogGMqAKNGT8
         hz8X3qZpQxGq0cScSVtj5H+m8WY5WQcm/+FmR3/Z8oYlJ9vEzlM3DCWFgobmEjoVGa
         mBHTy6IxyAKgCM7iRgm0CAlDeZu/EfqQDlBmFMec=
Date:   Thu, 19 Nov 2020 09:45:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next 0/9] s390/qeth: updates 2020-11-17
Message-ID: <20201119094551.27baf47a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <46384624-7fbe-fc18-9dd5-fb9c114a1868@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
        <20201118173517.4cfaa900@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <46384624-7fbe-fc18-9dd5-fb9c114a1868@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 11:25:31 +0200 Julian Wiedmann wrote:
> On 19.11.20 03:35, Jakub Kicinski wrote:
> > On Tue, 17 Nov 2020 17:15:11 +0100 Julian Wiedmann wrote:  
> >> please apply the following patch series for qeth to netdev's net-next tree.
> >>
> >> This brings some cleanups, and a bunch of improvements for our
> >> .get_link_ksettings() code.  
> > 
> > Applied, thanks!
> >   
> 
> Thank you! Looks like you missed patch 1 in the series though... no biggie,
> I'll resend it with the next batch of patches.

Ahhh, sorry, somehow patchwork did not fold it into the same series, 
and I didn't notice:

https://patchwork.kernel.org/project/netdevbpf/list/?series=386125&state=*

Let me add a big fat warning to my scripts so this doesn't happen again.
