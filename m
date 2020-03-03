Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4BB176959
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgCCAa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:30:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45619 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCCAa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:30:56 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so523034pfg.12;
        Mon, 02 Mar 2020 16:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FKDXHGbgSUybJbBcy0shbv2BnyaxWG/IpfDFLqlZAkk=;
        b=juCEpYp1FFjRWpzSfr9RIloY9IMSP8gTwFWUd01MRDiOqXrKc6N/k5GzLaLmppz2Zd
         nFXyl8xanSTjbPqG0nR6WkL76Hc6oVDSK9S8oQNSOiNS3LlMuednPQ6cx9iLYVN2SJV/
         8YyBUBZmr5hvUlGWTpPY/XVVV2d4bo+Grrc8OvDY3iWrNtFko9QA/BUR56eSQ5FeIYYZ
         RPW4vGu20oVoBErZO1cby779krz5g6o5XCFXI69mYLOIDFHfdKVCytu3RlhCv65LsIMj
         AAM9rbTMM+KW6CUXl2lUK1WALVkzWPnPAbVXpOCRUCPRPpBUp7KoviVsLBbSO3T3cQUb
         N0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FKDXHGbgSUybJbBcy0shbv2BnyaxWG/IpfDFLqlZAkk=;
        b=KIg2W5NcHU3jnoEaKmnapZfAX46PVrCn5yRXnG5SUyUzJIWinLh9ffxHAQibdOuZWy
         UmeJvsqZWBVQlvK3a/dkzHZssdLNDTAkJybGhYtPW3MGonbJYeZjY69+r20x6fZcRBiP
         X2OMMvTXgg+af/vcTXzBT4brkA5T8ixl3/qY2G6fIUR4ABhP/gXdZfuhPCQ3pPmOm9VA
         Pu0x3YK+elaYKtVROOW/S+yuXd62YnTTUOebBgRxMQTe/s9I93P8s5FYFkxjBXQ1rMlL
         ojr2HtvRSRuZqlCaSC+PIKHRBGVN4sKxrUHErocorBjrmFINm6odpCkaQ7B+3tpQON6N
         aGaA==
X-Gm-Message-State: ANhLgQ0nnZu1JcIulI2x7tWiRgHv2nT0ms97I2/OBsD+GZPYvTOjR09R
        c/8LjDH8vvnkOuMdbwuR3uI=
X-Google-Smtp-Source: ADFU+vsza0MZwcoRcQzx95HlZtZN37c0OD2X1kA+ve4sxE0FrSztX3lrT/UDzbvhhKKL8jWdzNEZ9Q==
X-Received: by 2002:a63:82c2:: with SMTP id w185mr1505709pgd.382.1583195455513;
        Mon, 02 Mar 2020 16:30:55 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:1db6])
        by smtp.gmail.com with ESMTPSA id u7sm21833469pfh.128.2020.03.02.16.30.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 16:30:54 -0800 (PST)
Date:   Mon, 2 Mar 2020 16:30:52 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/4] Move BPF_PROG, BPF_KPROBE, and
 BPF_KRETPROBE to libbpf
Message-ID: <20200303003051.skfwue32z6y4kvyu@ast-mbp>
References: <20200229231112.1240137-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200229231112.1240137-1-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 29, 2020 at 03:11:08PM -0800, Andrii Nakryiko wrote:
> Move BPF_PROG, BPF_KPROBE, and BPF_KRETPROBE helper macros from private
> selftests helpers to public libbpf ones. These helpers are extremely helpful
> for writing tracing BPF applications and have been requested to be exposed for
> easy use (e.g., [0]).
> 
> As part of this move, fix up BPF_KRETPROBE to not allow for capturing input
> arguments (as it's unreliable and they will be often clobbered). Also, add
> vmlinux.h header guard to allow multi-time inclusion, if necessary; but also
> to let PT_REGS_PARM do proper detection of struct pt_regs field names on x86
> arch. See relevant patches for more details.
> 
>   [0] https://github.com/iovisor/bcc/pull/2778#issue-381642907

Looks like folks started to copy paste this macro into different places.
So definitely makes sense to move it.
Applied. Thanks
