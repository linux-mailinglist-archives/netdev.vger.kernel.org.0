Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD21197121
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 01:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgC2XqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 19:46:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:60452 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgC2XqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 19:46:23 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIhdC-0002mX-GH; Mon, 30 Mar 2020 01:46:18 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jIhdC-000Jec-8D; Mon, 30 Mar 2020 01:46:18 +0200
Subject: Re: [PATCH v4 1/2] libbpf: Add setter for initial value for internal
 maps
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200328182834.196578-1-toke@redhat.com>
 <20200329132253.232541-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e717cb05-8342-5fde-e468-9a58272e2c8c@iogearbox.net>
Date:   Mon, 30 Mar 2020 01:46:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200329132253.232541-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25766/Sun Mar 29 15:08:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/20 3:22 PM, Toke Høiland-Jørgensen wrote:
> For internal maps (most notably the maps backing global variables), libbpf
> uses an internal mmaped area to store the data after opening the object.
> This data is subsequently copied into the kernel map when the object is
> loaded.
> 
> This adds a function to set a new value for that data, which can be used to
> before it is loaded into the kernel. This is especially relevant for RODATA
> maps, since those are frozen on load.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Both applied, thanks!
