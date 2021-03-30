Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E481134DEBB
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhC3CxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:53:11 -0400
Received: from mail.as397444.net ([69.59.18.99]:57048 "EHLO mail.as397444.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229762AbhC3Cwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 22:52:54 -0400
X-Greylist: delayed 10117 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 22:52:54 EDT
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id C456F50562C
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 02:52:53 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1617070863; t=1617072773;
        bh=fiFgyrWCOd7RxpRLH2am6TpSS2Eg9bAeZv9hu7o57oQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=VzvCfshCPfG8UZ8abDw1uYQ6g8ZQAO89SxXWpcKOjCWF7LQkg4QWCxf/sCDqvxTm2
         iH5Q+Uk5iOqmeHjCFGYnMNtLSphRvSKyDv+VM6sh0VPh9J5kmRon545lKxtzNBv5VQ
         sBOUP/DeJcmnL2cmmZ9CYGZdt25ctzQIP/8WX4Pxzg/XNMAXwqjUe4+zbqqwVx70Fy
         PDQDQd9rANHT888rNyg5LaHJ3saE+HnMXVI8GZ9TtGFEuQy9EbGNbNiNjFvBPZCLB6
         WcSxPCkI+0NkNH4NTMj0ADo9Pz812UsTLOUuE3aV2T6w6bkbEDl+2Yk1DNpWhnWN38
         NGdRWXA3c3RoQ==
Message-ID: <7b77831a-68d5-a1fb-5481-b6516db5cf37@bluematt.me>
Date:   Mon, 29 Mar 2021 22:52:53 -0400
MIME-Version: 1.0
Subject: Re: IP_FRAG_TIME Default Too Large
Content-Language: en-US
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b024bedb-d9e8-ee04-2443-2804760f51e4@mattcorallo.com>
From:   Matt Corallo <linux-net@mattcorallo.com>
In-Reply-To: <b024bedb-d9e8-ee04-2443-2804760f51e4@mattcorallo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/21 20:04, Matt Corallo wrote:
> This issue largely goes away when setting net.ipv4.ipfrag_time to 0/1.
Quick correction - the issue is reduced when set to 1 (as you might expect, you don't see as much loss if you wipe the 
fragment buffer every second) but if you set it to zero hosts randomly hang after some time (presumably when the buffer 
fills)? Either way, 0 should probably not be an allowed value for net.ipv4.ipfrag_time.

Matt
