Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834B447A234
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhLSVJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236159AbhLSVJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 16:09:51 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1693AC061574;
        Sun, 19 Dec 2021 13:09:51 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id k23so12797223lje.1;
        Sun, 19 Dec 2021 13:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=/ODWiIFGBcYIvOfjZgM+N+Zmuylofd9rTC/IRS5c5Dg=;
        b=CNJnTKoVrR+mwizs+Fk1R93lblNcNM4P27W7UK4hd4s27ASSOzb/5wDgppG9NcagXE
         Qy60cY1bQvHLHQL7dCVp3zkiQ2nsriGwYA9hAAgDFeBIfHx29yp0n6Fq9xM/BhR/Vr9A
         CIrTllNeGrazQCLEbz+bOscvL/no/U1lFSiR+5AYFd5ZXZvfJtgRLQe/4cf9wRlQSlZe
         rx24LCf1j7eaEsRpedCvFeYYPeM3CdJi2MUQK42Fsr1sG2UHHymcs4himDf4VcWHenKH
         2qRMV5yaFyW+hp2hXjRYQgT3AWdkGEwVO/Sv7g0LdQgfk77kwbW6OQ2xmdxbiPD+2ayX
         egUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/ODWiIFGBcYIvOfjZgM+N+Zmuylofd9rTC/IRS5c5Dg=;
        b=xILUm7rKOlhPbkeQZno1MZxuWRo9SND/aiH1GUM9CecsSUqQaUa74nyZVneokqb+/q
         U+YamWlpCx4omnJATS1w9EsvQTNd7jyqoU0tkswXENm4vj3HqFjvORuxc58KSvOhPiwq
         ZLCKt0C2v1ta+R6yX8QOOtK1l/MELF18j5XjzVMnXQRVoIBd573MJInzPzSk+KP0d/FM
         u9KPVv8A49CbqA6mZbglIGxnc6lyG+PvN+JWztJ3ktXUQ39uaHV35sG+8nIbbr+Svmhh
         PJBt0Gh4ZVAFkHhGZq+ZsF2769pf35dGyQquNKxZV4SMEZoX/nKwT/qcIqVRydNi7Dxe
         hpcA==
X-Gm-Message-State: AOAM531MzWwE61uNpnZMregfq4f+WKubiuLv5ZbonpRn1cn2MMmFnEU5
        7rfzGC4e5fTp3kYgNwpB6Eg=
X-Google-Smtp-Source: ABdhPJx3wPQ6HrbBYqzrVoNQwf8mAOx7GXoGOS7f1asn6BPTyEDxiSEYwlceB8H2wBV85PMZeh9NIA==
X-Received: by 2002:a2e:7305:: with SMTP id o5mr12072132ljc.180.1639948189334;
        Sun, 19 Dec 2021 13:09:49 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.239])
        by smtp.gmail.com with ESMTPSA id q10sm2333370ljp.44.2021.12.19.13.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 13:09:48 -0800 (PST)
Message-ID: <dac227fc-b0ce-79e1-c42f-eb03b4f5d699@gmail.com>
Date:   Mon, 20 Dec 2021 00:09:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] kernel BUG at net/phonet/socket.c:LINE!
Content-Language: en-US
To:     syzbot <syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com>,
        courmisch@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000005721f05d3810165@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <00000000000005721f05d3810165@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/21 17:58, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    60ec7fcfe768 qlcnic: potential dereference null pointer of..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=11b3505db00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa556098924b78f0
> dashboard link: https://syzkaller.appspot.com/bug?extid=2dc91e7fc3dea88b1e8a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168791cdb00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a0cbcdb00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com
> 

This bug can be triggered via simple

sk = socket(AF_PHONET)
ioctl(sk, SIOCPNENABLEPIPE, 0)
connect(sk);


ioctl() sets sk->sk_state to TCP_SYN_SENT in pep_sock_enable() and then 
there is following check in pn_socket_bind():

	if (sk->sk_state != TCP_CLOSE || pn_port(pn->sobject)) {
		err = -EINVAL; /* attempt to rebind */
		goto out;
	}

Looks like "sk->sk_state != TCP_CLOSE" check is redundant and 
pn_port(pn->sobject) is unique flag, that socket is already binded.




With regards,
Pavel Skripkin
