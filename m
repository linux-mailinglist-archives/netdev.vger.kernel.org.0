Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE667B7D4
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 03:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfGaBxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 21:53:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36908 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfGaBxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 21:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9dYgiyE7tY+jolyoIC290OJonbSBB0TWYhI9HfnD5UY=; b=07AejvtsDmpqcFSlag/B7fsgaC
        RSXLyk+mjeF+M14wValD/wt2g5KYdasf/CgxkJOtTiG0CBK2T1F0TQ6SCjCf3jkhX3J7x6x9Wi3V9
        d4fVBH+OGVyfHCP8rMkgg9M0mWESr4vGSs1uaf6K1UMDthsrKjIUXrIs7DTTGrtLzQL2+udx2yTVK
        psULG4fDzJIhXvx+HQAlbxo6TB/QSj81z7N0jCa0rgBKn21nGU295Vpk9WayoV3rlja+gFrfFdhnB
        8iXKpGyCXM+k/5Fai+nOPUaSfZdS0LCtfJkFF7Hk8+L88AiHRLGPRXlbvksdLe8swv9njAsforrWm
        2ajrstbw==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hsdnf-00064Q-EU; Wed, 31 Jul 2019 01:53:07 +0000
Subject: Re: [PATCH bpf-next v10 10/10] landlock: Add user and kernel
 documentation for Landlock
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-11-mic@digikod.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <88e90c22-1b78-c2f2-8823-fa776265361c@infradead.org>
Date:   Tue, 30 Jul 2019 18:53:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190721213116.23476-11-mic@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/19 2:31 PM, Mickaël Salaün wrote:
> This documentation can be built with the Sphinx framework.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> ---
> 
> Changes since v9:
> * update with expected attach type and expected attach triggers
> 
> Changes since v8:
> * remove documentation related to chaining and tagging according to this
>   patch series
> 
> Changes since v7:
> * update documentation according to the Landlock revamp
> 
> Changes since v6:
> * add a check for ctx->event
> * rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
> * rename Landlock version to ABI to better reflect its purpose and add a
>   dedicated changelog section
> * update tables
> * relax no_new_privs recommendations
> * remove ABILITY_WRITE related functions
> * reword rule "appending" to "prepending" and explain it
> * cosmetic fixes
> 
> Changes since v5:
> * update the rule hierarchy inheritance explanation
> * briefly explain ctx->arg2
> * add ptrace restrictions
> * explain EPERM
> * update example (subtype)
> * use ":manpage:"
> ---
>  Documentation/security/index.rst           |   1 +
>  Documentation/security/landlock/index.rst  |  20 +++
>  Documentation/security/landlock/kernel.rst |  99 ++++++++++++++
>  Documentation/security/landlock/user.rst   | 147 +++++++++++++++++++++
>  4 files changed, 267 insertions(+)
>  create mode 100644 Documentation/security/landlock/index.rst
>  create mode 100644 Documentation/security/landlock/kernel.rst
>  create mode 100644 Documentation/security/landlock/user.rst


> diff --git a/Documentation/security/landlock/kernel.rst b/Documentation/security/landlock/kernel.rst
> new file mode 100644
> index 000000000000..7d1e06d544bf
> --- /dev/null
> +++ b/Documentation/security/landlock/kernel.rst
> @@ -0,0 +1,99 @@
> +==============================
> +Landlock: kernel documentation
> +==============================
> +
> +eBPF properties
> +===============
> +
> +To get an expressive language while still being safe and small, Landlock is
> +based on eBPF. Landlock should be usable by untrusted processes and must
> +therefore expose a minimal attack surface. The eBPF bytecode is minimal,
> +powerful, widely used and designed to be used by untrusted applications. Thus,
> +reusing the eBPF support in the kernel enables a generic approach while
> +minimizing new code.
> +
> +An eBPF program has access to an eBPF context containing some fields used to
> +inspect the current object. These arguments can be used directly (e.g. cookie)
> +or passed to helper functions according to their types (e.g. inode pointer). It
> +is then possible to do complex access checks without race conditions or
> +inconsistent evaluation (i.e.  `incorrect mirroring of the OS code and state
> +<https://www.ndss-symposium.org/ndss2003/traps-and-pitfalls-practical-problems-system-call-interposition-based-security-tools/>`_).
> +
> +A Landlock hook describes a particular access type.  For now, there is two

                                                                 there are two

> +hooks dedicated to filesystem related operations: LANDLOCK_HOOK_FS_PICK and
> +LANDLOCK_HOOK_FS_WALK.  A Landlock program is tied to one hook.  This makes it
> +possible to statically check context accesses, potentially performed by such
> +program, and hence prevents kernel address leaks and ensure the right use of

                                                        ensures

> +hook arguments with eBPF functions.  Any user can add multiple Landlock
> +programs per Landlock hook.  They are stacked and evaluated one after the
> +other, starting from the most recent program, as seccomp-bpf does with its
> +filters.  Underneath, a hook is an abstraction over a set of LSM hooks.
> +
> +
> +Guiding principles
> +==================
> +
> +Unprivileged use
> +----------------
> +
> +* Landlock helpers and context should be usable by any unprivileged and
> +  untrusted program while following the system security policy enforced by
> +  other access control mechanisms (e.g. DAC, LSM).
> +
> +
> +Landlock hook and context
> +-------------------------
> +
> +* A Landlock hook shall be focused on access control on kernel objects instead
> +  of syscall filtering (i.e. syscall arguments), which is the purpose of
> +  seccomp-bpf.
> +* A Landlock context provided by a hook shall express the minimal and more
> +  generic interface to control an access for a kernel object.
> +* A hook shall guaranty that all the BPF function calls from a program are> +  safe.  Thus, the related Landlock context arguments shall always be of the
> +  same type for a particular hook.  For example, a network hook could share
> +  helpers with a file hook because of UNIX socket.  However, the same helpers
> +  may not be compatible for a file system handle and a net handle.
> +* Multiple hooks may use the same context interface.
> +
> +
> +Landlock helpers
> +----------------
> +
> +* Landlock helpers shall be as generic as possible while at the same time being
> +  as simple as possible and following the syscall creation principles (cf.
> +  *Documentation/adding-syscalls.txt*).
> +* The only behavior change allowed on a helper is to fix a (logical) bug to
> +  match the initial semantic.
> +* Helpers shall be reentrant, i.e. only take inputs from arguments (e.g. from
> +  the BPF context), to enable a hook to use a cache.  Future program options
> +  might change this cache behavior.
> +* It is quite easy to add new helpers to extend Landlock.  The main concern
> +  should be about the possibility to leak information from the kernel that may
> +  not be accessible otherwise (i.e. side-channel attack).
> +
> +
> +Questions and answers
> +=====================
> +
> +Why not create a custom hook for each kind of action?
> +-----------------------------------------------------
> +
> +Landlock programs can handle these checks.  Adding more exceptions to the
> +kernel code would lead to more code complexity.  A decision to ignore a kind of
> +action can and should be done at the beginning of a Landlock program.
> +
> +
> +Why a program does not return an errno or a kill code?
> +------------------------------------------------------
> +
> +seccomp filters can return multiple kind of code, including an errno value or a

                                       kinds

> +kill signal, which may be convenient for access control.  Those return codes
> +are hardwired in the userland ABI.  Instead, Landlock's approach is to return a
> +boolean to allow or deny an action, which is much simpler and more generic.
> +Moreover, we do not really have a choice because, unlike to seccomp, Landlock
> +programs are not enforced at the syscall entry point but may be executed at any
> +point in the kernel (through LSM hooks) where an errno return code may not make
> +sense.  However, with this simple ABI and with the ability to call helpers,
> +Landlock may gain features similar to seccomp-bpf in the future while being
> +compatible with previous programs.
> diff --git a/Documentation/security/landlock/user.rst b/Documentation/security/landlock/user.rst
> new file mode 100644
> index 000000000000..14c4f3b377bd
> --- /dev/null
> +++ b/Documentation/security/landlock/user.rst
> @@ -0,0 +1,147 @@
> +================================
> +Landlock: userland documentation
> +================================
> +
> +Landlock programs
> +=================
> +
> +eBPF programs are used to create security programs.  They are contained and can
> +call only a whitelist of dedicated functions. Moreover, they can only loop
> +under strict conditions, which protects from denial of service.  More
> +information on BPF can be found in *Documentation/networking/filter.txt*.
> +
> +
> +Writing a program
> +-----------------
> +
> +To enforce a security policy, a thread first needs to create a Landlock program.
> +The easiest way to write an eBPF program depicting a security program is to write
> +it in the C language.  As described in *samples/bpf/README.rst*, LLVM can
> +compile such programs.  Files *samples/bpf/landlock1_kern.c* and those in
> +*tools/testing/selftests/landlock/* can be used as examples.
> +
> +Once the eBPF program is created, the next step is to create the metadata
> +describing the Landlock program.  This metadata includes an expected attach type which
> +contains the hook type to which the program is tied, and expected attach
> +triggers which identify the actions for which the program should be run.
> +
> +A hook is a policy decision point which exposes the same context type for
> +each program evaluation.
> +
> +A Landlock hook describes the kind of kernel object for which a program will be
> +triggered to allow or deny an action.  For example, the hook
> +BPF_LANDLOCK_FS_PICK can be triggered every time a landlocked thread performs a
> +set of action related to the filesystem (e.g. open, read, write, mount...).

          actions

> +This actions are identified by the `triggers` bitfield.
> +
> +The next step is to fill a :c:type:`struct bpf_load_program_attr
> +<bpf_load_program_attr>` with BPF_PROG_TYPE_LANDLOCK_HOOK, the expected attach
> +type and other BPF program metadata.  This bpf_attr must then be passed to the
> +:manpage:`bpf(2)` syscall alongside the BPF_PROG_LOAD command.  If everything
> +is deemed correct by the kernel, the thread gets a file descriptor referring to
> +this program.
> +
> +In the following code, the *insn* variable is an array of BPF instructions
> +which can be extracted from an ELF file as is done in bpf_load_file() from
> +*samples/bpf/bpf_load.c*.

A little confusing.  Is there a mixup of <insn> and <insns>?

> +
> +.. code-block:: c
> +
> +    int prog_fd;
> +    struct bpf_load_program_attr load_attr;
> +
> +    memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
> +    load_attr.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK;
> +    load_attr.expected_attach_type = BPF_LANDLOCK_FS_PICK;
> +    load_attr.expected_attach_triggers = LANDLOCK_TRIGGER_FS_PICK_OPEN;
> +    load_attr.insns = insns;
> +    load_attr.insns_cnt = sizeof(insn) / sizeof(struct bpf_insn);
> +    load_attr.license = "GPL";
> +
> +    prog_fd = bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz);
> +    if (prog_fd == -1)
> +        exit(1);
> +
> +
> +Enforcing a program
> +-------------------
> +
> +Once the Landlock program has been created or received (e.g. through a UNIX
> +socket), the thread willing to sandbox itself (and its future children) should
> +perform the following two steps.
> +
> +The thread should first request to never be allowed to get new privileges with a
> +call to :manpage:`prctl(2)` and the PR_SET_NO_NEW_PRIVS option.  More
> +information can be found in *Documentation/prctl/no_new_privs.txt*.
> +
> +.. code-block:: c
> +
> +    if (prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0))
> +        exit(1);
> +
> +A thread can apply a program to itself by using the :manpage:`seccomp(2)` syscall.
> +The operation is SECCOMP_PREPEND_LANDLOCK_PROG, the flags must be empty and the
> +*args* argument must point to a valid Landlock program file descriptor.
> +
> +.. code-block:: c
> +
> +    if (seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd))
> +        exit(1);
> +
> +If the syscall succeeds, the program is now enforced on the calling thread and
> +will be enforced on all its subsequently created children of the thread as
> +well.  Once a thread is landlocked, there is no way to remove this security
> +policy, only stacking more restrictions is allowed.  The program evaluation is
> +performed from the newest to the oldest.
> +
> +When a syscall ask for an action on a kernel object, if this action is denied,

                  asks

> +then an EACCES errno code is returned through the syscall.
> +
> +
> +.. _inherited_programs:
> +
> +Inherited programs
> +------------------
> +
> +Every new thread resulting from a :manpage:`clone(2)` inherits Landlock program
> +restrictions from its parent.  This is similar to the seccomp inheritance as
> +described in *Documentation/prctl/seccomp_filter.txt*.
> +
> +
> +Ptrace restrictions
> +-------------------
> +
> +A landlocked process has less privileges than a non-landlocked process and must
> +then be subject to additional restrictions when manipulating another process.
> +To be allowed to use :manpage:`ptrace(2)` and related syscalls on a target
> +process, a landlocked process must have a subset of the target process programs.
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Maybe that last statement is correct, but it seems to me that it is missing something.

> +
> +
> +Landlock structures and constants
> +=================================
> +
> +Hook types
> +----------
> +
> +.. kernel-doc:: include/uapi/linux/landlock.h
> +    :functions: landlock_hook_type
> +
> +
> +Contexts
> +--------
> +
> +.. kernel-doc:: include/uapi/linux/landlock.h
> +    :functions: landlock_ctx_fs_pick landlock_ctx_fs_walk landlock_ctx_fs_get
> +
> +
> +Triggers for fs_pick
> +--------------------
> +
> +.. kernel-doc:: include/uapi/linux/landlock.h
> +    :functions: landlock_triggers
> +
> +
> +Additional documentation
> +========================
> +
> +See https://landlock.io
> 


-- 
~Randy
