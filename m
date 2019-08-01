Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EB67E0B4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbfHARDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:03:10 -0400
Received: from smtp-out.ssi.gouv.fr ([86.65.182.90]:55731 "EHLO
        smtp-out.ssi.gouv.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbfHARDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 13:03:09 -0400
Received: from smtp-out.ssi.gouv.fr (localhost [127.0.0.1])
        by smtp-out.ssi.gouv.fr (Postfix) with ESMTP id 2F34ED00072;
        Thu,  1 Aug 2019 19:03:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
        s=20160407; t=1564678995;
        bh=Vg8JcoezJVp7vjZmqa8C4nPWGAhydCSPAEaYJBtc760=;
        h=Subject:To:CC:References:From:Date:In-Reply-To:From:Subject;
        b=sm5QxRpgkicHUfKQgQmP3GEy/WpVeObfEpdX+jz3MtlgbtyUZh2KAL2aFrQU/mV5h
         79cnOm+sBzNXD/n0+M+QqqRucMoqDT2oiFlrL0Ureu3nxT87AQ2TiL7v16xYxBwZai
         diCFLCiu+FOPRGA4RiaKRA+VdpUefQdSbGCRe0y+eU8dv4YXtWenptJzX7QAJgpYvA
         vTzU7bTGktQ9G0BZGHJugv20X1YVi8YE5KeFtqszeJ7nQPHEYViTsE2AbcNxe4GMuS
         ZelKuMJhI7Yrqb6+ILZfQy10YqNh2HmwBo+ro0epkVpb1zl7+tcyyDYshbu2egnLzG
         v9fWRM03+ONng==
Subject: Re: [PATCH bpf-next v10 10/10] landlock: Add user and kernel
 documentation for Landlock
To:     Randy Dunlap <rdunlap@infradead.org>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <linux-kernel@vger.kernel.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
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
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        <kernel-hardening@lists.openwall.com>, <linux-api@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-11-mic@digikod.net>
 <88e90c22-1b78-c2f2-8823-fa776265361c@infradead.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Message-ID: <2ced8fc8-79a6-b0fb-70fe-6716fae92aa7@ssi.gouv.fr>
Date:   Thu, 1 Aug 2019 19:03:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:52.0) Gecko/20100101
 Thunderbird/52.9.0
MIME-Version: 1.0
In-Reply-To: <88e90c22-1b78-c2f2-8823-fa776265361c@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for this spelling fixes. Some comments:

On 31/07/2019 03:53, Randy Dunlap wrote:
> On 7/21/19 2:31 PM, Micka=C3=ABl Sala=C3=BCn wrote:
>> This documentation can be built with the Sphinx framework.
>>
>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> ---
>>
>> Changes since v9:
>> * update with expected attach type and expected attach triggers
>>
>> Changes since v8:
>> * remove documentation related to chaining and tagging according to this
>>   patch series
>>
>> Changes since v7:
>> * update documentation according to the Landlock revamp
>>
>> Changes since v6:
>> * add a check for ctx->event
>> * rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
>> * rename Landlock version to ABI to better reflect its purpose and add a
>>   dedicated changelog section
>> * update tables
>> * relax no_new_privs recommendations
>> * remove ABILITY_WRITE related functions
>> * reword rule "appending" to "prepending" and explain it
>> * cosmetic fixes
>>
>> Changes since v5:
>> * update the rule hierarchy inheritance explanation
>> * briefly explain ctx->arg2
>> * add ptrace restrictions
>> * explain EPERM
>> * update example (subtype)
>> * use ":manpage:"
>> ---
>>  Documentation/security/index.rst           |   1 +
>>  Documentation/security/landlock/index.rst  |  20 +++
>>  Documentation/security/landlock/kernel.rst |  99 ++++++++++++++
>>  Documentation/security/landlock/user.rst   | 147 +++++++++++++++++++++
>>  4 files changed, 267 insertions(+)
>>  create mode 100644 Documentation/security/landlock/index.rst
>>  create mode 100644 Documentation/security/landlock/kernel.rst
>>  create mode 100644 Documentation/security/landlock/user.rst
>
>
>> diff --git a/Documentation/security/landlock/kernel.rst b/Documentation/=
security/landlock/kernel.rst
>> new file mode 100644
>> index 000000000000..7d1e06d544bf
>> --- /dev/null
>> +++ b/Documentation/security/landlock/kernel.rst
>> @@ -0,0 +1,99 @@
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>> +Landlock: kernel documentation
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>> +
>> +eBPF properties
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +To get an expressive language while still being safe and small, Landloc=
k is
>> +based on eBPF. Landlock should be usable by untrusted processes and mus=
t
>> +therefore expose a minimal attack surface. The eBPF bytecode is minimal=
,
>> +powerful, widely used and designed to be used by untrusted applications=
. Thus,
>> +reusing the eBPF support in the kernel enables a generic approach while
>> +minimizing new code.
>> +
>> +An eBPF program has access to an eBPF context containing some fields us=
ed to
>> +inspect the current object. These arguments can be used directly (e.g. =
cookie)
>> +or passed to helper functions according to their types (e.g. inode poin=
ter). It
>> +is then possible to do complex access checks without race conditions or
>> +inconsistent evaluation (i.e.  `incorrect mirroring of the OS code and =
state
>> +<https://www.ndss-symposium.org/ndss2003/traps-and-pitfalls-practical-p=
roblems-system-call-interposition-based-security-tools/>`_).
>> +
>> +A Landlock hook describes a particular access type.  For now, there is =
two
>
>                                                                  there ar=
e two
>
>> +hooks dedicated to filesystem related operations: LANDLOCK_HOOK_FS_PICK=
 and
>> +LANDLOCK_HOOK_FS_WALK.  A Landlock program is tied to one hook.  This m=
akes it
>> +possible to statically check context accesses, potentially performed by=
 such
>> +program, and hence prevents kernel address leaks and ensure the right u=
se of
>
>                                                         ensures
>
>> +hook arguments with eBPF functions.  Any user can add multiple Landlock
>> +programs per Landlock hook.  They are stacked and evaluated one after t=
he
>> +other, starting from the most recent program, as seccomp-bpf does with =
its
>> +filters.  Underneath, a hook is an abstraction over a set of LSM hooks.
>> +
>> +
>> +Guiding principles
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Unprivileged use
>> +----------------
>> +
>> +* Landlock helpers and context should be usable by any unprivileged and
>> +  untrusted program while following the system security policy enforced=
 by
>> +  other access control mechanisms (e.g. DAC, LSM).
>> +
>> +
>> +Landlock hook and context
>> +-------------------------
>> +
>> +* A Landlock hook shall be focused on access control on kernel objects =
instead
>> +  of syscall filtering (i.e. syscall arguments), which is the purpose o=
f
>> +  seccomp-bpf.
>> +* A Landlock context provided by a hook shall express the minimal and m=
ore
>> +  generic interface to control an access for a kernel object.
>> +* A hook shall guaranty that all the BPF function calls from a program =
are> +  safe.  Thus, the related Landlock context arguments shall always be=
 of the
>> +  same type for a particular hook.  For example, a network hook could s=
hare
>> +  helpers with a file hook because of UNIX socket.  However, the same h=
elpers
>> +  may not be compatible for a file system handle and a net handle.
>> +* Multiple hooks may use the same context interface.
>> +
>> +
>> +Landlock helpers
>> +----------------
>> +
>> +* Landlock helpers shall be as generic as possible while at the same ti=
me being
>> +  as simple as possible and following the syscall creation principles (=
cf.
>> +  *Documentation/adding-syscalls.txt*).
>> +* The only behavior change allowed on a helper is to fix a (logical) bu=
g to
>> +  match the initial semantic.
>> +* Helpers shall be reentrant, i.e. only take inputs from arguments (e.g=
. from
>> +  the BPF context), to enable a hook to use a cache.  Future program op=
tions
>> +  might change this cache behavior.
>> +* It is quite easy to add new helpers to extend Landlock.  The main con=
cern
>> +  should be about the possibility to leak information from the kernel t=
hat may
>> +  not be accessible otherwise (i.e. side-channel attack).
>> +
>> +
>> +Questions and answers
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Why not create a custom hook for each kind of action?
>> +-----------------------------------------------------
>> +
>> +Landlock programs can handle these checks.  Adding more exceptions to t=
he
>> +kernel code would lead to more code complexity.  A decision to ignore a=
 kind of
>> +action can and should be done at the beginning of a Landlock program.
>> +
>> +
>> +Why a program does not return an errno or a kill code?
>> +------------------------------------------------------
>> +
>> +seccomp filters can return multiple kind of code, including an errno va=
lue or a
>
>                                        kinds
>
>> +kill signal, which may be convenient for access control.  Those return =
codes
>> +are hardwired in the userland ABI.  Instead, Landlock's approach is to =
return a
>> +boolean to allow or deny an action, which is much simpler and more gene=
ric.
>> +Moreover, we do not really have a choice because, unlike to seccomp, La=
ndlock
>> +programs are not enforced at the syscall entry point but may be execute=
d at any
>> +point in the kernel (through LSM hooks) where an errno return code may =
not make
>> +sense.  However, with this simple ABI and with the ability to call help=
ers,
>> +Landlock may gain features similar to seccomp-bpf in the future while b=
eing
>> +compatible with previous programs.
>> diff --git a/Documentation/security/landlock/user.rst b/Documentation/se=
curity/landlock/user.rst
>> new file mode 100644
>> index 000000000000..14c4f3b377bd
>> --- /dev/null
>> +++ b/Documentation/security/landlock/user.rst
>> @@ -0,0 +1,147 @@
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +Landlock: userland documentation
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Landlock programs
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +eBPF programs are used to create security programs.  They are contained=
 and can
>> +call only a whitelist of dedicated functions. Moreover, they can only l=
oop
>> +under strict conditions, which protects from denial of service.  More
>> +information on BPF can be found in *Documentation/networking/filter.txt=
*.
>> +
>> +
>> +Writing a program
>> +-----------------
>> +
>> +To enforce a security policy, a thread first needs to create a Landlock=
 program.
>> +The easiest way to write an eBPF program depicting a security program i=
s to write
>> +it in the C language.  As described in *samples/bpf/README.rst*, LLVM c=
an
>> +compile such programs.  Files *samples/bpf/landlock1_kern.c* and those =
in
>> +*tools/testing/selftests/landlock/* can be used as examples.
>> +
>> +Once the eBPF program is created, the next step is to create the metada=
ta
>> +describing the Landlock program.  This metadata includes an expected at=
tach type which
>> +contains the hook type to which the program is tied, and expected attac=
h
>> +triggers which identify the actions for which the program should be run=
.
>> +
>> +A hook is a policy decision point which exposes the same context type f=
or
>> +each program evaluation.
>> +
>> +A Landlock hook describes the kind of kernel object for which a program=
 will be
>> +triggered to allow or deny an action.  For example, the hook
>> +BPF_LANDLOCK_FS_PICK can be triggered every time a landlocked thread pe=
rforms a
>> +set of action related to the filesystem (e.g. open, read, write, mount.=
..).
>
>           actions
>
>> +This actions are identified by the `triggers` bitfield.
>> +
>> +The next step is to fill a :c:type:`struct bpf_load_program_attr
>> +<bpf_load_program_attr>` with BPF_PROG_TYPE_LANDLOCK_HOOK, the expected=
 attach
>> +type and other BPF program metadata.  This bpf_attr must then be passed=
 to the
>> +:manpage:`bpf(2)` syscall alongside the BPF_PROG_LOAD command.  If ever=
ything
>> +is deemed correct by the kernel, the thread gets a file descriptor refe=
rring to
>> +this program.
>> +
>> +In the following code, the *insn* variable is an array of BPF instructi=
ons
>> +which can be extracted from an ELF file as is done in bpf_load_file() f=
rom
>> +*samples/bpf/bpf_load.c*.
>
> A little confusing.  Is there a mixup of <insn> and <insns>?

Indeed, a typo was inserted with a rewrite of this part.

>
>> +
>> +.. code-block:: c
>> +
>> +    int prog_fd;
>> +    struct bpf_load_program_attr load_attr;
>> +
>> +    memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
>> +    load_attr.prog_type =3D BPF_PROG_TYPE_LANDLOCK_HOOK;
>> +    load_attr.expected_attach_type =3D BPF_LANDLOCK_FS_PICK;
>> +    load_attr.expected_attach_triggers =3D LANDLOCK_TRIGGER_FS_PICK_OPE=
N;
>> +    load_attr.insns =3D insns;
>> +    load_attr.insns_cnt =3D sizeof(insn) / sizeof(struct bpf_insn);
>> +    load_attr.license =3D "GPL";
>> +
>> +    prog_fd =3D bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz)=
;
>> +    if (prog_fd =3D=3D -1)
>> +        exit(1);
>> +
>> +
>> +Enforcing a program
>> +-------------------
>> +
>> +Once the Landlock program has been created or received (e.g. through a =
UNIX
>> +socket), the thread willing to sandbox itself (and its future children)=
 should
>> +perform the following two steps.
>> +
>> +The thread should first request to never be allowed to get new privileg=
es with a
>> +call to :manpage:`prctl(2)` and the PR_SET_NO_NEW_PRIVS option.  More
>> +information can be found in *Documentation/prctl/no_new_privs.txt*.
>> +
>> +.. code-block:: c
>> +
>> +    if (prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0))
>> +        exit(1);
>> +
>> +A thread can apply a program to itself by using the :manpage:`seccomp(2=
)` syscall.
>> +The operation is SECCOMP_PREPEND_LANDLOCK_PROG, the flags must be empty=
 and the
>> +*args* argument must point to a valid Landlock program file descriptor.
>> +
>> +.. code-block:: c
>> +
>> +    if (seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd))
>> +        exit(1);
>> +
>> +If the syscall succeeds, the program is now enforced on the calling thr=
ead and
>> +will be enforced on all its subsequently created children of the thread=
 as
>> +well.  Once a thread is landlocked, there is no way to remove this secu=
rity
>> +policy, only stacking more restrictions is allowed.  The program evalua=
tion is
>> +performed from the newest to the oldest.
>> +
>> +When a syscall ask for an action on a kernel object, if this action is =
denied,
>
>                   asks
>
>> +then an EACCES errno code is returned through the syscall.
>> +
>> +
>> +.. _inherited_programs:
>> +
>> +Inherited programs
>> +------------------
>> +
>> +Every new thread resulting from a :manpage:`clone(2)` inherits Landlock=
 program
>> +restrictions from its parent.  This is similar to the seccomp inheritan=
ce as
>> +described in *Documentation/prctl/seccomp_filter.txt*.
>> +
>> +
>> +Ptrace restrictions
>> +-------------------
>> +
>> +A landlocked process has less privileges than a non-landlocked process =
and must
>> +then be subject to additional restrictions when manipulating another pr=
ocess.
>> +To be allowed to use :manpage:`ptrace(2)` and related syscalls on a tar=
get
>> +process, a landlocked process must have a subset of the target process =
programs.
>             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
> Maybe that last statement is correct, but it seems to me that it is missi=
ng something.

What about this:

To be allowed to trace a process (using :manpage:`ptrace(2)`), a
landlocked tracer process must only be constrained by a subset (possibly
empty) of the Landlock programs which are also applied to the tracee.
This ensure that the tracer has less or the same constraints than the
tracee, hence protecting against privilege escalation.

>
>> +
>> +
>> +Landlock structures and constants
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Hook types
>> +----------
>> +
>> +.. kernel-doc:: include/uapi/linux/landlock.h
>> +    :functions: landlock_hook_type
>> +
>> +
>> +Contexts
>> +--------
>> +
>> +.. kernel-doc:: include/uapi/linux/landlock.h
>> +    :functions: landlock_ctx_fs_pick landlock_ctx_fs_walk landlock_ctx_=
fs_get
>> +
>> +
>> +Triggers for fs_pick
>> +--------------------
>> +
>> +.. kernel-doc:: include/uapi/linux/landlock.h
>> +    :functions: landlock_triggers
>> +
>> +
>> +Additional documentation
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> +
>> +See https://landlock.io
>>
>
>

--
Micka=C3=ABl Sala=C3=BCn
ANSSI/SDE/ST/LAM

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
