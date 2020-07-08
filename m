Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDDF2193E0
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgGHWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:55:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:33638 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGHWzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:55:14 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtIy8-00009C-5C; Thu, 09 Jul 2020 00:55:12 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtIy7-000CsF-Vf; Thu, 09 Jul 2020 00:55:12 +0200
Subject: Re: [PATCH bpf-next] bpf: Fix another bpftool segfault without
 skeleton code enabled
To:     louis.peens@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, oss-drivers@netronome.com
References: <20200708110827.7673-1-louis.peens@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8db2662b-44e9-f81a-8aea-f4f8af7e868d@iogearbox.net>
Date:   Thu, 9 Jul 2020 00:55:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200708110827.7673-1-louis.peens@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25867/Wed Jul  8 15:50:39 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 1:08 PM, louis.peens@netronome.com wrote:
> From: Louis Peens <louis.peens@netronome.com>
> 
> emit_obj_refs_json needs to added the same as with emit_obj_refs_plain
> to prevent segfaults, similar to Commit "8ae4121bd89e bpf: Fix bpftool
> without skeleton code enabled"). See the error below:
> 
>      # ./bpftool -p prog
>      {
>          "error": "bpftool built without PID iterator support"
>      },[{
>              "id": 2,
>              "type": "cgroup_skb",
>              "tag": "7be49e3934a125ba",
>              "gpl_compatible": true,
>              "loaded_at": 1594052789,
>              "uid": 0,
>              "bytes_xlated": 296,
>              "jited": true,
>              "bytes_jited": 203,
>              "bytes_memlock": 4096,
>              "map_ids": [2,3
>      Segmentation fault (core dumped)
> 
> The same happens for ./bpftool -p map, as well as ./bpftool -j prog/map.
> 
> Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied, thanks!
