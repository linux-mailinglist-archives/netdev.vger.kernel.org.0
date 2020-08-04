Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139C123BF65
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 20:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgHDSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 14:34:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:40002 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgHDSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 14:34:13 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k31lA-0002U0-7f; Tue, 04 Aug 2020 20:34:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k31lA-000509-2r; Tue, 04 Aug 2020 20:34:00 +0200
Subject: Re: pull-request: bpf-next 2020-08-04
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200803235640.31210-1-daniel@iogearbox.net>
 <20200803.184515.1642003997353340419.davem@davemloft.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ec370ab0-ba7c-a8d6-4966-a83566d99791@iogearbox.net>
Date:   Tue, 4 Aug 2020 20:33:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200803.184515.1642003997353340419.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25894/Tue Aug  4 14:38:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/20 3:45 AM, David Miller wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Tue,  4 Aug 2020 01:56:40 +0200
> 
>> The following pull-request contains BPF updates for your *net-next* tree.
> 
> Pulled, there was a minor conflict in net/core/dev.c please double check
> my work.

Right, I provided merge resolution / guidance in the PR for this, not sure if
you saw it, but either way looks good to me, thanks!
