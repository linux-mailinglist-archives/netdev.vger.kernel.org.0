Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7487A163DA
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 14:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfEGMle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 08:41:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36865 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfEGMld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 08:41:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id y5so19896405wma.2
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 05:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OU1byXVl+EKQdKaptPW+4TR/68tCu30Q7Jm5ILKuzJk=;
        b=hQkQ9M+5hgje9jC118XPfqE329zteqbYXM8GNsoZA2Qu5tx/GnbHkLFv5hyZLwzQNj
         Dr/HluwTz1xuUK2PbcvFl1nqyDXJmXi4S4HYAC7VuzuQjcASqrD55RcDyfX0B83kcMLh
         AIzrOel4+1QYRxj/bUG0IR2NKffn3aM1wRp9jfVxFiub6UB0BHrwFu5iPWBxKLgIx2q6
         jMhotdznX2LPs6UGY2kD53GpG+5Od5hd2ayGGS/FpM7Fqx75yVjx3oBjwdoHrmSFr3mB
         5b36bdjhzVgJ8RDT028QW6U57bcrQfOACmvYCm2taEoEEUnKS2TFBv041ykOZFYd8KpC
         8N1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OU1byXVl+EKQdKaptPW+4TR/68tCu30Q7Jm5ILKuzJk=;
        b=GH5BXaUBUfspf0/dZV+okYlcp32aC9F1MuLoDYZkmyyYmn25L0BXe7XWba3H5hJQ/T
         MgixiIMcxCn3/diJ6yVa2/559VKL1b6+lLlFHfBIPTDCEbcJUBoJeb8S3yhU/WosoPX7
         d98590qwwD2nEqWLRQGOjRehhU5BZ0jiZADSTiAEG4TrT+6rptcXZnOCxihyAdVnZWFA
         Jaj3Taw9xmFolFpgmKm6WpsT4LP9S4BqwF62Kz8OFvK5HVqSdkb9lTxMsNl+SE4vT80e
         n82pWJoKbNrCujINLbaba/97bAHAcQv0Zi/AW98uM6Ps9OIyAxHJXIb+wYHJNmMHbB+u
         xd6A==
X-Gm-Message-State: APjAAAXx4lLD4Llzy8Jofrh0sklSQ0QKf+7ZHkdQq9yi9EffIvsTUiI6
        d9vcwtwEqRDGPeFmfNDbk0X+MA==
X-Google-Smtp-Source: APXvYqyzxinkH7mAE5z0gvzbz9ZfewXUZXQVz+tQQp/ktmDi4e0sNv96zEsb13oqBb/sxYNGAqMcBA==
X-Received: by 2002:a05:600c:2248:: with SMTP id a8mr21686132wmm.75.1557232890415;
        Tue, 07 May 2019 05:41:30 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id k1sm11206482wmi.48.2019.05.07.05.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 05:41:30 -0700 (PDT)
Date:   Tue, 7 May 2019 14:41:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Aya Levin <ayal@mellanox.com>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next RFC] Dump SW SQ context as part of tx reporter
Message-ID: <20190507124129.GC2157@nanopsycho>
References: <1556547459-7756-1-git-send-email-ayal@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556547459-7756-1-git-send-email-ayal@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 29, 2019 at 04:17:39PM CEST, ayal@mellanox.com wrote:
>TX reporter reports an error on two scenarios:
>- TX timeout on a specific tx queue
>- TX completion error on a specific send queue
>Prior to this patch, no dump data was supported by the tx reporter. This
>patch adds support for SW data dump of the related SQ context. The dump
>is simply the SQ's raw memory snapshot taken right after the error was
>reported, before any recovery procedure was launched. With this
>approach, no maintenance is needed as the driver fetch the actual data
>according to the layout on which the SQ was compiled with.  By providing
>a SW context, one can easily debug error on a given SQ.
>
>In order to offline translate the raw memory into a human readable
>format, the user can use some out-of-kernel scripts which receives as an
>input the following:
>- Object raw memory
>- Driver object compiled with debug info (can be taken/generated at any time from the machine)
>- Object name
>
>An example of such script output can be seen below.
>Note: the script is not offered as part of this patch as it do not
>belong to the kernel, I just described it in order to grasp the general
>idea of how/what can be fetched from SW dump via devlink health.
>
>The output of the SW dump can be extracted by devlink health command:
>$ sudo devlink health dump show pci/0000:00:0b.0 reporter tx.
> mlx5e_txqsq: sqn: 6336
> memory:
>   00 00 00 00 00 00 00 00
>   01 00 00 00 00 00 00 00
>   00 00 00 00 00 00 00 00
>   45 f4 88 cb 09 00 00 00
>   00 00 00 00 00 00 00 00
>   00 00 00 00 00 00 00 00
>   c0 ff ff ff 1f 00 00 00
>   f8 18 1e 89 81 88 ff ff
>   ...
>
>script output below, with struct members names and actual values:
>
>struct  mlx5e_txqsq {
>	short unsigned int         cc 	 0x5 ;
>	unsigned int               dma_fifo_cc 	 0x5 ;
>	struct  net_dim {
>		unsigned char      state 	 0x1 ;
>		struct  net_dim_stats {
>			int        ppms 	 0x0 ;
>			int        bpms 	 0x0 ;
>			int        epms 	 0x0 ;
>		} prev_stats;
>		struct  net_dim_sample {
>			long long int time 	 0x90766ef9d ;
>			unsigned int pkt_ctr 	 0x0 ;
>			unsigned int byte_ctr 	 0x0 ;
>			short unsigned int event_ctr 	 0x0 ;
>		} start_sample;
>		struct  work_struct {
>			struct   {
>				long int counter 	 0x1fffffffc0 ;
>			} data;
>			struct  list_head {
>				struct list_head * next 	 0xffff8881b08998f8 ;
>				struct list_head * prev 	 0xffff8881b08998f8 ;
>			} entry;
>			void       (*func)(struct work_struct *) 	 0xffffffffa02d0e30 ;
>		} work;
>		unsigned char      profile_ix 	 0x60 ;
>		unsigned char      mode 	 0x72 ;
>		unsigned char      tune_state 	 0x35 ;
>		unsigned char      steps_right 	 0xa0 ;
>		unsigned char      steps_left 	 0xff ;
>		unsigned char      tired 	 0xff ;
>	} dim;
>	short unsigned int         pc 	 0x0 ;
>	unsigned int               dma_fifo_pc 	 0x0 ;
>	struct  mlx5e_cq {
>		struct  mlx5_cqwq {
>			struct  mlx5_frag_buf_ctrl {
>				struct mlx5_buf_list * frags 	 0x500000005 ;
>				unsigned int sz_m1 	 0x0 ;
>				short unsigned int frag_sz_m1 	 0x0 ;
>				short unsigned int strides_offset 	 0x0 ;
>				unsigned char log_sz 	 0x0 ;
>				unsigned char log_stride 	 0x0 ;
>				unsigned char log_frag_strides 	 0x0 ;
>			} fbc;
>			__be32 *   db 	 0x0 ;
>			unsigned int cc 	 0x0 ;
>		} wq;
>		short unsigned int event_ctr 	 0x0 ;
>		struct napi_struct * napi 	 0x0 ;
>		struct  mlx5_core_cq {
>			unsigned int cqn 	 0x0 ;
>			int        cqe_sz 	 0x0 ;
>			__be32 *   set_ci_db 	 0xffff8881b1aa4988 ;
>			__be32 *   arm_db 	 0x3f000003ff ;
>			struct mlx5_uars_page * uar 	 0x6060a ;
>			struct  refcount_struct {
>				struct   {
>					int    counter 	 0xa1814500 ;
>				} refs;
>			} refcount;
>			struct  completion {
>				unsigned int done 	 0x5 ;
>				struct  wait_queue_head {
>					struct  spinlock {
>						union   {
>							struct  raw_spinlock {
>								struct  qspinlock {
>									union   {
>										struct   {
>											int                                                    counter 	 0x5 ;
>										} val;
>										struct   {
>											unsigned char                                          locked 	 0x5 ;
>											unsigned char                                          pending 	 0x0 ;
>										} ;
>										struct   {
>											short unsigned int                                     locked_pending 	 0x5 ;
>											short unsigned int                                     tail 	 0x0 ;
>										} ;
>									} ;
>								} raw_lock;
>							} rlock;
>						} ;
>					} lock;
>					struct  list_head {
>						struct list_head * next 	 0xffff8881b089bb88 ;
>						struct list_head * prev 	 0x4000000c0a ;
>					} head;
>				} wait;
>			} free;
>			unsigned int vector 	 0xa1814500 ;
>			unsigned int irqn 	 0xffff8881 ;
>			void       (*comp)(struct mlx5_core_cq *) 	 0xffff8881a1814504 ;
>			void       (*event)(struct mlx5_core_cq *, enum mlx5_event) 	 0xffff8881a2cdea08 ;
>			unsigned int cons_index 	 0x1 ;
>			unsigned int arm_sn 	 0x0 ;
>			struct mlx5_rsc_debug * dbg 	 0x0 ;
>			int        pid 	 0x0 ;
>			struct   {
>				struct  list_head {
>					struct list_head * next 	 0xffffffff ;
>					struct list_head * prev 	 0xffffffffffffffff ;
>				} list;
>				void (*comp)(struct mlx5_core_cq *) 	 0xffffffffa0356940 ;
>				void * priv 	 0x0 ;
>			} tasklet_ctx;
>			int        reset_notify_added 	 0x0 ;
>			struct  list_head {
>				struct list_head * next 	 0xffffffffa0300700 ;
>				struct list_head * prev 	 0xd ;
>			} reset_notify;
>			struct mlx5_eq_comp * eq 	 0x0 ;
>			short unsigned int uid 	 0x9a70 ;
>		} mcq;
>		struct mlx5e_channel * channel 	 0xffff8881b0899a70 ;
>		struct mlx5_core_dev * mdev 	 0x4800000001 ;
>		struct  mlx5_wq_ctrl {
>			struct mlx5_core_dev * mdev 	 0xffffffffa02d5350 ;
>			struct  mlx5_frag_buf {
>				struct mlx5_buf_list * frags 	 0xffffffffa02d5460 ;
>				int npages 	 0x0 ;
>				int size 	 0x5 ;
>				unsigned char page_shift 	 0x8 ;
>			} buf;
>			struct  mlx5_db {
>				__be32 * db 	 0x1c6 ;
>				union   {
>					struct mlx5_db_pgdir * pgdir 	 0x0 ;
>					struct mlx5_ib_user_db_page * user_page 	 0x0 ;
>				} u;
>				long long unsigned int dma 	 0xffff8881b0899ab0 ;
>				int index 	 0x0 ;
>			} db;
>		} wq_ctrl;
>	} cq;
>	struct  mlx5_wq_cyc {
>		struct  mlx5_frag_buf_ctrl {
>			struct mlx5_buf_list * frags 	 0xffff8881a7600160 ;
>			unsigned int sz_m1 	 0xa7600160 ;
>			short unsigned int frag_sz_m1 	 0x8881 ;
>			short unsigned int strides_offset 	 0xffff ;
>			unsigned char log_sz 	 0x88 ;
>			unsigned char log_stride 	 0x49 ;
>			unsigned char log_frag_strides 	 0xaa ;
>		} fbc;
>		__be32 *           db 	 0x1000000000010 ;
>		short unsigned int sz 	 0xc ;
>		short unsigned int wqe_ctr 	 0x0 ;
>		short unsigned int cur_sz 	 0x0 ;
>	} wq;
>	unsigned int               dma_fifo_mask 	 0xa1814500 ;
>	struct mlx5e_sq_stats *    stats 	 0xffff8881a33a0348 ;
>	struct   {
>		struct mlx5e_sq_dma * dma_fifo 	 0x1a1814500 ;
>		struct mlx5e_tx_wqe_info * wqe_info 	 0x14 ;
>	} db;
>	void *                     uar_map 	 0x0 ;
>	struct netdev_queue *      txq 	 0x0 ;
>	unsigned int               sqn 	 0x18c0 ;
>	unsigned char              min_inline_mode 	 0x0 ;
>	struct device *            pdev 	 0x0 ;
>	unsigned int               mkey_be 	 0x0 ;
>	long unsigned int          state 	 0x0 ;
>	struct hwtstamp_config *   tstamp 	 0x0 ;
>	struct mlx5_clock *        clock 	 0xffff8881b1aa6f88 ;
>	struct  mlx5_wq_ctrl {
>		struct mlx5_core_dev * mdev 	 0x3f000003ff ;
>		struct  mlx5_frag_buf {
>			struct mlx5_buf_list * frags 	 0x6060a ;
>			int        npages 	 0xa1814604 ;
>			int        size 	 0xffff8881 ;
>			unsigned char page_shift 	 0x0 ;
>		} buf;
>		struct  mlx5_db {
>			__be32 *   db 	 0xfff ;
>			union   {
>				struct mlx5_db_pgdir * pgdir 	 0x0 ;
>				struct mlx5_ib_user_db_page * user_page 	 0x0 ;
>			} u;
>			long long unsigned int dma 	 0xffff888188440000 ;
>			int        index 	 0x8b074000 ;
>		} db;
>	} wq_ctrl;
>	struct mlx5e_channel *     channel 	 0xffffc9000010d800 ;
>	int                        txq_ix 	 0xa0020180 ;
>	unsigned int               rate_limit 	 0xffff8881 ;
>	struct  work_struct {
>		struct   {
>			long int   counter 	 0x1000018c0 ;
>		} data;
>		struct  list_head {
>			struct list_head * next 	 0xffff8881c32b68e8 ;
>			struct list_head * prev 	 0x800 ;
>		} entry;
>		void               (*func)(struct work_struct *) 	 0x9 ;
>	} recover_work;
>} ;

I don't get it. You are dumping live kernel memory? There are already
facilities to do that in place. Why to replicate it?


>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>---
> .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 100 +++++++++++++++++++++
> 1 file changed, 100 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>index 476dd97f7f2f..8a39f5525e57 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
>@@ -9,6 +9,7 @@
> 
> struct mlx5e_tx_err_ctx {
> 	int (*recover)(struct mlx5e_txqsq *sq);
>+	int (*dump)(struct mlx5e_txqsq *sq);
> 	struct mlx5e_txqsq *sq;
> };
> 
>@@ -281,10 +282,109 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
> 	return err;
> }
> 
>+static int mlx5e_tx_reporter_sw_dump_from_ctx(struct mlx5e_priv *priv,
>+					      struct mlx5e_txqsq *sq,
>+					      struct devlink_fmsg *fmsg)
>+{
>+	u64 *ptr = (u64 *)sq;
>+	int copy, err;
>+	int i = 0;
>+
>+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
>+		return 0;
>+
>+	err = devlink_fmsg_pair_nest_start(fmsg, "mlx5e_txqsq");
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_obj_nest_start(fmsg);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "memory");
>+	if (err)
>+		return err;
>+
>+	while (i < sizeof(struct mlx5e_txqsq)) {
>+		copy = sizeof(u64);
>+
>+		if (i + copy > sizeof(struct mlx5e_txqsq))
>+			copy = sizeof(struct mlx5e_txqsq) - i;
>+
>+		err = devlink_fmsg_binary_put(fmsg, ptr, copy);
>+		if (err)
>+			return err;
>+		ptr++;
>+		i += copy;
>+	}
>+
>+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_obj_nest_end(fmsg);
>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_pair_nest_end(fmsg);
>+
>+	return err;
>+}
>+
>+static int mlx5e_tx_reporter_sw_dump_all(struct mlx5e_priv *priv,
>+					 struct devlink_fmsg *fmsg)
>+{
>+	int i, err = 0;
>+
>+	mutex_lock(&priv->state_lock);
>+
>+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
>+		goto unlock;
>+
>+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "SQs");
>+	if (err)
>+		goto unlock;
>+
>+	for (i = 0; i < priv->channels.num * priv->channels.params.num_tc;
>+	     i++) {
>+		err = devlink_fmsg_obj_nest_start(fmsg);
>+		if (err)
>+			goto unlock;
>+
>+		err = mlx5e_tx_reporter_sw_dump_from_ctx(priv, priv->txq2sq[i],
>+							 fmsg);
>+		if (err)
>+			goto unlock;
>+
>+		err = devlink_fmsg_pair_nest_end(fmsg);
>+		if (err)
>+			goto unlock;
>+	}
>+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
>+	if (err)
>+		goto unlock;
>+
>+unlock:
>+	mutex_unlock(&priv->state_lock);
>+	return err;
>+}
>+
>+static int mlx5e_tx_reporter_sw_dump(struct devlink_health_reporter *reporter,
>+				     struct devlink_fmsg *fmsg, void *context)
>+{
>+	struct mlx5e_priv *priv = devlink_health_reporter_priv(reporter);
>+	struct mlx5e_tx_err_ctx *err_ctx = context;
>+
>+	return err_ctx ? mlx5e_tx_reporter_sw_dump_from_ctx(priv, err_ctx->sq,
>+							    fmsg) :
>+			 mlx5e_tx_reporter_sw_dump_all(priv, fmsg);
>+}
>+
> static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
> 		.name = "tx",
> 		.recover = mlx5e_tx_reporter_recover,
> 		.diagnose = mlx5e_tx_reporter_diagnose,
>+		.dump = mlx5e_tx_reporter_sw_dump,
> };
> 
> #define MLX5_REPORTER_TX_GRACEFUL_PERIOD 500
>-- 
>2.14.1
>
