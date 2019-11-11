Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A4DF7532
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKKNj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:39:58 -0500
Received: from www62.your-server.de ([213.133.104.62]:57296 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKNj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:39:58 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iU9v7-0006nk-G4; Mon, 11 Nov 2019 14:39:53 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iU9v7-00016D-5s; Mon, 11 Nov 2019 14:39:53 +0100
Subject: Re: net --> net-next merge
To:     David Miller <davem@davemloft.net>, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20191109.122917.550362329016169460.davem@davemloft.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <21bdd43a-551f-333e-4db8-8729a17d3c71@iogearbox.net>
Date:   Mon, 11 Nov 2019 14:39:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191109.122917.550362329016169460.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25630/Mon Nov 11 10:59:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/19 9:29 PM, David Miller wrote:
> 
> Please double check my conflict resoltuion for samples/bpf/Makefile

Looks good, thanks!
