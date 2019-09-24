Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8596BD121
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 20:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407467AbfIXSBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 14:01:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:35472 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391108AbfIXSBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 14:01:20 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iCp7l-00052b-Mj; Tue, 24 Sep 2019 20:01:17 +0200
Date:   Tue, 24 Sep 2019 20:01:17 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH V11 0/4] BPF: New helper to obtain namespace data from
 current task
Message-ID: <20190924180117.GA5889@pc-63.home>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924152005.4659-1-cneirabustos@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25582/Tue Sep 24 10:20:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 12:20:01PM -0300, Carlos Neira wrote:
> Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> scripts but this helper returns the pid as seen by the root namespace which is
> fine when a bcc script is not executed inside a container.
> When the process of interest is inside a container, pid filtering will not work
> if bpf_get_current_pid_tgid() is used.
> This helper addresses this limitation returning the pid as it's seen by the current
> namespace where the script is executing.
> 
> In the future different pid_ns files may belong to different devices, according to the
> discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> used to do pid filtering even inside a container.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> 
> Carlos Neira (4):
>   fs/nsfs.c: added ns_match
>   bpf: added new helper bpf_get_ns_current_pid_tgid
>   tools: Added bpf_get_ns_current_pid_tgid helper
>   tools/testing/selftests/bpf: Add self-tests for new helper. self tests
>     added for new helper

bpf-next is currently closed due to merge window. Please resubmit once back open, thanks.
