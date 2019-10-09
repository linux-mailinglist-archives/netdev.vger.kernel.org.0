Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1BED0515
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 03:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfJIBOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 21:14:44 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35540 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIBOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 21:14:44 -0400
Received: by mail-qk1-f196.google.com with SMTP id w2so736699qkf.2;
        Tue, 08 Oct 2019 18:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pAh3dCwN814R9d8yP8na2TLCmx/jtyTwBwu6AfD2QGk=;
        b=PpsfHXJ0ikVcgbtKF2H3Wk58954d8u7duAdaEz9i3rDfzRF3UyOoLS4BeHTuubrloA
         qORqaajfnbv7S65z3ecfEAukwCY2vugCocbIJDMq9mE0Uua8RQOh6uu8gnOlS8nLjobl
         R/Ua5SREcT7E7Yxp8Up/qABPOxXUFzmOcTnD9YsbJFZd9iwwUzsgIqruzyUwALWGKS9p
         hqkJZUut7IfXOPBWE/sUKxhFtS1InSOGKQCYiEvu5w68mja2tmbx8xczFF/mXc3sfpn8
         VGGPfvahcuHOhzxxwZWxeHCTJ/38JS44LzHdP+eRO/uTUsvfTvI1lxRbfV1O+aHpj8NS
         gXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pAh3dCwN814R9d8yP8na2TLCmx/jtyTwBwu6AfD2QGk=;
        b=UBkKSUIooPOHBsw2TxkLaYDDMNXAOjEP+UGAW8tilRPqYBgiDFJUAtVgiw+3cCWyUB
         KRUO7dxqfIS5kvginqXhvgU3PGFs8pORdontM2W7yesbddtvB3x5zKs0/7iqIIN4fJ5u
         7CIdJtJfeSEnTArsowzzlROmmn2/1n04dBx5NeGu3LMJD7FHcMy6gjPX56vT8xF7vUcq
         9KlUx/oU9wiYTvJ8Rj2zaCYpHF4y8wK+9jVMsGNHsDUQ+qdQIQFcrDZ36RONbYgvlNHJ
         F27cKA9Jz8NZ6aIjV49jdYSqn7VSTCDLOnlpU60F93qkUJdHruh3cOKC7ETty0kH+CFF
         oZuQ==
X-Gm-Message-State: APjAAAUjmItyKP53eC+MmBOhMjIcLV0qwuKloUt973bOkOlf1jwfA2xQ
        q16mQjI3MS7ATepGDV8dK+VC5UfwWL29fOfZzPo=
X-Google-Smtp-Source: APXvYqxMbeBf3URlr5KlAckzKmNqiBB2STm/cqZ9dOk4okfkY4IVNlYKCe1o1MeGzpQo7dWvn9nJlhVrcP3fpn47h7c=
X-Received: by 2002:a05:620a:1355:: with SMTP id c21mr1230857qkl.288.1570583680990;
 Tue, 08 Oct 2019 18:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
In-Reply-To: <1568909380-32199-1-git-send-email-cai@lca.pw>
From:   Yuyang Du <duyuyang@gmail.com>
Date:   Wed, 9 Oct 2019 09:14:29 +0800
Message-ID: <CAHttsrbtLqWxwu_3aNObKNeOd1E4X_eRssH59JTDkQ_+t3jVBA@mail.gmail.com>
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
To:     Qian Cai <cai@lca.pw>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        jslaby@suse.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org,
        tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        tj@kernel.org, mark@fasheh.com, jlbec@evilplan.or,
        joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com,
        davem@davemloft.net, st@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, alexander.levin@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I didn't have the guts to do this, and I am glad you did it :)

Yuyang

On Fri, 20 Sep 2019 at 00:10, Qian Cai <cai@lca.pw> wrote:
>
> Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> in __lock_release"), @nested is no longer used in lock_release(), so
> remove it from all lock_release() calls and friends.
>
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  drivers/gpu/drm/drm_connector.c               |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |  6 +++---
>  drivers/gpu/drm/i915/gt/intel_engine_pm.c     |  2 +-
>  drivers/gpu/drm/i915/i915_request.c           |  2 +-
>  drivers/tty/tty_ldsem.c                       |  8 ++++----
>  fs/dcache.c                                   |  2 +-
>  fs/jbd2/transaction.c                         |  4 ++--
>  fs/kernfs/dir.c                               |  4 ++--
>  fs/ocfs2/dlmglue.c                            |  2 +-
>  include/linux/jbd2.h                          |  2 +-
>  include/linux/lockdep.h                       | 21 ++++++++++-----------
>  include/linux/percpu-rwsem.h                  |  4 ++--
>  include/linux/rcupdate.h                      |  2 +-
>  include/linux/rwlock_api_smp.h                | 16 ++++++++--------
>  include/linux/seqlock.h                       |  4 ++--
>  include/linux/spinlock_api_smp.h              |  8 ++++----
>  include/linux/ww_mutex.h                      |  2 +-
>  include/net/sock.h                            |  2 +-
>  kernel/bpf/stackmap.c                         |  2 +-
>  kernel/cpu.c                                  |  2 +-
>  kernel/locking/lockdep.c                      |  3 +--
>  kernel/locking/mutex.c                        |  4 ++--
>  kernel/locking/rtmutex.c                      |  6 +++---
>  kernel/locking/rwsem.c                        | 10 +++++-----
>  kernel/printk/printk.c                        | 10 +++++-----
>  kernel/sched/core.c                           |  2 +-
>  lib/locking-selftest.c                        | 24 ++++++++++++------------
>  mm/memcontrol.c                               |  2 +-
>  net/core/sock.c                               |  2 +-
>  tools/lib/lockdep/include/liblockdep/common.h |  3 +--
>  tools/lib/lockdep/include/liblockdep/mutex.h  |  2 +-
>  tools/lib/lockdep/include/liblockdep/rwlock.h |  2 +-
>  tools/lib/lockdep/preload.c                   | 16 ++++++++--------
>  33 files changed, 90 insertions(+), 93 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
> index 4c766624b20d..4a8b2e5c2af6 100644
> --- a/drivers/gpu/drm/drm_connector.c
> +++ b/drivers/gpu/drm/drm_connector.c
> @@ -719,7 +719,7 @@ void drm_connector_list_iter_end(struct drm_connector_list_iter *iter)
>                 __drm_connector_put_safe(iter->conn);
>                 spin_unlock_irqrestore(&config->connector_list_lock, flags);
>         }
> -       lock_release(&connector_list_iter_dep_map, 0, _RET_IP_);
> +       lock_release(&connector_list_iter_dep_map, _RET_IP_);
>  }
>  EXPORT_SYMBOL(drm_connector_list_iter_end);
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> index edd21d14e64f..1a51b3598d63 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> @@ -509,14 +509,14 @@ void i915_gem_shrinker_taints_mutex(struct drm_i915_private *i915,
>                       I915_MM_SHRINKER, 0, _RET_IP_);
>
>         mutex_acquire(&mutex->dep_map, 0, 0, _RET_IP_);
> -       mutex_release(&mutex->dep_map, 0, _RET_IP_);
> +       mutex_release(&mutex->dep_map, _RET_IP_);
>
> -       mutex_release(&i915->drm.struct_mutex.dep_map, 0, _RET_IP_);
> +       mutex_release(&i915->drm.struct_mutex.dep_map, _RET_IP_);
>
>         fs_reclaim_release(GFP_KERNEL);
>
>         if (unlock)
> -               mutex_release(&i915->drm.struct_mutex.dep_map, 0, _RET_IP_);
> +               mutex_release(&i915->drm.struct_mutex.dep_map, _RET_IP_);
>  }
>
>  #define obj_to_i915(obj__) to_i915((obj__)->base.dev)
> diff --git a/drivers/gpu/drm/i915/gt/intel_engine_pm.c b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
> index 65b5ca74b394..7f647243b3b9 100644
> --- a/drivers/gpu/drm/i915/gt/intel_engine_pm.c
> +++ b/drivers/gpu/drm/i915/gt/intel_engine_pm.c
> @@ -52,7 +52,7 @@ static inline unsigned long __timeline_mark_lock(struct intel_context *ce)
>  static inline void __timeline_mark_unlock(struct intel_context *ce,
>                                           unsigned long flags)
>  {
> -       mutex_release(&ce->timeline->mutex.dep_map, 0, _THIS_IP_);
> +       mutex_release(&ce->timeline->mutex.dep_map, _THIS_IP_);
>         local_irq_restore(flags);
>  }
>
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index a53777dd371c..e1f1be4d0531 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1456,7 +1456,7 @@ long i915_request_wait(struct i915_request *rq,
>         dma_fence_remove_callback(&rq->fence, &wait.cb);
>
>  out:
> -       mutex_release(&rq->engine->gt->reset.mutex.dep_map, 0, _THIS_IP_);
> +       mutex_release(&rq->engine->gt->reset.mutex.dep_map, _THIS_IP_);
>         trace_i915_request_wait_end(rq);
>         return timeout;
>  }
> diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
> index 60ff236a3d63..ce8291053af3 100644
> --- a/drivers/tty/tty_ldsem.c
> +++ b/drivers/tty/tty_ldsem.c
> @@ -303,7 +303,7 @@ static int __ldsem_down_read_nested(struct ld_semaphore *sem,
>         if (count <= 0) {
>                 lock_contended(&sem->dep_map, _RET_IP_);
>                 if (!down_read_failed(sem, count, timeout)) {
> -                       rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +                       rwsem_release(&sem->dep_map, _RET_IP_);
>                         return 0;
>                 }
>         }
> @@ -322,7 +322,7 @@ static int __ldsem_down_write_nested(struct ld_semaphore *sem,
>         if ((count & LDSEM_ACTIVE_MASK) != LDSEM_ACTIVE_BIAS) {
>                 lock_contended(&sem->dep_map, _RET_IP_);
>                 if (!down_write_failed(sem, count, timeout)) {
> -                       rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +                       rwsem_release(&sem->dep_map, _RET_IP_);
>                         return 0;
>                 }
>         }
> @@ -390,7 +390,7 @@ void ldsem_up_read(struct ld_semaphore *sem)
>  {
>         long count;
>
> -       rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +       rwsem_release(&sem->dep_map, _RET_IP_);
>
>         count = atomic_long_add_return(-LDSEM_READ_BIAS, &sem->count);
>         if (count < 0 && (count & LDSEM_ACTIVE_MASK) == 0)
> @@ -404,7 +404,7 @@ void ldsem_up_write(struct ld_semaphore *sem)
>  {
>         long count;
>
> -       rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +       rwsem_release(&sem->dep_map, _RET_IP_);
>
>         count = atomic_long_add_return(-LDSEM_WRITE_BIAS, &sem->count);
>         if (count < 0)
> diff --git a/fs/dcache.c b/fs/dcache.c
> index e88cf0554e65..f7931b682a0d 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1319,7 +1319,7 @@ static void d_walk(struct dentry *parent, void *data,
>
>                 if (!list_empty(&dentry->d_subdirs)) {
>                         spin_unlock(&this_parent->d_lock);
> -                       spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
> +                       spin_release(&dentry->d_lock.dep_map, _RET_IP_);
>                         this_parent = dentry;
>                         spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
>                         goto repeat;
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index bee8498d7792..b25ebdcabfa3 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -713,7 +713,7 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, gfp_t gfp_mask)
>         if (need_to_start)
>                 jbd2_log_start_commit(journal, tid);
>
> -       rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
> +       rwsem_release(&journal->j_trans_commit_map, _THIS_IP_);
>         handle->h_buffer_credits = nblocks;
>         /*
>          * Restore the original nofs context because the journal restart
> @@ -1848,7 +1848,7 @@ int jbd2_journal_stop(handle_t *handle)
>                         wake_up(&journal->j_wait_transaction_locked);
>         }
>
> -       rwsem_release(&journal->j_trans_commit_map, 1, _THIS_IP_);
> +       rwsem_release(&journal->j_trans_commit_map, _THIS_IP_);
>
>         if (wait_for_commit)
>                 err = jbd2_log_wait_commit(journal, tid);
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index 6ebae6bbe6a5..c45b82feac9a 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -438,7 +438,7 @@ void kernfs_put_active(struct kernfs_node *kn)
>                 return;
>
>         if (kernfs_lockdep(kn))
> -               rwsem_release(&kn->dep_map, 1, _RET_IP_);
> +               rwsem_release(&kn->dep_map, _RET_IP_);
>         v = atomic_dec_return(&kn->active);
>         if (likely(v != KN_DEACTIVATED_BIAS))
>                 return;
> @@ -476,7 +476,7 @@ static void kernfs_drain(struct kernfs_node *kn)
>
>         if (kernfs_lockdep(kn)) {
>                 lock_acquired(&kn->dep_map, _RET_IP_);
> -               rwsem_release(&kn->dep_map, 1, _RET_IP_);
> +               rwsem_release(&kn->dep_map, _RET_IP_);
>         }
>
>         kernfs_drain_open_files(kn);
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index ad594fef2ab0..71975b9b142c 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1687,7 +1687,7 @@ static void __ocfs2_cluster_unlock(struct ocfs2_super *osb,
>         spin_unlock_irqrestore(&lockres->l_lock, flags);
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         if (lockres->l_lockdep_map.key != NULL)
> -               rwsem_release(&lockres->l_lockdep_map, 1, caller_ip);
> +               rwsem_release(&lockres->l_lockdep_map, caller_ip);
>  #endif
>  }
>
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 603fbc4e2f70..564793c24d12 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -1170,7 +1170,7 @@ struct journal_s
>  #define jbd2_might_wait_for_commit(j) \
>         do { \
>                 rwsem_acquire(&j->j_trans_commit_map, 0, 0, _THIS_IP_); \
> -               rwsem_release(&j->j_trans_commit_map, 1, _THIS_IP_); \
> +               rwsem_release(&j->j_trans_commit_map, _THIS_IP_); \
>         } while (0)
>
>  /* journal feature predicate functions */
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index b8a835fd611b..c50d01ef1414 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -349,8 +349,7 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>                          int trylock, int read, int check,
>                          struct lockdep_map *nest_lock, unsigned long ip);
>
> -extern void lock_release(struct lockdep_map *lock, int nested,
> -                        unsigned long ip);
> +extern void lock_release(struct lockdep_map *lock, unsigned long ip);
>
>  /*
>   * Same "read" as for lock_acquire(), except -1 means any.
> @@ -428,7 +427,7 @@ static inline void lockdep_set_selftest_task(struct task_struct *task)
>  }
>
>  # define lock_acquire(l, s, t, r, c, n, i)     do { } while (0)
> -# define lock_release(l, n, i)                 do { } while (0)
> +# define lock_release(l, i)                    do { } while (0)
>  # define lock_downgrade(l, i)                  do { } while (0)
>  # define lock_set_class(l, n, k, s, i)         do { } while (0)
>  # define lock_set_subclass(l, s, i)            do { } while (0)
> @@ -591,42 +590,42 @@ static inline void print_irqtrace_events(struct task_struct *curr)
>
>  #define spin_acquire(l, s, t, i)               lock_acquire_exclusive(l, s, t, NULL, i)
>  #define spin_acquire_nest(l, s, t, n, i)       lock_acquire_exclusive(l, s, t, n, i)
> -#define spin_release(l, n, i)                  lock_release(l, n, i)
> +#define spin_release(l, i)                     lock_release(l, i)
>
>  #define rwlock_acquire(l, s, t, i)             lock_acquire_exclusive(l, s, t, NULL, i)
>  #define rwlock_acquire_read(l, s, t, i)                lock_acquire_shared_recursive(l, s, t, NULL, i)
> -#define rwlock_release(l, n, i)                        lock_release(l, n, i)
> +#define rwlock_release(l, i)                   lock_release(l, i)
>
>  #define seqcount_acquire(l, s, t, i)           lock_acquire_exclusive(l, s, t, NULL, i)
>  #define seqcount_acquire_read(l, s, t, i)      lock_acquire_shared_recursive(l, s, t, NULL, i)
> -#define seqcount_release(l, n, i)              lock_release(l, n, i)
> +#define seqcount_release(l, i)                 lock_release(l, i)
>
>  #define mutex_acquire(l, s, t, i)              lock_acquire_exclusive(l, s, t, NULL, i)
>  #define mutex_acquire_nest(l, s, t, n, i)      lock_acquire_exclusive(l, s, t, n, i)
> -#define mutex_release(l, n, i)                 lock_release(l, n, i)
> +#define mutex_release(l, i)                    lock_release(l, i)
>
>  #define rwsem_acquire(l, s, t, i)              lock_acquire_exclusive(l, s, t, NULL, i)
>  #define rwsem_acquire_nest(l, s, t, n, i)      lock_acquire_exclusive(l, s, t, n, i)
>  #define rwsem_acquire_read(l, s, t, i)         lock_acquire_shared(l, s, t, NULL, i)
> -#define rwsem_release(l, n, i)                 lock_release(l, n, i)
> +#define rwsem_release(l, i)                    lock_release(l, i)
>
>  #define lock_map_acquire(l)                    lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
>  #define lock_map_acquire_read(l)               lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
>  #define lock_map_acquire_tryread(l)            lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
> -#define lock_map_release(l)                    lock_release(l, 1, _THIS_IP_)
> +#define lock_map_release(l)                    lock_release(l, _THIS_IP_)
>
>  #ifdef CONFIG_PROVE_LOCKING
>  # define might_lock(lock)                                              \
>  do {                                                                   \
>         typecheck(struct lockdep_map *, &(lock)->dep_map);              \
>         lock_acquire(&(lock)->dep_map, 0, 0, 0, 1, NULL, _THIS_IP_);    \
> -       lock_release(&(lock)->dep_map, 0, _THIS_IP_);                   \
> +       lock_release(&(lock)->dep_map, _THIS_IP_);                      \
>  } while (0)
>  # define might_lock_read(lock)                                                 \
>  do {                                                                   \
>         typecheck(struct lockdep_map *, &(lock)->dep_map);              \
>         lock_acquire(&(lock)->dep_map, 0, 0, 1, 1, NULL, _THIS_IP_);    \
> -       lock_release(&(lock)->dep_map, 0, _THIS_IP_);                   \
> +       lock_release(&(lock)->dep_map, _THIS_IP_);                      \
>  } while (0)
>
>  #define lockdep_assert_irqs_enabled()  do {                            \
> diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> index 3998cdf9cd14..ad2ca2a89d5b 100644
> --- a/include/linux/percpu-rwsem.h
> +++ b/include/linux/percpu-rwsem.h
> @@ -93,7 +93,7 @@ static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
>                 __percpu_up_read(sem); /* Unconditional memory barrier */
>         preempt_enable();
>
> -       rwsem_release(&sem->rw_sem.dep_map, 1, _RET_IP_);
> +       rwsem_release(&sem->rw_sem.dep_map, _RET_IP_);
>  }
>
>  extern void percpu_down_write(struct percpu_rw_semaphore *);
> @@ -118,7 +118,7 @@ extern int __percpu_init_rwsem(struct percpu_rw_semaphore *,
>  static inline void percpu_rwsem_release(struct percpu_rw_semaphore *sem,
>                                         bool read, unsigned long ip)
>  {
> -       lock_release(&sem->rw_sem.dep_map, 1, ip);
> +       lock_release(&sem->rw_sem.dep_map, ip);
>  #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
>         if (!read)
>                 atomic_long_set(&sem->rw_sem.owner, RWSEM_OWNER_UNKNOWN);
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 75a2eded7aa2..269b31eab3d6 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -210,7 +210,7 @@ static inline void rcu_lock_acquire(struct lockdep_map *map)
>
>  static inline void rcu_lock_release(struct lockdep_map *map)
>  {
> -       lock_release(map, 1, _THIS_IP_);
> +       lock_release(map, _THIS_IP_);
>  }
>
>  extern struct lockdep_map rcu_lock_map;
> diff --git a/include/linux/rwlock_api_smp.h b/include/linux/rwlock_api_smp.h
> index 86ebb4bf9c6e..abfb53ab11be 100644
> --- a/include/linux/rwlock_api_smp.h
> +++ b/include/linux/rwlock_api_smp.h
> @@ -215,14 +215,14 @@ static inline void __raw_write_lock(rwlock_t *lock)
>
>  static inline void __raw_write_unlock(rwlock_t *lock)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_write_unlock(lock);
>         preempt_enable();
>  }
>
>  static inline void __raw_read_unlock(rwlock_t *lock)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_read_unlock(lock);
>         preempt_enable();
>  }
> @@ -230,7 +230,7 @@ static inline void __raw_read_unlock(rwlock_t *lock)
>  static inline void
>  __raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_read_unlock(lock);
>         local_irq_restore(flags);
>         preempt_enable();
> @@ -238,7 +238,7 @@ static inline void __raw_read_unlock(rwlock_t *lock)
>
>  static inline void __raw_read_unlock_irq(rwlock_t *lock)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_read_unlock(lock);
>         local_irq_enable();
>         preempt_enable();
> @@ -246,7 +246,7 @@ static inline void __raw_read_unlock_irq(rwlock_t *lock)
>
>  static inline void __raw_read_unlock_bh(rwlock_t *lock)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_read_unlock(lock);
>         __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
>  }
> @@ -254,7 +254,7 @@ static inline void __raw_read_unlock_bh(rwlock_t *lock)
>  static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
>                                              unsigned long flags)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_write_unlock(lock);
>         local_irq_restore(flags);
>         preempt_enable();
> @@ -262,7 +262,7 @@ static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
>
>  static inline void __raw_write_unlock_irq(rwlock_t *lock)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_write_unlock(lock);
>         local_irq_enable();
>         preempt_enable();
> @@ -270,7 +270,7 @@ static inline void __raw_write_unlock_irq(rwlock_t *lock)
>
>  static inline void __raw_write_unlock_bh(rwlock_t *lock)
>  {
> -       rwlock_release(&lock->dep_map, 1, _RET_IP_);
> +       rwlock_release(&lock->dep_map, _RET_IP_);
>         do_raw_write_unlock(lock);
>         __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
>  }
> diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
> index bcf4cf26b8c8..0491d963d47e 100644
> --- a/include/linux/seqlock.h
> +++ b/include/linux/seqlock.h
> @@ -79,7 +79,7 @@ static inline void seqcount_lockdep_reader_access(const seqcount_t *s)
>
>         local_irq_save(flags);
>         seqcount_acquire_read(&l->dep_map, 0, 0, _RET_IP_);
> -       seqcount_release(&l->dep_map, 1, _RET_IP_);
> +       seqcount_release(&l->dep_map, _RET_IP_);
>         local_irq_restore(flags);
>  }
>
> @@ -384,7 +384,7 @@ static inline void write_seqcount_begin(seqcount_t *s)
>
>  static inline void write_seqcount_end(seqcount_t *s)
>  {
> -       seqcount_release(&s->dep_map, 1, _RET_IP_);
> +       seqcount_release(&s->dep_map, _RET_IP_);
>         raw_write_seqcount_end(s);
>  }
>
> diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
> index b762eaba4cdf..19a9be9d97ee 100644
> --- a/include/linux/spinlock_api_smp.h
> +++ b/include/linux/spinlock_api_smp.h
> @@ -147,7 +147,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
>
>  static inline void __raw_spin_unlock(raw_spinlock_t *lock)
>  {
> -       spin_release(&lock->dep_map, 1, _RET_IP_);
> +       spin_release(&lock->dep_map, _RET_IP_);
>         do_raw_spin_unlock(lock);
>         preempt_enable();
>  }
> @@ -155,7 +155,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
>  static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
>                                             unsigned long flags)
>  {
> -       spin_release(&lock->dep_map, 1, _RET_IP_);
> +       spin_release(&lock->dep_map, _RET_IP_);
>         do_raw_spin_unlock(lock);
>         local_irq_restore(flags);
>         preempt_enable();
> @@ -163,7 +163,7 @@ static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
>
>  static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
>  {
> -       spin_release(&lock->dep_map, 1, _RET_IP_);
> +       spin_release(&lock->dep_map, _RET_IP_);
>         do_raw_spin_unlock(lock);
>         local_irq_enable();
>         preempt_enable();
> @@ -171,7 +171,7 @@ static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
>
>  static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
>  {
> -       spin_release(&lock->dep_map, 1, _RET_IP_);
> +       spin_release(&lock->dep_map, _RET_IP_);
>         do_raw_spin_unlock(lock);
>         __local_bh_enable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
>  }
> diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
> index 3af7c0e03be5..d7554252404c 100644
> --- a/include/linux/ww_mutex.h
> +++ b/include/linux/ww_mutex.h
> @@ -182,7 +182,7 @@ static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
>  static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
>  {
>  #ifdef CONFIG_DEBUG_MUTEXES
> -       mutex_release(&ctx->dep_map, 0, _THIS_IP_);
> +       mutex_release(&ctx->dep_map, _THIS_IP_);
>
>         DEBUG_LOCKS_WARN_ON(ctx->acquired);
>         if (!IS_ENABLED(CONFIG_PROVE_LOCKING))
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 2c53f1a1d905..e46db0c846d2 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1484,7 +1484,7 @@ static inline void sock_release_ownership(struct sock *sk)
>                 sk->sk_lock.owned = 0;
>
>                 /* The sk_lock has mutex_unlock() semantics: */
> -               mutex_release(&sk->sk_lock.dep_map, 1, _RET_IP_);
> +               mutex_release(&sk->sk_lock.dep_map, _RET_IP_);
>         }
>  }
>
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 052580c33d26..dcfe2d37ad15 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -338,7 +338,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
>                  * up_read_non_owner(). The rwsem_release() is called
>                  * here to release the lock from lockdep's perspective.
>                  */
> -               rwsem_release(&current->mm->mmap_sem.dep_map, 1, _RET_IP_);
> +               rwsem_release(&current->mm->mmap_sem.dep_map, _RET_IP_);
>         }
>  }
>
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index e1967e9eddc2..97ed88e0cf72 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -336,7 +336,7 @@ static void lockdep_acquire_cpus_lock(void)
>
>  static void lockdep_release_cpus_lock(void)
>  {
> -       rwsem_release(&cpu_hotplug_lock.rw_sem.dep_map, 1, _THIS_IP_);
> +       rwsem_release(&cpu_hotplug_lock.rw_sem.dep_map, _THIS_IP_);
>  }
>
>  /*
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 233459c03b5a..8123518f9045 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -4491,8 +4491,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>  }
>  EXPORT_SYMBOL_GPL(lock_acquire);
>
> -void lock_release(struct lockdep_map *lock, int nested,
> -                         unsigned long ip)
> +void lock_release(struct lockdep_map *lock, unsigned long ip)
>  {
>         unsigned long flags;
>
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 468a9b8422e3..5352ce50a97e 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -1091,7 +1091,7 @@ void __sched ww_mutex_unlock(struct ww_mutex *lock)
>  err_early_kill:
>         spin_unlock(&lock->wait_lock);
>         debug_mutex_free_waiter(&waiter);
> -       mutex_release(&lock->dep_map, 1, ip);
> +       mutex_release(&lock->dep_map, ip);
>         preempt_enable();
>         return ret;
>  }
> @@ -1225,7 +1225,7 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
>         DEFINE_WAKE_Q(wake_q);
>         unsigned long owner;
>
> -       mutex_release(&lock->dep_map, 1, ip);
> +       mutex_release(&lock->dep_map, ip);
>
>         /*
>          * Release the lock before (potentially) taking the spinlock such that
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index 2874bf556162..851bbb10819d 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -1517,7 +1517,7 @@ int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock)
>         mutex_acquire(&lock->dep_map, 0, 0, _RET_IP_);
>         ret = rt_mutex_fastlock(lock, TASK_INTERRUPTIBLE, rt_mutex_slowlock);
>         if (ret)
> -               mutex_release(&lock->dep_map, 1, _RET_IP_);
> +               mutex_release(&lock->dep_map, _RET_IP_);
>
>         return ret;
>  }
> @@ -1561,7 +1561,7 @@ int __sched __rt_mutex_futex_trylock(struct rt_mutex *lock)
>                                        RT_MUTEX_MIN_CHAINWALK,
>                                        rt_mutex_slowlock);
>         if (ret)
> -               mutex_release(&lock->dep_map, 1, _RET_IP_);
> +               mutex_release(&lock->dep_map, _RET_IP_);
>
>         return ret;
>  }
> @@ -1600,7 +1600,7 @@ int __sched rt_mutex_trylock(struct rt_mutex *lock)
>   */
>  void __sched rt_mutex_unlock(struct rt_mutex *lock)
>  {
> -       mutex_release(&lock->dep_map, 1, _RET_IP_);
> +       mutex_release(&lock->dep_map, _RET_IP_);
>         rt_mutex_fastunlock(lock, rt_mutex_slowunlock);
>  }
>  EXPORT_SYMBOL_GPL(rt_mutex_unlock);
> diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> index eef04551eae7..44e68761f432 100644
> --- a/kernel/locking/rwsem.c
> +++ b/kernel/locking/rwsem.c
> @@ -1504,7 +1504,7 @@ int __sched down_read_killable(struct rw_semaphore *sem)
>         rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
>
>         if (LOCK_CONTENDED_RETURN(sem, __down_read_trylock, __down_read_killable)) {
> -               rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +               rwsem_release(&sem->dep_map, _RET_IP_);
>                 return -EINTR;
>         }
>
> @@ -1546,7 +1546,7 @@ int __sched down_write_killable(struct rw_semaphore *sem)
>
>         if (LOCK_CONTENDED_RETURN(sem, __down_write_trylock,
>                                   __down_write_killable)) {
> -               rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +               rwsem_release(&sem->dep_map, _RET_IP_);
>                 return -EINTR;
>         }
>
> @@ -1573,7 +1573,7 @@ int down_write_trylock(struct rw_semaphore *sem)
>   */
>  void up_read(struct rw_semaphore *sem)
>  {
> -       rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +       rwsem_release(&sem->dep_map, _RET_IP_);
>         __up_read(sem);
>  }
>  EXPORT_SYMBOL(up_read);
> @@ -1583,7 +1583,7 @@ void up_read(struct rw_semaphore *sem)
>   */
>  void up_write(struct rw_semaphore *sem)
>  {
> -       rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +       rwsem_release(&sem->dep_map, _RET_IP_);
>         __up_write(sem);
>  }
>  EXPORT_SYMBOL(up_write);
> @@ -1639,7 +1639,7 @@ int __sched down_write_killable_nested(struct rw_semaphore *sem, int subclass)
>
>         if (LOCK_CONTENDED_RETURN(sem, __down_write_trylock,
>                                   __down_write_killable)) {
> -               rwsem_release(&sem->dep_map, 1, _RET_IP_);
> +               rwsem_release(&sem->dep_map, _RET_IP_);
>                 return -EINTR;
>         }
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ca65327a6de8..c8be5a0f5259 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -248,7 +248,7 @@ static void __up_console_sem(unsigned long ip)
>  {
>         unsigned long flags;
>
> -       mutex_release(&console_lock_dep_map, 1, ip);
> +       mutex_release(&console_lock_dep_map, ip);
>
>         printk_safe_enter_irqsave(flags);
>         up(&console_sem);
> @@ -1679,20 +1679,20 @@ static int console_lock_spinning_disable_and_check(void)
>         raw_spin_unlock(&console_owner_lock);
>
>         if (!waiter) {
> -               spin_release(&console_owner_dep_map, 1, _THIS_IP_);
> +               spin_release(&console_owner_dep_map, _THIS_IP_);
>                 return 0;
>         }
>
>         /* The waiter is now free to continue */
>         WRITE_ONCE(console_waiter, false);
>
> -       spin_release(&console_owner_dep_map, 1, _THIS_IP_);
> +       spin_release(&console_owner_dep_map, _THIS_IP_);
>
>         /*
>          * Hand off console_lock to waiter. The waiter will perform
>          * the up(). After this, the waiter is the console_lock owner.
>          */
> -       mutex_release(&console_lock_dep_map, 1, _THIS_IP_);
> +       mutex_release(&console_lock_dep_map, _THIS_IP_);
>         return 1;
>  }
>
> @@ -1746,7 +1746,7 @@ static int console_trylock_spinning(void)
>         /* Owner will clear console_waiter on hand off */
>         while (READ_ONCE(console_waiter))
>                 cpu_relax();
> -       spin_release(&console_owner_dep_map, 1, _THIS_IP_);
> +       spin_release(&console_owner_dep_map, _THIS_IP_);
>
>         printk_safe_exit_irqrestore(flags);
>         /*
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f9a1346a5fa9..f845693e8e75 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3105,7 +3105,7 @@ static inline void finish_task(struct task_struct *prev)
>          * do an early lockdep release here:
>          */
>         rq_unpin_lock(rq, rf);
> -       spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
> +       spin_release(&rq->lock.dep_map, _THIS_IP_);
>  #ifdef CONFIG_DEBUG_SPINLOCK
>         /* this is a valid case when another task releases the spinlock */
>         rq->lock.owner = next;
> diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
> index a1705545e6ac..14f44f59e733 100644
> --- a/lib/locking-selftest.c
> +++ b/lib/locking-selftest.c
> @@ -1475,7 +1475,7 @@ static void ww_test_edeadlk_normal(void)
>
>         mutex_lock(&o2.base);
>         o2.ctx = &t2;
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>
>         WWAI(&t);
>         t2 = t;
> @@ -1500,7 +1500,7 @@ static void ww_test_edeadlk_normal_slow(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         WWAI(&t);
> @@ -1527,7 +1527,7 @@ static void ww_test_edeadlk_no_unlock(void)
>
>         mutex_lock(&o2.base);
>         o2.ctx = &t2;
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>
>         WWAI(&t);
>         t2 = t;
> @@ -1551,7 +1551,7 @@ static void ww_test_edeadlk_no_unlock_slow(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         WWAI(&t);
> @@ -1576,7 +1576,7 @@ static void ww_test_edeadlk_acquire_more(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         WWAI(&t);
> @@ -1597,7 +1597,7 @@ static void ww_test_edeadlk_acquire_more_slow(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         WWAI(&t);
> @@ -1618,11 +1618,11 @@ static void ww_test_edeadlk_acquire_more_edeadlk(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         mutex_lock(&o3.base);
> -       mutex_release(&o3.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o3.base.dep_map, _THIS_IP_);
>         o3.ctx = &t2;
>
>         WWAI(&t);
> @@ -1644,11 +1644,11 @@ static void ww_test_edeadlk_acquire_more_edeadlk_slow(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         mutex_lock(&o3.base);
> -       mutex_release(&o3.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o3.base.dep_map, _THIS_IP_);
>         o3.ctx = &t2;
>
>         WWAI(&t);
> @@ -1669,7 +1669,7 @@ static void ww_test_edeadlk_acquire_wrong(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         WWAI(&t);
> @@ -1694,7 +1694,7 @@ static void ww_test_edeadlk_acquire_wrong_slow(void)
>         int ret;
>
>         mutex_lock(&o2.base);
> -       mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
> +       mutex_release(&o2.base.dep_map, _THIS_IP_);
>         o2.ctx = &t2;
>
>         WWAI(&t);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1c4c08b45e44..3956ab6dba14 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1800,7 +1800,7 @@ static void mem_cgroup_oom_unlock(struct mem_cgroup *memcg)
>         struct mem_cgroup *iter;
>
>         spin_lock(&memcg_oom_lock);
> -       mutex_release(&memcg_oom_lock_dep_map, 1, _RET_IP_);
> +       mutex_release(&memcg_oom_lock_dep_map, _RET_IP_);
>         for_each_mem_cgroup_tree(iter, memcg)
>                 iter->oom_lock = false;
>         spin_unlock(&memcg_oom_lock);
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 07863edbe6fc..a988e70cdac5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -521,7 +521,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
>
>                 rc = sk_backlog_rcv(sk, skb);
>
> -               mutex_release(&sk->sk_lock.dep_map, 1, _RET_IP_);
> +               mutex_release(&sk->sk_lock.dep_map, _RET_IP_);
>         } else if (sk_add_backlog(sk, skb, sk->sk_rcvbuf)) {
>                 bh_unlock_sock(sk);
>                 atomic_inc(&sk->sk_drops);
> diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
> index a81d91d4fc78..a6d7ee5f18ba 100644
> --- a/tools/lib/lockdep/include/liblockdep/common.h
> +++ b/tools/lib/lockdep/include/liblockdep/common.h
> @@ -42,8 +42,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
>  void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
>                         int trylock, int read, int check,
>                         struct lockdep_map *nest_lock, unsigned long ip);
> -void lock_release(struct lockdep_map *lock, int nested,
> -                       unsigned long ip);
> +void lock_release(struct lockdep_map *lock, unsigned long ip);
>  void lockdep_reset_lock(struct lockdep_map *lock);
>  void lockdep_register_key(struct lock_class_key *key);
>  void lockdep_unregister_key(struct lock_class_key *key);
> diff --git a/tools/lib/lockdep/include/liblockdep/mutex.h b/tools/lib/lockdep/include/liblockdep/mutex.h
> index 783dd0df06f9..bd106b82759b 100644
> --- a/tools/lib/lockdep/include/liblockdep/mutex.h
> +++ b/tools/lib/lockdep/include/liblockdep/mutex.h
> @@ -42,7 +42,7 @@ static inline int liblockdep_pthread_mutex_lock(liblockdep_pthread_mutex_t *lock
>
>  static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
>  {
> -       lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
> +       lock_release(&lock->dep_map, (unsigned long)_RET_IP_);
>         return pthread_mutex_unlock(&lock->mutex);
>  }
>
> diff --git a/tools/lib/lockdep/include/liblockdep/rwlock.h b/tools/lib/lockdep/include/liblockdep/rwlock.h
> index 365762e3a1ea..6d5d2932bf4d 100644
> --- a/tools/lib/lockdep/include/liblockdep/rwlock.h
> +++ b/tools/lib/lockdep/include/liblockdep/rwlock.h
> @@ -44,7 +44,7 @@ static inline int liblockdep_pthread_rwlock_rdlock(liblockdep_pthread_rwlock_t *
>
>  static inline int liblockdep_pthread_rwlock_unlock(liblockdep_pthread_rwlock_t *lock)
>  {
> -       lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
> +       lock_release(&lock->dep_map, (unsigned long)_RET_IP_);
>         return pthread_rwlock_unlock(&lock->rwlock);
>  }
>
> diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
> index 76245d16196d..8f1adbe887b2 100644
> --- a/tools/lib/lockdep/preload.c
> +++ b/tools/lib/lockdep/preload.c
> @@ -270,7 +270,7 @@ int pthread_mutex_lock(pthread_mutex_t *mutex)
>          */
>         r = ll_pthread_mutex_lock(mutex);
>         if (r)
> -               lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
> +               lock_release(&__get_lock(mutex)->dep_map, (unsigned long)_RET_IP_);
>
>         return r;
>  }
> @@ -284,7 +284,7 @@ int pthread_mutex_trylock(pthread_mutex_t *mutex)
>         lock_acquire(&__get_lock(mutex)->dep_map, 0, 1, 0, 1, NULL, (unsigned long)_RET_IP_);
>         r = ll_pthread_mutex_trylock(mutex);
>         if (r)
> -               lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
> +               lock_release(&__get_lock(mutex)->dep_map, (unsigned long)_RET_IP_);
>
>         return r;
>  }
> @@ -295,7 +295,7 @@ int pthread_mutex_unlock(pthread_mutex_t *mutex)
>
>         try_init_preload();
>
> -       lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)_RET_IP_);
> +       lock_release(&__get_lock(mutex)->dep_map, (unsigned long)_RET_IP_);
>         /*
>          * Just like taking a lock, only in reverse!
>          *
> @@ -355,7 +355,7 @@ int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock)
>         lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 2, 1, NULL, (unsigned long)_RET_IP_);
>         r = ll_pthread_rwlock_rdlock(rwlock);
>         if (r)
> -               lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
> +               lock_release(&__get_lock(rwlock)->dep_map, (unsigned long)_RET_IP_);
>
>         return r;
>  }
> @@ -369,7 +369,7 @@ int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock)
>         lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 2, 1, NULL, (unsigned long)_RET_IP_);
>         r = ll_pthread_rwlock_tryrdlock(rwlock);
>         if (r)
> -               lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
> +               lock_release(&__get_lock(rwlock)->dep_map, (unsigned long)_RET_IP_);
>
>         return r;
>  }
> @@ -383,7 +383,7 @@ int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock)
>         lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 0, 1, NULL, (unsigned long)_RET_IP_);
>         r = ll_pthread_rwlock_trywrlock(rwlock);
>         if (r)
> -                lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
> +               lock_release(&__get_lock(rwlock)->dep_map, (unsigned long)_RET_IP_);
>
>         return r;
>  }
> @@ -397,7 +397,7 @@ int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock)
>         lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
>         r = ll_pthread_rwlock_wrlock(rwlock);
>         if (r)
> -               lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
> +               lock_release(&__get_lock(rwlock)->dep_map, (unsigned long)_RET_IP_);
>
>         return r;
>  }
> @@ -408,7 +408,7 @@ int pthread_rwlock_unlock(pthread_rwlock_t *rwlock)
>
>          init_preload();
>
> -       lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)_RET_IP_);
> +       lock_release(&__get_lock(rwlock)->dep_map, (unsigned long)_RET_IP_);
>         r = ll_pthread_rwlock_unlock(rwlock);
>         if (r)
>                 lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 1, NULL, (unsigned long)_RET_IP_);
> --
> 1.8.3.1
>
