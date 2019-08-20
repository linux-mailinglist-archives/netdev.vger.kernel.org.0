Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17183963CC
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbfHTPK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:10:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:41146 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfHTPK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:10:28 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05mE-0000Vu-7u; Tue, 20 Aug 2019 17:10:26 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i05mE-000K2H-1Q; Tue, 20 Aug 2019 17:10:26 +0200
Subject: Re: [PATCH bpf-next v2] bpf: add BTF ids in procfs for file
 descriptors to BTF objects
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190820135346.7593-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <edf6e5a1-6431-52c4-a77f-a012919b958b@iogearbox.net>
Date:   Tue, 20 Aug 2019 17:10:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190820135346.7593-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25547/Tue Aug 20 10:27:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 3:53 PM, Quentin Monnet wrote:
> Implement the show_fdinfo hook for BTF FDs file operations, and make it
> print the id of the BTF object. This allows for a quick retrieval of the
> BTF id from its FD; or it can help understanding what type of object
> (BTF) the file descriptor points to.
> 
> v2:
> - Do not expose data_size, only btf_id, in FD info.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks!
