Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F3B4A5C48
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiBAMa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:30:27 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:50681 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbiBAMa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:30:26 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 97C4C200E7AC;
        Tue,  1 Feb 2022 13:30:24 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 97C4C200E7AC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643718624;
        bh=2Y/PrOPn4JhV59tu89LcprN1QsOki6fty5u+KAjQVyo=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=n0KzHKYpa6Nwn78q/Mgs5zvFkPSrwhyNGgaRB0GojgosULeVCy6rT1/1+T3NStOwG
         Is1ReCslMHoIKTXyBqvf+om3nYplJjV9jv8L5DnaV0h2kztHD6GvXZAGgWO8ltX2Qt
         1xeuCulzRf8LVIpqDXf8LCYd+ZtFCGuvfsqcHgoKHi2SCO6VbeIsoCfgYO2nDrG1X7
         XK88sx1Q+NHxruV2p28Q+2P7VyJ9Dv0Qv5+vnxPB/bd7XLqmYLFEEGWzvXecHDs2p+
         q5LyN0hChHyfgLUC7nMyugwP56yURwUlKKjR6MfBydFhOvhr8zT9DjjiO465weu9CO
         3ZyaAMnuZ9SXA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 8C34D60606A9A;
        Tue,  1 Feb 2022 13:30:24 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oynGYUZMKW81; Tue,  1 Feb 2022 13:30:24 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 72668603B1667;
        Tue,  1 Feb 2022 13:30:24 +0100 (CET)
Date:   Tue, 1 Feb 2022 13:30:24 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <1477010559.12570446.1643718624333.JavaMail.zimbra@uliege.be>
In-Reply-To: <20220131105458.4a7c182f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220126184628.26013-1-justin.iurman@uliege.be> <20220126184628.26013-2-justin.iurman@uliege.be> <20220128173121.7bb0f8b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <31581393.9071156.1643455487833.JavaMail.zimbra@uliege.be> <20220131105458.4a7c182f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next 1/2] uapi: ioam: Insertion frequency
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4026)
Thread-Topic: uapi: ioam: Insertion frequency
Thread-Index: WRLr8rxe4IuLnLa+SUXQuTCvmcOF+w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 31, 2022, at 7:54 PM, Jakub Kicinski kuba@kernel.org wrote:
>> >> +	IOAM6_IPTUNNEL_FREQ_K,		/* s32 */
>> >> +	IOAM6_IPTUNNEL_FREQ_N,		/* s32 */
>> > 
>> > You can't insert into the middle of a uAPI enum. Binary compatibility.
>> 
>> Is it really the middle? I recall adding the "mode" at the top (still
>> below the "_UNSPEC"), which I thought was correct at that time (and had
>> no objection).
> 
> Maybe because both changes were made in the same kernel release?
> Not sure.

I just checked. They were both in two different releases, i.e., 5.15 and
5.16. That's weird. It means that the value of IOAM6_IPTUNNEL_TRACE has
changed between 5.15 and 5.16, where it shouldn't have, right? Anyway...

>> That's why I did the same here. Should I move it to the end, then?
> 
> You have to move it. I don't see how this patch as is wouldn't change
> the value of IOAM6_IPTUNNEL_MODE.

Indeed. So moving it below IOAM6_IPTUNNEL_TRACE should be fine I guess.
