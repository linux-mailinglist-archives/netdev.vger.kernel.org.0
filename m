Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AF5142E2E
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgATO4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 09:56:03 -0500
Received: from mail.dlink.ru ([178.170.168.18]:33174 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgATO4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 09:56:03 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 85DD21B202A0; Mon, 20 Jan 2020 17:56:00 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 85DD21B202A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1579532160; bh=9DbgI3YRw82O91b1kx0E5exwSxg7vePCSmEOj9HFVls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=LzxXLrYUJet/kCUVwA/VM8YN6DVi2VNyYoDh62EK6fuQAMnc1vvjx31Hd6tyERMtW
         qR5C4GBGcKDQM34RwiWJbpu0bWtfiOcXKDqcovxU17UWQeYjrFCNM9Vg7U4esg7T8R
         Q1LcQvSHEwOWIuLtgn2JuGp7mAD/ljJpuiNbTcqM=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id BF3F31B202A0;
        Mon, 20 Jan 2020 17:55:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru BF3F31B202A0
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 87BED1B2265F;
        Mon, 20 Jan 2020 17:55:52 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 20 Jan 2020 17:55:52 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 20 Jan 2020 17:55:52 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, edumazet@google.com,
        netdev@vger.kernel.org, davem@davemloft.net,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net] net: Fix packet reordering caused by GRO and
 listified RX cooperation
In-Reply-To: <1b91ee24-1ec0-3aef-9ab7-d58673dc98ae@solarflare.com>
References: <20200117150913.29302-1-maximmi@mellanox.com>
 <7939223efeb4ed9523a802702874be9b8f37f231.camel@mellanox.com>
 <da13831f11d0141728a96954685fdf40@dlink.ru>
 <5b0519b8640f9f270a9570720986eee7@dlink.ru>
 <1b91ee24-1ec0-3aef-9ab7-d58673dc98ae@solarflare.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <c356cc089554350c010ef871dbad16fe@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote 20.01.2020 17:39:
> On 20/01/2020 09:44, Alexander Lobakin wrote:
>> Still need Edward's review.
> Sorry for delay, didn't have time to catch up with the net-next 
> firehose
>  on Friday.

Oh, no problem at all.

> With this change:
>> IV. Patch + gro_normal_list() is placed after napi_gro_flush()
>  and the corrected Fixes tag, I agree that the solution is correct, and
>  expect to ack v2 when it's posted.

Exactly, great. Thanks!

> -Ed

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
