Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1325F12BBCE
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 00:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfL0X2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 18:28:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:60732 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL0X2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 18:28:41 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ikz1y-00015B-PD; Sat, 28 Dec 2019 00:28:30 +0100
Received: from [185.105.41.29] (helo=linux-9.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ikz1y-000Skt-ER; Sat, 28 Dec 2019 00:28:30 +0100
Subject: Re: pull-request: bpf-next 2019-12-27
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, bjorn.topel@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20191227180817.30438-1-daniel@iogearbox.net>
 <20191227.142042.195965541160730299.davem@davemloft.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1e43c387-aca8-57c4-9aea-3be0c34fd0cb@iogearbox.net>
Date:   Sat, 28 Dec 2019 00:28:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191227.142042.195965541160730299.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25676/Fri Dec 27 11:04:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/19 11:20 PM, David Miller wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> Date: Fri, 27 Dec 2019 19:08:17 +0100
> 
>> The following pull-request contains BPF updates for your *net-next* tree.
> 
> Pulled and conflicts resolved as per your description, thanks!
> 
> I'll push out after some quick build testing.

Perfect, thanks a lot!
