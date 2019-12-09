Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869E811666D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 06:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLIF27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 00:28:59 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:1550
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfLIF26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 00:28:58 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 212E820942;
        Mon,  9 Dec 2019 05:28:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Dec 2019 06:28:53 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     David Miller <davem@davemloft.net>
Cc:     andrew.hendry@gmail.com, edumazet@google.com,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/x25: add new state X25_STATE_5
Organization: TDT AG
In-Reply-To: <20191207.115922.532322440743611081.davem@davemloft.net>
References: <20191206133418.14075-1-ms@dev.tdt.de>
 <20191207.115922.532322440743611081.davem@davemloft.net>
Message-ID: <3841dcf6dab454445da7b225e0d45212@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-12-07 20:59, David Miller wrote:
> From: Martin Schiller <ms@dev.tdt.de>
> Date: Fri,  6 Dec 2019 14:34:18 +0100
> 
>> +	switch (frametype) {
>> +
>> +		case X25_CLEAR_REQUEST:
> 
> Please remove this unnecessary empty line.
> 
>> +			if (!pskb_may_pull(skb, X25_STD_MIN_LEN + 2))
>> +				goto out_clear;
> 
> A goto path for a single call site?  Just inline the operations here.

Well, I was guided by the code style of the other states.
I could add a patch to also clean up the other states.
What do you think?

