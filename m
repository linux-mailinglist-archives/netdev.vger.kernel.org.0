Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E929E7E0E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfJ2Bgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:36:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbfJ2Bgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 21:36:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 89F2960D82; Tue, 29 Oct 2019 01:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572312996;
        bh=Mv2J845sZ1e4fsPYWzkhpXf5jScuwP+p1t+8zgQxR5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G+I4lHua2nOIO1gBo7zGQLd+Bm6sdsQKImmPFIWu5d/+EZGNGbyIOIaPvPPM6pYgF
         00Hy58QcPgLkV6DzNA00dAr+OJxojNmSoEj9viS9zF+2nGN6gcobcqzs0glTugc5DV
         tf3avWuT0/uU5FIl8Z/aZGAV9r0aIVpsDzDw1PT8=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 21AC36081E;
        Tue, 29 Oct 2019 01:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572312996;
        bh=Mv2J845sZ1e4fsPYWzkhpXf5jScuwP+p1t+8zgQxR5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G+I4lHua2nOIO1gBo7zGQLd+Bm6sdsQKImmPFIWu5d/+EZGNGbyIOIaPvPPM6pYgF
         00Hy58QcPgLkV6DzNA00dAr+OJxojNmSoEj9viS9zF+2nGN6gcobcqzs0glTugc5DV
         tf3avWuT0/uU5FIl8Z/aZGAV9r0aIVpsDzDw1PT8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Oct 2019 19:36:36 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
In-Reply-To: <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
 <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
 <f7a0507ce733dd722b1320622dfd1caa@codeaurora.org>
 <CADVnQy=SDgiFH57MUv5kNHSjD2Vsk+a-UD0yXQKGNGY-XLw5cw@mail.gmail.com>
 <2279a8988c3f37771dda5593b350d014@codeaurora.org>
 <CADVnQykjfjPNv6F1EtWWvBT0dZFgf1QPDdhNaCX3j3bFCkViwA@mail.gmail.com>
 <f9ae970c12616f61c6152ebe34019e2b@codeaurora.org>
 <CADVnQymqKpMh3iRfrdiAYjb+2ejKswk8vaZCY6EW4-3ppDnv_w@mail.gmail.com>
Message-ID: <81ace6052228e12629f73724236ade63@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> I've queued up a build which logs calls to tcp_write_queue_purge and
>> clears tp->highest_sack and tp->sacked_out. I will let you know how
>> it fares by end of week.
> 
> OK, thanks. That should be a useful data point.

I haven't seen the crash in the testing so far.
Looks like clearing these values seems to help.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
