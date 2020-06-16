Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C521FA4FE
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 02:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFPATt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 20:19:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:60622 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgFPATs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 20:19:48 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jkzKN-00046F-1y; Tue, 16 Jun 2020 02:19:47 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jkzKM-0006J7-QR; Tue, 16 Jun 2020 02:19:46 +0200
Subject: Re: [PATCH bpf] tools/bpftool: add ringbuf map to a list of known map
 types
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200615225355.366256-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fb96f885-2be9-9b3a-f8c1-7dff5990a6de@iogearbox.net>
Date:   Tue, 16 Jun 2020 02:19:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200615225355.366256-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25844/Mon Jun 15 15:06:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 12:53 AM, Andrii Nakryiko wrote:
> Add symbolic name "ringbuf" to map to BPF_MAP_TYPE_RINGBUF. Without this,
> users will see "type 27" instead of "ringbuf" in `map show` output.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
