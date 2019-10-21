Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F76DE76B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 11:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfJUJJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 05:09:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36304 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfJUJJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 05:09:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id c22so2812032wmd.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 02:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TaQwTvK1evW8iznCOaX0Dx5Wt8VMsQDDFjYXritIreU=;
        b=fHu3EtiF9ruyRT3jfiurneHaLqLgnGEODGYo8hixbVfDhiLSggot8fXhEkA+slysAi
         bcOhQF8SyUdIv+zGGFslyo1W0IiqOENCe7WTumQjaJd/9hG8rJqR90KXql2d5tUG9KGN
         pLKgbavtSdDdlJ+aBNiBLoqhYXOPD/+Bkk/MM3ZkiUeRIZo/vv5i81oksMoeNrzehy0m
         fV2HOE+Gt6WI1LdMlESQ6YIw3WMyX5/uoARc2Z9HvRXbVCYCLm05Hv/6xo1ApZ3qGxC4
         wcALJgO9P19YZCuem/btHEnDdoMx2WM9wl9S8Wd/f0QJw7GLqOakrzqLK7++nwlklJR/
         f+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TaQwTvK1evW8iznCOaX0Dx5Wt8VMsQDDFjYXritIreU=;
        b=B0XL/+xkx9cCzR5sEP5JjdCkn/D7eZsyn26ZofGk06CGMoM4QYNFDHmqGqwvCi6of0
         HJk8w+4JJgbwpdPeVnf0tzETI+uJ443ZWEa1RpmkNOci93/ncw/M5hxB05LX0hWNf0T4
         4fgo8/j6RCtLUZmOdSJh2ougFEkK28Z84EwJ2YNcpH77xVnWvUSmlRFM3th05nzSNHBd
         02z+3Bq/R+W/cuz5G/zINCB02VQex7BT+5Cs7Y0980S3hxn6IfUxqmghIbT/ouzy7r1e
         RHl3kcbUvGRepAPRe6USgDNg62azKLPKHZO2U0i0G1B9pDNwybKXM6uAJa7BK7pjASXw
         VNOw==
X-Gm-Message-State: APjAAAUf2+vArG6mLBC04uu3CtAVcYw0otNKmN7w8NSF7veBbDFHVbKL
        xhn0LlT6NpJIGyZkHNFap+QchQ==
X-Google-Smtp-Source: APXvYqzXK0mgjXJQIUhVzFgoKoEQsengCMFXu9K2D5GRye/2Myg7oZjK70I7QIogVX8sjnHz2pmINA==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr18984261wml.142.1571648952625;
        Mon, 21 Oct 2019 02:09:12 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id u26sm15195771wrd.87.2019.10.21.02.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 02:09:11 -0700 (PDT)
Date:   Mon, 21 Oct 2019 10:09:09 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Joe Perches <joe@perches.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH] kernel: convert switch/case fallthrough
 comments to fallthrough;
Message-ID: <20191021090909.yjyed4qodjjcioqc@holly.lan>
References: <f31b38b9ad515a138edaecf85701b1e3db064114.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f31b38b9ad515a138edaecf85701b1e3db064114.camel@perches.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:35:08AM -0700, Joe Perches wrote:
> Use the new pseudo keyword "fallthrough;" and not the
> various /* fallthrough */ style comments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> This is a single patch for the kernel/ source tree,
> which would otherwise
> be sent through as separate
> patches to 19 maintainer sections.

For the kernel/debug/ files:

Acked-by: Daniel Thompson <daniel.thompson@linaro.org>

Will you be putting this in an immutable branch once you've collected
enough acks?

[TBH I don't actually expect any conflict between this and the pending
kgdb changes for this kernel cycle anyway...]


Daniel.


> 
> compilation tested only.
> 
> Done by the script in this email:
> https://lore.kernel.org/lkml/9fe980f7e28242c2835ffae34914c5f68e8268a7.camel@perches.com/
> 
>  kernel/auditfilter.c               | 2 +-
>  kernel/bpf/cgroup.c                | 4 ++--
>  kernel/bpf/verifier.c              | 4 ++--
>  kernel/capability.c                | 2 +-
>  kernel/compat.c                    | 6 +++---
>  kernel/debug/gdbstub.c             | 6 +++---
>  kernel/debug/kdb/kdb_keyboard.c    | 4 ++--
>  kernel/debug/kdb/kdb_support.c     | 6 +++---
>  kernel/events/core.c               | 3 +--
>  kernel/futex.c                     | 4 ++--
>  kernel/gcov/gcc_3_4.c              | 6 +++---
>  kernel/irq/handle.c                | 3 +--
>  kernel/irq/manage.c                | 5 ++---
>  kernel/kallsyms.c                  | 4 ++--
>  kernel/pid.c                       | 2 +-
>  kernel/power/hibernate.c           | 2 +-
>  kernel/power/qos.c                 | 4 ++--
>  kernel/printk/printk.c             | 2 +-
>  kernel/sched/core.c                | 2 +-
>  kernel/sched/topology.c            | 6 +++---
>  kernel/signal.c                    | 2 +-
>  kernel/sys.c                       | 3 +--
>  kernel/time/hrtimer.c              | 2 +-
>  kernel/time/posix-timers.c         | 4 ++--
>  kernel/time/tick-broadcast.c       | 2 +-
>  kernel/time/timer.c                | 2 +-
>  kernel/trace/blktrace.c            | 2 +-
>  kernel/trace/trace_events_filter.c | 4 ++--
>  28 files changed, 47 insertions(+), 51 deletions(-)
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index b0126e9c0743..471cd680479d 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -674,7 +674,7 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
>  				data->values[i] = AUDIT_UID_UNSET;
>  				break;
>  			}
> -			/* fall through - if set */
> +			fallthrough;	/* if set */
>  		default:
>  			data->values[i] = f->val;
>  		}
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index ddd8addcdb5c..955631f1b77d 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -797,7 +797,7 @@ cgroup_base_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  	case BPF_FUNC_trace_printk:
>  		if (capable(CAP_SYS_ADMIN))
>  			return bpf_get_trace_printk_proto();
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		return NULL;
>  	}
> @@ -1439,7 +1439,7 @@ static bool cg_sockopt_is_valid_access(int off, int size,
>  			return prog->expected_attach_type ==
>  				BPF_CGROUP_GETSOCKOPT;
>  		case offsetof(struct bpf_sockopt, optname):
> -			/* fallthrough */
> +			fallthrough;
>  		case offsetof(struct bpf_sockopt, level):
>  			if (size != size_default)
>  				return false;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ffc3e53f5300..d2b6fd8545e2 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2249,7 +2249,7 @@ static bool may_access_direct_pkt_data(struct bpf_verifier_env *env,
>  	case BPF_PROG_TYPE_CGROUP_SKB:
>  		if (t == BPF_WRITE)
>  			return false;
> -		/* fallthrough */
> +		fallthrough;
>  
>  	/* Program types with direct read + write access go here! */
>  	case BPF_PROG_TYPE_SCHED_CLS:
> @@ -4381,7 +4381,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
>  				off_reg == dst_reg ? dst : src);
>  			return -EACCES;
>  		}
> -		/* fall-through */
> +		fallthrough;
>  	default:
>  		break;
>  	}
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 1444f3954d75..7c59b096c98a 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -93,7 +93,7 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
>  		break;
>  	case _LINUX_CAPABILITY_VERSION_2:
>  		warn_deprecated_v2();
> -		/* fall through - v3 is otherwise equivalent to v2. */
> +		fallthrough;	/* v3 is otherwise equivalent to v2 */
>  	case _LINUX_CAPABILITY_VERSION_3:
>  		*tocopy = _LINUX_CAPABILITY_U32S_3;
>  		break;
> diff --git a/kernel/compat.c b/kernel/compat.c
> index a2bc1d6ceb57..d9c61f4317be 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -343,11 +343,11 @@ get_compat_sigset(sigset_t *set, const compat_sigset_t __user *compat)
>  		return -EFAULT;
>  	switch (_NSIG_WORDS) {
>  	case 4: set->sig[3] = v.sig[6] | (((long)v.sig[7]) << 32 );
> -		/* fall through */
> +		fallthrough;
>  	case 3: set->sig[2] = v.sig[4] | (((long)v.sig[5]) << 32 );
> -		/* fall through */
> +		fallthrough;
>  	case 2: set->sig[1] = v.sig[2] | (((long)v.sig[3]) << 32 );
> -		/* fall through */
> +		fallthrough;
>  	case 1: set->sig[0] = v.sig[0] | (((long)v.sig[1]) << 32 );
>  	}
>  #else
> diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
> index 4b280fc7dd67..b9d8b7248964 100644
> --- a/kernel/debug/gdbstub.c
> +++ b/kernel/debug/gdbstub.c
> @@ -1033,14 +1033,14 @@ int gdb_serial_stub(struct kgdb_state *ks)
>  				return DBG_PASS_EVENT;
>  			}
>  #endif
> -			/* Fall through */
> +			fallthrough;
>  		case 'C': /* Exception passing */
>  			tmp = gdb_cmd_exception_pass(ks);
>  			if (tmp > 0)
>  				goto default_handle;
>  			if (tmp == 0)
>  				break;
> -			/* Fall through - on tmp < 0 */
> +			fallthrough;	/* on tmp < 0 */
>  		case 'c': /* Continue packet */
>  		case 's': /* Single step packet */
>  			if (kgdb_contthread && kgdb_contthread != current) {
> @@ -1049,7 +1049,7 @@ int gdb_serial_stub(struct kgdb_state *ks)
>  				break;
>  			}
>  			dbg_activate_sw_breakpoints();
> -			/* Fall through - to default processing */
> +			fallthrough;	/* to default processing */
>  		default:
>  default_handle:
>  			error = kgdb_arch_handle_exception(ks->ex_vector,
> diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
> index 750497b0003a..f877a0a0d7cf 100644
> --- a/kernel/debug/kdb/kdb_keyboard.c
> +++ b/kernel/debug/kdb/kdb_keyboard.c
> @@ -173,11 +173,11 @@ int kdb_get_kbd_char(void)
>  	case KT_LATIN:
>  		if (isprint(keychar))
>  			break;		/* printable characters */
> -		/* fall through */
> +		fallthrough;
>  	case KT_SPEC:
>  		if (keychar == K_ENTER)
>  			break;
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		return -1;	/* ignore unprintables */
>  	}
> diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
> index b8e6306e7e13..d636506f695a 100644
> --- a/kernel/debug/kdb/kdb_support.c
> +++ b/kernel/debug/kdb/kdb_support.c
> @@ -432,7 +432,7 @@ int kdb_getphysword(unsigned long *word, unsigned long addr, size_t size)
>  				*word = w8;
>  			break;
>  		}
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		diag = KDB_BADWIDTH;
>  		kdb_printf("kdb_getphysword: bad width %ld\n", (long) size);
> @@ -481,7 +481,7 @@ int kdb_getword(unsigned long *word, unsigned long addr, size_t size)
>  				*word = w8;
>  			break;
>  		}
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		diag = KDB_BADWIDTH;
>  		kdb_printf("kdb_getword: bad width %ld\n", (long) size);
> @@ -525,7 +525,7 @@ int kdb_putword(unsigned long addr, unsigned long word, size_t size)
>  			diag = kdb_putarea(addr, w8);
>  			break;
>  		}
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		diag = KDB_BADWIDTH;
>  		kdb_printf("kdb_putword: bad width %ld\n", (long) size);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 9ec0b0bfddbd..04e75b1144c5 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -9361,8 +9361,7 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
>  		case IF_SRC_KERNELADDR:
>  		case IF_SRC_KERNEL:
>  			kernel = 1;
> -			/* fall through */
> -
> +			fallthrough;
>  		case IF_SRC_FILEADDR:
>  		case IF_SRC_FILE:
>  			if (state != IF_STATE_SOURCE)
> diff --git a/kernel/futex.c b/kernel/futex.c
> index bd18f60e4c6c..ab12b6229d2d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -3639,12 +3639,12 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>  	switch (cmd) {
>  	case FUTEX_WAIT:
>  		val3 = FUTEX_BITSET_MATCH_ANY;
> -		/* fall through */
> +		fallthrough;
>  	case FUTEX_WAIT_BITSET:
>  		return futex_wait(uaddr, flags, val, timeout, val3);
>  	case FUTEX_WAKE:
>  		val3 = FUTEX_BITSET_MATCH_ANY;
> -		/* fall through */
> +		fallthrough;
>  	case FUTEX_WAKE_BITSET:
>  		return futex_wake(uaddr, flags, val, val3);
>  	case FUTEX_REQUEUE:
> diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
> index 801ee4b0b969..32fc3278166f 100644
> --- a/kernel/gcov/gcc_3_4.c
> +++ b/kernel/gcov/gcc_3_4.c
> @@ -455,7 +455,7 @@ int gcov_iter_next(struct gcov_iterator *iter)
>  	case RECORD_COUNT:
>  		/* Advance to next count */
>  		iter->count++;
> -		/* fall through */
> +		fallthrough;
>  	case RECORD_COUNT_LEN:
>  		if (iter->count < get_func(iter)->n_ctrs[iter->type]) {
>  			iter->record = 9;
> @@ -465,7 +465,7 @@ int gcov_iter_next(struct gcov_iterator *iter)
>  		get_type(iter)->offset += iter->count;
>  		iter->count = 0;
>  		iter->type++;
> -		/* fall through */
> +		fallthrough;
>  	case RECORD_FUNCTION_CHECK:
>  		if (iter->type < iter->num_types) {
>  			iter->record = 7;
> @@ -474,7 +474,7 @@ int gcov_iter_next(struct gcov_iterator *iter)
>  		/* Advance to next function */
>  		iter->type = 0;
>  		iter->function++;
> -		/* fall through */
> +		fallthrough;
>  	case RECORD_TIME_STAMP:
>  		if (iter->function < iter->info->n_functions)
>  			iter->record = 3;
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index a4ace611f47f..b38d2fd70fe1 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -165,8 +165,7 @@ irqreturn_t __handle_irq_event_percpu(struct irq_desc *desc, unsigned int *flags
>  			}
>  
>  			__irq_wake_thread(desc, action);
> -
> -			/* Fall through - to add to randomness */
> +			fallthrough;	/* to add to randomness */
>  		case IRQ_HANDLED:
>  			*flags |= action->flags;
>  			break;
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 1753486b440c..baa86020f243 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -222,7 +222,7 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>  	case IRQ_SET_MASK_OK:
>  	case IRQ_SET_MASK_OK_DONE:
>  		cpumask_copy(desc->irq_common_data.affinity, mask);
> -		/* fall through */
> +		fallthrough;
>  	case IRQ_SET_MASK_OK_NOCOPY:
>  		irq_validate_effective_affinity(data);
>  		irq_set_thread_affinity(desc);
> @@ -792,8 +792,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned long flags)
>  	case IRQ_SET_MASK_OK_DONE:
>  		irqd_clear(&desc->irq_data, IRQD_TRIGGER_MASK);
>  		irqd_set(&desc->irq_data, flags);
> -		/* fall through */
> -
> +		fallthrough;
>  	case IRQ_SET_MASK_OK_NOCOPY:
>  		flags = irqd_get_trigger_type(&desc->irq_data);
>  		irq_settings_set_trigger_mask(desc, flags);
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 136ce049c4ad..05ce8a4d4729 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -651,11 +651,11 @@ int kallsyms_show_value(void)
>  	case 0:
>  		if (kallsyms_for_perf())
>  			return 1;
> -	/* fallthrough */
> +		fallthrough;
>  	case 1:
>  		if (has_capability_noaudit(current, CAP_SYSLOG))
>  			return 1;
> -	/* fallthrough */
> +		fallthrough;
>  	default:
>  		return 0;
>  	}
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 0a9f2e437217..b2a005a6dea1 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -144,7 +144,7 @@ void free_pid(struct pid *pid)
>  			/* Handle a fork failure of the first process */
>  			WARN_ON(ns->child_reaper);
>  			ns->pid_allocated = 0;
> -			/* fall through */
> +			fallthrough;
>  		case 0:
>  			schedule_work(&ns->proc_work);
>  			break;
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 3c0a5a8170b0..d091dcd57557 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -647,7 +647,7 @@ static void power_down(void)
>  		break;
>  	case HIBERNATION_PLATFORM:
>  		hibernation_platform_enter();
> -		/* Fall through */
> +		fallthrough;
>  	case HIBERNATION_SHUTDOWN:
>  		if (pm_power_off)
>  			kernel_power_off();
> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> index 9568a2fe7c11..6bf5295b2ade 100644
> --- a/kernel/power/qos.c
> +++ b/kernel/power/qos.c
> @@ -236,7 +236,7 @@ int pm_qos_update_target(struct pm_qos_constraints *c, struct plist_node *node,
>  		 * changed
>  		 */
>  		plist_del(node, &c->list);
> -		/* fall through */
> +		fallthrough;
>  	case PM_QOS_ADD_REQ:
>  		plist_node_init(node, new_value);
>  		plist_add(node, &c->list);
> @@ -309,7 +309,7 @@ bool pm_qos_update_flags(struct pm_qos_flags *pqf,
>  		break;
>  	case PM_QOS_UPDATE_REQ:
>  		pm_qos_flags_remove_req(pqf, req);
> -		/* fall through */
> +		fallthrough;
>  	case PM_QOS_ADD_REQ:
>  		req->flags = val;
>  		INIT_LIST_HEAD(&req->node);
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ca65327a6de8..6b3d7c68e6fe 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1531,7 +1531,7 @@ int do_syslog(int type, char __user *buf, int len, int source)
>  	/* Read/clear last kernel messages */
>  	case SYSLOG_ACTION_READ_CLEAR:
>  		clear = true;
> -		/* FALL THRU */
> +		fallthrough;
>  	/* Read last kernel messages */
>  	case SYSLOG_ACTION_READ_ALL:
>  		if (!buf || len < 0)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index dd05a378631a..050b728728f4 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2068,7 +2068,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>  				state = possible;
>  				break;
>  			}
> -			/* Fall-through */
> +			fallthrough;
>  		case possible:
>  			do_set_cpus_allowed(p, cpu_possible_mask);
>  			state = fail;
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index b5667a273bf6..7d6b84e0caca 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1224,13 +1224,13 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
>  	case sa_rootdomain:
>  		if (!atomic_read(&d->rd->refcount))
>  			free_rootdomain(&d->rd->rcu);
> -		/* Fall through */
> +		fallthrough;
>  	case sa_sd:
>  		free_percpu(d->sd);
> -		/* Fall through */
> +		fallthrough;
>  	case sa_sd_storage:
>  		__sdt_free(cpu_map);
> -		/* Fall through */
> +		fallthrough;
>  	case sa_none:
>  		break;
>  	}
> diff --git a/kernel/signal.c b/kernel/signal.c
> index c4da1ef56fdf..73bdcc1f2561 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -846,7 +846,7 @@ static int check_kill_permission(int sig, struct kernel_siginfo *info,
>  			 */
>  			if (!sid || sid == task_session(current))
>  				break;
> -			/* fall through */
> +			fallthrough;
>  		default:
>  			return -EPERM;
>  		}
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a611d1d58c7d..bad4f30e7f37 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1737,8 +1737,7 @@ void getrusage(struct task_struct *p, int who, struct rusage *r)
>  
>  		if (who == RUSAGE_CHILDREN)
>  			break;
> -		/* fall through */
> -
> +		fallthrough;
>  	case RUSAGE_SELF:
>  		thread_group_cputime_adjusted(p, &tgutime, &tgstime);
>  		utime += tgutime;
> diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
> index 0d4dc241c0fb..8060a35682e1 100644
> --- a/kernel/time/hrtimer.c
> +++ b/kernel/time/hrtimer.c
> @@ -373,7 +373,7 @@ static bool hrtimer_fixup_activate(void *addr, enum debug_obj_state state)
>  	switch (state) {
>  	case ODEBUG_STATE_ACTIVE:
>  		WARN_ON(1);
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		return false;
>  	}
> diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
> index 0ec5b7a1d769..6cc658391702 100644
> --- a/kernel/time/posix-timers.c
> +++ b/kernel/time/posix-timers.c
> @@ -413,12 +413,12 @@ static struct pid *good_sigevent(sigevent_t * event)
>  		rtn = pid_task(pid, PIDTYPE_PID);
>  		if (!rtn || !same_thread_group(rtn, current))
>  			return NULL;
> -		/* FALLTHRU */
> +		fallthrough;
>  	case SIGEV_SIGNAL:
>  	case SIGEV_THREAD:
>  		if (event->sigev_signo <= 0 || event->sigev_signo > SIGRTMAX)
>  			return NULL;
> -		/* FALLTHRU */
> +		fallthrough;
>  	case SIGEV_NONE:
>  		return pid;
>  	default:
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index e51778c312f1..36d7464c8962 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -381,7 +381,7 @@ void tick_broadcast_control(enum tick_broadcast_mode mode)
>  	switch (mode) {
>  	case TICK_BROADCAST_FORCE:
>  		tick_broadcast_forced = 1;
> -		/* fall through */
> +		fallthrough;
>  	case TICK_BROADCAST_ON:
>  		cpumask_set_cpu(cpu, tick_broadcast_on);
>  		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
> diff --git a/kernel/time/timer.c b/kernel/time/timer.c
> index 4820823515e9..6512d721ef57 100644
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -653,7 +653,7 @@ static bool timer_fixup_activate(void *addr, enum debug_obj_state state)
>  
>  	case ODEBUG_STATE_ACTIVE:
>  		WARN_ON(1);
> -		/* fall through */
> +		fallthrough;
>  	default:
>  		return false;
>  	}
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 2d6e93ab0478..0a1753dc69d3 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -717,7 +717,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
>  #endif
>  	case BLKTRACESTART:
>  		start = 1;
> -		/* fall through */
> +		fallthrough;
>  	case BLKTRACESTOP:
>  		ret = __blk_trace_startstop(q, start);
>  		break;
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index c9a74f82b14a..78b0bfc4d72e 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -499,7 +499,7 @@ predicate_parse(const char *str, int nr_parens, int nr_preds,
>  					ptr++;
>  					break;
>  				}
> -				/* fall through */
> +				fallthrough;
>  			default:
>  				parse_error(pe, FILT_ERR_TOO_MANY_PREDS,
>  					    next - str);
> @@ -1273,7 +1273,7 @@ static int parse_pred(const char *str, void *data,
>  		switch (op) {
>  		case OP_NE:
>  			pred->not = 1;
> -			/* Fall through */
> +			fallthrough;
>  		case OP_GLOB:
>  		case OP_EQ:
>  			break;
> 
> 
> 
> 
> _______________________________________________
> Kgdb-bugreport mailing list
> Kgdb-bugreport@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kgdb-bugreport
