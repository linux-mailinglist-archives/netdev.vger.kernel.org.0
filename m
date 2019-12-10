Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD02117D48
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfLJBkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:40:23 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:33875 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfLJBkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:40:22 -0500
Received: by mail-pj1-f46.google.com with SMTP id j11so5561198pjs.1;
        Mon, 09 Dec 2019 17:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=N9EX0/WVsuVS1Rm6bUUrGixIzfIklafYZW7EtGC8b3Y=;
        b=Uml6OhqZSV6VYJbQuu8+X2A4IoLicLmIqQRZYoKhWIZ8OIGxfL3xx1GPc8b8tKjf7x
         Pa9aOGT/eTNa7oe+Vv/6pFy+yjTtrbq8dgH67TAsjlAay2mo7QJv0/6b2Dp+OyRKUpbP
         qRg4FrjrCe+gK/xue0GTxIXWepQai7JT9WCeSMnj6NmLiVm63TdQrVcykBFNAx8JTxVT
         hsVgorPuQwmaI/qjOwnYO0bH7vo/qc+fUp7HldxjkSGnS3gi2e/yN6+2W33G7W187Odc
         LP2SuzY5qga+GQc+cUwqpgoTiFCKccJ/FBHk5C4JTgJJjw21AG9miAFIRm4oNWEfh1F6
         Q7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=N9EX0/WVsuVS1Rm6bUUrGixIzfIklafYZW7EtGC8b3Y=;
        b=VRmSWItEwqvOVR53PMpwuqxrEcOOAAeuEklBUvXqCbL8gekzgLUJavdGe8wAtEp0O4
         rvDRkyxVx4cUysC+7sjU7YFBaB9TDBNu96g7JEtXaGc4yvJUhNz7tuRRcTSJthJMpWrd
         mZFpWfnpQMZmF11sweTcav46zJk0Nvm5hykbGgCSGhht10M9uJIuZiEOdKuxGNtFhz8z
         JLfpNTYwlnZO8rdV2/Yvg5GnHyRWVOS8amQgvwScbjr3fxhV+omfFqhoCPa1V/0OLSsE
         655FYmwITsdEJjFLQYy2c6JMZq+9fitWIn8KmKy+BciaOdjplbc8eHJvp7GRX5PxxHwS
         jtFA==
X-Gm-Message-State: APjAAAUTzC9QJPlJ8MtjihA97TdXOGNI0p6uB79Fg0dralvA/1vUee3j
        Chb0biOaHl1avtAxxw9v0UY=
X-Google-Smtp-Source: APXvYqzEI0NkXZB47SBngHI5ZAZhdHlR7ZlgB2VI/y7IkJK9AMlxIeRyr7n7JIr9G2xH5u0HRomNyA==
X-Received: by 2002:a17:902:9a0b:: with SMTP id v11mr32464748plp.151.1575942021898;
        Mon, 09 Dec 2019 17:40:21 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:8eea])
        by smtp.gmail.com with ESMTPSA id c184sm733235pfa.39.2019.12.09.17.40.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 17:40:21 -0800 (PST)
Date:   Mon, 9 Dec 2019 17:40:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        daniel@iogearbox.net, netdev@vger.kernel.org
Subject: Re: Establishing /usr/lib/bpf as a convention for eBPF bytecode
 files?
Message-ID: <20191210014018.ltmjgsaafve54o6w@ast-mbp.dhcp.thefacebook.com>
References: <87fthtlotk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fthtlotk.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 12:29:27PM +0100, Toke Høiland-Jørgensen wrote:
> Hi everyone
> 
> As you have no doubt noticed, we have started thinking about how to
> package eBPF-related applications in distributions. As a part of this,
> I've been thinking about what to recommend for applications that ship
> pre-compiled BPF byte-code files.
> 
> The obvious place to place those would be somewhere in the system
> $LIBDIR (i.e., /usr/lib or /usr/lib64, depending on the distro). But
> since BPF byte code is its own binary format, different from regular
> executables, I think having a separate path to put those under makes
> sense. So I'm proposing to establish a convention that pre-compiled BPF
> programs be installed into /usr/lib{,64}/bpf.
> 
> This would let users discover which BPF programs are shipped on their
> system, and it could be used to discover which package loaded a
> particular BPF program, by walking the directory to find the file a
> loaded program came from. It would not work for dynamically-generated
> bytecode, of course, but I think at least some applications will end up
> shipping pre-compiled bytecode files (we're doing that for xdp-tools,
> for instance).
> 
> As I said, this would be a convention. We're already using it for
> xdp-tools[0], so my plan is to use that as the "first mover", try to get
> distributions to establish the path as a part of their filesystem
> layout, and then just try to encourage packages to use it. Hopefully it
> will catch on.
> 
> Does anyone have any objections to this? Do you think it is a complete
> waste of time, or is it worth giving it a shot? :)

What will be the name of file/directory ?
What is going to be the mechanism to clean it up?
What will be stored in there? Just .o files ?

libbcc stores original C and rewritten C in /var/tmp/bcc/bpf_prog_TAG/
It was useful for debugging. Since TAG is used as directory name
reloading the same bcc script creates the same dir and /var/tmp
periodically gets cleaned by reboot.

Installing bpf .o into common location feels useful. Not sure though
how you can convince folks to follow such convention.
That was the main problem with libbcc. Not everything is using that lib.
So teaching folks who debug bpf in production to look into /var/tmp/bcc
wasn't enough. 'bpftool p s' is still the main mechanism.
Some C++ services embed bpf .o as part of x86 binary and that binary
is installed. They wouldn't want to split bpf .o into separate file
since it will complicate dependency management, risk conflicts, etc.
Just food for thought.

