Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6635A2C573E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390345AbgKZOjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:39:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46226 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389991AbgKZOjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:39:55 -0500
X-Greylist: delayed 3495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2020 09:39:54 EST
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kiHWk-00FtFp-7u; Thu, 26 Nov 2020 06:41:38 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kiHWj-0003Ma-5I; Thu, 26 Nov 2020 06:41:38 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20201126162248.7e7963fe@canb.auug.org.au>
Date:   Thu, 26 Nov 2020 07:41:12 -0600
In-Reply-To: <20201126162248.7e7963fe@canb.auug.org.au> (Stephen Rothwell's
        message of "Thu, 26 Nov 2020 16:22:48 +1100")
Message-ID: <87a6v4nslj.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kiHWj-0003Ma-5I;;;mid=<87a6v4nslj.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19590D4YxTqaZNbKHQ7oHvcJ0XZUjADk20=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=8.0 tests=ALL_TRUSTED,BAYES_20,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1073]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
X-Spam-Timing: total 526 ms - load_scoreonly_sql: 0.10 (0.0%),
        signal_user_changed: 13 (2.5%), b_tie_ro: 11 (2.1%), parse: 1.42
        (0.3%), extract_message_metadata: 17 (3.3%), get_uri_detail_list: 1.38
        (0.3%), tests_pri_-1000: 7 (1.4%), tests_pri_-950: 1.78 (0.3%),
        tests_pri_-900: 1.40 (0.3%), tests_pri_-90: 67 (12.8%), check_bayes:
        65 (12.4%), b_tokenize: 7 (1.3%), b_tok_get_all: 6 (1.1%),
        b_comp_prob: 2.3 (0.4%), b_tok_touch_all: 47 (8.9%), b_finish: 1.18
        (0.2%), tests_pri_0: 165 (31.4%), check_dkim_signature: 0.67 (0.1%),
        check_dkim_adsp: 2.6 (0.5%), poll_dns_idle: 217 (41.2%), tests_pri_10:
        4.2 (0.8%), tests_pri_500: 243 (46.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: linux-next: manual merge of the userns tree with the bpf-next tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> Today's linux-next merge of the userns tree got a conflict in:
>
>   kernel/bpf/task_iter.c
>
> between commit:
>
>   91b2db27d3ff ("bpf: Simplify task_file_seq_get_next()")
>
> from the bpf-next tree and commit:
>
>   edc52f17257a ("bpf/task_iter: In task_file_seq_get_next use task_lookup_next_fd_rcu")
>
> from the userns tree.
>
> I fixed it up (I think, see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

Thanks.  Reading through the diff that looks right, and it has been already
reported.

Eric

