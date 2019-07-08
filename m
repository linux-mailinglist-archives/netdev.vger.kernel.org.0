Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427A96229A
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbfGHP1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:27:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:45422 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388473AbfGHP1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:27:04 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVXi-0000k4-Fj; Mon, 08 Jul 2019 17:27:02 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkVXi-000FGx-8Y; Mon, 08 Jul 2019 17:27:02 +0200
Subject: Re: [PATCH bpf-next] tools: bpftool: add completion for bpftool prog
 "loadall"
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190708130546.7518-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b64cefff-1162-5fa3-6841-cbde08f01fad@iogearbox.net>
Date:   Mon, 8 Jul 2019 17:27:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190708130546.7518-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08/2019 03:05 PM, Quentin Monnet wrote:
> Bash completion for proposing the "loadall" subcommand is missing. Let's
> add it to the completion script.
> 
> Add a specific case to propose "load" and "loadall" for completing:
> 
>     $ bpftool prog load
>                        ^ cursor is here
> 
> Otherwise, completion considers that $command is in load|loadall and
> starts making related completions (file or directory names, as the
> number of words on the command line is below 6), when the only suggested
> keywords should be "load" and "loadall" until one has been picked and a
> space entered after that to move to the next word.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks!
