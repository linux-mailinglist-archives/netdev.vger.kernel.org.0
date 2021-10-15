Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3076C42F992
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241943AbhJORGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:06:08 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:34031 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbhJORGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:06:07 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 0CFFE200DB97;
        Fri, 15 Oct 2021 19:03:59 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 0CFFE200DB97
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1634317439;
        bh=zpwnN2AUjkgE9diC5/FWFAWyy6H04+bF7Paw1V8HRXU=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=hjPj906ubIJmgzHduAG4jcprq29zMtasVoo/0YZfkQ7jkwWTKvqK2aPsPMIdtxoHS
         Oix8E0rWuj00gW+QvsJbjUg3cTliWKQQsiY5r/h5rVjviEpnJxCmUx6arnaTYn+Ii1
         fBE4Szwo214BE0DWMjUzHVw2Ye+o6D2Y/W48FhWZDiGtnTKEL8CvqPWI2pWFV5YdzK
         BOn06xSmnUS+ZyEZ/QtqiaB3Q+Xq97ioiZd5b5MG1RtatzZP+X12i/nic3vuq5LC+i
         SDrFGGmYCvviNEBqzZ/EBHyIHBHNxf3yWBFh56cx171MmmQu5s/h4y0Uuj5gMWxUwQ
         q+Hc1ADaLY1yQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 0512B60225548;
        Fri, 15 Oct 2021 19:03:59 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id v61Udbh7qz41; Fri, 15 Oct 2021 19:03:58 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id E393E6016F437;
        Fri, 15 Oct 2021 19:03:58 +0200 (CEST)
Date:   Fri, 15 Oct 2021 19:03:58 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <1483539844.133216515.1634317438885.JavaMail.zimbra@uliege.be>
In-Reply-To: <20211014172800.26374a35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211011180412.22781-1-justin.iurman@uliege.be> <20211014172800.26374a35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net 0/2] Correct the IOAM behavior for undefined trace
 type bits
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.165.223.37]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF93 (Linux)/8.8.15_GA_4026)
Thread-Topic: Correct the IOAM behavior for undefined trace type bits
Thread-Index: u9JAO48wz0+BxvSWk5ziU1HYeKhzzw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> (@Jakub @David: there will be a conflict for #2 when merging net->net-next, due
>> to commit [1]. The conflict is only 5-10 lines for #2 (#1 should be fine) inside
>> the file tools/testing/selftests/net/ioam6.sh, so quite short though possibly
>> ugly. Sorry for that, I didn't expect to post this one... Had I known, I'd have
>> made the opposite.)

Hi Jakub,

> Hi Justin, net was merged into net-next now, please double check the
> resolution. I think it's the same as Stephen's [1]. In the future please

Thanks for that, I just checked and it's indeed OK.

> try to include a tree way diff or instructions on how to do the merge.

Noted, thanks again.

> Thanks!
> 
> [1]
> https://lore.kernel.org/all/20211013104227.62c4d3af@canb.auug.org.au/
