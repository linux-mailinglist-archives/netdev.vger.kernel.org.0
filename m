Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B513D39C07F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhFDTkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:40:00 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:42664 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229810AbhFDTj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:39:58 -0400
Received: from omf13.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 86FD4181B956E;
        Fri,  4 Jun 2021 19:38:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf13.hostedemail.com (Postfix) with ESMTPA id 80AD71124FA;
        Fri,  4 Jun 2021 19:38:08 +0000 (UTC)
Message-ID: <144460ce4f34a51dabb76e422a718573db77cdc8.camel@perches.com>
Subject: [PATCH] treewide: Add missing semicolons to __assign_str uses
From:   Joe Perches <joe@perches.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lima@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Date:   Fri, 04 Jun 2021 12:38:07 -0700
In-Reply-To: <20210604122128.0d348960@oasis.local.home>
References: <cover.1621024265.git.bristot@redhat.com>
         <2c59beee3b36b15592bfbb9f26dee7f8b55fd814.1621024265.git.bristot@redhat.com>
         <20210603172902.41648183@gandalf.local.home>
         <1e068d21106bb6db05b735b4916bb420e6c9842a.camel@perches.com>
         <20210604122128.0d348960@oasis.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.90
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 80AD71124FA
X-Stat-Signature: phq1t84r7hdy78tyjsrpdrat168hrsik
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/PIeFEZ46D7snJ1nSJmE2kCP8dD8iXWeo=
X-HE-Tag: 1622835488-93370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __assign_str macro has an unusual ending semicolon but the vast
majority of uses of the macro already have semicolon termination.

$ git grep -P '\b__assign_str\b' | wc -l
551
$ git grep -P '\b__assign_str\b.*;' | wc -l
480

Add semicolons to the __assign_str() uses without semicolon termination
and all the other uses without semicolon termination via additional defines
that are equivalent to __assign_str() with the eventual goal of removing
the semicolon from the __assign_str() macro definition.

Link: https://lore.kernel.org/lkml/1e068d21106bb6db05b735b4916bb420e6c9842a.camel@perches.com/

Signed-off-by: Joe Perches <joe@perches.com>
---

Resending without all the direct cc's, only the mailing lists as
it seems not to have gone through via vger.

Compiled x84-64 allyesconfig

On Fri, 2021-06-04 at 12:21 -0400, Steven Rostedt wrote:
> I have no problem taking a clean up patch that adds semicolons to all
> use cases of "__assign_str()" and ever remove the one from where it is
> defined. As long as it doesn't break any builds, I'm fine with that.

Removing the semicolon from the macro definition is left for another patch.

 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h          | 14 ++++----
 drivers/gpu/drm/lima/lima_trace.h                  |  2 +-
 drivers/infiniband/hw/hfi1/trace_misc.h            |  4 +--
 drivers/infiniband/hw/hfi1/trace_rc.h              |  4 +--
 drivers/infiniband/hw/hfi1/trace_tid.h             |  6 ++--
 drivers/infiniband/hw/hfi1/trace_tx.h              |  8 ++---
 drivers/infiniband/sw/rdmavt/trace_cq.h            |  4 +--
 drivers/infiniband/sw/rdmavt/trace_mr.h            |  2 +-
 drivers/infiniband/sw/rdmavt/trace_qp.h            |  4 +--
 drivers/infiniband/sw/rdmavt/trace_rc.h            |  2 +-
 drivers/infiniband/sw/rdmavt/trace_tx.h            |  4 +--
 drivers/misc/mei/mei-trace.h                       |  6 ++--
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  | 12 +++----
 drivers/net/fjes/fjes_trace.h                      |  4 +--
 drivers/usb/cdns3/cdnsp-trace.h                    |  2 +-
 fs/nfs/nfs4trace.h                                 |  6 ++--
 fs/nfs/nfstrace.h                                  |  4 +--
 include/trace/events/btrfs.h                       |  2 +-
 include/trace/events/dma_fence.h                   |  4 +--
 include/trace/events/rpcgss.h                      |  4 +--
 include/trace/events/sunrpc.h                      | 40 +++++++++++-----------
 net/mac80211/trace.h                               |  2 +-
 22 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
index 0527772fe1b80..d855cb53c7e09 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
@@ -176,10 +176,10 @@ TRACE_EVENT(amdgpu_cs_ioctl,
 
 	    TP_fast_assign(
 			   __entry->sched_job_id = job->base.id;
-			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job))
+			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job));
 			   __entry->context = job->base.s_fence->finished.context;
 			   __entry->seqno = job->base.s_fence->finished.seqno;
-			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name)
+			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name);
 			   __entry->num_ibs = job->num_ibs;
 			   ),
 	    TP_printk("sched_job=%llu, timeline=%s, context=%u, seqno=%u, ring_name=%s, num_ibs=%u",
@@ -201,10 +201,10 @@ TRACE_EVENT(amdgpu_sched_run_job,
 
 	    TP_fast_assign(
 			   __entry->sched_job_id = job->base.id;
-			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job))
+			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job));
 			   __entry->context = job->base.s_fence->finished.context;
 			   __entry->seqno = job->base.s_fence->finished.seqno;
-			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name)
+			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name);
 			   __entry->num_ibs = job->num_ibs;
 			   ),
 	    TP_printk("sched_job=%llu, timeline=%s, context=%u, seqno=%u, ring_name=%s, num_ibs=%u",
@@ -229,7 +229,7 @@ TRACE_EVENT(amdgpu_vm_grab_id,
 
 	    TP_fast_assign(
 			   __entry->pasid = vm->pasid;
-			   __assign_str(ring, ring->name)
+			   __assign_str(ring, ring->name);
 			   __entry->vmid = job->vmid;
 			   __entry->vm_hub = ring->funcs->vmhub,
 			   __entry->pd_addr = job->vm_pd_addr;
@@ -424,7 +424,7 @@ TRACE_EVENT(amdgpu_vm_flush,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(ring, ring->name)
+			   __assign_str(ring, ring->name);
 			   __entry->vmid = vmid;
 			   __entry->vm_hub = ring->funcs->vmhub;
 			   __entry->pd_addr = pd_addr;
@@ -525,7 +525,7 @@ TRACE_EVENT(amdgpu_ib_pipe_sync,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(ring, sched_job->base.sched->name)
+			   __assign_str(ring, sched_job->base.sched->name);
 			   __entry->id = sched_job->base.id;
 			   __entry->fence = fence;
 			   __entry->ctx = fence->context;
diff --git a/drivers/gpu/drm/lima/lima_trace.h b/drivers/gpu/drm/lima/lima_trace.h
index 3a430e93d384c..494b9790b1daf 100644
--- a/drivers/gpu/drm/lima/lima_trace.h
+++ b/drivers/gpu/drm/lima/lima_trace.h
@@ -24,7 +24,7 @@ DECLARE_EVENT_CLASS(lima_task,
 		__entry->task_id = task->base.id;
 		__entry->context = task->base.s_fence->finished.context;
 		__entry->seqno = task->base.s_fence->finished.seqno;
-		__assign_str(pipe, task->base.sched->name)
+		__assign_str(pipe, task->base.sched->name);
 		),
 
 	TP_printk("task=%llu, context=%u seqno=%u pipe=%s",
diff --git a/drivers/infiniband/hw/hfi1/trace_misc.h b/drivers/infiniband/hw/hfi1/trace_misc.h
index 8db2253523ffe..93338988b9220 100644
--- a/drivers/infiniband/hw/hfi1/trace_misc.h
+++ b/drivers/infiniband/hw/hfi1/trace_misc.h
@@ -63,7 +63,7 @@ TRACE_EVENT(hfi1_interrupt,
 			     __array(char, buf, 64)
 			     __field(int, src)
 			     ),
-	    TP_fast_assign(DD_DEV_ASSIGN(dd)
+	    TP_fast_assign(DD_DEV_ASSIGN(dd);
 			   is_entry->is_name(__entry->buf, 64,
 					     src - is_entry->start);
 			   __entry->src = src;
@@ -100,7 +100,7 @@ TRACE_EVENT(hfi1_fault_opcode,
 			     __field(u32, qpn)
 			     __field(u8, opcode)
 			     ),
-	    TP_fast_assign(DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+	    TP_fast_assign(DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 			   __entry->qpn = qp->ibqp.qp_num;
 			   __entry->opcode = opcode;
 			   ),
diff --git a/drivers/infiniband/hw/hfi1/trace_rc.h b/drivers/infiniband/hw/hfi1/trace_rc.h
index 1ebca37862e06..5f49e1eeb2116 100644
--- a/drivers/infiniband/hw/hfi1/trace_rc.h
+++ b/drivers/infiniband/hw/hfi1/trace_rc.h
@@ -70,7 +70,7 @@ DECLARE_EVENT_CLASS(hfi1_rc_template,
 			__field(u32, r_psn)
 			),
 		    TP_fast_assign(
-			DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+			DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 			__entry->qpn = qp->ibqp.qp_num;
 			__entry->s_flags = qp->s_flags;
 			__entry->psn = psn;
@@ -130,7 +130,7 @@ DECLARE_EVENT_CLASS(/* rc_ack */
 		__field(u32, lpsn)
 	),
 	TP_fast_assign(/* assign */
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->aeth = aeth;
 		__entry->psn = psn;
diff --git a/drivers/infiniband/hw/hfi1/trace_tid.h b/drivers/infiniband/hw/hfi1/trace_tid.h
index 985ffa9cc958f..d129b81959599 100644
--- a/drivers/infiniband/hw/hfi1/trace_tid.h
+++ b/drivers/infiniband/hw/hfi1/trace_tid.h
@@ -886,7 +886,7 @@ DECLARE_EVENT_CLASS(/* sender_info */
 		__field(u8, s_retry)
 	),
 	TP_fast_assign(/* assign */
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->state = qp->state;
 		__entry->s_cur = qp->s_cur;
@@ -1285,7 +1285,7 @@ DECLARE_EVENT_CLASS(/* rc_rcv_err */
 		__field(int, diff)
 	),
 	TP_fast_assign(/* assign */
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->s_flags = qp->s_flags;
 		__entry->state = qp->state;
@@ -1574,7 +1574,7 @@ DECLARE_EVENT_CLASS(/* tid_ack */
 		__field(u32, resync_psn)
 	),
 	TP_fast_assign(/* assign */
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->aeth = aeth;
 		__entry->psn = psn;
diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index d44fc54858b90..f1922a7619fe8 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -120,7 +120,7 @@ DECLARE_EVENT_CLASS(hfi1_qpsleepwakeup_template,
 		    __field(unsigned long, iow_flags)
 		    ),
 		    TP_fast_assign(
-		    DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		    DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		    __entry->flags = flags;
 		    __entry->qpn = qp->ibqp.qp_num;
 		    __entry->s_flags = qp->s_flags;
@@ -868,7 +868,7 @@ TRACE_EVENT(
 		__field(int, send_flags)
 	),
 	TP_fast_assign(
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->wqe = wqe;
 		__entry->wr_id = wqe->wr.wr_id;
 		__entry->qpn = qp->ibqp.qp_num;
@@ -904,7 +904,7 @@ DECLARE_EVENT_CLASS(
 		__field(bool, flag)
 	),
 	TP_fast_assign(
-		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->flag = flag;
 	),
@@ -952,7 +952,7 @@ DECLARE_EVENT_CLASS(/* AIP  */
 		__field(u8, stopped)
 	),
 	TP_fast_assign(/* assign */
-		DD_DEV_ASSIGN(txq->priv->dd)
+		DD_DEV_ASSIGN(txq->priv->dd);
 		__entry->txq = txq;
 		__entry->sde = txq->sde;
 		__entry->head = txq->tx_ring.head;
diff --git a/drivers/infiniband/sw/rdmavt/trace_cq.h b/drivers/infiniband/sw/rdmavt/trace_cq.h
index e3c416c6f900f..91bc192cee5e4 100644
--- a/drivers/infiniband/sw/rdmavt/trace_cq.h
+++ b/drivers/infiniband/sw/rdmavt/trace_cq.h
@@ -85,7 +85,7 @@ DECLARE_EVENT_CLASS(rvt_cq_template,
 				     __field(int, comp_vector_cpu)
 				     __field(u32, flags)
 				     ),
-		    TP_fast_assign(RDI_DEV_ASSIGN(cq->rdi)
+		    TP_fast_assign(RDI_DEV_ASSIGN(cq->rdi);
 				   __entry->ip = cq->ip;
 				   __entry->cqe = attr->cqe;
 				   __entry->comp_vector = attr->comp_vector;
@@ -123,7 +123,7 @@ DECLARE_EVENT_CLASS(
 		__field(u32, imm)
 	),
 	TP_fast_assign(
-		RDI_DEV_ASSIGN(cq->rdi)
+		RDI_DEV_ASSIGN(cq->rdi);
 		__entry->wr_id = wc->wr_id;
 		__entry->status = wc->status;
 		__entry->opcode = wc->opcode;
diff --git a/drivers/infiniband/sw/rdmavt/trace_mr.h b/drivers/infiniband/sw/rdmavt/trace_mr.h
index 95b8a0e3b8bdb..c5b675ca4fa08 100644
--- a/drivers/infiniband/sw/rdmavt/trace_mr.h
+++ b/drivers/infiniband/sw/rdmavt/trace_mr.h
@@ -195,7 +195,7 @@ TRACE_EVENT(
 		__field(uint, sg_offset)
 	),
 	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(to_imr(ibmr)->mr.pd->device))
+		RDI_DEV_ASSIGN(ib_to_rvt(to_imr(ibmr)->mr.pd->device));
 		__entry->ibmr_iova = ibmr->iova;
 		__entry->iova = to_imr(ibmr)->mr.iova;
 		__entry->user_base = to_imr(ibmr)->mr.user_base;
diff --git a/drivers/infiniband/sw/rdmavt/trace_qp.h b/drivers/infiniband/sw/rdmavt/trace_qp.h
index c32d21cc615e4..800cec8bb3c76 100644
--- a/drivers/infiniband/sw/rdmavt/trace_qp.h
+++ b/drivers/infiniband/sw/rdmavt/trace_qp.h
@@ -65,7 +65,7 @@ DECLARE_EVENT_CLASS(rvt_qphash_template,
 		__field(u32, bucket)
 	),
 	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->bucket = bucket;
 	),
@@ -97,7 +97,7 @@ DECLARE_EVENT_CLASS(
 		__field(u32, to)
 	),
 	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
 		__entry->hrtimer = &qp->s_rnr_timer;
 		__entry->s_flags = qp->s_flags;
diff --git a/drivers/infiniband/sw/rdmavt/trace_rc.h b/drivers/infiniband/sw/rdmavt/trace_rc.h
index c47357af20998..9de52e1380251 100644
--- a/drivers/infiniband/sw/rdmavt/trace_rc.h
+++ b/drivers/infiniband/sw/rdmavt/trace_rc.h
@@ -71,7 +71,7 @@ DECLARE_EVENT_CLASS(rvt_rc_template,
 			__field(u32, r_psn)
 			),
 		    TP_fast_assign(
-			RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+			RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device));
 			__entry->qpn = qp->ibqp.qp_num;
 			__entry->s_flags = qp->s_flags;
 			__entry->psn = psn;
diff --git a/drivers/infiniband/sw/rdmavt/trace_tx.h b/drivers/infiniband/sw/rdmavt/trace_tx.h
index d963ca755828f..cb96be0f8f194 100644
--- a/drivers/infiniband/sw/rdmavt/trace_tx.h
+++ b/drivers/infiniband/sw/rdmavt/trace_tx.h
@@ -111,7 +111,7 @@ TRACE_EVENT(
 		__field(int, wr_num_sge)
 	),
 	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device));
 		__entry->wqe = wqe;
 		__entry->wr_id = wqe->wr.wr_id;
 		__entry->qpn = qp->ibqp.qp_num;
@@ -170,7 +170,7 @@ TRACE_EVENT(
 		__field(int, send_flags)
 	),
 	TP_fast_assign(
-		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device));
 		__entry->wqe = wqe;
 		__entry->wr_id = wqe->wr.wr_id;
 		__entry->qpn = qp->ibqp.qp_num;
diff --git a/drivers/misc/mei/mei-trace.h b/drivers/misc/mei/mei-trace.h
index df758033dc937..fe46ff2b9d69f 100644
--- a/drivers/misc/mei/mei-trace.h
+++ b/drivers/misc/mei/mei-trace.h
@@ -26,7 +26,7 @@ TRACE_EVENT(mei_reg_read,
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev))
+		__assign_str(dev, dev_name(dev));
 		__entry->reg  = reg;
 		__entry->offs = offs;
 		__entry->val = val;
@@ -45,7 +45,7 @@ TRACE_EVENT(mei_reg_write,
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev))
+		__assign_str(dev, dev_name(dev));
 		__entry->reg = reg;
 		__entry->offs = offs;
 		__entry->val = val;
@@ -64,7 +64,7 @@ TRACE_EVENT(mei_pci_cfg_read,
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev))
+		__assign_str(dev, dev_name(dev));
 		__entry->reg  = reg;
 		__entry->offs = offs;
 		__entry->val = val;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
index e6609068e81be..64aa7d350df16 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
@@ -21,7 +21,7 @@ TRACE_EVENT(otx2_msg_alloc,
 			     __field(u16, id)
 			     __field(u64, size)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
 			   __entry->id = id;
 			   __entry->size = size;
 	    ),
@@ -36,7 +36,7 @@ TRACE_EVENT(otx2_msg_send,
 			     __field(u16, num_msgs)
 			     __field(u64, msg_size)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
 			   __entry->num_msgs = num_msgs;
 			   __entry->msg_size = msg_size;
 	    ),
@@ -52,7 +52,7 @@ TRACE_EVENT(otx2_msg_check,
 			     __field(u16, rspid)
 			     __field(int, rc)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
 			   __entry->reqid = reqid;
 			   __entry->rspid = rspid;
 			   __entry->rc = rc;
@@ -69,8 +69,8 @@ TRACE_EVENT(otx2_msg_interrupt,
 			     __string(str, msg)
 			     __field(u64, intr)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
-			   __assign_str(str, msg)
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
+			   __assign_str(str, msg);
 			   __entry->intr = intr;
 	    ),
 	    TP_printk("[%s] mbox interrupt %s (0x%llx)\n", __get_str(dev),
@@ -84,7 +84,7 @@ TRACE_EVENT(otx2_msg_process,
 			     __field(u16, id)
 			     __field(int, err)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
 			   __entry->id = id;
 			   __entry->err = err;
 	    ),
diff --git a/drivers/net/fjes/fjes_trace.h b/drivers/net/fjes/fjes_trace.h
index 9237b69d8e217..6437ddbd7842e 100644
--- a/drivers/net/fjes/fjes_trace.h
+++ b/drivers/net/fjes/fjes_trace.h
@@ -232,7 +232,7 @@ TRACE_EVENT(fjes_hw_start_debug_err,
 		 __string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err)
+		__assign_str(err, err);
 	),
 	TP_printk("%s", __get_str(err))
 );
@@ -258,7 +258,7 @@ TRACE_EVENT(fjes_hw_stop_debug_err,
 		 __string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err)
+		__assign_str(err, err);
 	),
 	TP_printk("%s", __get_str(err))
 );
diff --git a/drivers/usb/cdns3/cdnsp-trace.h b/drivers/usb/cdns3/cdnsp-trace.h
index 5aa88ca012de1..6a2571c6aa9ed 100644
--- a/drivers/usb/cdns3/cdnsp-trace.h
+++ b/drivers/usb/cdns3/cdnsp-trace.h
@@ -138,7 +138,7 @@ DECLARE_EVENT_CLASS(cdnsp_log_simple,
 		__string(text, msg)
 	),
 	TP_fast_assign(
-		__assign_str(text, msg)
+		__assign_str(text, msg);
 	),
 	TP_printk("%s", __get_str(text))
 );
diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index 2ef75caad6dab..7a2567aa2b86d 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -625,7 +625,7 @@ TRACE_EVENT(nfs4_state_mgr,
 
 		TP_fast_assign(
 			__entry->state = clp->cl_state;
-			__assign_str(hostname, clp->cl_hostname)
+			__assign_str(hostname, clp->cl_hostname);
 		),
 
 		TP_printk(
@@ -1637,7 +1637,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_callback_event,
 				__entry->fileid = 0;
 				__entry->dev = 0;
 			}
-			__assign_str(dstaddr, clp ? clp->cl_hostname : "unknown")
+			__assign_str(dstaddr, clp ? clp->cl_hostname : "unknown");
 		),
 
 		TP_printk(
@@ -1694,7 +1694,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_stateid_callback_event,
 				__entry->fileid = 0;
 				__entry->dev = 0;
 			}
-			__assign_str(dstaddr, clp ? clp->cl_hostname : "unknown")
+			__assign_str(dstaddr, clp ? clp->cl_hostname : "unknown");
 			__entry->stateid_seq =
 				be32_to_cpu(stateid->seqid);
 			__entry->stateid_hash =
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index eb1ef3462e842..dd0df132772a2 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -1431,8 +1431,8 @@ DECLARE_EVENT_CLASS(nfs_xdr_event,
 			__entry->version = task->tk_client->cl_vers;
 			__entry->error = error;
 			__assign_str(program,
-				     task->tk_client->cl_program->name)
-			__assign_str(procedure, task->tk_msg.rpc_proc->p_name)
+				     task->tk_client->cl_program->name);
+			__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
 		),
 
 		TP_printk(
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 76e0be7e14d05..8cf61e42900e8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1093,7 +1093,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 		__entry->flags	= flags;
 		__entry->bytes	= bytes;
 		__entry->flush	= flush;
-		__assign_str(reason, reason)
+		__assign_str(reason, reason);
 	),
 
 	TP_printk_btrfs("%s: flush=%d(%s) flags=%llu(%s) bytes=%llu",
diff --git a/include/trace/events/dma_fence.h b/include/trace/events/dma_fence.h
index 64e92d56c6a8f..3963e79ca7b42 100644
--- a/include/trace/events/dma_fence.h
+++ b/include/trace/events/dma_fence.h
@@ -23,8 +23,8 @@ DECLARE_EVENT_CLASS(dma_fence,
 	),
 
 	TP_fast_assign(
-		__assign_str(driver, fence->ops->get_driver_name(fence))
-		__assign_str(timeline, fence->ops->get_timeline_name(fence))
+		__assign_str(driver, fence->ops->get_driver_name(fence));
+		__assign_str(timeline, fence->ops->get_timeline_name(fence));
 		__entry->context = fence->context;
 		__entry->seqno = fence->seqno;
 	),
diff --git a/include/trace/events/rpcgss.h b/include/trace/events/rpcgss.h
index ffdbe6f85da8b..b2a2672e66322 100644
--- a/include/trace/events/rpcgss.h
+++ b/include/trace/events/rpcgss.h
@@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(rpcgss_ctx_class,
 	TP_fast_assign(
 		__entry->cred = gc;
 		__entry->service = gc->gc_service;
-		__assign_str(principal, gc->gc_principal)
+		__assign_str(principal, gc->gc_principal);
 	),
 
 	TP_printk("cred=%p service=%s principal='%s'",
@@ -535,7 +535,7 @@ TRACE_EVENT(rpcgss_upcall_msg,
 	),
 
 	TP_fast_assign(
-		__assign_str(msg, buf)
+		__assign_str(msg, buf);
 	),
 
 	TP_printk("msg='%s'", __get_str(msg))
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index d02e01a27b690..861f199896c6a 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -154,8 +154,8 @@ TRACE_EVENT(rpc_clnt_new,
 		__entry->client_id = clnt->cl_clid;
 		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
 		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
-		__assign_str(program, program)
-		__assign_str(server, server)
+		__assign_str(program, program);
+		__assign_str(server, server);
 	),
 
 	TP_printk("client=%u peer=[%s]:%s program=%s server=%s",
@@ -180,8 +180,8 @@ TRACE_EVENT(rpc_clnt_new_err,
 
 	TP_fast_assign(
 		__entry->error = error;
-		__assign_str(program, program)
-		__assign_str(server, server)
+		__assign_str(program, program);
+		__assign_str(server, server);
 	),
 
 	TP_printk("program=%s server=%s error=%d",
@@ -284,8 +284,8 @@ TRACE_EVENT(rpc_request,
 		__entry->client_id = task->tk_client->cl_clid;
 		__entry->version = task->tk_client->cl_vers;
 		__entry->async = RPC_IS_ASYNC(task);
-		__assign_str(progname, task->tk_client->cl_program->name)
-		__assign_str(procname, rpc_proc_name(task))
+		__assign_str(progname, task->tk_client->cl_program->name);
+		__assign_str(procname, rpc_proc_name(task));
 	),
 
 	TP_printk("task:%u@%u %sv%d %s (%ssync)",
@@ -494,10 +494,10 @@ DECLARE_EVENT_CLASS(rpc_reply_event,
 		__entry->task_id = task->tk_pid;
 		__entry->client_id = task->tk_client->cl_clid;
 		__entry->xid = be32_to_cpu(task->tk_rqstp->rq_xid);
-		__assign_str(progname, task->tk_client->cl_program->name)
+		__assign_str(progname, task->tk_client->cl_program->name);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(procname, rpc_proc_name(task))
-		__assign_str(servername, task->tk_xprt->servername)
+		__assign_str(procname, rpc_proc_name(task));
+		__assign_str(servername, task->tk_xprt->servername);
 	),
 
 	TP_printk("task:%u@%d server=%s xid=0x%08x %sv%d %s",
@@ -622,8 +622,8 @@ TRACE_EVENT(rpc_stats_latency,
 		__entry->task_id = task->tk_pid;
 		__entry->xid = be32_to_cpu(task->tk_rqstp->rq_xid);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(progname, task->tk_client->cl_program->name)
-		__assign_str(procname, rpc_proc_name(task))
+		__assign_str(progname, task->tk_client->cl_program->name);
+		__assign_str(procname, rpc_proc_name(task));
 		__entry->backlog = ktime_to_us(backlog);
 		__entry->rtt = ktime_to_us(rtt);
 		__entry->execute = ktime_to_us(execute);
@@ -669,15 +669,15 @@ TRACE_EVENT(rpc_xdr_overflow,
 			__entry->task_id = task->tk_pid;
 			__entry->client_id = task->tk_client->cl_clid;
 			__assign_str(progname,
-				     task->tk_client->cl_program->name)
+				     task->tk_client->cl_program->name);
 			__entry->version = task->tk_client->cl_vers;
-			__assign_str(procedure, task->tk_msg.rpc_proc->p_name)
+			__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
 		} else {
 			__entry->task_id = 0;
 			__entry->client_id = 0;
-			__assign_str(progname, "unknown")
+			__assign_str(progname, "unknown");
 			__entry->version = 0;
-			__assign_str(procedure, "unknown")
+			__assign_str(procedure, "unknown");
 		}
 		__entry->requested = requested;
 		__entry->end = xdr->end;
@@ -735,9 +735,9 @@ TRACE_EVENT(rpc_xdr_alignment,
 		__entry->task_id = task->tk_pid;
 		__entry->client_id = task->tk_client->cl_clid;
 		__assign_str(progname,
-			     task->tk_client->cl_program->name)
+			     task->tk_client->cl_program->name);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(procedure, task->tk_msg.rpc_proc->p_name)
+		__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
 
 		__entry->offset = offset;
 		__entry->copied = copied;
@@ -1107,9 +1107,9 @@ TRACE_EVENT(xprt_retransmit,
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->ntrans = rqst->rq_ntrans;
 		__assign_str(progname,
-			     task->tk_client->cl_program->name)
+			     task->tk_client->cl_program->name);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(procedure, task->tk_msg.rpc_proc->p_name)
+		__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
 	),
 
 	TP_printk(
@@ -1842,7 +1842,7 @@ TRACE_EVENT(svc_xprt_accept,
 
 	TP_fast_assign(
 		__assign_str(addr, xprt->xpt_remotebuf);
-		__assign_str(protocol, xprt->xpt_class->xcl_name)
+		__assign_str(protocol, xprt->xpt_class->xcl_name);
 		__assign_str(service, service);
 	),
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 8fcc390564029..3fc1e4c5344c0 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -33,7 +33,7 @@
 			__string(vif_name, sdata->name)
 #define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata;	\
 			__entry->p2p = sdata->vif.p2p;					\
-			__assign_str(vif_name, sdata->name)
+			__assign_str(vif_name, sdata->name);
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 


