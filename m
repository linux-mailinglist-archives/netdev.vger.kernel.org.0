Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFCA20757D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390162AbgFXOSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:18:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:37344 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388836AbgFXOSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:18:31 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jo6EO-0004Ke-2W; Wed, 24 Jun 2020 16:18:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jo6EN-000Olk-RW; Wed, 24 Jun 2020 16:18:27 +0200
Subject: Re: [PATCH bpf-next v2] tools: bpftool: fix variable shadowing in
 emit_obj_refs_json()
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200623213600.16643-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <01cd9c60-c563-4c7c-ec8a-a9dfbcec3867@iogearbox.net>
Date:   Wed, 24 Jun 2020 16:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200623213600.16643-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25853/Wed Jun 24 15:13:27 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 11:36 PM, Quentin Monnet wrote:
> Building bpftool yields the following complaint:
> 
>      pids.c: In function 'emit_obj_refs_json':
>      pids.c:175:80: warning: declaration of 'json_wtr' shadows a global declaration [-Wshadow]
>        175 | void emit_obj_refs_json(struct obj_refs_table *table, __u32 id, json_writer_t *json_wtr)
>            |                                                                 ~~~~~~~~~~~~~~~^~~~~~~~
>      In file included from pids.c:11:
>      main.h:141:23: note: shadowed declaration is here
>        141 | extern json_writer_t *json_wtr;
>            |                       ^~~~~~~~
> 
> Let's rename the variable.
> 
> v2:
> - Rename the variable instead of calling the global json_wtr directly.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Applied, thanks!
